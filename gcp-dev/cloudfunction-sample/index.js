'use strict';
require('babel-polyfill');
const {google} = require('googleapis');
const PACKAGE = require('./package');
const math = require('mathjs');
const moment = require('moment');
const waitUntil = require('wait-until');
const request = require('request');
const serviceAccountKey = require('./service_account_key');
const PROJECT_RESOURCE_PATTERN = '^projects\/([a-zA-Z0-9-_]*)\/topics\/([a-zA-Z0-9-_]*)$';

// By using Service Account Key to instantiated a jwt client based on google OAuth
const jwtClient = new google.auth.JWT(
    serviceAccountKey.client_email,
    null,
    serviceAccountKey.private_key,
    [
        'https://www.googleapis.com/auth/bigquery',
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/cloud-platform.read-only'
    ]
);

// Parse project ID and Cloud Function name from project resource value
const parseResources = (resource) => {
    const regex = new RegExp(PROJECT_RESOURCE_PATTERN, 'ig');
    const matches = regex.exec(resource);
    console.log('Matches:', matches);
    if (matches && matches.length === 3) {
        return {
            projectId: matches[1],
            cloudFunctionName: matches[2]
        };
    }
    return null;
};

// A promise to retrieve Access Token
const getAccessToken = () => {
    return new Promise((resolve, reject) => {
        console.log('Trying to retrieve a valid access_token');
        jwtClient.authorize(function (err, tokens) {
            if (err) {
                console.error(err);
                reject(err);
            } else if (tokens && tokens.access_token) {
                console.log('Retrieved a valid access_token successfully');
                resolve(tokens.access_token);
            } else {
                console.log('Failed to retrieve access_token');
                console.log('RESPONSE: ', JSON.stringify(tokens));
                reject(null);
            }
        });
    })
};

// Dump a job detail object to string value
const dumpJobDetails = (jobDetails) =>  {
    let jobDetailMessage = '';
    if (jobDetails) {
        jobDetailMessage += `(projectId:${jobDetails.jobReference.projectId}) `;
        jobDetailMessage += `(sourceUris:${JSON.stringify(jobDetails.configuration.load.sourceUris)}) `;
        jobDetailMessage += `(destinationTable: (${jobDetails.configuration.load.destinationTable.datasetId}.${jobDetails.configuration.load.destinationTable.tableId})`
    }
    return jobDetailMessage;
};


// Retrieve BigQuery job details by using Google rest API
const getJobDetailsByAccessTokenAndId = (accessToken, projectId, jobId) => {
    const jobUrl = `https://www.googleapis.com/bigquery/v2/projects/${projectId}/jobs/${jobId}`;
    console.log(`Trying to get job status from '${jobUrl}'`);
    return new Promise((resolve, reject) => {
        request({
            url: jobUrl,
            headers: {
                'User-Agent': 'Cloud Function - BigQuery job checker',
                'Authorization': `Bearer ${accessToken}`
            }
        }, function (error, response, body) {
            if (error) {
                reject(error);
            } else {
                if (body) {
                    const result = JSON.parse(body);
                    console.log(`Job '${jobId}' details are : ${dumpJobDetails(result)}`);
                    console.log(`Job '${jobId}' state is [${result.status.state}]`);
                    if (result.status.state === 'DONE') {
                        console.log('Job is finished');
                        resolve(result);
                    } else {
                        console.log('Job is still running');
                        reject(false);
                    }
                } else {
                    console.error(`Cannot fetch job details in ID '${jobId}'`);
                    reject(false);
                }
            }
        });
    })
};

// Display the total time cost
const displayTimecost = (startTime, jobId) => {
    const endTime = moment();
    const secondsDiff = endTime.diff(startTime, 'seconds');
    console.log(`Check job status by ID (${jobId}) took about ${secondsDiff} seconds totally`);
};

// Default subpub message handler (entrypoint)
// THe message should be sent to subpub as following format:
//  {
//      data : {
//          data : base64.encode("job id")
//      }
//  }
exports.subscribe = function (event, callback) {
    const startTime = moment();
    console.log(`VERSION:${PACKAGE.version}`);
    console.log(`Event: ${JSON.stringify(event)}`);
    const resources = parseResources((event.context && event.context.resource) ? event.context.resource.name : event.resource);
    console.log(`Resources are : ${resources}`);
    console.log(`Current Project ID is : ${resources.projectId}`);
    console.log(`Current CloudFunction name is : ${resources.cloudFunctionName}`);
    const jobId = Buffer.from(event.data.data, 'base64').toString();
    console.log(`Going to check job status by ID : ${jobId}`);
    if (jobId) {
        getAccessToken().then((accessToken) => {
            console.log(`Retrieved access token : ${accessToken}`);
            waitUntil()
                .interval(1 * 60 * 1000) // delay each fetch request for 1 minutes
                .times(8)
                .condition((cb) => {
                    console.log('Trying to check whether job is already finished or not');
                    getJobDetailsByAccessTokenAndId(accessToken, resources.projectId, jobId).then((jobDetails) => {
                        cb(jobDetails);
                    }, () => {
                        cb(false);
                    });
                })
                .done((result) => {
                    console.log(`Reached the job condition, and return the result : ${JSON.stringify(result)}`);
                    if (result && result.status && !result.status.errors) {
                        const timeSpending = result.statistics.endTime - result.statistics.startTime;
                        console.log(`Job runs successfully, and it takes about ${math.round(timeSpending / 1000)} seconds, and imported ${result.statistics.load.outputRows} rows`)
                    } else if (result && result.status) {
                        console.error(`Job fails because of (${result.status.errorResult.reason})`);
                        console.error(result.status.errorResult.message);
                    } else {
                        console.log(`Seems job is still running`);
                        console.error('Failed to wait until job done');
                    }
                    displayTimecost(startTime, jobId);
                    console.log('========== DONE ==========');
                    callback();
                });
        }, (err) => {
            console.error('Failed to get access token', err);
            displayTimecost(startTime, jobId);
            callback(false);
        }).catch((err) => {
            console.error('Unexpected error', err);
            displayTimecost(startTime, jobId);
            callback(false);
        });
    } else {
        displayTimecost(startTime, jobId);
        console.log('Ignore this message because of invalid job ID');
        callback(false);
    }
};

// End of file
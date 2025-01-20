const axios = require('axios');
const util = require('util');
const instance = axios.create(
    {
        baseURL: 'https://hooks.slack.com',
    },
);
const SLACK_APP_API = '';

const buildSlackRequestOption = (data) => {
    return {
      method: 'POST',
      url: SLACK_APP_API,
      headers: { 'Content-Type': 'application/json'},
      data: {
          "text": data,
      },
    };
};

exports.handler = async (event) => {
    const responseBody = await instance(buildSlackRequestOption('hello world'));
    const response = {
        statusCode: 200,
        body: util.inspect(responseBody),
    };
    return response;
};

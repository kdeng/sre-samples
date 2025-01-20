"""
Handle all unexpected URLs
"""
import logging
import time
import os

from flask import Flask, request

app = Flask(__name__)

# Define logger
FORMAT = '%(asctime)s (%(processName)s) [%(name)s] %(levelname)s - %(message)s'
logging.basicConfig(format=FORMAT)
_LOGGER = logging.getLogger('MAIN')
_LOGGER.setLevel(logging.INFO)

@app.route('/')
def root():
    requestID = request.environ.get('REQUEST_LOG_ID')
    os.environ['REQUEST_LOG_ID']

    print("1.1 Received a request (%s)" % (requestID))
    print(request.environ)
    print(os.environ)
    _LOGGER.info("1.2 Received a request `%s`" % requestID)
    time.sleep(2) 
    print("2.1 Before return the response (%s)" % requestID)
    _LOGGER.info("2.2 Before return the response `%s`" % requestID)
    return "hello world"

if __name__ == "__main__":
	app.run(host='127.0.0.1', port=8080, debug=True)

"""
Handle all unexpected URLs
"""
import logging
from flask import Flask

app = Flask(__name__)

@app.route('/')
def root():
    # For the sake of example, use static information to inflate the template.
    # This will be replaced with real information in later steps.
    print("hello world")
    return "hello world"

if __name__ == "__main__":
	app.run(host='127.0.0.1', port=8080, debug=True)
	# from google.appengine.ext.webapp.util import run_wsgi_app
	# run_wsgi_app(app)
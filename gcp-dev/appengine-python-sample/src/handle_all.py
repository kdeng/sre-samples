"""
Handle all unexpected URLs
"""
import logging
from google.appengine.ext import webapp

class NotFoundPageHandler(webapp.RequestHandler):
	"""
	URL handler returns 404 for all unexpected requests
	"""

	def get(self):
		"""
		Get method handler
		"""
		self.error(404)
		self.response.out.write('Not Found')
		logging.info("Not Found handler")


app = webapp.WSGIApplication([('/.*', NotFoundPageHandler)], debug=True)


if __name__ == "__main__":
	from google.appengine.ext.webapp.util import run_wsgi_app
	run_wsgi_app(app)
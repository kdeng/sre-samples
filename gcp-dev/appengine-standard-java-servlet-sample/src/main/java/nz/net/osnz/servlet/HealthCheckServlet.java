package nz.net.osnz.servlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
@WebServlet(
    name = "healthCheck",
    description = "Health Check Servlet",
    urlPatterns = {"/_ah/health", "/_ah/start", "/_ah/stop", "/_ah/warmup"}
)
public class HealthCheckServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(HealthCheckServlet.class);

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        LOG.info("Received health check request '{}' in GET method", request.getRequestURI());
        response.setContentType("text/plain");
        response.getWriter().println("OK");
        response.setStatus(com.google.appengine.repackaged.org.apache.http.HttpStatus.SC_OK);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        LOG.info("Received health check request '{}' in POST method", request.getRequestURI());
        response.setContentType("text/plain");
        response.getWriter().println("OK");
        response.setStatus(com.google.appengine.repackaged.org.apache.http.HttpStatus.SC_OK);
    }

}

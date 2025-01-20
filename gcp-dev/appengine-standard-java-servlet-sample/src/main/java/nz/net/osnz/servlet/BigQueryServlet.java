package nz.net.osnz.servlet;

import com.google.appengine.api.utils.SystemProperty;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Properties;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
@WebServlet(
    name = "requests",
    description = "Requests: Trivial request",
    urlPatterns = "/"
)
public class BigQueryServlet extends HttpServlet {


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Properties properties = System.getProperties();
        response.setContentType("text/plain");
        response.getWriter().println("Hello App Engine - Standard using "
            + SystemProperty.version.get() + " Java "
            + properties.get("java.specification.version")
        );

    }



}

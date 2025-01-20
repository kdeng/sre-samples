package nz.net.osnz.servlet;

import org.eclipse.jetty.http.HttpStatus;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import java.net.HttpURLConnection;
import java.net.URL;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
public class HealthCheckServletIntegrationTest {

    private static Server server;

    @BeforeClass
    public static void setup() throws Exception {
        // Create Server
        server = new Server(8080);
        ServletContextHandler context = new ServletContextHandler();

        ServletHolder servletHolder = new ServletHolder("health", HealthCheckServlet.class);
        context.addServlet(servletHolder, "/");
        server.setHandler(context);
        // Start Server
        server.start();
    }

    @AfterClass
    public static void setDown() throws Exception {
        // Stop Server
        server.stop();
    }

    @Before
    public void verifyJettyServer() throws Exception {
        // Test GET
        HttpURLConnection http = (HttpURLConnection) new URL("http://localhost:8080/").openConnection();
        http.connect();
        assertThat("Response Code", http.getResponseCode(), is(HttpStatus.OK_200));
    }


    @Test
    public void shouldReturnOKStatusFromHealthAPI() throws Exception {
        HttpURLConnection http = (HttpURLConnection) new URL("http://localhost:8080/_ah/health").openConnection();
        http.connect();
        assertThat("Response Code", http.getResponseCode(), is(HttpStatus.OK_200));
        assertThat("Response Body", http.getResponseMessage(), is("OK"));
    }
}

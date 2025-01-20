package nz.net.osnz.appengine;

import org.eclipse.jetty.http.HttpStatus;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerCollection;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;


/**
 * @author Kefeng Deng (deng@51any.com)
 */
public class HelloJSPTest {

    private Server server;

    @Before
    public void startJetty() throws Exception {
        // Create Server
        server = new Server(8123);

//        ServletContextHandler context = new ServletContextHandler();

//        ServletHolder defaultServ = new ServletHolder("default", DefaultServlet.class);
//        defaultServ.setInitParameter("resourceBase", System.getProperty("user.dir"));
//        defaultServ.setInitParameter("dirAllowed", "true");
//        context.addServlet(defaultServ, "/");

        // Web
        ResourceHandler webHandler = new ResourceHandler();
        webHandler.setResourceBase("./src/main/webapp/.");
        webHandler.setWelcomeFiles(new String[]{"hello.jsp"});

        // Server
        HandlerCollection handlers = new HandlerCollection();
        handlers.addHandler(webHandler);

        server.setHandler(handlers);

        // Start Server
        server.start();
    }

    @After
    public void stopJetty() {
        try {
            server.stop();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testGet() throws Exception {
        // Test GET
        HttpURLConnection http = (HttpURLConnection) new URL("http://localhost:8123/").openConnection();
        http.connect();
        assertThat("Response Code", http.getResponseCode(), is(HttpStatus.OK_200));
        BufferedReader br = new BufferedReader(new InputStreamReader(http.getInputStream()));
        String responseBody = getResponseBody(http);

        assertThat("Response body", responseBody, containsString("Hello From Appengine"));
    }

    private String getResponseBody(HttpURLConnection httpURLConnection) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String output;
        while ((output = br.readLine()) != null) {
            sb.append(output);
        }
        return sb.toString();
    }

}

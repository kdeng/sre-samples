package nz.net.osnz.servlet;

import org.junit.Test;
import org.mockito.Mockito;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.atLeast;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
public class HelloServletTest {

    @Test
    public void shouldContainsTextInResponse() throws IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);

        when(request.getParameter("username")).thenReturn("me");

        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        new HelloServlet().doGet(request, response);

        Mockito.verify(request, atLeast(1)).getParameter("username"); // only if you want to verify username was
        // called...
        writer.flush(); // it may not have been flushed yet...
        assertTrue(stringWriter.toString().contains("Hello App Engine - Standard using "));
    }

}

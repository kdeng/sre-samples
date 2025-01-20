package nz.net.osnz.servlet;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
@WebFilter(
    filterName = "helloFilter",
    urlPatterns = "/*"
)
public class HelloFilter implements Filter {

    private final static Logger LOG = Logger.getLogger(HelloFilter.class.getName());

    public void init(FilterConfig filterConfig) throws ServletException {
        LOG.info("Hello Filter Init");
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        LOG.info("Hello Filter do filter");
        chain.doFilter(request, response);
    }

    public void destroy() {
        LOG.info("Hello Filter do destroy");
    }
}

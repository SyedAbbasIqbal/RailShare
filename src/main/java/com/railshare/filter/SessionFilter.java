package com.railshare.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletResponse;

/**
 * Session Filter - Manages session timeout and redirects
 */
@WebFilter("/*")
public class SessionFilter implements Filter {
    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes in seconds

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
    	HttpServletResponse httpResponse = (HttpServletResponse) response;

    	httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    	httpResponse.setHeader("Pragma", "no-cache");
    	httpResponse.setDateHeader("Expires", 0);
    	
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null) {
            // Set session timeout
            session.setMaxInactiveInterval(SESSION_TIMEOUT);
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

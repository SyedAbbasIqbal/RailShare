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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        HttpSession session = req.getSession(false);

        // Public pages (no login required)
        if (path.equals("/") ||
            path.equals("/index.jsp") ||
            path.equals("/login.jsp") ||
            path.equals("/register.jsp") ||
            path.equals("/role.jsp") ||
            path.startsWith("/login") ||
            path.startsWith("/register") ||
            path.startsWith("/css/") ||
            path.startsWith("/js/") ||
            path.startsWith("/images/")) {

            chain.doFilter(request, response);
            return;
        }

        // Check if user logged in
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Admin page protection only
        if (path.startsWith("/admin")) {
            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Admin access required");
                return;
            }
        }

        // allow everything else
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
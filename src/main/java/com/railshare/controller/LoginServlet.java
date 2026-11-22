package com.railshare.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.railshare.dao.UserDAO;
import com.railshare.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || password == null
                || username.trim().isEmpty()
                || password.trim().isEmpty()) {

            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = userDAO.login(username, password);

        if (user != null) {

        	// Create session
        	HttpSession session = request.getSession();

        	// Prevent Session Fixation
        	request.changeSessionId();

        	session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Debug logs
            System.out.println("Login Success");
            System.out.println("Username: " + user.getUsername());
            System.out.println("Role: " + user.getRole());

            // Redirect based on role
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {

                System.out.println("Redirecting to Admin");

                // Go through AdminServlet
                response.sendRedirect(request.getContextPath() + "/admin");

            } else {

                System.out.println("Redirecting to Role Page");

                response.sendRedirect(request.getContextPath() + "/role.jsp");
            }

        } else {

            System.out.println("Login Failed");

            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
package com.railshare.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.railshare.dao.TicketDAO;
import com.railshare.model.Ticket;

/**
 * ExpiryServlet - Handles automatic expiry of tickets
 * This servlet can be called periodically (via scheduler or on page load)
 * to expire tickets that are within 6 hours of travel time
 */
@WebServlet("/expire-tickets")
public class ExpiryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TicketDAO ticketDAO;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Expire tickets that are within 6 hours of travel
        List<Ticket> expiredTickets = ticketDAO.expireTickets();
        
        // For admin dashboard or API response
        if (request.getParameter("format") != null && "json".equals(request.getParameter("format"))) {
            response.setContentType("application/json");
            response.getWriter().write("{\"expired\": " + expiredTickets.size() + "}");
        } else {
            // Redirect or show message
            response.getWriter().write("Expired " + expiredTickets.size() + " tickets");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

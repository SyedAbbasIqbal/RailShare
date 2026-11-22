package com.railshare.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.railshare.dao.AdminActionDAO;
import com.railshare.dao.TicketDAO;
import com.railshare.dao.TransferDAO;
import com.railshare.dao.UserDAO;
import com.railshare.model.User;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private TicketDAO ticketDAO;
    private TransferDAO transferDAO;
    private AdminActionDAO adminActionDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        ticketDAO = new TicketDAO();
        transferDAO = new TransferDAO();
        adminActionDAO = new AdminActionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("users".equals(action)) {
            request.setAttribute("users", userDAO.getAllUsers());
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } else if ("tickets".equals(action)) {
            request.setAttribute("tickets", ticketDAO.getAllTickets());
            request.getRequestDispatcher("/admin/tickets.jsp").forward(request, response);
        } else if ("reports".equals(action)) {
            // Get statistics
            TransferDAO.TransferStats stats = transferDAO.getTransferStats();
            request.setAttribute("stats", stats);
            request.setAttribute("monthlyReports", transferDAO.getMonthlyReport());
            
            // Count expired tickets
            long expiredCount = ticketDAO.getAllTickets().stream()
                .filter(t -> "EXPIRED".equals(t.getStatus()))
                .count();
            request.setAttribute("expiredCount", expiredCount);
            
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        } else {
            // Default: dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("blockUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean success = userDAO.updateUserStatus(userId, "BLOCKED");
            if (success) {
                adminActionDAO.logAction(admin.getId(), "BLOCK_USER", userId, 0, "Blocked user ID: " + userId);
                request.setAttribute("success", "User blocked successfully");
            } else {
                request.setAttribute("error", "Failed to block user");
            }
            request.setAttribute("users", userDAO.getAllUsers());
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);

        } else if ("unblockUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean success = userDAO.updateUserStatus(userId, "ACTIVE");
            if (success) {
                adminActionDAO.logAction(admin.getId(), "UNBLOCK_USER", userId, 0, "Unblocked user ID: " + userId);
                request.setAttribute("success", "User unblocked successfully");
            } else {
                request.setAttribute("error", "Failed to unblock user");
            }
            request.setAttribute("users", userDAO.getAllUsers());
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);

        } else if ("deleteTicket".equals(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            boolean success = ticketDAO.deleteTicket(ticketId);
            if (success) {
                adminActionDAO.logAction(admin.getId(), "DELETE_TICKET", 0, ticketId, "Deleted ticket ID: " + ticketId);
                request.setAttribute("success", "Ticket deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete ticket");
            }
            request.setAttribute("tickets", ticketDAO.getAllTickets());
            request.getRequestDispatcher("/admin/tickets.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        }
    }
}

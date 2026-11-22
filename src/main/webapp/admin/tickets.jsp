<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Ticket" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
    if (tickets == null) {
        response.sendRedirect(request.getContextPath() + "/admin?action=tickets");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">
    <title>Manage Tickets - RailShare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">RailShare - Admin</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=users">Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=tickets">Tickets</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=reports">Reports</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <div class="card">
            <h2>All Tickets</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Seller ID</th>
                        <th>Train</th>
                        <th>Route</th>
                        <th>Date &amp; Time</th>
                        <th>Class</th>
                        <th>PNR</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Listed At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Ticket ticket : tickets) { %>
                    <tr>
                        <td><%= ticket.getId() %></td>
                        <td><%= ticket.getSellerId() %></td>
                        <td><%= ticket.getTrainNumber() %></td>
                        <td><%= ticket.getFromStation() %> → <%= ticket.getToStation() %></td>
                        <td><%= ticket.getTravelDate() %> <%= ticket.getTravelTime() %></td>
                        <td><%= ticket.getTicketClass() %></td>
                        <td><%= ticket.getPnr() %></td>
                        <td>₹<%= ticket.getTotalAmount() %></td>
                        <td>
                            <span class="badge badge-<%= ticket.getStatus().toLowerCase() %>">
                                <%= ticket.getStatus() %>
                            </span>
                        </td>
                        <td><%= ticket.getListedAt() != null ? ticket.getListedAt().toString().substring(0, 16) : "N/A" %></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                                <input type="hidden" name="action" value="deleteTicket">
                                <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                <button type="submit" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;" 
                                        onclick="return confirm('Are you sure you want to delete this ticket?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>

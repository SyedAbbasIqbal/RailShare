<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) {
        response.sendRedirect(request.getContextPath() + "/admin?action=users");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Manage Users - RailShare</title>
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
            <h2>Manage Users</h2>
            
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
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (User user : users) { %>
                    <tr>
                        <td><%= user.getId() %></td>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getRole() %></td>
                        <td>
                            <span class="badge badge-<%= "ACTIVE".equals(user.getStatus()) ? "active" : "blocked" %>">
                                <%= user.getStatus() %>
                            </span>
                        </td>
                        <td><%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 16) : "N/A" %></td>
                        <td>
                            <% if ("ACTIVE".equals(user.getStatus())) { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                                    <input type="hidden" name="action" value="blockUser">
                                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                                    <button type="submit" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;">Block</button>
                                </form>
                            <% } else { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                                    <input type="hidden" name="action" value="unblockUser">
                                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                                    <button type="submit" class="btn btn-success" style="padding: 5px 10px; font-size: 12px;">Unblock</button>
                                </form>
                            <% } %>
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

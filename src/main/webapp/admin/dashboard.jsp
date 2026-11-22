<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.dao.TicketDAO" %>
<%@ page import="com.railshare.dao.TransferDAO" %>
<%@ page import="com.railshare.dao.UserDAO" %>
<%@ page import="java.util.List" %>

<%
User user = (User) session.getAttribute("user");

if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

TicketDAO ticketDAO = new TicketDAO();
TransferDAO transferDAO = new TransferDAO();
UserDAO userDAO = new UserDAO();

List<com.railshare.model.Ticket> allTickets =
ticketDAO.getAllTickets();

TransferDAO.TransferStats stats =
transferDAO.getTransferStats();

long totalTickets =
allTickets.size();

long availableTickets =
allTickets.stream()
.filter(t ->
"AVAILABLE".equalsIgnoreCase(
t.getStatus()))
.count();

long transferredTickets =
allTickets.stream()
.filter(t ->
"TRANSFERRED".equalsIgnoreCase(
t.getStatus()))
.count();

long expiredTickets =
allTickets.stream()
.filter(t ->
"EXPIRED".equalsIgnoreCase(
t.getStatus()))
.count();

List<com.railshare.model.User> allUsers =
userDAO.getAllUsers();

long totalUsers =
allUsers.size();

long activeUsers =
allUsers.stream()
.filter(u ->
"ACTIVE".equalsIgnoreCase(
u.getStatus()))
.count();

long blockedUsers =
allUsers.stream()
.filter(u ->
"BLOCKED".equalsIgnoreCase(
u.getStatus()))
.count();
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>
Admin Dashboard - RailShare
</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<header>

<nav>

<div class="logo">
RailShare - Admin
</div>

<ul class="nav-links">

<li>
<a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
Dashboard
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/admin?action=users">
Users
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/admin?action=tickets">
Tickets
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/admin?action=reports">
Reports
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/logout">
Logout
</a>
</li>

</ul>

</nav>

</header>


<div class="container">

<h1 style="color:white;
margin-bottom:30px;">

Admin Dashboard

</h1>


<div class="dashboard-stats">

<div class="stat-card">
<h3><%= totalUsers %></h3>
<p>Total Users</p>
</div>

<div class="stat-card">
<h3><%= activeUsers %></h3>
<p>Active Users</p>
</div>

<div class="stat-card">
<h3><%= totalTickets %></h3>
<p>Total Tickets</p>
</div>

<div class="stat-card">
<h3><%= stats.totalSold %></h3>
<p>Tickets Sold</p>
</div>

<div class="stat-card">
<h3><%= expiredTickets %></h3>
<p>Expired Tickets</p>
</div>


<div class="stat-card">
<h3>
₹<%= stats.totalServiceFee != null
? stats.totalServiceFee
: "0.00" %>
</h3>
<p>Total Service Fee</p>
</div>

</div>


<div class="card">

<h2>
Quick Actions
</h2>

<div style="
display:flex;
gap:20px;
margin-top:20px;
flex-wrap:wrap;">

<a href="${pageContext.request.contextPath}/admin?action=users"
class="btn btn-primary">

Manage Users

</a>


<a href="${pageContext.request.contextPath}/admin?action=tickets"
class="btn btn-primary">

View Tickets

</a>


<a href="${pageContext.request.contextPath}/admin?action=reports"
class="btn btn-primary">

View Reports

</a>


<a href="${pageContext.request.contextPath}/admin/fare?action=view"
class="btn btn-primary">

Manage Fares

</a>


<a href="${pageContext.request.contextPath}/expire-tickets"
class="btn btn-secondary"
target="_blank">

Expire Tickets

</a>

<a href="${pageContext.request.contextPath}/admin/transfer-history.jsp"
class="btn btn-primary">

Transfer History

</a>

</div>

</div>


<div class="card">

<h2>
System Overview
</h2>

<div style="
display:grid;
grid-template-columns:
repeat(auto-fit, minmax(300px,1fr));
gap:20px;
margin-top:20px;">

<div>

<h3 style="color:#667eea;">
Ticket Status
</h3>

<p>
Available:
<%= availableTickets %>
</p>

<p>
Transferred:
<%= transferredTickets %>
</p>

<p>
Expired:
<%= expiredTickets %>
</p>

</div>


<div>

<h3 style="color:#667eea;">
User Status
</h3>

<p>
Active:
<%= activeUsers %>
</p>

<p>
Blocked:
<%= blockedUsers %>
</p>

</div>


<div>

<h3 style="color:#667eea;">
Revenue
</h3>

<p>
Total Revenue:
₹<%= stats.totalRevenue != null
? stats.totalRevenue
: "0.00" %>
</p>

<p>
Service Fee:
₹<%= stats.totalServiceFee != null
? stats.totalServiceFee
: "0.00" %>
</p>

</div>

</div>

</div>

</div>

</body>
</html>
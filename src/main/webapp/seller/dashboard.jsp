<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.dao.TicketDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Ticket" %>

<%
User user = (User) session.getAttribute("user");


// Only check login
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

TicketDAO ticketDAO = new TicketDAO();
List<Ticket> myTickets = ticketDAO.getTicketsBySeller(user.getId());

long availableCount = myTickets.stream().filter(t -> "AVAILABLE".equals(t.getStatus())).count();
long transferredCount = myTickets.stream().filter(t -> "TRANSFERRED".equals(t.getStatus())).count();
long expiredCount = myTickets.stream().filter(t -> "EXPIRED".equals(t.getStatus())).count();


%>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">
<title>Seller Dashboard - RailShare</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>

<body>

<header>
<nav>
<div class="logo">RailShare - Seller</div>

<ul class="nav-links">
<li><a href="<%=request.getContextPath()%>/seller/dashboard.jsp">Dashboard</a></li>
<li><a href="<%=request.getContextPath()%>/ticket?action=list">List Ticket</a></li>
<li><a href="<%=request.getContextPath()%>/ticket?action=my-tickets">My Tickets</a></li>
<li><a href="<%=request.getContextPath()%>/logout">Logout</a></li>
</ul>

</nav>
</header>

<div class="container">

<h1 style="color:#fff;margin-bottom:30px;">
Welcome, <%= user.getUsername() %>!
</h1>

<div class="dashboard-stats">

<div class="stat-card">
<h3><%= availableCount %></h3>
<p>Available Tickets</p>
</div>

<div class="stat-card">
<h3><%= transferredCount %></h3>
<p>Transferred Tickets</p>
</div>

<div class="stat-card">
<h3><%= expiredCount %></h3>
<p>Expired Tickets</p>
</div>

<div class="stat-card">
<h3><%= myTickets.size() %></h3>
<p>Total Tickets</p>
</div>

</div>

<div class="card">

<h2>Quick Actions</h2>

<div style="display:flex;gap:20px;margin-top:20px;">

<a href="<%=request.getContextPath()%>/ticket?action=list" class="btn btn-primary">
List New Ticket
</a>

<a href="<%=request.getContextPath()%>/ticket?action=my-tickets" class="btn btn-secondary">
View My Tickets
</a>

</div>

</div>

<% if (!myTickets.isEmpty()) { %>

<div class="card">

<h2>Recent Tickets</h2>

<table>

<thead>
<tr>
<th>Train</th>
<th>Route</th>
<th>Date &amp; Time</th>
<th>Class</th>
<th>Price</th>
<th>Status</th>
</tr>
</thead>

<tbody>

<% for (Ticket ticket : myTickets.subList(0, Math.min(5, myTickets.size()))) { %>

<tr>
<td><%= ticket.getTrainNumber() %></td>
<td><%= ticket.getFromStation() %> → <%= ticket.getToStation() %></td>
<td><%= ticket.getTravelDate() %> <%= ticket.getTravelTime() %></td>
<td><%= ticket.getTicketClass() %></td>
<td>₹<%= ticket.getTotalAmount() %></td>

<td>
<span class="badge badge-<%= ticket.getStatus().toLowerCase() %>">
<%= ticket.getStatus() %>
</span>
</td>

</tr>

<% } %>

</tbody>
</table>

</div>

<% } %>

</div>

</body>
</html>

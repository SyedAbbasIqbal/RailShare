<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Ticket" %>

<%
User user = (User) session.getAttribute("user");


if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

@SuppressWarnings("unchecked")
List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");

if (tickets == null) {
    response.sendRedirect(request.getContextPath() + "/ticket?action=my-tickets");
    return;
}


%>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">
<title>My Tickets - RailShare</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header>
<nav>
<div class="logo">RailShare - Seller</div>

<ul class="nav-links">
<li><a href="${pageContext.request.contextPath}/seller/dashboard.jsp">Dashboard</a></li>
<li><a href="${pageContext.request.contextPath}/ticket?action=list">List Ticket</a></li>
<li><a href="${pageContext.request.contextPath}/ticket?action=my-tickets">My Tickets</a></li>
<li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
</ul>

</nav>
</header>

<div class="container">

<div class="card">

<h2>My Tickets</h2>

<% if (tickets.isEmpty()) { %>

<p style="text-align:center;padding:40px;color:#666;">
You haven't listed any tickets yet.
<a href="${pageContext.request.contextPath}/ticket?action=list">List your first ticket</a>
</p>

<% } else { %>

<table>

<thead>
<tr>
<th>Train</th>
<th>Route</th>
<th>Date &amp; Time</th>
<th>Class</th>
<th>PNR</th>
<th>Price</th>
<th>Service Fee</th>
<th>Total</th>
<th>Status</th>
<th>Listed At</th>
</tr>
</thead>

<tbody>

<% for (Ticket ticket : tickets) { %>

<tr>
<td><%= ticket.getTrainNumber() %></td>
<td><%= ticket.getFromStation() %> → <%= ticket.getToStation() %></td>
<td><%= ticket.getTravelDate() %> <%= ticket.getTravelTime() %></td>
<td><%= ticket.getTicketClass() %></td>
<td><%= ticket.getPnr() %></td>
<td>₹<%= ticket.getPrice() %></td>
<td>₹<%= ticket.getServiceFee() %></td>
<td><strong>₹<%= ticket.getTotalAmount() %></strong></td>

<td>
<span class="badge badge-<%= ticket.getStatus().toLowerCase() %>">
<%= ticket.getStatus() %>
</span>
</td>

<td>
<%= ticket.getListedAt() != null ? ticket.getListedAt().toString().substring(0,16) : "N/A" %>
</td>

</tr>

<% } %>

</tbody>

</table>

<% } %>

</div>

<div style="margin-top:20px;">
<a href="${pageContext.request.contextPath}/seller/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
<a href="${pageContext.request.contextPath}/ticket?action=list" class="btn btn-primary">List New Ticket</a>
</div>

</div>

</body>
</html>

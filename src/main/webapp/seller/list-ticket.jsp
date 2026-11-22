<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ include file="../common/stations.jspf" %>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
response.sendRedirect(request.getContextPath() + "/login.jsp");
return;
}
%>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">
<title>List Ticket - RailShare</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
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

<div class="card" style="max-width:800px;margin:30px auto;">

<h2>List Your Ticket</h2>

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

<form id="ticketForm" action="${pageContext.request.contextPath}/ticket" method="post">

<div class="form-group">
<label for="trainNumber">Train Number (5 digits)</label>
<input type="text" id="trainNumber" name="trainNumber" maxlength="5" required>
</div>

<div class="form-group">
<label for="fromStation">
From Station
</label>

<input type="text"
id="fromStation"
name="fromStation"
list="stations"
required>
</div>


<div class="form-group">
<label for="toStation">
To Station
</label>

<input type="text"
id="toStation"
name="toStation"
list="stations"
required>
</div>

<div class="form-group">
<label for="travelDate">Travel Date</label>
<input type="date" id="travelDate" name="travelDate" required>
</div>

<div class="form-group">
<label for="travelTime">Travel Time</label>
<input type="time" id="travelTime" name="travelTime" required>
</div>


<div class="form-group">
<label for="class">Class</label>
<select id="class" name="class" required>
<option value="">Select Class</option>
<option value="Sleeper">Sleeper</option>
<option value="3AC">3AC</option>
<option value="2AC">2AC</option>
<option value="1AC">1AC</option>
</select>
</div>


<div class="form-group">

<label>Seat Type</label>

<select name="seatType" required>

<option value="">
Select Seat Type
</option>

<option value="Lower">
Lower
</option>

<option value="Middle">
Middle
</option>

<option value="Upper">
Upper
</option>

<option value="Side Lower">
Side Lower
</option>

<option value="Side Upper">
Side Upper
</option>

</select>

</div>

<div class="form-group">

<label>Coach Number</label>

<input
type="text"
name="coachNo"
placeholder="Ex: S1"
required>

</div>

<div class="form-group">

<label>Seat Number</label>

<input
type="text"
name="seatNo"
placeholder="Ex: 42"
required>

</div>

<div class="form-group">
<label for="pnr">PNR (10 digits)</label>
<input type="text" id="pnr" name="pnr" maxlength="10" required>
</div>

<div class="alert alert-info">
<strong>Note:</strong> Price will be automatically fetched from the system. 
Service fee (5%) will be added automatically. Ticket must be listed at least 6 hours before travel time.
</div>

<button type="submit" class="btn btn-primary" style="width:100%;">List Ticket</button>

</form>

<div style="margin-top:20px;">
<a href="${pageContext.request.contextPath}/seller/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
</div>

</div>

</div>

</body>
</html>

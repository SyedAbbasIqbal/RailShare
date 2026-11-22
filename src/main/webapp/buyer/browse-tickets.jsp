<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.railshare.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Ticket" %>

<%@ include file="../common/stations.jspf" %>

<%
User user =
(User) session.getAttribute("user");

if (user == null ||
!"BUYER".equals(user.getRole())) {

response.sendRedirect(
request.getContextPath()
+ "/login.jsp");

return;
}

@SuppressWarnings("unchecked")
List<Ticket> tickets =
(List<Ticket>)
request.getAttribute("tickets");

if (tickets == null) {

response.sendRedirect(
request.getContextPath()
+ "/ticket?action=browse");

return;
}

String searchDate =
request.getParameter("searchDate");

String searchTrain =
request.getParameter("searchTrain");

String searchClass =
request.getParameter("searchClass");

String fromStation =
request.getParameter("fromStation");

String toStation =
request.getParameter("toStation");
%>

<!DOCTYPE html>
<html>

<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<meta charset="UTF-8">

<title>
Browse Tickets - RailShare
</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<header>

<nav>

<div class="logo">
RailShare - Buyer
</div>

<ul class="nav-links">

<li>
<a href="${pageContext.request.contextPath}/buyer/dashboard.jsp">
Dashboard
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/ticket?action=browse">
Browse Tickets
</a>
</li>

<li>
<a href="${pageContext.request.contextPath}/buyer/my-purchases.jsp">
My Purchases
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

<div class="card">

<h2>
Browse Available Tickets
</h2>


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


<form method="get"
action="${pageContext.request.contextPath}/ticket"
class="search-form">

<input type="hidden"
name="action"
value="browse">


<div class="form-group">

<label for="fromStation">
From Station
</label>

<input type="text"
id="fromStation"
name="fromStation"
list="stations"
value="<%= fromStation != null ? fromStation : "" %>">

</div>


<div class="form-group">

<label for="toStation">
To Station
</label>

<input type="text"
id="toStation"
name="toStation"
list="stations"
value="<%= toStation != null ? toStation : "" %>">

</div>


<div class="form-group">

<label for="searchDate">
Travel Date
</label>

<input type="date"
id="searchDate"
name="searchDate"
value="<%= searchDate != null ? searchDate : "" %>">

</div>


<div class="form-group">

<label for="searchTrain">
Train Number
</label>

<input type="text"
id="searchTrain"
name="searchTrain"
maxlength="5"
value="<%= searchTrain != null ? searchTrain : "" %>">

</div>

<div class="form-group">

<label for="timeFilter">
Travel Time
</label>

<select id="timeFilter"
name="timeFilter">

<option value="">
All Time
</option>

<option value="6am-12pm"
<%= "6am-12pm".equals(request.getParameter("timeFilter"))
? "selected" : "" %>>

6 AM to 12 PM

</option>

<option value="12pm-6pm"
<%= "12pm-6pm".equals(request.getParameter("timeFilter"))
? "selected" : "" %>>

12 PM to 6 PM

</option>

<option value="6pm-12am"
<%= "6pm-12am".equals(request.getParameter("timeFilter"))
? "selected" : "" %>>

6 PM to 12 AM

</option>

<option value="12am-6am"
<%= "12am-6am".equals(request.getParameter("timeFilter"))
? "selected" : "" %>>

12 AM to 6 AM

</option>

</select>

</div>

<div class="form-group">

<label for="searchClass">
Class
</label>

<select id="searchClass"
name="searchClass">

<option value="">
All Classes
</option>

<option value="Sleeper"
<%= "Sleeper".equals(searchClass)
? "selected"
: "" %>>

Sleeper

</option>

<option value="3AC"
<%= "3AC".equals(searchClass)
? "selected"
: "" %>>

3AC

</option>

<option value="2AC"
<%= "2AC".equals(searchClass)
? "selected"
: "" %>>

2AC

</option>

<option value="1AC"
<%= "1AC".equals(searchClass)
? "selected"
: "" %>>

1AC

</option>

</select>

</div>


<button type="submit"
class="btn btn-primary">

Search

</button>

</form>


<% if (tickets.isEmpty()) { %>

<p style="
text-align:center;
padding:40px;
color:#666;">

No tickets available
matching your search criteria.

</p>

<% } else { %>

<div class="ticket-grid">

<% for (Ticket ticket : tickets) { %>

<div class="ticket-card">

<h3>
Train
<%= ticket.getTrainNumber() %>
</h3>

<div class="ticket-info">

<strong>
Route:
</strong>

<%= ticket.getFromStation() %>
→
<%= ticket.getToStation() %>

</div>


<div class="ticket-info">

<strong>
Date & Time:
</strong>

<%= ticket.getTravelDate() %>

<%= ticket.getTravelTime() %>

</div>


<div class="ticket-info">

<strong>
Class:
</strong>

<%= ticket.getTicketClass() %>

</div>

<div class="ticket-info">

<strong>
Coach:
</strong>

<%= ticket.getCoachNo() != null
? ticket.getCoachNo()
: "N/A" %>

</div>

<div class="ticket-info">

<strong>
Seat No:
</strong>

<%= ticket.getSeatNo() != null
? ticket.getSeatNo()
: "N/A" %>

</div>

<div class="ticket-info">

<strong>
Berth:
</strong>

<%= ticket.getSeatType() != null
? ticket.getSeatType()
: "N/A" %>

</div>


<div class="ticket-info">

<strong>
Price:
</strong>

₹<%= ticket.getPrice() %>

</div>


<div class="ticket-info">

<strong>
Service Fee:
</strong>

₹<%= ticket.getServiceFee() %>

</div>


<div class="ticket-price">

Total:
₹<%= ticket.getTotalAmount() %>

</div>

<form method="get"
action="${pageContext.request.contextPath}/buyer/payment.jsp"
style="margin-top:15px;">

<input type="hidden"
name="ticketId"
value="<%= ticket.getId() %>">

<input type="hidden"
name="amount"
value="<%= ticket.getTotalAmount() %>">

<input type="hidden"
name="trainNumber"
value="<%= ticket.getTrainNumber() %>">

<input type="hidden"
name="fromStation"
value="<%= ticket.getFromStation() %>">

<input type="hidden"
name="toStation"
value="<%= ticket.getToStation() %>">

<button type="submit"
class="btn btn-primary"
style="width:100%;">

Purchase Ticket

</button>

</form>

</div>

<% } %>

</div>

<% } %>

</div>


<div style="margin-top:20px;">

<a href="${pageContext.request.contextPath}/buyer/dashboard.jsp"
class="btn btn-secondary">

Back to Dashboard

</a>

</div>

</div>

</body>
</html>
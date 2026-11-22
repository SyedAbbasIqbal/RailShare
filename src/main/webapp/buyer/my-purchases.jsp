<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.dao.TransferDAO" %>
<%@ page import="com.railshare.dao.TicketDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Transfer" %>
<%@ page import="com.railshare.model.Ticket" %>

<%
User user =
(User) session.getAttribute(
"user");

if (user == null ||
!"BUYER".equals(
user.getRole())) {

response.sendRedirect(
request.getContextPath()
+ "/login.jsp");

return;
}

TransferDAO transferDAO =
new TransferDAO();

TicketDAO ticketDAO =
new TicketDAO();

List<Transfer> transfers =
transferDAO.getTransfersByBuyer(
user.getId());
%>

<!DOCTYPE html>
<html>

<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<meta charset="UTF-8">

<title>
My Purchases - RailShare
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
My Purchase History
</h2>

<% if (transfers.isEmpty()) { %>

<p style="text-align:center;
padding:40px;
color:#666;">

You haven't purchased any tickets yet.

<a href="${pageContext.request.contextPath}/ticket?action=browse">

Browse available tickets

</a>

</p>

<% } else { %>

<table>

<thead>

<tr>

<th>
Ticket ID
</th>

<th>
Train
</th>

<th>
Route
</th>

<th>
Coach
</th>

<th>
Seat No
</th>

<th>
Berth
</th>

<th>
Price
</th>

<th>
Service Fee
</th>

<th>
Total Amount
</th>

<th>
Payment Status
</th>

<th>
Transfer Date
</th>

<th>
Ticket
</th>

</tr>

</thead>

<tbody>

<%
for (Transfer transfer
: transfers) {

Ticket ticket =
ticketDAO.getTicketById(
transfer.getTicketId());
%>

<tr>

<td>
<%= transfer.getTicketId() %>
</td>

<td>
<%= ticket != null
? ticket.getTrainNumber()
: "N/A" %>
</td>

<td>
<%= ticket != null
? ticket.getFromStation()
+ " → "
+ ticket.getToStation()
: "N/A" %>
</td>

<td>
<%= ticket != null
? ticket.getCoachNo()
: "N/A" %>
</td>

<td>
<%= ticket != null
? ticket.getSeatNo()
: "N/A" %>
</td>

<td>
<%= ticket != null
? ticket.getSeatType()
: "N/A" %>
</td>

<td>
₹<%= transfer.getPrice() %>
</td>

<td>
₹<%= transfer.getServiceFee() %>
</td>

<td>
<strong>
₹<%= transfer.getTotalAmount() %>
</strong>
</td>

<td>

<span class="badge badge-<%= "SUCCESS".equals(transfer.getPaymentStatus()) ? "transferred" : "expired" %>">

<%= transfer.getPaymentStatus() %>

</span>

</td>

<td>

<%= transfer.getTransferDate() != null
? transfer.getTransferDate().toString().substring(0,16)
: "N/A" %>

</td>

<td>

<a href="${pageContext.request.contextPath}/buyer/view-ticket.jsp?ticketId=<%= transfer.getTicketId() %>"
style="background:#1a73e8;
color:white;
padding:8px 14px;
border-radius:8px;
text-decoration:none;
font-weight:bold;
display:inline-block;">

View Ticket

</a>

</td>

</tr>

<% } %>

</tbody>

</table>

<% } %>

</div>

<div style="margin-top:20px;">

<a href="${pageContext.request.contextPath}/buyer/dashboard.jsp"
class="btn btn-secondary">

Back to Dashboard

</a>

<a href="${pageContext.request.contextPath}/ticket?action=browse"
class="btn btn-primary">

Browse More Tickets

</a>

</div>

</div>

</body>

</html>
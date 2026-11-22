<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.model.Transfer" %>
<%@ page import="com.railshare.model.Ticket" %>
<%@ page import="com.railshare.dao.TransferDAO" %>
<%@ page import="com.railshare.dao.TicketDAO" %>
<%@ page import="java.util.List" %>

<%
User user =
(User) session.getAttribute(
"user");

if(user == null ||
!"BUYER".equals(
user.getRole())){

response.sendRedirect(
request.getContextPath()
+ "/login.jsp");

return;
}

String ticketIdStr =
request.getParameter(
"ticketId");

if(ticketIdStr == null){

response.sendRedirect(
request.getContextPath()
+ "/buyer/my-purchases.jsp");

return;
}

int ticketId =
Integer.parseInt(
ticketIdStr);

TransferDAO transferDAO =
new TransferDAO();

TicketDAO ticketDAO =
new TicketDAO();

List<Transfer> transfers =
transferDAO.getTransfersByBuyer(
user.getId());

Transfer transfer =
null;

for(Transfer t
: transfers){

if(t.getTicketId()
== ticketId){

transfer = t;
break;
}
}

if(transfer == null){

response.sendRedirect(
request.getContextPath()
+ "/buyer/my-purchases.jsp");

return;
}

Ticket ticket =
ticketDAO.getTicketById(
ticketId);
%>

<!DOCTYPE html>
<html>

<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">

<title>
RailShare E-Ticket
</title>

<style>

body{
font-family:Arial,sans-serif;
background:#f2f5fa;
margin:0;
padding:30px;
}

.ticket-container{
max-width:1100px;
margin:auto;
background:white;
border-radius:20px;
overflow:hidden;
box-shadow:0 4px 20px rgba(0,0,0,0.15);
}

.ticket-header{
background:#1a73e8;
color:white;
padding:25px;
text-align:center;
}

.ticket-header h1{
margin:0;
font-size:34px;
}

.ticket-header p{
margin:8px 0 0;
font-size:15px;
}

.ticket-body{
padding:30px;
}

.section{
margin-bottom:25px;
border-bottom:1px solid #eee;
padding-bottom:20px;
}

.section h3{
margin-bottom:15px;
color:#1a73e8;
}

.info-grid{
display:grid;
grid-template-columns:1fr 1fr;
gap:15px;
}

.info-box{
background:#f8f9fc;
padding:15px;
border-radius:12px;
}

.label{
font-size:13px;
color:#666;
margin-bottom:5px;
}

.value{
font-size:18px;
font-weight:bold;
color:#222;
}

.status{
display:inline-block;
padding:8px 14px;
border-radius:10px;
font-weight:bold;
background:#d4edda;
color:#155724;
}

.qr{
text-align:center;
margin-top:25px;
}

.qr img{
width:180px;
height:180px;
border-radius:15px;
border:1px solid #ddd;
}

.footer{
text-align:center;
padding:20px;
font-size:13px;
color:#777;
}

.print-btn{
display:block;
margin:20px auto;
padding:14px 28px;
background:#1a73e8;
color:white;
border:none;
border-radius:12px;
font-size:17px;
font-weight:bold;
cursor:pointer;
}

.print-btn:hover{
opacity:0.9;
}

@media print{

.print-btn{
display:none;
}

body{
background:white;
padding:0;
}

.ticket-container{
box-shadow:none;
}
}

</style>

</head>

<body>

<div class="ticket-container">

<div class="ticket-header">

<h1>
🚆 RAILSHARE E-TICKET
</h1>

<p>
Your Ticket Transfer Confirmation
</p>

</div>

<div class="ticket-body">

<div class="section">

<h3>
Passenger Details
</h3>

<div class="info-grid">

<div class="info-box">

<div class="label">
Passenger Name
</div>

<div class="value">
<%= transfer.getPassengerName() %>
</div>

</div>

<div class="info-box">

<div class="label">
Age / Gender
</div>

<div class="value">
<%= transfer.getAge() %>
/
<%= transfer.getGender() %>
</div>

</div>

</div>

</div>


<div class="section">

<h3>
Journey Details
</h3>

<div class="info-grid">

<div class="info-box">

<div class="label">
Train Number
</div>

<div class="value">
<%= ticket.getTrainNumber() %>
</div>

</div>

<div class="info-box">

<div class="label">
PNR
</div>

<div class="value">
<%= ticket.getPnr() %>
</div>

</div>

<div class="info-box">

<div class="label">
From
</div>

<div class="value">
<%= ticket.getFromStation() %>
</div>

</div>

<div class="info-box">

<div class="label">
To
</div>

<div class="value">
<%= ticket.getToStation() %>
</div>

</div>

<div class="info-box">

<div class="label">
Travel Date
</div>

<div class="value">
<%= ticket.getTravelDate() %>
</div>

</div>

<div class="info-box">

<div class="label">
Travel Time
</div>

<div class="value">
<%= ticket.getTravelTime() %>
</div>

</div>

</div>

</div>


<div class="section">

<h3>
Seat Details
</h3>

<div class="info-grid">

<div class="info-box">

<div class="label">
Class
</div>

<div class="value">
<%= ticket.getTicketClass() %>
</div>

</div>

<div class="info-box">

<div class="label">
Coach
</div>

<div class="value">
<%= ticket.getCoachNo() %>
</div>

</div>

<div class="info-box">

<div class="label">
Seat Number
</div>

<div class="value">
<%= ticket.getSeatNo() %>
</div>

</div>

<div class="info-box">

<div class="label">
Berth
</div>

<div class="value">
<%= ticket.getSeatType() %>
</div>

</div>

</div>

</div>


<div class="section">

<h3>
Payment Details
</h3>

<div class="info-grid">

<div class="info-box">

<div class="label">
Total Amount
</div>

<div class="value">
₹<%= transfer.getTotalAmount() %>
</div>

</div>

<div class="info-box">

<div class="label">
Payment Status
</div>

<div class="value">

<span class="status">
<%= transfer.getPaymentStatus() %>
</span>

</div>

</div>

</div>

</div>

<div class="qr">

<img src="${pageContext.request.contextPath}/images/qr.JPG"
alt="QR">

<p>
RailShare Verified Ticket
</p>

</div>

<div style="text-align:center;">

<a href="${pageContext.request.contextPath}/download-ticket?ticketId=<%= ticket.getId() %>"
style="display:inline-block;
padding:14px 22px;
background:#28a745;
color:white;
text-decoration:none;
border-radius:12px;
font-size:17px;
font-weight:bold;
margin-right:10px;">

⬇ Download PDF

</a>

<button
class="print-btn"
onclick="window.print()"
style="display:inline-block;">

🖨 Print Ticket

</button>

</div>

</div>

<div class="footer">

This is a digitally generated RailShare ticket.
Please carry valid ID proof during travel.

</div>

</div>

</body>
</html>
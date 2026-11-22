<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.model.Transfer" %>
<%@ page import="com.railshare.model.Ticket" %>
<%@ page import="com.railshare.dao.TransferDAO" %>
<%@ page import="com.railshare.dao.TicketDAO" %>
<%@ page import="com.railshare.dao.UserDAO" %>

<%
User user = (User) session.getAttribute("user");

if(user == null || !"ADMIN".equals(user.getRole())){
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

TransferDAO transferDAO = new TransferDAO();
TicketDAO ticketDAO = new TicketDAO();
UserDAO userDAO = new UserDAO();
String fromDate =
request.getParameter(
"fromDate");

String toDate =
request.getParameter(
"toDate");

String train =
request.getParameter(
"train");

String filter =
request.getParameter(
"filter");

List<Transfer> transfers;

boolean hasFilter =
(fromDate != null &&
!fromDate.isEmpty())

||

(toDate != null &&
!toDate.isEmpty())

||

(train != null &&
!train.isEmpty())

||

(filter != null &&
!filter.isEmpty());

if(hasFilter){

transfers =
transferDAO
.getFilteredTransfers(
fromDate,
toDate,
train,
filter);

}else{

transfers =
transferDAO
.getAllTransfers();
}

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Transfer History</title>

<style>

body{
font-family:Arial,sans-serif;
background:#f2f5fa;
margin:0;
padding:0;
}

header{
background:#1a73e8;
padding:18px;
color:white;
font-size:24px;
font-weight:bold;
text-align:center;
}

.container{
padding:30px;
}

.card{
background:white;
padding:25px;
border-radius:18px;
box-shadow:0 4px 15px rgba(0,0,0,0.1);
overflow:auto;
}

table{
width:100%;
border-collapse:collapse;
}

th{
background:#1a73e8;
color:white;
padding:14px;
text-align:left;
}

td{
padding:14px;
border-bottom:1px solid #ddd;
}

.success{
background:#d4edda;
color:#155724;
padding:6px 12px;
border-radius:8px;
font-weight:bold;
}

.failed{
background:#f8d7da;
color:#721c24;
padding:6px 12px;
border-radius:8px;
font-weight:bold;
}

.download-btn{
background:#28a745;
color:white;
padding:10px 14px;
border-radius:8px;
text-decoration:none;
font-weight:bold;
display:inline-block;
}

.back-btn{
display:inline-block;
margin-top:20px;
background:#6c757d;
color:white;
padding:12px 18px;
border-radius:10px;
text-decoration:none;
font-weight:bold;
}

</style>

</head>

<body>

<header>
RailShare - Admin Transfer History
</header>

<div class="container">

<div class="card">

<h2>All Ticket Transfers</h2>

<form method="get"
style="display:flex;
gap:10px;
align-items:center;
flex-wrap:wrap;
margin-bottom:20px;
background:#f8f9fa;
padding:15px;
border-radius:12px;">

<label><strong>From:</strong></label>

<input type="date"
name="fromDate"
value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>"
style="padding:10px;
border:1px solid #ccc;
border-radius:8px;">

<label><strong>To:</strong></label>

<input type="date"
name="toDate"
value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>"
style="padding:10px;
border:1px solid #ccc;
border-radius:8px;">

<label><strong>Train:</strong></label>

<input type="text"
name="train"
maxlength="5"
inputmode="numeric"
pattern="[0-9]{5}"
placeholder="Train No"
value="<%= request.getParameter("train") != null ? request.getParameter("train") : "" %>"
style="padding:10px;
border:1px solid #ccc;
border-radius:8px;
width:120px;">

<select name="filter"
style="padding:10px;
border:1px solid #ccc;
border-radius:8px;">

<option value="">Quick Filter</option>

<option value="daily"
<%= "daily".equals(request.getParameter("filter"))
? "selected" : "" %>>
Today
</option>

<option value="weekly"
<%= "weekly".equals(request.getParameter("filter"))
? "selected" : "" %>>
This Week
</option>

<option value="monthly"
<%= "monthly".equals(request.getParameter("filter"))
? "selected" : "" %>>
This Month
</option>

<option value="yearly"
<%= "yearly".equals(request.getParameter("filter"))
? "selected" : "" %>>
This Year
</option>

</select>

<button type="submit"
style="background:#1a73e8;
color:white;
border:none;
padding:10px 18px;
border-radius:8px;
cursor:pointer;
font-weight:bold;">

Search

</button>

<a href="transfer-history.jsp"
style="background:#dc3545;
color:white;
padding:10px 18px;
border-radius:8px;
text-decoration:none;
font-weight:bold;">

Reset

</a>

</form>

<table>

<thead>
<tr>
<th>Seller</th>
<th>Buyer</th>
<th>Passenger</th>
<th>Age/Gender</th>
<th>Train</th>
<th>Route</th>
<th>Coach</th>
<th>Seat</th>
<th>Berth</th>
<th>Amount</th>
<th>Status</th>
<th>Date</th>
<th>PDF</th>
</tr>
</thead>

<tbody>

<%
for(Transfer transfer : transfers){

Ticket ticket =
ticketDAO.getTicketById(
transfer.getTicketId());

User seller =
userDAO.getUserById(
transfer.getSellerId());

User buyer =
userDAO.getUserById(
transfer.getBuyerId());
%>

<tr>

<td><%= seller != null ? seller.getUsername() : "N/A" %></td>

<td><%= buyer != null ? buyer.getUsername() : "N/A" %></td>

<td><%= transfer.getPassengerName() %></td>

<td><%= transfer.getAge() %> / <%= transfer.getGender() %></td>

<td><%= ticket != null ? ticket.getTrainNumber() : "N/A" %></td>

<td><%= ticket != null ? ticket.getFromStation() + " → " + ticket.getToStation() : "N/A" %></td>

<td><%= ticket != null ? ticket.getCoachNo() : "N/A" %></td>

<td><%= ticket != null ? ticket.getSeatNo() : "N/A" %></td>

<td><%= ticket != null ? ticket.getSeatType() : "N/A" %></td>

<td>₹<%= transfer.getTotalAmount() %></td>

<td>
<span class="<%= "SUCCESS".equals(transfer.getPaymentStatus()) ? "success" : "failed" %>">
<%= transfer.getPaymentStatus() %>
</span>
</td>

<td>
<%= transfer.getTransferDate() != null
? transfer.getTransferDate().toString().substring(0,16)
: "N/A" %>
</td>

<td>
<a href="${pageContext.request.contextPath}/download-ticket?ticketId=<%= transfer.getTicketId() %>"
class="download-btn">
Download PDF
</a>
</td>

</tr>

<% } %>

</tbody>

</table>

<a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
class="back-btn">
Back to Dashboard
</a>

</div>

</div>

</body>

</html>
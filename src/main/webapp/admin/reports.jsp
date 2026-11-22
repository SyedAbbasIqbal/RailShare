<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.dao.TransferDAO" %>

<%
User user =
(User) session.getAttribute("user");

if(user == null ||
!"ADMIN".equalsIgnoreCase(
user.getRole())){

    response.sendRedirect(
    request.getContextPath()
    + "/login.jsp");

    return;
}

String filter =
request.getParameter("filter");

String fromDate =
request.getParameter("fromDate");

String toDate =
request.getParameter("toDate");

String train =
request.getParameter("train");

TransferDAO transferDAO =
new TransferDAO();

TransferDAO.ReportStats stats =
transferDAO.getReportStats(
filter,
fromDate,
toDate,
train);

if(stats == null){
    stats =
    new TransferDAO.ReportStats();
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>
Admin Reports
</title>

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
max-width:1100px;
margin:auto;
padding:30px;
}

.card{
background:white;
padding:25px;
border-radius:18px;
box-shadow:
0 4px 15px rgba(0,0,0,0.1);
}

.filter-bar{
display:flex;
gap:10px;
flex-wrap:wrap;
align-items:center;
margin-bottom:25px;
}

input,
select,
button{
padding:10px;
border:1px solid #ccc;
border-radius:8px;
font-size:15px;
}

button{
background:#1a73e8;
color:white;
border:none;
cursor:pointer;
font-weight:bold;
}

.reset-btn{
background:#dc3545;
color:white;
padding:10px 18px;
border-radius:8px;
text-decoration:none;
font-weight:bold;
display:inline-flex;
align-items:center;
}

.report-box{
background:#f8f9fa;
padding:25px;
border-radius:14px;
font-size:18px;
line-height:2;
}

.title{
font-size:24px;
font-weight:bold;
margin-bottom:20px;
color:#1a73e8;
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
.date-range{
display:flex;
align-items:center;
gap:8px;
background:#f8f9fa;
padding:8px 12px;
border-radius:10px;
border:1px solid #ddd;
}

.date-range label{
font-weight:bold;
font-size:14px;
color:#555;
}

.arrow{
font-size:18px;
font-weight:bold;
}

@media(max-width:768px){

.date-range{
flex-direction:column;
align-items:stretch;
width:100%;
}

.arrow{
text-align:center;
}

}

@media(max-width:768px){

.filter-bar{
flex-direction:column;
align-items:stretch;
}

input,
select,
button,
.reset-btn{
width:100%;
box-sizing:border-box;
justify-content:center;
}

}

</style>

</head>

<body>

<header>
RailShare - Admin Reports
</header>

<div class="container">

<div class="card">

<form method="get"
action="${pageContext.request.contextPath}/admin/reports.jsp"
class="filter-bar">

<select name="filter">

<option value="">
Select Report
</option>

<option value="daily"
<%= "daily".equals(filter)
? "selected" : "" %>>
Daily
</option>

<option value="weekly"
<%= "weekly".equals(filter)
? "selected" : "" %>>
Weekly
</option>

<option value="monthly"
<%= "monthly".equals(filter)
? "selected" : "" %>>
Monthly
</option>

<option value="yearly"
<%= "yearly".equals(filter)
? "selected" : "" %>>
Yearly
</option>

<option value="custom"
<%= "custom".equals(filter)
? "selected" : "" %>>
Custom
</option>

</select>

<div class="date-range">

<label>
From
</label>

<input type="date"
name="fromDate"
value="<%= fromDate != null
? fromDate : "" %>">

<span class="arrow">
→
</span>

<label>
To
</label>

<input type="date"
name="toDate"
value="<%= toDate != null
? toDate : "" %>">

</div>

<input type="text"
name="train"
maxlength="5"
placeholder="Train No"
value="<%= train != null
? train : "" %>">

<button type="submit">
Generate Report
</button>

<a href=
"${pageContext.request.contextPath}/admin/reports.jsp"
class="reset-btn">

Reset

</a>

</form>

<div class="report-box">

<div class="title">

<%
if("daily".equals(filter)){
out.print("DAILY REPORT");
}else if("weekly".equals(filter)){
out.print("WEEKLY REPORT");
}else if("monthly".equals(filter)){
out.print("MONTHLY REPORT");
}else if("yearly".equals(filter)){
out.print("YEARLY REPORT");
}else if("custom".equals(filter)){
out.print("CUSTOM REPORT");
}else{
out.print("REPORT SUMMARY");
}
%>

</div>

<%
if(fromDate != null &&
!fromDate.isEmpty()){
%>

<b>From:</b>
<%= fromDate %>
<br>

<%
}
%>

<%
if(toDate != null &&
!toDate.isEmpty()){
%>

<b>To:</b>
<%= toDate %>
<br><br>

<%
}
%>

Tickets Sold :
<b>
<%= stats.ticketsSold %>
</b>
<br>

Tickets Purchased :
<b>
<%= stats.ticketsPurchased %>
</b>
<br>

Revenue :
<b>
₹<%= stats.revenue == null
? "0.00"
: stats.revenue %>
</b>
<br>

Service Fee :
<b>
₹<%= stats.serviceFee == null
? "0.00"
: stats.serviceFee %>
</b>
<br>

Transfers Count :
<b>
<%= stats.transferCount %>
</b>
<br>

Success Payments :
<b>
<%= stats.successPayments %>
</b>
<br>

Failed Payments :
<b>
<%= stats.failedPayments %>
</b>

</div>

<a href=
"${pageContext.request.contextPath}/admin/dashboard.jsp"
class="back-btn">

Back to Dashboard

</a>

</div>

</div>

</body>
</html>
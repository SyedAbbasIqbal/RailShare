<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.railshare.model.User" %>

<%
User user = (User) session.getAttribute("user");

if(user == null || !"ADMIN".equals(user.getRole())){
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

String filter = request.getParameter("filter");
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
String train = request.getParameter("train");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Analytics Report</title>

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
max-width:1100px;
margin:auto;
}

.card{
background:white;
padding:25px;
border-radius:18px;
box-shadow:0 4px 15px rgba(0,0,0,0.1);
}

.filter-bar{
display:flex;
gap:10px;
flex-wrap:wrap;
align-items:center;
margin-bottom:25px;
}

input,select,button{
padding:10px;
border-radius:8px;
border:1px solid #ccc;
font-size:15px;
}

button{
background:#1a73e8;
color:white;
border:none;
cursor:pointer;
font-weight:bold;
padding:10px 18px;
}

.report-box{
background:#f8f9fa;
padding:25px;
border-radius:14px;
line-height:2;
font-size:18px;
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

@media(max-width:768px){

.filter-bar{
flex-direction:column;
align-items:stretch;
}

input,select,button{
width:100%;
}

}

</style>

</head>

<body>

<header>
RailShare - Analytics Report
</header>

<div class="container">

<div class="card">

<form method="get" class="filter-bar">

<select name="filter">

<option value="">Select Report</option>

<option value="daily"
<%= "daily".equals(filter) ? "selected" : "" %>>
Daily
</option>

<option value="weekly"
<%= "weekly".equals(filter) ? "selected" : "" %>>
Weekly
</option>

<option value="monthly"
<%= "monthly".equals(filter) ? "selected" : "" %>>
Monthly
</option>

<option value="yearly"
<%= "yearly".equals(filter) ? "selected" : "" %>>
Yearly
</option>

<option value="custom"
<%= "custom".equals(filter) ? "selected" : "" %>>
Custom
</option>

</select>

<input type="date"
name="fromDate"
value="<%= fromDate != null ? fromDate : "" %>">

<input type="date"
name="toDate"
value="<%= toDate != null ? toDate : "" %>">

<input type="text"
name="train"
maxlength="5"
placeholder="Train No"
value="<%= train != null ? train : "" %>">

<button type="submit">
Generate Report
</button>

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

Tickets Sold : 0 <br>

Tickets Purchased : 0 <br>

Revenue : ₹0 <br>

Service Fee : ₹0 <br>

Transfers Count : 0 <br>

Success Payments : 0 <br>

Failed Payments : 0

</div>

<a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
class="back-btn">
Back to Dashboard
</a>

</div>

</div>

</body>

</html>
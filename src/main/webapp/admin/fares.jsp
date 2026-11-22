<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Fare" %>
<%@ include file="../common/stations.jspf" %>

<%
Fare editFare =
(Fare) request.getAttribute("editFare");

@SuppressWarnings("unchecked")
List<Fare> fares =
(List<Fare>)
request.getAttribute("fares");
%>

<!DOCTYPE html>
<html>

<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<meta charset="UTF-8">

<title>
Manage Fares
</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/css/style.css">

<style>

.container{
    width:90%;
    margin:auto;
    margin-top:30px;
}

.form-box{
    background:#fff;
    padding:20px;
    border-radius:10px;
    margin-bottom:30px;
}

.form-group{
    margin-bottom:15px;
}

.form-group input{
    width:100%;
    padding:10px;
}

table{
    width:100%;
    border-collapse:collapse;
    background:#fff;
}

table th,
table td{
    border:1px solid #ddd;
    padding:12px;
    text-align:center;
}

table th{
    background:#667eea;
    color:white;
}

.btn{
    padding:8px 15px;
    text-decoration:none;
    border:none;
    cursor:pointer;
    border-radius:5px;
}

.btn-primary{
    background:#667eea;
    color:white;
}

.btn-danger{
    background:red;
    color:white;
}

.btn-edit{
    background:green;
    color:white;
}

</style>

</head>

<body>

<div class="container">

<h1>
Manage Fares
</h1>


<div class="form-box">

<h2>

<%= editFare != null
? "Update Fare"
: "Add Fare" %>

</h2>

<form action="${pageContext.request.contextPath}/admin/fare"
method="post">

<input type="hidden"
name="id"
value="<%= editFare != null ? editFare.getId() : "" %>">


<div class="form-group">

<input type="text"
name="trainNumber"
placeholder="Train Number"
required
value="<%= editFare != null ? editFare.getTrainNumber() : "" %>">

</div>

<div class="form-group">

<input type="text"
name="fromStation"
list="stations"
placeholder="From Station"
required
value="<%= editFare != null ? editFare.getFromStation() : "" %>">

</div>


<div class="form-group">

<input type="text"
name="toStation"
list="stations"
placeholder="To Station"
required
value="<%= editFare != null ? editFare.getToStation() : "" %>">

</div>

<div class="form-group">

<input type="text"
name="ticketClass"
placeholder="Ticket Class"
required
value="<%= editFare != null ? editFare.getTicketClass() : "" %>">

</div>


<div class="form-group">

<input type="number"
step="0.01"
name="fareAmount"
placeholder="Fare Amount"
required
value="<%= editFare != null
? editFare.getFareAmount()
: "" %>">

</div>


<button type="submit"
class="btn btn-primary">

<%= editFare != null
? "Update Fare"
: "Add Fare" %>

</button>

</form>

</div>


<h2>
Fare List
</h2>

<table>

<tr>

<th>ID</th>
<th>Train No</th>
<th>From</th>
<th>To</th>
<th>Class</th>
<th>Fare</th>
<th>Actions</th>

</tr>

<%

if(fares != null){

for(Fare fare : fares){

%>

<tr>

<td>
<%= fare.getId() %>
</td>

<td>
<%= fare.getTrainNumber() %>
</td>

<td>
<%= fare.getFromStation() %>
</td>

<td>
<%= fare.getToStation() %>
</td>

<td>
<%= fare.getTicketClass() %>
</td>

<td>
₹<%= fare.getFareAmount() %>
</td>

<td>

<a href="${pageContext.request.contextPath}/admin/fare?action=edit&id=<%= fare.getId() %>"
class="btn btn-edit">

Edit

</a>


<a href="${pageContext.request.contextPath}/admin/fare?action=delete&id=<%= fare.getId() %>"
class="btn btn-danger"
onclick="return confirm('Are you sure?')">

Delete

</a>

</td>

</tr>

<%
}
}
%>

</table>

</div>

</body>
</html>
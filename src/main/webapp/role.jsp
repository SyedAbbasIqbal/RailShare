<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if (session.getAttribute("user") == null) {
response.sendRedirect("login.jsp");
return;
}
%>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport"
content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">
<title>Select Role</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<div class="container">
    <div class="card" style="max-width:500px;margin:80px auto;text-align:center;">


    <h2>Select Your Mode</h2>

    <p>How do you want to use RailShare?</p>

    <br>

    <a href="${pageContext.request.contextPath}/buyer/dashboard.jsp">
        <button class="btn btn-primary" style="width:80%;margin:10px;">
            Continue as Buyer
        </button>
    </a>

    <a href="${pageContext.request.contextPath}/seller/dashboard.jsp">
        <button class="btn btn-primary" style="width:80%;margin:10px;">
            Continue as Seller
        </button>
    </a>

</div>


</div>

</body>
</html>

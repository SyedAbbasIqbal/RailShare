<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Login - RailShare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">RailShare</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
            </ul>
        </nav>
    </header>


<div class="container">
    <div class="card" style="max-width: 500px; margin: 50px auto;">
        <h2>Login</h2>
        
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

        <form action="${pageContext.request.contextPath}/login" method="post">
            
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%;">Login</button>
        </form>

        <p style="text-align: center; margin-top: 20px;">
            Don't have an account? 
            <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
        </p>
        
        <p style="text-align: center; margin-top: 10px; font-size: 14px; color: #666;">
            Admin login: username: admin, password: admin123$
        </p>
    </div>
</div>


</body>
</html>

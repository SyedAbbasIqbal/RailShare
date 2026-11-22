<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Register - RailShare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">RailShare</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <div class="card" style="max-width: 500px; margin: 50px auto;">
            <h2>Register</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required minlength="3" maxlength="50">
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required minlength="6">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6">
                </div>

                <!-- <div class="form-group">
                    <label for="role">I want to</label>
                    <select id="role" name="role" required>
                        <option value="BUYER">Buy Tickets</option>
                        <option value="SELLER">Sell Tickets</option>
                    </select>
                </div> -->

                <button type="submit" class="btn btn-primary" style="width: 100%;">Register</button>
            </form>

            <p style="text-align: center; margin-top: 20px;">
                Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a>
            </p>
        </div>
    </div>
</body>
</html>

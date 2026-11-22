<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.railshare.model.User" %>
<%@ page import="com.railshare.dao.TransferDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.railshare.model.Transfer" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"BUYER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    TransferDAO transferDAO = new TransferDAO();
    List<Transfer> myPurchases = transferDAO.getTransfersByBuyer(user.getId());
    long successfulPurchases = myPurchases.stream()
        .filter(t -> "SUCCESS".equals(t.getPaymentStatus())).count();
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Buyer Dashboard - RailShare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">RailShare - Buyer</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/buyer/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/ticket?action=browse">Browse Tickets</a></li>
                <li><a href="${pageContext.request.contextPath}/buyer/my-purchases.jsp">My Purchases</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 style="color: #fff; margin-bottom: 30px;">Welcome, <%= user.getUsername() %>!</h1>

        <div class="dashboard-stats">
            <div class="stat-card">
                <h3><%= successfulPurchases %></h3>
                <p>Successful Purchases</p>
            </div>
            <div class="stat-card">
                <h3><%= myPurchases.size() %></h3>
                <p>Total Transactions</p>
            </div>
        </div>

        <div class="card">
            <h2>Quick Actions</h2>
            <div style="display: flex; gap: 20px; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/ticket?action=browse" class="btn btn-primary">Browse Available Tickets</a>
                <a href="${pageContext.request.contextPath}/buyer/my-purchases.jsp" class="btn btn-secondary">View My Purchases</a>
            </div>
        </div>
    </div>
</body>
</html>

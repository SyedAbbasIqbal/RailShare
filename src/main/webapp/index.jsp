<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>RailShare - Transfer Unused Train Tickets</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">RailShare</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <div class="card" style="text-align: center; max-width: 800px; margin: 50px auto;">
            <h1 style="color: #667eea; font-size: 48px; margin-bottom: 20px;">Welcome to RailShare</h1>
            <p style="font-size: 20px; color: #666; margin-bottom: 30px;">
                Transfer your unused train tickets at original price. No black ticketing, no illegal resale.
            </p>
            
            <div style="display: flex; gap: 20px; justify-content: center; margin-top: 40px;">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Login</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary">Register</a>
            </div>

            <div style="margin-top: 50px; padding: 30px; background: #f8f9fa; border-radius: 10px;">
                <h2 style="color: #667eea; margin-bottom: 20px;">How It Works</h2>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; text-align: left;">
                    <div>
                        <h3 style="color: #667eea;">For Sellers</h3>
                        <p>List your unused normal train tickets. System automatically fetches the price. Tickets must be listed at least 6 hours before travel.</p>
                    </div>
                    <div>
                        <h3 style="color: #667eea;">For Buyers</h3>
                        <p>Browse available tickets, search by date, train, or class. Purchase at fixed original price plus service fee.</p>
                    </div>
                    <div>
                        <h3 style="color: #667eea;">Safe &amp; Secure</h3>
                        <p>Strict server-side validation prevents fraud. Admin monitoring ensures fairness and reliability.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; RailShare </p>
    </footer>
</body>
</html>

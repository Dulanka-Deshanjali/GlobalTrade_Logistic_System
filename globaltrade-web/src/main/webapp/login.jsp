<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | GlobalTrade Logistics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --navy: #0B1D33; --amber: #F2A93B; }
        body { background-color: #F5F7FA; font-family: 'Inter', sans-serif; }
        .login-card { border: 1px solid #E4E8EF; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .card-header { background: var(--navy) !important; color: #fff; border-radius: 12px 12px 0 0 !important; padding: 20px; }
        .btn-primary { background: var(--amber); border-color: var(--amber); color: var(--navy); font-weight: 700; }
        .btn-primary:hover { background: #e0982a; border-color: #e0982a; color: var(--navy); }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

<div class="card login-card" style="width: 400px;">
    <div class="card-header text-center">
        <h4 class="mb-0"><i class="fa-solid fa-earth-americas me-2"></i>GlobalTrade</h4>
        <small class="text-white-50">Logistics & Supply Chain Management</small>
    </div>
    <div class="card-body p-4">

        <!-- Login Error Message (Login වැරදුනොත් පෙන්වීමට) -->
        <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger py-2 text-center small" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-1"></i> Invalid Username or Password!
        </div>
        <% } %>

        <!-- Payara Glassfish Security Check (j_security_check මඟින් Authentication සිදු වේ) -->
        <form method="POST" action="j_security_check">
            <div class="mb-3">
                <label class="form-label fw-bold small text-muted">USERNAME</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                    <input type="text" class="form-control" name="j_username" required placeholder="Enter your username">
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-bold small text-muted">PASSWORD</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                    <input type="password" class="form-control" name="j_password" required placeholder="Enter your password">
                </div>
            </div>
            <button type="submit" class="btn btn-primary w-100 py-2">
                <i class="fa-solid fa-right-to-bracket me-1"></i> Sign In
            </button>
        </form>


        <div class="text-center mt-3 pt-2 border-top small text-muted">
            New to GlobalTrade? <a href="${pageContext.request.contextPath}/customer-register-page" class="text-decoration-none fw-bold" style="color: var(--navy);">Register as a Customer</a>
        </div>
    </div>
    <div class="card-footer text-center bg-white border-0 py-3 text-muted small">
        &copy; 2026 GlobalTrade Logistics Corporation
    </div>
</div>

</body>
</html>
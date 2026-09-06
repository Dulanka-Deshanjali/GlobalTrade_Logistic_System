<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Registration | GlobalTrade</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --navy: #0B1D33; --amber: #F2A93B; --bg-soft: #F5F7FA; --ink: #1C2733; }
        body { background-color: var(--bg-soft); font-family: 'Inter', sans-serif; color: var(--ink); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px 0; }
        .card-register { border: none; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; max-width: 480px; width: 100%; }
        .card-header-custom { background: linear-gradient(135deg, #0B1D33 0%, #142C48 100%); color: #fff; padding: 25px; text-align: center; }
        .btn-warning-custom { background-color: var(--amber); color: #1C2733; font-weight: 600; transition: all 0.2s; }
        .btn-warning-custom:hover { background-color: #e09930; color: #000; }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card card-register bg-white mx-auto">
                <div class="card-header-custom">
                    <h4 class="fw-bold mb-1"><i class="fa-solid fa-user-plus me-2 text-warning"></i> Create Account</h4>
                    <p class="text-white-50 small mb-0">Join GlobalTrade Customer Portal</p>
                </div>
                <div class="card-body p-4">
                    <form id="registerForm" onsubmit="registerCustomer(event)">
                        <!-- Username Field -->
                        <div class="mb-3">
                            <label class="form-label fw-bold small">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                                <input type="text" class="form-control" id="username" required placeholder="Choose a username">
                            </div>
                        </div>

                        <!-- Full Name Field -->
                        <div class="mb-3">
                            <label class="form-label fw-bold small">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid id-card text-muted"></i></span>
                                <input type="text" class="form-control" id="fullName" required placeholder="Enter your full name">
                            </div>
                        </div>

                        <!-- Email Address Field -->
                        <div class="mb-3">
                            <label class="form-label fw-bold small">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                                <input type="email" class="form-control" id="email" required placeholder="name@example.com">
                            </div>
                        </div>

                        <!-- Password Field -->
                        <div class="mb-4">
                            <label class="form-label fw-bold small">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                                <input type="password" class="form-control" id="password" required placeholder="Create a password">
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-warning-custom py-2">Register Now</button>
                        </div>
                        <div class="text-center small text-muted">
                            Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" class="text-decoration-none fw-bold" style="color: var(--navy);">Sign In</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function registerCustomer(event) {
        event.preventDefault();

        const data = {
            username: document.getElementById('username').value,
            fullName: document.getElementById('fullName').value,
            email: document.getElementById('email').value,
            password: document.getElementById('password').value
        };

        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/api/customer/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
            .then(async res => {
                const result = await res.json();
                if (res.ok) {
                    alert(result.message || 'Registration successful!');
                    window.location.href = contextPath + '/login.jsp';
                } else {
                    alert(result.error || 'Registration failed.');
                }
            })
            .catch(err => {
                console.error('Error:', err);
                alert('An error occurred during registration.');
            });
    }
</script>
</body>
</html>
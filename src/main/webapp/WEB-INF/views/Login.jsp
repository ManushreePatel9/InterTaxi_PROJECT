<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Intercity Cabs</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --brand-yellow: #FFB703;
            --brand-dark: #1D232A;
            --brand-light: #F8FAFC;
            --card-bg: #FFFFFF;
            --text-dark: #0F172A;
            --text-muted: #64748B;
            --border-color: #E2E8F0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            position: relative;
            overflow-x: hidden;
        }

        /* Decorative Background Glows */
        .bg-glow-1 {
            position: absolute;
            width: 350px;
            height: 350px;
            background: rgba(255, 183, 3, 0.15);
            filter: blur(90px);
            border-radius: 50%;
            top: 5%;
            left: 10%;
            z-index: 0;
        }

        .bg-glow-2 {
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(56, 189, 248, 0.12);
            filter: blur(90px);
            border-radius: 50%;
            bottom: 5%;
            right: 10%;
            z-index: 0;
        }

        .login-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 460px;
        }

        .login-card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 2.8rem 2.2rem;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .brand-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .brand-icon-box {
            width: 60px;
            height: 60px;
            background: var(--brand-yellow);
            color: var(--brand-dark);
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-bottom: 1rem;
            box-shadow: 0 8px 20px rgba(255, 183, 3, 0.35);
        }

        .brand-title {
            font-weight: 800;
            color: var(--text-dark);
            font-size: 1.75rem;
            margin-bottom: 0.25rem;
        }

        .brand-subtitle {
            color: var(--text-muted);
            font-size: 0.92rem;
        }

        /* Input Group Styling */
        .input-group-custom {
            position: relative;
            margin-bottom: 1.25rem;
        }

        .input-group-custom label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.4rem;
            display: block;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            color: var(--text-muted);
            font-size: 1.1rem;
            pointer-events: none;
            transition: color 0.2s ease;
        }

        .form-control-custom {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.8rem;
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-dark);
            background-color: var(--brand-light);
            border: 1.5px solid var(--border-color);
            border-radius: 12px;
            transition: all 0.2s ease;
        }

        .form-control-custom:focus {
            background-color: #FFFFFF;
            border-color: var(--brand-dark);
            box-shadow: 0 0 0 4px rgba(29, 35, 42, 0.08);
            outline: none;
        }

        .form-control-custom:focus + .input-icon {
            color: var(--brand-dark);
        }

        .password-toggle-btn {
            position: absolute;
            right: 16px;
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 1.1rem;
            padding: 0;
        }

        /* Remember Me & Forgot Password */
        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            font-size: 0.85rem;
        }

        .form-check-input:checked {
            background-color: var(--brand-dark);
            border-color: var(--brand-dark);
        }

        .forgot-link {
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
        }

        .forgot-link:hover {
            color: var(--brand-dark);
            text-decoration: underline;
        }

        /* Button */
        .btn-taxi-submit {
            width: 100%;
            background-color: var(--brand-yellow);
            color: var(--brand-dark);
            font-weight: 700;
            font-size: 1.05rem;
            padding: 0.85rem;
            border-radius: 12px;
            border: none;
            box-shadow: 0 6px 20px rgba(255, 183, 3, 0.4);
            transition: all 0.2s ease-in-out;
        }

        .btn-taxi-submit:hover {
            background-color: #E0A100;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 183, 3, 0.5);
        }

        .signup-footer {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        .signup-footer a {
            color: var(--brand-dark);
            font-weight: 700;
            text-decoration: none;
        }

        .signup-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="bg-glow-1"></div>
<div class="bg-glow-2"></div>

<div class="login-container">
    <div class="login-card">

        <!-- Header / Logo -->
        <div class="brand-header">
            <div class="brand-icon-box">
                <i class="bi bi-taxi-front-fill"></i>
            </div>
            <h2 class="brand-title">Welcome Back</h2>
            <p class="brand-subtitle">Login to book rides or manage trips</p>
        </div>

        <!-- Success Message (Optional: Signup success redirect ke baad) -->
        <% 
            String successMsg = (String) request.getAttribute("successMsg");
            if (successMsg != null) { 
        %>
            <div class="alert alert-success rounded-3 py-2 px-3 mb-4 text-center small" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> <%= successMsg %>
            </div>
        <% } %>

        <!-- Error Message (Invalid Email/Password) -->
        <% 
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) { 
        %>
            <div class="alert alert-danger rounded-3 py-2 px-3 mb-4 text-center small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> <%= errorMsg %>
            </div>
        <% } %>

        <form action="login" method="POST" class="needs-validation" novalidate>

            <!-- Email Address -->
            <div class="input-group-custom">
                <label for="email">Email Address</label>
                <div class="input-wrapper">
                    <input type="email" class="form-control-custom" id="email" name="email" placeholder="name@example.com" required>
                    <i class="bi bi-envelope input-icon"></i>
                </div>
            </div>

            <!-- Password -->
            <div class="input-group-custom">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <input type="password" class="form-control-custom" id="password" name="password" placeholder="Enter your password" required>
                    <i class="bi bi-lock input-icon"></i>
                    <button type="button" class="password-toggle-btn" onclick="togglePassword()">
                        <i class="bi bi-eye-slash" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <!-- Remember Me & Forgot Password -->
            <div class="form-options">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                    <label class="form-check-label text-muted" for="rememberMe">
                        Remember me
                    </label>
                </div>
                <a href="forgot-password.jsp" class="forgot-link">Forgot Password?</a>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-taxi-submit">
                Log In <i class="bi bi-arrow-right ms-1"></i>
            </button>

            <!-- Signup Redirect -->
            <div class="signup-footer">
                Don't have an account? <a href="/">Register now</a>
            </div>

        </form>

    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Toggle Password Visibility
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');
        
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.classList.replace('bi-eye-slash', 'bi-eye');
        } else {
            passwordInput.type = 'password';
            eyeIcon.classList.replace('bi-eye', 'bi-eye-slash');
        }
    }

    // Form Validation Script
    (function () {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>

</body>
</html>
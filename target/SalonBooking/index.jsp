<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Booking System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    
</head>
<body class="auth-page">
<div class="background">
    <div class="grain"></div>
    <div class="aurora aurora-a"></div>
    <div class="aurora aurora-b"></div>

    <div class="auth-shell">
        <section class="showcase">
            <p class="showcase-chip">Luxury Grooming Studio</p>
            <h1>Salon Booking</h1>
            <p class="showcase-line">Precision styling, premium care, seamless appointments.</p>

            <div class="feature-grid">
                <div class="feature-card">
                    <span class="feature-no">01</span>
                    <p>Secure customer and admin login with role access.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-no">02</span>
                    <p>Fast service booking flow with modern checkout.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-no">03</span>
                    <p>Elegant interface crafted for desktop and mobile.</p>
                </div>
            </div>
        </section>

        <section class="glass-box">
            <h2>Welcome Back</h2>
            <p class="tagline">Look good. Feel confident.</p>

            <div class="auth-tabs">
                <button type="button" id="loginTab" class="tab-btn active-tab" onclick="showLogin()">Login</button>
                <button type="button" id="registerTab" class="tab-btn" onclick="showRegister()">Register</button>
            </div>

            <form id="loginForm" action="<%= request.getContextPath() %>/LoginServlet" method="post">
                <div class="input-box">
                    <i class="fa fa-envelope"></i>
                    <input type="email" name="loginEmail" placeholder="Email" required>
                </div>

                <div class="input-box">
                    <i class="fa fa-lock"></i>
                    <input type="password" name="loginpassword" placeholder="Password"
                           pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$"
                           title="Must contain at least 8 characters, one uppercase, one lowercase, one number and one special character"
                           required>
                </div>

                <select name="loginType">
                    <option value="customer">Customer</option>
                    <option value="admin">Admin</option>
                </select>

                <button type="submit">Login</button>

                <p class="switch">
                    New here? <span onclick="showRegister()">Create Account</span>
                </p>
            </form>

            <form id="registerForm" action="<%= request.getContextPath() %>/RegisterServlet" method="post" style="display:none;">
                <div class="input-box">
                    <i class="fa fa-user"></i>
                    <input type="text" name="regName" placeholder="Full Name" required>
                </div>

                <div class="input-box">
                    <i class="fa fa-envelope"></i>
                    <input type="email" name="regEmail" placeholder="Email" required>
                </div>

                <div class="input-box">
                    <i class="fa fa-lock"></i>
                    <input type="password" name="regpassword" placeholder="Password"
                           pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$"
                           title="Must contain at least 8 characters, one uppercase, one lowercase, one number and one special character"
                           required>
                </div>

                <div class="input-box">
                    <i class="fa fa-phone"></i>
                    <input type="text" name="regPhone" placeholder="Phone Number" required>
                </div>

                <select name="regType">
                    <option value="customer">Customer</option>
                    <option value="admin">Admin</option>
                </select>

                <button type="submit">Register</button>

                <p class="switch">
                    Already registered? <span onclick="showLogin()">Login</span>
                </p>
            </form>
        </section>
    </div>
</div>

<script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>

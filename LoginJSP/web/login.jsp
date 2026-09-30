<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .login-card {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 360px;
        }

        .login-card h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            outline: none;
        }

        .form-group input:focus {
            border-color: #4a90d9;
        }

        .btn {
            width: 100%;
            padding: 10px;
            background: #4a90d9;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 5px;
        }

        .btn:hover {
            background: #357abd;
        }

        .error-msg {
            color: red;
            text-align: center;
            margin-bottom: 15px;
            font-size: 13px;
        }

        .link {
            text-align: center;
            margin-top: 18px;
            font-size: 13px;
            color: #666;
        }

        .link a {
            color: #4a90d9;
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Login</h2>

        <%
            String error = request.getParameter("error");
            if ("invalid".equals(error)) {
        %>
            <p class="error-msg">Invalid username or password.</p>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/login" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter username" required />
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter password" required />
            </div>
            <button type="submit" class="btn">Login</button>
        </form>

        <div class="link">
            Don't have an account? <a href="register.jsp">Register here</a>
        </div>
    </div>

    <script>
        function validateForm() {
            var username = document.getElementById('username').value.trim();
            var password = document.getElementById('password').value.trim();

            if (username === '' || password === '') {
                alert('Please fill in all fields.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>

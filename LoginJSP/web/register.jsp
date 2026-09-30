<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Page</title>
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

        .register-card {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 360px;
        }

        .register-card h2 {
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
            border-color: #28a745;
        }

        .btn {
            width: 100%;
            padding: 10px;
            background: #28a745;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 5px;
        }

        .btn:hover {
            background: #218838;
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
            color: #28a745;
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-card">
        <h2>Register</h2>

        <%
            String error = request.getParameter("error");
            if ("duplicate".equals(error)) {
        %>
            <p class="error-msg">Username already exists. Please choose a different one.</p>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Choose a username" required />
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Choose a password" required />
            </div>
            <button type="submit" class="btn">Register</button>
        </form>

        <div class="link">
            Already have an account? <a href="login.jsp">Login here</a>
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
            if (password.length < 4) {
                alert('Password must be at least 4 characters.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>

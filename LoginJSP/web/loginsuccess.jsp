<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Success</title>
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

        .success-card {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 360px;
            text-align: center;
        }

        .checkmark {
            font-size: 48px;
            color: #28a745;
            margin-bottom: 15px;
        }

        .success-card h2 {
            color: #28a745;
            margin-bottom: 10px;
        }

        .success-card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 10px 25px;
            background: #4a90d9;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn:hover {
            background: #357abd;
        }
    </style>
</head>
<body>
    <div class="success-card">
        <div class="checkmark">&#10004;</div>
        <h2>Login Successful!</h2>
        <p>You have logged in successfully.</p>
        <a href="login.jsp" class="btn">Logout</a>
    </div>
</body>
</html>

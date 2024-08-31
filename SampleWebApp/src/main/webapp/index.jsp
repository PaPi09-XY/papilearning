<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome to KayLearning</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        p {
            color: #666;
        }
        .info {
            margin-top: 20px;
            font-size: 0.9em;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to KayLearning!</h1>
        <p>Your CI/CD deployment was successful!</p>

        <div class="info">
            <p><strong>Server Information:</strong></p>
            <p>Server Name: <%= application.getServerInfo() %></p>
            <p>Java Version: <%= System.getProperty("java.version") %></p>
            <p>Operating System: <%= System.getProperty("os.name") %></p>
        </div>

        <div class="info">
            <p><strong>Deployment Details:</strong></p>
            <p>Build Number: <%= request.getAttribute("BUILD_NUMBER") %></p>
            <p>Deployed at: <%= new java.util.Date() %></p>
        </div>
    </div>
</body>
</html>

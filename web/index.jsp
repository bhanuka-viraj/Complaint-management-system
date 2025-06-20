<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #6b48ff, #00d2ff);
            height: 100vh;
            width: 100vw;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            font-family: 'Arial', sans-serif;
            color: #fff;
        }
        .card {
            background: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            padding: 2rem;
            text-align: center;
            max-width: 700px;
            width: 90%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }
        .card-title {
            color: #6b48ff;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .card-text {
            color: #333;
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }
        .btn-custom {
            background-color: #6b48ff;
            color: #fff;
            padding: 10px 30px;
            border: none;
            border-radius: 25px;
            font-weight: 500;
            width: auto;
            display: inline-block;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .btn-custom:hover {
            background-color: #5a3fe5;
            transform: scale(1.05);
        }
        .time-display {
            font-size: 0.9rem;
            color: #555;
            margin-top: 1rem;
        }
        @media (max-width: 576px) {
            .card-title {
                font-size: 2rem;
            }
            .card-text {
                font-size: 1rem;
            }
            .btn-custom {
                padding: 8px 20px;
            }
        }
    </style>
</head>
<body>
<div class="card">
    <h1 class="card-title">Welcome to</h1>
    <h1 class="card-title">Complaint Management System</h1>
    <p class="card-text">Efficiently manage and track your complaints with ease. Log in to get started!</p>
    <a href="login.jsp" class="btn btn-custom">Go to Login</a>
    <p class="time-display">The current time is: <%= new java.util.Date() %></p>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
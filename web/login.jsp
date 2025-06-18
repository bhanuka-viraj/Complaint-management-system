<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Login</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .error { color: red; }
  </style>
</head>
<body>
<h2>Login to Complaint Management System</h2>
<% if (request.getAttribute("error") != null) { %>
<p class="error"><%= request.getAttribute("error") %></p>
<% } %>
<form action="login" method="post">
  <label>Username: <input type="text" name="username" required></label><br>
  <label>Password: <input type="password" name="password" required></label><br>
  <button type="submit">Login</button>
</form>
</body>
</html>
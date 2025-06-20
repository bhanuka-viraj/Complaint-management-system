<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Register</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <style>
    body {
      background-color: #f3f4f6;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .form-container {
      background-color: white;
      padding: 2rem;
      border-radius: 0.5rem;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      width: 450px;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h2 class="text-center mb-4">Register</h2>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-danger text-center" role="alert"><%= request.getAttribute("error") %></div>
  <% } %>
  <% if (request.getAttribute("message") != null) { %>
  <div class="alert alert-success text-center" role="alert"><%= request.getAttribute("message") %></div>
  <% } %>
  <form action="register" method="post" class="needs-validation" novalidate>
    <div class="mb-3">
      <label for="username" class="form-label">Username</label>
      <input type="text" class="form-control" id="username" name="username" required>
      <div class="invalid-feedback">Please enter a username.</div>
    </div>
    <div class="mb-3">
      <label for="password" class="form-label">Password</label>
      <input type="password" class="form-control" id="password" name="password" required>
      <div class="invalid-feedback">Please enter a password.</div>
    </div>
    <div class="mb-3">
      <label for="role" class="form-label">Role</label>
      <select class="form-select" id="role" name="role" required>
        <option value="Employee">Employee</option>
        <option value="Admin">Admin</option>
      </select>
      <div class="invalid-feedback">Please select a role.</div>
    </div>
    <button type="submit" class="btn btn-primary w-100">Register</button>
    <p class="text-center mt-2"><a href="login.jsp" class="link-primary">Back to Login</a></p>
  </form>
  <script>
    // Bootstrap validation
    (function () {
      'use strict';
      var forms = document.querySelectorAll('.needs-validation');
      Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          }
          form.classList.add('was-validated');
        }, false);
      });
    })();
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdlZxGxc" crossorigin="anonymous"></script>
</div>
</body>
</html>
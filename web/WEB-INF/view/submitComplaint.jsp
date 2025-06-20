<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Submit Complaint</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8fafc;
      font-family: 'Segoe UI', sans-serif;
      padding: 40px;
    }
    .form-container {
      max-width: 600px;
      margin: auto;
    }
  </style>
</head>
<body>
<div class="container form-container">
  <div class="card shadow-sm">
    <div class="card-header bg-primary text-white">
      <h4 class="mb-0">Submit New Complaint</h4>
    </div>
    <div class="card-body">
      <form action="<%= request.getContextPath() %>/complaint/submit" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="title" class="form-label">Title</label>
          <input type="text" id="title" name="title" class="form-control" required>
          <div class="invalid-feedback">Please enter a title.</div>
        </div>
        <div class="mb-3">
          <label for="description" class="form-label">Description</label>
          <textarea id="description" name="description" rows="4" class="form-control" required></textarea>
          <div class="invalid-feedback">Please enter a description.</div>
        </div>
        <div class="d-flex justify-content-between">
          <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Back</a>
          <button type="submit" class="btn btn-primary">Submit</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
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
</body>
</html>

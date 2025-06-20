<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bhanuka.cms.model.dto.ComplaintDTO" %>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Complaint</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f3f4f6; height: 100vh; margin: 0; }
    .form-container { max-width: 500px; }
  </style>
</head>
<body>
<div class="container mt-5">
  <div class="form-container p-4 bg-white rounded shadow">
    <h2 class="text-center mb-4">Edit Complaint</h2>

    <%
      ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
      String role = (session.getAttribute("userId") != null) ? (String) session.getAttribute("role") : null;
      if (complaint == null) {
        complaint = new ComplaintDTO();
        request.setAttribute("error", "Complaint not found or invalid ID.");
      }
      int complaintId = (complaint.getId() > 0) ? complaint.getId() : 0;
      boolean isEmployee = !"Admin".equals(role);
      boolean isResolved = "Resolved".equals(complaint.getStatus());
    %>

    <form action="<%= request.getContextPath() %>/complaint/edit" method="post" class="needs-validation" novalidate>
      <input type="hidden" name="id" value="<%= complaintId %>">

      <div class="mb-3">
        <label class="form-label">Title</label>
        <input type="text" class="form-control" name="title"
               value="<%= complaint.getTitle() != null ? complaint.getTitle() : "" %>"
               required <%= isResolved ? "readonly" : "" %>>
        <div class="invalid-feedback">Please enter a title.</div>
      </div>

      <div class="mb-3">
        <label class="form-label">Description</label>
        <textarea class="form-control" name="description" required <%= isResolved ? "readonly" : "" %>><%= complaint.getDescription() != null ? complaint.getDescription() : "" %></textarea>
        <div class="invalid-feedback">Please enter a description.</div>
      </div>

      <% if (!isEmployee) { %>
      <div class="mb-3">
        <label class="form-label">Status</label>
        <select class="form-select" name="status" required>
          <option value="Pending" <%= "Pending".equals(complaint.getStatus()) ? "selected" : "" %>>Pending</option>
          <option value="In Progress" <%= "In Progress".equals(complaint.getStatus()) ? "selected" : "" %>>In Progress</option>
          <option value="Resolved" <%= "Resolved".equals(complaint.getStatus()) ? "selected" : "" %>>Resolved</option>
        </select>
        <div class="invalid-feedback">Please select a status.</div>
      </div>
      <% } %>

      <% if ("Admin".equals(role)) { %>
      <div class="mb-3">
        <label class="form-label">Remarks</label>
        <input type="text" class="form-control" name="remarks"
               value="<%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %>">
      </div>
      <% } %>

      <button type="submit" class="btn btn-primary w-100" <%= isResolved ? "disabled" : "" %>>Update</button>
      <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary w-100 mt-2">Back</a>
    </form>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger mt-3" role="alert">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>
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

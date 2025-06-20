<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bhanuka.cms.model.dto.ComplaintDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8fafc;
      font-family: 'Segoe UI', sans-serif;
      padding: 30px;
    }
    .badge-status {
      font-size: 0.9rem;
    }
    textarea {
      resize: vertical;
    }
  </style>
</head>
<body>
<div class="container">
  <!-- Welcome Card -->
  <div class="card shadow mb-4">
    <div class="card-body">
      <h3 class="card-title">Welcome, <%= session.getAttribute("username") %>!</h3>
      <p class="text-muted mb-3">Your role: <strong><%= session.getAttribute("role") %></strong></p>
      <div class="d-flex gap-3 flex-wrap">
        <% if ("Employee".equals(session.getAttribute("role"))) { %>
        <a href="<%= request.getContextPath() %>/dashboard?submit=true" class="btn btn-success">
          <i class="bi bi-plus-circle"></i> Submit Complaint
        </a>
        <% } %>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger">
          <i class="bi bi-box-arrow-right"></i> Logout
        </a>
      </div>
    </div>
  </div>

  <!-- Submit Complaint Section -->
  <% if ("true".equals(request.getAttribute("isSubmitting"))) { %>
  <div class="card shadow mb-4">
    <div class="card-header bg-primary text-white">
      <h5 class="mb-0"><i class="bi bi-file-earmark-plus"></i> Submit New Complaint</h5>
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
          <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary">Submit</button>
        </div>
      </form>
    </div>
  </div>
  <% } %>

  <!-- Edit Complaint Section -->
  <% if ("true".equals(request.getAttribute("isEditing"))) { %>
  <% ComplaintDTO editingComplaint = (ComplaintDTO) request.getAttribute("editingComplaint"); %>
  <div class="card shadow mb-4">
    <div class="card-header bg-primary text-white">
      <h5 class="mb-0"><i class="bi bi-pencil-square"></i> Edit Complaint</h5>
    </div>
    <div class="card-body">
      <form action="<%= request.getContextPath() %>/complaint/edit" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="id" value="<%= editingComplaint.getId() %>">
        <div class="mb-3">
          <label for="editTitle" class="form-label">Title</label>
          <input type="text" id="editTitle" name="title" class="form-control" value="<%= editingComplaint.getTitle() != null ? editingComplaint.getTitle() : "" %>" required <%= ("Employee".equals(session.getAttribute("role")) && "Resolved".equals(editingComplaint.getStatus())) ? "readonly" : "" %>>
          <div class="invalid-feedback">Please enter a title.</div>
        </div>
        <div class="mb-3">
          <label for="editDescription" class="form-label">Description</label>
          <textarea id="editDescription" name="description" rows="4" class="form-control" required <%= ("Employee".equals(session.getAttribute("role")) && "Resolved".equals(editingComplaint.getStatus())) ? "readonly" : "" %>><%= editingComplaint.getDescription() != null ? editingComplaint.getDescription() : "" %></textarea>
          <div class="invalid-feedback">Please enter a description.</div>
        </div>
        <% if ("Admin".equals(session.getAttribute("role"))) { %>
        <div class="mb-3">
          <label for="editStatus" class="form-label">Status</label>
          <select id="editStatus" name="status" class="form-select" required>
            <option value="Pending" <%= "Pending".equals(editingComplaint.getStatus()) ? "selected" : "" %>>Pending</option>
            <option value="In Progress" <%= "In Progress".equals(editingComplaint.getStatus()) ? "selected" : "" %>>In Progress</option>
            <option value="Resolved" <%= "Resolved".equals(editingComplaint.getStatus()) ? "selected" : "" %>>Resolved</option>
          </select>
          <div class="invalid-feedback">Please select a status.</div>
        </div>
        <div class="mb-3">
          <label for="editRemarks" class="form-label">Remarks</label>
          <input type="text" id="editRemarks" name="remarks" class="form-control" value="<%= editingComplaint.getRemarks() != null ? editingComplaint.getRemarks() : "" %>">
        </div>
        <% } %>
        <div class="d-flex justify-content-between">
          <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Cancel</a>
          <button type="submit" class="btn btn-primary" <%= ("Employee".equals(session.getAttribute("role")) && "Resolved".equals(editingComplaint.getStatus())) ? "disabled" : "" %>>Update</button>
        </div>
      </form>
      <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger mt-3">
        <%= request.getAttribute("error") %>
      </div>
      <% } %>
    </div>
  </div>
  <% } %>

  <!-- Complaint List -->
  <div class="card shadow">
    <div class="card-header bg-primary text-white">
      <h5 class="mb-0"><i class="bi bi-card-list"></i> Complaint List</h5>
    </div>
    <div class="card-body">
      <%
        List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaints");
        String role = (session.getAttribute("userId") != null) ? (String) session.getAttribute("role") : null;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int userId = session.getAttribute("userId") != null ? (int) session.getAttribute("userId") : -1;

        if (complaints != null && !complaints.isEmpty()) {
      %>
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Status</th>
            <th>Remarks</th>
            <th>Updated</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <% for (ComplaintDTO complaint : complaints) {
            boolean isEmployee = !"Admin".equals(role);
            boolean isResolved = "Resolved".equals(complaint.getStatus());
            boolean isOwnComplaint = complaint.getUserId() == userId;
            if ("Admin".equals(role) || isOwnComplaint) {
              String statusBadgeClass = switch (complaint.getStatus()) {
                case "Pending" -> "bg-warning text-dark";
                case "In Progress" -> "bg-info text-dark";
                case "Resolved" -> "bg-success";
                default -> "bg-secondary";
              };
          %>
          <tr>
            <td><%= complaint.getId() %></td>
            <td><%= complaint.getTitle() %></td>
            <td style="max-width: 200px;"><%= complaint.getDescription() != null ? complaint.getDescription() : "N/A" %></td>
            <td><span class="badge <%= statusBadgeClass %> badge-status"><%= complaint.getStatus() %></span></td>
            <td><%= complaint.getRemarks() != null ? complaint.getRemarks() : "N/A" %></td>
            <td><%= complaint.getUpdatedAt() != null ? dateFormat.format(complaint.getUpdatedAt()) : "N/A" %></td>
            <td>
              <% if (!isEmployee || isOwnComplaint) { %>
              <a href="<%= request.getContextPath() %>/complaint/edit/<%= complaint.getId() %>" class="btn btn-outline-primary btn-sm me-1" title="Edit">
                <i class="bi bi-pencil-square"></i>
              </a>
              <% } %>
              <% if (!isEmployee || (isOwnComplaint && !isResolved)) { %>
              <a href="<%= request.getContextPath() %>/complaint/delete/<%= complaint.getId() %>" class="btn btn-outline-danger btn-sm"
                 onclick="return confirm('Are you sure you want to delete this complaint?');" title="Delete">
                <i class="bi bi-trash"></i>
              </a>
              <% } %>
            </td>
          </tr>
          <% } } %>
          </tbody>
        </table>
      </div>
      <% } else { %>
      <p class="text-muted text-center">No complaints found.</p>
      <% } %>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  (() => {
    'use strict';
    const forms = document.querySelectorAll('.needs-validation');
    Array.prototype.forEach.call(forms, form => {
      form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      });
    });
  })();
</script>
</body>
</html>
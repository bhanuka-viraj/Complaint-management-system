<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bhanuka.cms.model.dto.ComplaintDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
  <title>Complaint List</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8fafc;
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', sans-serif;
    }
    .table-container {
      max-width: 1000px;
    }
    .card-header {
      background-color: #0d6efd;
      color: white;
    }
    .badge-status {
      font-size: 0.9rem;
    }
  </style>
</head>
<body>
<div class="container py-5">
  <div class="table-container mx-auto">
    <div class="card shadow">
      <div class="card-header text-center">
        <h3 class="mb-0">Complaint List</h3>
      </div>
      <div class="card-body">
        <%
          List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaints");
          String role = (session.getAttribute("userId") != null) ? (String) session.getAttribute("role") : null;
          SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          if (complaints != null && !complaints.isEmpty()) {
        %>
        <div class="table-responsive">
          <table class="table table-hover align-middle">
            <thead class="table-light">
            <tr>
              <th>#</th>
              <th>Title</th>
              <th>Status</th>
              <th>Remarks</th>
              <th>Updated</th>
              <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
              for (ComplaintDTO complaint : complaints) {
                boolean isEmployee = !"Admin".equals(role);
                boolean isResolved = "Resolved".equals(complaint.getStatus());
                boolean isOwnComplaint = complaint.getUserId() == (int) session.getAttribute("userId");

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
                <a href="<%= request.getContextPath() %>/complaint/delete/<%= complaint.getId() %>" class="btn btn-outline-danger btn-sm" title="Delete" onclick="return confirm('Are you sure you want to delete this complaint?');">
                  <i class="bi bi-trash"></i>
                </a>
                <% } %>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
        <% } else { %>
        <p class="text-center text-muted">No complaints found.</p>
        <% } %>

        <div class="mt-4 d-flex justify-content-between">
          <% if (!"Admin".equals(role)) { %>
          <a href="<%= request.getContextPath() %>/complaint/submit" class="btn btn-success">
            <i class="bi bi-plus-circle"></i> Submit Complaint
          </a>
          <% } %>
          <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">
            <i class="bi bi-arrow-left-circle"></i> Back to Dashboard
          </a>
        </div>

      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

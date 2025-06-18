<%@ page contentType="text/html;charset=UTF-8" import="com.bhanuka.cms.model.dto.ComplaintDTO, java.util.List" %>
<html>
<head>
  <title>Complaint List</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
  </style>
</head>
<body>
<h2>Complaint List</h2>
<% List<ComplaintDTO> complaints = (List<ComplaintDTO>) request.getAttribute("complaints"); %>
<% if (complaints != null && !complaints.isEmpty()) { %>
<table>
  <tr>
    <th>ID</th>
    <th>Title</th>
    <th>Status</th>
    <th>Remarks</th>
    <th>Actions</th>
  </tr>
  <% for (ComplaintDTO complaint : complaints) { %>
  <tr>
    <td><%= complaint.getId() %></td>
    <td><%= complaint.getTitle() %></td>
    <td><%= complaint.getStatus() %></td>
    <td><%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %></td>
    <td>
      <% if ("Admin".equals(session.getAttribute("role")) || complaint.getStatus().equals("Pending")) { %>
      <a href="<%= request.getContextPath() %>/complaint/edit/<%= complaint.getId() %>">Edit</a>
      <a href="<%= request.getContextPath() %>/complaint/delete?id=<%= complaint.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
      <% } %>
    </td>
  </tr>
  <% } %>
</table>
<% } else { %>
<p>No complaints found.</p>
<% } %>
<a href="<%= request.getContextPath() %>/WEB-INF/dashboard.jsp">Back to Dashboard</a>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" import="com.bhanuka.cms.model.dto.ComplaintDTO" %>
<html>
<head>
  <title>Edit Complaint</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
  </style>
</head>
<body>
<h2>Edit Complaint</h2>
<% ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint"); %>
<% if (complaint != null) { %>
<form action="<%= request.getContextPath() %>/complaint/update" method="post">
  <input type="hidden" name="id" value="<%= complaint.getId() %>">
  <label>Status: <select name="status" required>
    <option value="Pending" <%= "Pending".equals(complaint.getStatus()) ? "selected" : "" %>>Pending</option>
    <option value="In Progress" <%= "In Progress".equals(complaint.getStatus()) ? "selected" : "" %>>In Progress</option>
    <option value="Resolved" <%= "Resolved".equals(complaint.getStatus()) ? "selected" : "" %>>Resolved</option>
  </select></label><br>
  <label>Remarks: <textarea name="remarks" required><%= complaint.getRemarks() != null ? complaint.getRemarks() : "" %></textarea></label><br>
  <button type="submit">Update</button>
</form>
<% } else { %>
<p>Complaint not found.</p>
<% } %>
<a href="<%= request.getContextPath() %>/WEB-INF/complaintList.jsp">Back to List</a>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Submit Complaint</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
  </style>
</head>
<body>
<h2>Submit New Complaint</h2>
<form action="<%= request.getContextPath() %>/complaint/submit" method="post">
  <label>Title: <input type="text" name="title" required></label><br>
  <label>Description: <textarea name="description" required></textarea></label><br>
  <button type="submit">Submit</button>
</form>
<a href="<%= request.getContextPath() %>/WEB-INF/dashboard.jsp">Back to Dashboard</a>
</body>
</html>
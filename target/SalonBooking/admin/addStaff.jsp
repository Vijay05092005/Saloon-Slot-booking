<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>View Staff</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-staff.css">
</head>
<body>
<div class="container">
   <h2>Add Staff</h2>

    <a href="<%= request.getContextPath() %>/admin/viewProducts.jsp" class="back-btn">Back to Product Updation</a><br><br>

    <form action="<%= request.getContextPath() %>/AddStaffServlet" method="post">
        Name: <input type="text" name="name" required><br><br>
        Role: <input type="text" name="role" required><br><br>
        Experience (years): <input type="number" name="experience" required><br><br>
        Phone: <input type="text" name="phone" required><br><br>
        Salary: <input type="number" step="0.01" name="salary" required><br><br>

        <input type="submit" value="Add Staff">
    </form>
</div>
</body>
</html>

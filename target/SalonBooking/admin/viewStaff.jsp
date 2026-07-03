<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>View Staff</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-staff.css">
</head>
<body>
<div class="table-container">
    <h2>Staff List</h2>

    <a href="<%= request.getContextPath() %>/admin/addStaff.jsp">Add New Staff</a><br><br>
    <a href="<%= request.getContextPath() %>/admin/viewProducts.jsp" class="back-btn">Back to Product Updation</a>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Role</th>
                <th>Experience</th>
                <th>Phone</th>
                <th>Salary</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM staff");
ResultSet rs = ps.executeQuery();

while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("role") %></td>
    <td><%= rs.getInt("experience") %></td>
    <td><%= rs.getString("phone") %></td>
    <td><%= rs.getDouble("salary") %></td>
    <td><%= rs.getString("status") %></td>
    <td>
        <a class="action-btn edit-btn"
           href="<%= request.getContextPath() %>/admin/editStaff.jsp?id=<%= rs.getInt("id") %>">Edit</a>

        <a class="action-btn delete-btn"
           href="<%= request.getContextPath() %>/DeleteStaffServlet?id=<%= rs.getInt("id") %>">Delete</a>
    </td>
</tr>

<% }
con.close();
%>
</table>
</div>
</body>
</html>

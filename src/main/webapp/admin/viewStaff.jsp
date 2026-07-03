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
<div class="admin-page">
    <aside class="dashboard-sidebar">
        <div class="sidebar-brand">
            <p class="sidebar-kicker">Admin Panel</p>
            <h2>Salon Control</h2>
            <p class="sidebar-copy">Manage staff records and jump to the other admin sections from this sidebar.</p>
        </div>

        <nav class="sidebar-nav">
            <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewProducts.jsp">Product Updation</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/addProduct.jsp">Add New Product</a>
            <a class="sidebar-link active" href="<%= request.getContextPath() %>/admin/viewStaff.jsp">Staff Management</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/adminDashboard.jsp">Session Information</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">Order Details</a>
            <a class="sidebar-link" href="http://localhost/SalonBookingPHP/admin/dashboard.php">Slot Updation</a>
        </nav>
    </aside>

    <div class="table-container">
        <div class="panel-header">
            <div>
                <p class="section-label">Team</p>
                <h2>Staff List</h2>
            </div>
            <a href="<%= request.getContextPath() %>/admin/addStaff.jsp" class="header-btn">Add New Staff</a>
        </div>

        <p class="panel-copy">Review employee details, update roles, and manage current staff status from one table.</p>

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
</div>
</body>
</html>

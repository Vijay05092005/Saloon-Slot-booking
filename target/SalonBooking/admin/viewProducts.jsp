<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
HttpSession adminSession = request.getSession(false);
if (adminSession == null || !"admin".equals(adminSession.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Products</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-staff.css">
</head>
<body>
<div class="table-container">
    <h2>Product Updation</h2>

    <div class="admin-links">
        <a href="<%= request.getContextPath() %>/admin/addProduct.jsp">Add New Product</a>
        <a href="<%= request.getContextPath() %>/admin/viewStaff.jsp">Staff Management</a>
        <a href="<%= request.getContextPath() %>/adminDashboard.jsp">Session Information</a>
        <a href="<%= request.getContextPath() %>/admin/viewOrders.jsp">Order Details</a>
        <a href="http://localhost/SalonBookingPHP/admin/dashboard.php" target="_blank">Slot Updation</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Photo</th>
                <th>Image Path</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
try (Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement("SELECT id, name, price, image, active FROM products ORDER BY id");
     ResultSet rs = ps.executeQuery()) {

    while (rs.next()) {
%>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td>&#8377; <%= rs.getInt("price") %></td>
                <td>
                    <img
                        class="table-photo"
                        src="<%= request.getContextPath() %>/user/images/<%= rs.getString("image") %>"
                        alt="<%= rs.getString("name") %>">
                </td>
                <td class="image-path">/user/images/<%= rs.getString("image") %></td>
                <td><%= rs.getInt("active") == 1 ? "Active" : "Inactive" %></td>
                <td>
                    <a class="action-btn edit-btn"
                       href="<%= request.getContextPath() %>/admin/editProduct.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                    <a class="action-btn delete-btn"
                       href="<%= request.getContextPath() %>/DeleteProductServlet?id=<%= rs.getInt("id") %>"
                       onclick="return confirm('Delete this product?');">Delete</a>
                </td>
            </tr>
<%
    }
} catch (Exception e) {
%>
            <tr>
                <td colspan="7">Unable to load products.</td>
            </tr>
<%
}
%>
        </tbody>
    </table>
</div>
</body>
</html>

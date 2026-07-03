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
<div class="admin-page">
    <aside class="dashboard-sidebar">
        <div class="sidebar-brand">
            <p class="sidebar-kicker">Admin Panel</p>
            <h2>Salon Control</h2>
            <p class="sidebar-copy">Move across product, staff, order, slot, and session pages from one place.</p>
        </div>

        <nav class="sidebar-nav">
            <a class="sidebar-link active" href="<%= request.getContextPath() %>/admin/viewProducts.jsp">Product Updation</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/addProduct.jsp">Add New Product</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewStaff.jsp">Staff Management</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/adminDashboard.jsp">Session Information</a>
            <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">Order Details</a>
            <a class="sidebar-link" href="http://localhost/SalonBookingPHP/admin/dashboard.php">Slot Updation</a>
        </nav>
    </aside>

    <div class="table-container product-page">
        <div class="panel-header">
            <div>
                <p class="section-label">Catalog</p>
                <h2>Product Updation</h2>
            </div>
            <a href="<%= request.getContextPath() %>/admin/addProduct.jsp" class="header-btn">Add New Product</a>
        </div>

        <p class="panel-copy">Manage the same products customers see in the store, with quick edit and delete actions for each item.</p>

        <div class="product-grid">
<%
try (Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement("SELECT id, name, price, image, active FROM products ORDER BY id");
     ResultSet rs = ps.executeQuery()) {

    while (rs.next()) {
%>
            <div class="admin-product-card">
                <div class="product-status <%= rs.getInt("active") == 1 ? "status-active" : "status-inactive" %>">
                    <%= rs.getInt("active") == 1 ? "Active" : "Inactive" %>
                </div>
                <img
                    class="admin-product-image"
                    src="<%= request.getContextPath() %>/user/images/<%= rs.getString("image") %>"
                    alt="<%= rs.getString("name") %>">
                <div class="admin-product-body">
                    <p class="product-id">Product #<%= rs.getInt("id") %></p>
                    <h3><%= rs.getString("name") %></h3>
                    <p class="product-price">&#8377; <%= rs.getInt("price") %></p>
                    <p class="product-path">/user/images/<%= rs.getString("image") %></p>
                </div>
                <div class="product-card-actions">
                    <a class="action-btn edit-btn"
                       href="<%= request.getContextPath() %>/admin/editProduct.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                    <a class="action-btn delete-btn"
                       href="<%= request.getContextPath() %>/DeleteProductServlet?id=<%= rs.getInt("id") %>"
                       onclick="return confirm('Delete this product?');">Delete</a>
                </div>
            </div>
<%
    }
} catch (Exception e) {
%>
            <p class="empty-state">Unable to load products.</p>
<%
}
%>
        </div>
    </div>
</div>
</body>
</html>

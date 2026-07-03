<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
HttpSession adminSession = request.getSession(false);
if (adminSession == null || !"admin".equals(adminSession.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-staff.css">
</head>
<body>
<div class="container">
    <h2>Edit Product</h2>
    <a href="<%= request.getContextPath() %>/admin/viewProducts.jsp" class="back-btn">Back to Product Updation</a>

<%
try (Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement("SELECT id, name, price, image, active FROM products WHERE id=?")) {

    ps.setInt(1, id);
    try (ResultSet rs = ps.executeQuery()) {
        if (!rs.next()) {
%>
    <p>Product not found.</p>
<%
        } else {
%>
    <form action="<%= request.getContextPath() %>/UpdateProductServlet" method="post">
        <input type="hidden" name="id" value="<%= id %>">

        <div class="form-group">
            <label>Product Name</label>
            <input type="text" name="name" value="<%= rs.getString("name") %>" required>
        </div>

        <div class="form-group">
            <label>Price</label>
            <input type="number" name="price" min="0" value="<%= rs.getInt("price") %>" required>
        </div>

        <div class="form-group">
            <label>Image File Name</label>
            <input type="text" name="image" value="<%= rs.getString("image") %>" required>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="active" <%= rs.getInt("active") == 1 ? "checked" : "" %>>
                Active
            </label>
        </div>

        <button type="submit">Update Product</button>
    </form>
<%
        }
    }
} catch (Exception e) {
%>
    <p>Unable to load product.</p>
<%
}
%>
</div>
</body>
</html>

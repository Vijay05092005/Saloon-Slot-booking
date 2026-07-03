<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>Add Product</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-staff.css">
</head>
<body>
<div class="container">
    <h2>Add Product</h2>
    <a href="<%= request.getContextPath() %>/admin/viewProducts.jsp" class="back-btn">Back to Product Updation</a>

    <form action="<%= request.getContextPath() %>/AddProductServlet" method="post">
        <div class="form-group">
            <label>Product Name</label>
            <input type="text" name="name" required>
        </div>

        <div class="form-group">
            <label>Price</label>
            <input type="number" name="price" min="0" required>
        </div>

        <div class="form-group">
            <label>Image File Name</label>
            <input type="text" name="image" placeholder="shampoo.jpg" required>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="active" checked>
                Active
            </label>
        </div>

        <button type="submit">Add Product</button>
    </form>
</div>
</body>
</html>

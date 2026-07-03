<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="util.OrderXmlUtil" %>
<%@ page import="util.OrderXmlUtil.OrderRecord" %>
<%@ page import="util.OrderXmlUtil.OrderItem" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
HttpSession s = request.getSession(false);
if (s == null || !"admin".equals(s.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
}

List<OrderRecord> orders = null;
String loadError = null;
try {
    String ordersPath = application.getInitParameter("ordersXmlPath");
    if (ordersPath == null || ordersPath.trim().isEmpty()) {
        ordersPath = application.getRealPath("/") + ".." + File.separator + ".." + File.separator + "data" + File.separator + "orders.xml";
    }
    File ordersFile = new File(ordersPath).getCanonicalFile();
    orders = OrderXmlUtil.readOrders(ordersFile);
} catch (Exception ex) {
    loadError = "Unable to load XML orders.";
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Records</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-dashboard.css">
</head>
<body>
<div class="background">
    <div class="dashboard-glass">
        <div class="top-header">
            <h1>Order Records</h1>
            <div class="top-actions">
                <a class="header-link primary" href="<%= request.getContextPath() %>/admin/viewProducts.jsp">Back to Product Updation</a>
            </div>
        </div>

        <p class="tagline">Stored in XML after successful payment</p>

        <% if (loadError != null) { %>
            <div class="glass-section">
                <p><%= loadError %></p>
            </div>
        <% } else if (orders == null || orders.isEmpty()) { %>
            <div class="glass-section">
                <p>No orders have been stored yet.</p>
            </div>
        <% } else { %>
            <% for (OrderRecord order : orders) { %>
                <div class="glass-section order-card">
                    <h3><%= order.getOrderId() %></h3>
                    <p class="order-meta">Placed: <%= order.getCreatedAt() %></p>
                    <p class="order-meta">Customer: <strong><%= order.getCustomerName() %></strong> | Phone: <%= order.getCustomerPhone() %></p>
                    <p class="order-meta">Address: <%= order.getCustomerAddress() %></p>
                    <p class="order-meta">Payment: <strong><%= order.getPaymentMethod() %></strong> | <%= order.getPaymentDetails() %> | Status: <span class="active"><%= order.getPaymentStatus() %></span></p>

                    <table>
                        <tr>
                            <th>Product</th>
                            <th>Qty</th>
                            <th>Unit Price</th>
                            <th>Subtotal</th>
                        </tr>
                        <% for (OrderItem item : order.getItems()) { %>
                            <tr>
                                <td><%= item.getProductName() %></td>
                                <td><%= item.getQuantity() %></td>
                                <td>&#8377; <%= item.getUnitPrice() %></td>
                                <td>&#8377; <%= item.getSubtotal() %></td>
                            </tr>
                        <% } %>
                        <tr>
                            <th colspan="3">Order Total</th>
                            <th>&#8377; <%= order.getTotalAmount() %></th>
                        </tr>
                    </table>
                </div>
            <% } %>
        <% } %>
    </div>
</div>
</body>
</html>

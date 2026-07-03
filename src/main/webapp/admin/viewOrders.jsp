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
int totalIncome = 0;
try {
    String ordersPath = application.getInitParameter("ordersXmlPath");
    if (ordersPath == null || ordersPath.trim().isEmpty()) {
        ordersPath = application.getRealPath("/") + ".." + File.separator + ".." + File.separator + "data" + File.separator + "orders.xml";
    }
    File ordersFile = new File(ordersPath).getCanonicalFile();
    orders = OrderXmlUtil.readOrders(ordersFile);
    if (orders != null) {
        for (OrderRecord order : orders) {
            totalIncome += order.getTotalAmount();
        }
    }
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
    <div class="dashboard-layout">
        <aside class="dashboard-sidebar">
            <div class="sidebar-brand">
                <p class="sidebar-kicker">Admin Panel</p>
                <h2>Salon Control</h2>
                <p class="sidebar-copy">Open other admin sections quickly while reviewing stored order records.</p>
            </div>

            <nav class="sidebar-nav">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewProducts.jsp">Product Updation</a>
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/addProduct.jsp">Add New Product</a>
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewStaff.jsp">Staff Management</a>
                <a class="sidebar-link" href="<%= request.getContextPath() %>/adminDashboard.jsp">Session Information</a>
                <a class="sidebar-link active" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">Order Details</a>
                <a class="sidebar-link" href="http://localhost/SalonBookingPHP/admin/dashboard.php">Slot Updation</a>
            </nav>

            <form action="<%= request.getContextPath() %>/LogoutServlet" method="get" class="sidebar-logout-form">
                <button class="logout-btn">Logout</button>
            </form>
        </aside>

        <div class="dashboard-glass">
            <div class="top-header">
                <div>
                    <p class="section-label">Orders</p>
                    <h1>Order Records</h1>
                </div>
                <div class="orders-income-card">
                    <span class="orders-income-label">Total Income</span>
                    <strong>&#8377; <%= totalIncome %></strong>
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
                <div class="glass-section">
                    <table class="orders-table">
                        <tr>
                            <th>Order ID</th>
                            <th>Placed On</th>
                            <th>Customer Details</th>
                            <th>Order Details</th>
                            <th>Payment Details</th>
                            <th>Total Amount</th>
                        </tr>
                        <% for (OrderRecord order : orders) { %>
                            <tr>
                                <td class="col-order-id"><strong><%= order.getOrderId() %></strong></td>
                                <td class="col-placed-on"><%= order.getCreatedAt() %></td>
                                <td class="col-customer">
                                    <strong><%= order.getCustomerName() %></strong><br>
                                    <span class="muted-line"><%= order.getCustomerPhone() %></span><br>
                                    <span class="muted-line"><%= order.getCustomerAddress() %></span>
                                </td>
                                <td class="col-order-details">
                                    <% for (OrderItem item : order.getItems()) { %>
                                        <div class="order-item-line">
                                            <strong><%= item.getProductName() %></strong>
                                            <span>Qty: <%= item.getQuantity() %></span>
                                            <span>Unit Price: &#8377; <%= item.getUnitPrice() %></span>
                                            <span>Subtotal: &#8377; <%= item.getSubtotal() %></span>
                                        </div>
                                    <% } %>
                                </td>
                                <td class="col-payment">
                                    <strong><%= order.getPaymentMethod() %></strong><br>
                                    <span class="muted-line"><%= order.getPaymentDetails() %></span><br>
                                    Status: <span class="active"><%= order.getPaymentStatus() %></span>
                                </td>
                                <td class="col-total"><strong>&#8377; <%= order.getTotalAmount() %></strong></td>
                            </tr>
                        <% } %>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>

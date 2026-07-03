<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<html>
<head>
    <title>Your Cart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/user/css/style.css">
</head>
<body class="cart-page">
<div class="page-overlay">
    <h1 class="page-title">Your Cart</h1>
    <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout-btn">Logout</a>

<%
HashMap<Integer, Integer> cart =
    (HashMap<Integer, Integer>) session.getAttribute("cart");
int total = 0;
boolean hasItems = !(cart == null || cart.isEmpty());

if (!hasItems) {
%>
    <p class="empty-cart">Your cart is empty</p>
<%
} else {
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        StringBuilder placeholders = new StringBuilder();
        List<Integer> ids = new ArrayList<>(cart.keySet());
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }

        String sql = "SELECT id, name, price, image FROM products WHERE active = 1 AND id IN (" + placeholders.toString() + ")";
        ps = con.prepareStatement(sql);
        for (int i = 0; i < ids.size(); i++) {
            ps.setInt(i + 1, ids.get(i));
        }
        rs = ps.executeQuery();

        HashMap<Integer, String> nameMap = new HashMap<>();
        HashMap<Integer, Integer> priceMap = new HashMap<>();
        HashMap<Integer, String> imageMap = new HashMap<>();

        while (rs.next()) {
            int id = rs.getInt("id");
            nameMap.put(id, rs.getString("name"));
            priceMap.put(id, rs.getInt("price"));
            imageMap.put(id, rs.getString("image"));
        }
%>
<div class="cart-table">
<table>
<tr>
    <th>Product</th>
    <th>Image</th>
    <th>Price</th>
    <th>Qty</th>
    <th>Total</th>
</tr>
<%
        for (Integer productId : ids) {
            if (!nameMap.containsKey(productId)) {
                continue;
            }
            String name = nameMap.get(productId);
            int price = priceMap.get(productId);
            String image = imageMap.get(productId);
            int qty = cart.get(productId);
            int sub = price * qty;
            total += sub;
%>
<tr>
    <td><%= name %></td>
    <td>
        <img src="<%= request.getContextPath() %>/user/images/<%= image %>" class="cart-img" alt="<%= name %>">
    </td>
    <td>&#8377; <%= price %></td>
    <td>
        <div class="qty-control">
            <a href="<%= request.getContextPath() %>/user/updateQty.jsp?productId=<%= productId %>&action=dec">-</a>
            <span><%= qty %></span>
            <a href="<%= request.getContextPath() %>/user/updateQty.jsp?productId=<%= productId %>&action=inc">+</a>
        </div>
    </td>
    <td>&#8377; <%= sub %></td>
</tr>
<%
        }
%>
<tr class="total-row">
    <td colspan="4">Grand Total</td>
    <td>&#8377; <%= total %></td>
</tr>
</table>
</div>
<%
    } catch (Exception e) {
%>
    <p class="empty-cart">Unable to load cart items right now.</p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ex) {}
        if (ps != null) try { ps.close(); } catch (Exception ex) {}
        if (con != null) try { con.close(); } catch (Exception ex) {}
    }
}
%>

<div class="cart-actions">
    <a href="<%= request.getContextPath() %>/user/clearCart.jsp" class="clear-btn">Clear Cart</a>
    <% if (hasItems) { %>
    <a href="<%= request.getContextPath() %>/user/payment.jsp" class="pay-btn">Proceed to Payment</a>
    <% } %>
</div>

<a class="cart-btn continue-btn" href="<%= request.getContextPath() %>/user/products.jsp">Continue Shopping</a>
</div>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.OrderXmlUtil" %>
<%@ page import="util.OrderXmlUtil.OrderItem" %>
<%@ page import="util.OrderXmlUtil.NewOrderData" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Status</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/user/css/style.css">
</head>
<body>
<div class="page-overlay">
<%
HashMap<Integer, Integer> cart =
    (HashMap<Integer, Integer>) session.getAttribute("cart");

if (cart == null || cart.isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/user/cart.jsp");
    return;
}

String method = request.getParameter("paymentMethod");
boolean valid = method != null && !method.trim().isEmpty();
String error = "";
String fullName = request.getParameter("fullName");
String phone = request.getParameter("phone");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String pincode = request.getParameter("pincode");

if (fullName == null || fullName.trim().isEmpty() ||
    phone == null || !phone.matches("\\d{10}") ||
    address == null || address.trim().isEmpty() ||
    city == null || city.trim().isEmpty() ||
    state == null || state.trim().isEmpty() ||
    pincode == null || !pincode.matches("\\d{6}")) {
    valid = false;
    error = "Please enter a valid shipping address.";
}

if (valid && "card".equals(method)) {
    String cardNumber = request.getParameter("cardNumber");
    String expiry = request.getParameter("expiry");
    String cvv = request.getParameter("cvv");
    String cardName = request.getParameter("cardName");

    if (cardNumber == null || cardNumber.replaceAll("\\s", "").length() < 12 ||
        expiry == null || expiry.trim().length() < 4 ||
        cvv == null || cvv.trim().length() < 3 ||
        cardName == null || cardName.trim().isEmpty()) {
        valid = false;
        error = "Please fill valid card details.";
    }
} else if (valid && ! ("qr".equals(method) || "card".equals(method))) {
    valid = false;
    error = "Select a payment method.";
}

if (!valid) {
%>
    <div class="payment-box">
        <p class="empty-cart"><%= error %></p>
        <a href="<%= request.getContextPath() %>/user/payment.jsp" class="cart-btn">Back to Payment</a>
    </div>
<%
} else {
    String label = "";
    if ("qr".equals(method)) label = "QR Payment";
    else if ("card".equals(method)) label = "Card";
    int totalAmount = 0;
    List<OrderItem> orderItems = new ArrayList<>();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        List<Integer> ids = new ArrayList<>(cart.keySet());
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }

        String sql = "SELECT id, name, price FROM products WHERE active = 1 AND id IN (" + placeholders.toString() + ")";
        ps = con.prepareStatement(sql);
        for (int i = 0; i < ids.size(); i++) {
            ps.setInt(i + 1, ids.get(i));
        }

        rs = ps.executeQuery();
        while (rs.next()) {
            int productId = rs.getInt("id");
            int qty = cart.getOrDefault(productId, 0);
            if (qty <= 0) {
                continue;
            }
            OrderItem item = new OrderItem(rs.getString("name"), qty, rs.getInt("price"));
            orderItems.add(item);
            totalAmount += item.getSubtotal();
        }
    } catch (Exception ex) {
        valid = false;
        error = "Unable to process your order right now.";
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ex) {}
        if (ps != null) try { ps.close(); } catch (Exception ex) {}
        if (con != null) try { con.close(); } catch (Exception ex) {}
    }

    if (valid && orderItems.isEmpty()) {
        valid = false;
        error = "Your cart items could not be processed.";
    }

    if (valid) {
        String cardNumber = request.getParameter("cardNumber");
        String digits = cardNumber == null ? "" : cardNumber.replaceAll("\\D", "");
        String paymentDetails = "Paid via QR";
        if ("card".equals(method)) {
            String lastFour = digits.length() >= 4 ? digits.substring(digits.length() - 4) : digits;
            paymentDetails = "Card ending in " + lastFour;
        }

        String customerName = (String) session.getAttribute("userName");
        String shippingAddress = address.trim() + ", " + city.trim() + ", " + state.trim() + " - " + pincode.trim();

        try {
            String ordersPath = application.getInitParameter("ordersXmlPath");
            if (ordersPath == null || ordersPath.trim().isEmpty()) {
                ordersPath = application.getRealPath("/") + ".." + File.separator + ".." + File.separator + "data" + File.separator + "orders.xml";
            }
            File ordersFile = new File(ordersPath).getCanonicalFile();
            OrderXmlUtil.appendOrder(
                ordersFile,
                new NewOrderData(
                    (customerName == null || customerName.trim().isEmpty()) ? fullName.trim() : customerName.trim(),
                    phone.trim(),
                    shippingAddress,
                    label,
                    "SUCCESS",
                    paymentDetails,
                    totalAmount,
                    orderItems
                )
            );
            session.removeAttribute("cart");
        } catch (Exception ex) {
            valid = false;
            error = "Payment succeeded but the order could not be stored.";
        }
    }

    if (!valid) {
%>
    <div class="payment-box">
        <p class="empty-cart"><%= error %></p>
        <a href="<%= request.getContextPath() %>/user/payment.jsp" class="cart-btn">Back to Payment</a>
    </div>
<%
    } else {
%>
    <div class="payment-box">
        <h2 class="page-sub">Payment Successful</h2>
        <p class="payment-total">Payment Method: <strong><%= label %></strong></p>
        <p class="upi-note">Shipping To: <strong><%= fullName %></strong>, <%= address %>, <%= city %>, <%= state %> - <%= pincode %></p>
        <p class="upi-note">Phone: <%= phone %></p>
        <p class="upi-note">Order Total: <strong>&#8377; <%= totalAmount %></strong></p>
        <p class="upi-note">Your order has been placed successfully.</p>
        <a href="<%= request.getContextPath() %>/user/products.jsp" class="cart-btn">Continue Shopping</a>
    </div>
<%
    }
} %>
</div>
</body>
</html>

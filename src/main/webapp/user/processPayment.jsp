<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.OrderXmlUtil" %>
<%@ page import="util.OrderXmlUtil.OrderItem" %>
<%@ page import="util.OrderXmlUtil.NewOrderData" %>
<%@ page import="util.OrderXmlUtil.OrderRecord" %>
<%!
private String escapeHtml(String value) {
    if (value == null) {
        return "";
    }
    return value
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}

private String formatInvoiceDate(String value) {
    if (value == null || value.trim().isEmpty()) {
        return "";
    }
    try {
        return LocalDateTime.parse(value).format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
    } catch (Exception ex) {
        return value;
    }
}
%>
<%
Map<String, Object> invoiceData = (Map<String, Object>) session.getAttribute("lastInvoice");
if ("true".equalsIgnoreCase(request.getParameter("downloadInvoice"))) {
    if (invoiceData == null) {
        response.sendRedirect(request.getContextPath() + "/user/products.jsp");
        return;
    }

    String orderId = String.valueOf(invoiceData.get("orderId"));
    String safeFileName = URLEncoder.encode("invoice-" + orderId + ".html", "UTF-8").replace("+", "%20");
    List<OrderItem> invoiceItems = (List<OrderItem>) invoiceData.get("items");

    response.reset();
    response.setContentType("text/html; charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + safeFileName + "\"");

    StringBuilder invoiceHtml = new StringBuilder();
    invoiceHtml.append("<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><title>Invoice ")
        .append(escapeHtml(orderId))
        .append("</title><style>")
        .append("body{font-family:Arial,sans-serif;background:#f7f1ea;color:#2b1a12;margin:0;padding:32px;} ")
        .append(".invoice{max-width:900px;margin:0 auto;background:#fff;padding:32px;border-radius:18px;box-shadow:0 16px 40px rgba(44,25,16,.12);} ")
        .append(".head{display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap;border-bottom:2px solid #ead7c3;padding-bottom:20px;margin-bottom:24px;} ")
        .append(".brand h1{margin:0;font-size:30px;} .brand p,.meta p{margin:6px 0;} ")
        .append(".meta{text-align:right;} .block{margin-bottom:24px;} .block h2{font-size:18px;margin:0 0 10px;} ")
        .append("table{width:100%;border-collapse:collapse;} th,td{padding:12px;border-bottom:1px solid #ead7c3;text-align:left;} ")
        .append("th{background:#fbf5ee;} .amount{text-align:right;} .total{margin-top:18px;text-align:right;font-size:22px;font-weight:700;} ")
        .append("</style></head><body><div class=\"invoice\">")
        .append("<div class=\"head\"><div class=\"brand\"><h1>SalonBooking Invoice</h1><p>Thank you for your order.</p></div>")
        .append("<div class=\"meta\"><p><strong>Invoice No:</strong> ")
        .append(escapeHtml(orderId))
        .append("</p><p><strong>Date:</strong> ")
        .append(escapeHtml(formatInvoiceDate(String.valueOf(invoiceData.get("createdAt")))))
        .append("</p><p><strong>Payment:</strong> ")
        .append(escapeHtml(String.valueOf(invoiceData.get("paymentMethod"))))
        .append("</p></div></div>")
        .append("<div class=\"block\"><h2>Customer Details</h2><p><strong>Name:</strong> ")
        .append(escapeHtml(String.valueOf(invoiceData.get("customerName"))))
        .append("</p><p><strong>Phone:</strong> ")
        .append(escapeHtml(String.valueOf(invoiceData.get("phone"))))
        .append("</p><p><strong>Shipping Address:</strong> ")
        .append(escapeHtml(String.valueOf(invoiceData.get("shippingAddress"))))
        .append("</p></div>")
        .append("<div class=\"block\"><h2>Ordered Items</h2><table><thead><tr><th>Product</th><th>Qty</th><th>Unit Price</th><th class=\"amount\">Subtotal</th></tr></thead><tbody>");

    if (invoiceItems != null) {
        for (OrderItem item : invoiceItems) {
            invoiceHtml.append("<tr><td>")
                .append(escapeHtml(item.getProductName()))
                .append("</td><td>")
                .append(item.getQuantity())
                .append("</td><td>Rs. ")
                .append(item.getUnitPrice())
                .append("</td><td class=\"amount\">Rs. ")
                .append(item.getSubtotal())
                .append("</td></tr>");
        }
    }

    invoiceHtml.append("</tbody></table><div class=\"total\">Total: Rs. ")
        .append(invoiceData.get("totalAmount"))
        .append("</div></div>")
        .append("<div class=\"block\"><h2>Payment Details</h2><p>")
        .append(escapeHtml(String.valueOf(invoiceData.get("paymentDetails"))))
        .append("</p><p><strong>Status:</strong> Success</p></div>")
        .append("</div></body></html>");

    response.getWriter().write(invoiceHtml.toString());
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Status</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/user/css/style.css">
</head>
<body class="payment-page">
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
    String cleanedCardNumber = cardNumber == null ? "" : cardNumber.replaceAll("\\D", "");
    boolean validExpiry = expiry != null && expiry.matches("(0[1-9]|1[0-2])/\\d{2}");

    if (cleanedCardNumber.length() < 12 || cleanedCardNumber.length() > 16 ||
        !validExpiry ||
        cvv == null || cvv.trim().length() < 3 ||
        cardName == null || cardName.trim().isEmpty()) {
        valid = false;
        error = "Please fill valid card details.";
    }
} else if (valid && "netbanking".equals(method)) {
    String bankName = request.getParameter("bankName");
    String accountHolder = request.getParameter("accountHolder");
    String customerId = request.getParameter("customerId");
    String accountNumber = request.getParameter("accountNumber");
    String confirmAccountNumber = request.getParameter("confirmAccountNumber");
    String ifscCode = request.getParameter("ifscCode");
    String branchName = request.getParameter("branchName");
    boolean validIfsc = ifscCode != null && ifscCode.matches("[A-Za-z]{4}0[0-9A-Za-z]{6}");

    if (bankName == null || bankName.trim().isEmpty() ||
        accountHolder == null || accountHolder.trim().isEmpty() ||
        customerId == null || customerId.trim().isEmpty() ||
        accountNumber == null || !accountNumber.matches("\\d{9,18}") ||
        confirmAccountNumber == null || !confirmAccountNumber.equals(accountNumber) ||
        !validIfsc ||
        branchName == null || branchName.trim().isEmpty()) {
        valid = false;
        error = "Please fill valid net banking details.";
    }
} else if (valid && ! ("qr".equals(method) || "card".equals(method) || "netbanking".equals(method))) {
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
    String paymentDetails = "Paid via QR";
    String orderId = "";
    String createdAt = "";
    if ("qr".equals(method)) label = "QR Payment";
    else if ("card".equals(method)) label = "Card";
    else if ("netbanking".equals(method)) label = "Net Banking";
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
        if ("card".equals(method)) {
            String lastFour = digits.length() >= 4 ? digits.substring(digits.length() - 4) : digits;
            paymentDetails = "Card ending in " + lastFour;
        } else if ("netbanking".equals(method)) {
            String bankName = request.getParameter("bankName");
            String accountNumber = request.getParameter("accountNumber");
            String ifscCode = request.getParameter("ifscCode");
            String customerId = request.getParameter("customerId");
            String lastFour = accountNumber != null && accountNumber.length() >= 4
                ? accountNumber.substring(accountNumber.length() - 4)
                : "";
            paymentDetails = "Net Banking - " + bankName
                + ", A/C ending in " + lastFour
                + ", IFSC " + ifscCode.toUpperCase()
                + ", User " + customerId;
        }

        String customerName = (String) session.getAttribute("userName");
        String shippingAddress = address.trim() + ", " + city.trim() + ", " + state.trim() + " - " + pincode.trim();
        String invoiceCustomerName = (customerName == null || customerName.trim().isEmpty()) ? fullName.trim() : customerName.trim();

        try {
            String ordersPath = application.getInitParameter("ordersXmlPath");
            if (ordersPath == null || ordersPath.trim().isEmpty()) {
                ordersPath = application.getRealPath("/") + ".." + File.separator + ".." + File.separator + "data" + File.separator + "orders.xml";
            }
            File ordersFile = new File(ordersPath).getCanonicalFile();
            OrderRecord savedOrder = OrderXmlUtil.appendOrder(
                ordersFile,
                new NewOrderData(
                    invoiceCustomerName,
                    phone.trim(),
                    shippingAddress,
                    label,
                    "SUCCESS",
                    paymentDetails,
                    totalAmount,
                    orderItems
                )
            );
            orderId = savedOrder.getOrderId();
            createdAt = savedOrder.getCreatedAt();

            Map<String, Object> generatedInvoice = new LinkedHashMap<>();
            generatedInvoice.put("orderId", orderId);
            generatedInvoice.put("createdAt", createdAt);
            generatedInvoice.put("customerName", invoiceCustomerName);
            generatedInvoice.put("phone", phone.trim());
            generatedInvoice.put("shippingAddress", shippingAddress);
            generatedInvoice.put("paymentMethod", label);
            generatedInvoice.put("paymentDetails", paymentDetails);
            generatedInvoice.put("totalAmount", totalAmount);
            generatedInvoice.put("items", new ArrayList<OrderItem>(orderItems));
            session.setAttribute("lastInvoice", generatedInvoice);

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
        <p class="upi-note">Invoice No: <strong><%= orderId %></strong></p>
        <p class="upi-note">Invoice Date: <strong><%= formatInvoiceDate(createdAt) %></strong></p>
        <p class="payment-total">Payment Method: <strong><%= label %></strong></p>
        <p class="upi-note">Shipping To: <strong><%= fullName %></strong>, <%= address %>, <%= city %>, <%= state %> - <%= pincode %></p>
        <p class="upi-note">Phone: <%= phone %></p>
        <p class="upi-note">Order Total: <strong>&#8377; <%= totalAmount %></strong></p>
        <p class="upi-note">Your order has been placed successfully.</p>
        <div class="pay-actions">
            <a href="<%= request.getContextPath() %>/user/processPayment.jsp?downloadInvoice=true" class="pay-btn">Download Invoice</a>
            <a href="<%= request.getContextPath() %>/user/products.jsp" class="cart-btn">Continue Shopping</a>
        </div>
    </div>
<%
    }
} %>
</div>
</body>
</html>

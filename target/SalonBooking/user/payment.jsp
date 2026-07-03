<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/user/css/style.css">
</head>
<body class="payment-page">
<div class="page-overlay">
    <h1 class="page-title">Payment</h1>

<%
HashMap<Integer, Integer> cart =
    (HashMap<Integer, Integer>) session.getAttribute("cart");
int total = 0;

if (cart != null && !cart.isEmpty()) {
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

        String sql = "SELECT id, price FROM products WHERE active = 1 AND id IN (" + placeholders.toString() + ")";
        ps = con.prepareStatement(sql);
        for (int i = 0; i < ids.size(); i++) {
            ps.setInt(i + 1, ids.get(i));
        }

        rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            int price = rs.getInt("price");
            int qty = cart.getOrDefault(id, 0);
            total += (price * qty);
        }
    } catch (Exception e) {
        total = 0;
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ex) {}
        if (ps != null) try { ps.close(); } catch (Exception ex) {}
        if (con != null) try { con.close(); } catch (Exception ex) {}
    }
}

if (cart == null || cart.isEmpty()) {
%>
    <div class="cart-table">
        <p class="empty-cart">Your cart is empty. Add products before payment.</p>
        <a class="cart-btn" href="<%= request.getContextPath() %>/user/products.jsp">Continue Shopping</a>
    </div>
<%
} else {
%>
    <div class="payment-box">
        <form action="<%= request.getContextPath() %>/user/processPayment.jsp" method="post" id="paymentForm">
            <div class="checkout-grid">
                <div class="shipping-panel">
                    <span class="panel-kicker">Delivery Details</span>
                    <p class="shipping-title">Shipping Address</p>
                    <p class="shipping-subtext">Use the address where you want the products delivered.</p>
                    <div class="card-row">
                        <input type="text" name="fullName" placeholder="Full Name" autocomplete="name" required>
                        <input type="tel" name="phone" placeholder="Phone Number" autocomplete="tel" pattern="[0-9]{10}" required>
                    </div>
                    <textarea name="address" placeholder="House No, Street, Area" autocomplete="street-address" rows="6" required></textarea>
                    <div class="card-row">
                        <input type="text" name="city" placeholder="City" autocomplete="address-level2" required>
                        <input type="text" name="state" placeholder="State" autocomplete="address-level1" required>
                    </div>
                    <input type="text" name="pincode" placeholder="Pincode" autocomplete="postal-code" pattern="[0-9]{6}" required>
                </div>

                <div class="payment-panel">
                    <p class="payment-total">Total Amount: <strong>&#8377; <%= total %></strong></p>

                    <div class="method-list">
                        <label><input type="radio" name="paymentMethod" value="qr" checked> QR Payment</label>
                        <label><input type="radio" name="paymentMethod" value="card"> Card</label>
                    </div>
                    <p class="payment-note">Cash on Delivery is not available for online orders.</p>

                    <div id="qrBlock" class="method-block active-block">
                        <div class="qr-box">
                            <p class="qr-title">Scan this code with any UPI app</p>
                            <img
                                src="<%= request.getContextPath() %>/user/images/upi-qr.png"
                                alt="UPI QR Code"
                                class="upi-qr-img"
                                onerror="this.style.display='none'; document.getElementById('qrFallback').hidden = false;">
                            <p id="qrFallback" class="upi-note" hidden>QR image not found. Add file: user/images/upi-qr.png</p>
                            <p class="upi-note">UPI: salonbooking@upi</p>
                        </div>
                    </div>

                    <div id="cardBlock" class="method-block" hidden>
                        <input type="text" name="cardNumber" placeholder="Card Number" maxlength="19">
                        <div class="card-row">
                            <input type="text" name="expiry" placeholder="MM/YY" maxlength="5">
                            <input type="password" name="cvv" placeholder="CVV" maxlength="4">
                        </div>
                        <input type="text" name="cardName" placeholder="Name on Card">
                    </div>

                    <div class="pay-actions">
                        <button type="submit" class="pay-btn">Pay Now</button>
                        <a href="<%= request.getContextPath() %>/user/cart.jsp" class="cart-btn">Back to Cart</a>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        const methods = document.querySelectorAll('input[name="paymentMethod"]');
        const blocks = {
            qr: document.getElementById('qrBlock'),
            card: document.getElementById('cardBlock')
        };

        function showBlock(selected) {
            Object.keys(blocks).forEach(function(key) {
                blocks[key].classList.remove('active-block');
                blocks[key].hidden = true;
            });
            blocks[selected].classList.add('active-block');
            blocks[selected].hidden = false;
        }

        methods.forEach(function(radio) {
            radio.addEventListener('change', function() {
                showBlock(this.value);
            });
        });

        const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
        if (selectedMethod) {
            showBlock(selectedMethod.value);
        }
    </script>
<% } %>
</div>
</body>
</html>

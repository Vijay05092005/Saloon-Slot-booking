<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<html>
<head>
    <title>Salon Product Store</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/user/css/style.css">
</head>
<script>
function updateClock() {
    let clockElement = document.getElementById("digitalClock");

    if (clockElement) {
        clockElement.innerHTML = new Date().toLocaleTimeString();
    }
}

setInterval(updateClock, 1000);
updateClock();
</script>
<body class="products-page">

<div class="page-overlay">
    <div class="products-hero">
        <div class="hero-copy">
            <span class="hero-tag">Curated Salon Essentials</span>
            <h1 class="page-title">Salon Product Store</h1>
            <p class="page-sub">Premium care for your beauty</p>
        </div>
        <div class="hero-side">
            <div class="top-actions">
                <div class="digital-clock" id="digitalClock"></div>
                <a class="slot-btn" href="http://localhost/SalonBookingPHP/slot_booking.php">Book Slot</a>
                <a class="cart-btn" href="<%= request.getContextPath() %>/user/cart.jsp">View Cart</a>
            </div>
            <div class="hero-highlights">
                <div class="highlight-card">
                    <span class="highlight-value">Fresh</span>
                    <span class="highlight-label">daily self-care picks</span>
                </div>
                <div class="highlight-card">
                    <span class="highlight-value">Glow</span>
                    <span class="highlight-label">trusted salon-quality range</span>
                </div>
            </div>
        </div>
    </div>

    <div class="product-container">

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement("SELECT id, name, price, image FROM products WHERE active = 1 ORDER BY id");
        rs = ps.executeQuery();

        while (rs.next()) {
%>

        <div class="product-card">
            <div class="product-media">
                <img src="<%= request.getContextPath() %>/user/images/<%= rs.getString("image") %>" alt="<%= rs.getString("name") %>">
            </div>
            <div class="product-content">
                <span class="product-badge">Salon Pick</span>
                <h3><%= rs.getString("name") %></h3>
                <p class="price">&#8377; <%= rs.getInt("price") %></p>

                <form action="<%= request.getContextPath() %>/user/addToCart.jsp" method="post">
                <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </div>

<%
        }
    } catch (Exception e) {
%>
        <p class="empty-cart">Unable to load products right now.</p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ex) {}
        if (ps != null) try { ps.close(); } catch (Exception ex) {}
        if (con != null) try { con.close(); } catch (Exception ex) {}
    }
%>

    </div>

</div>
<style>
#chatBtn {
    position: fixed;
    bottom: 24px;
    right: 24px;
    width: 64px;
    height: 64px;
    border-radius: 50%;
    border: none;
    background: linear-gradient(135deg, #2ee2b6, #0fa4ff);
    color: white;
    font-size: 26px;
    cursor: pointer;
    box-shadow: 0 14px 35px rgba(16, 144, 255, 0.45);
    transition: transform 0.25s ease, box-shadow 0.25s ease;
    z-index: 1000;
    border: 1px solid rgba(255,255,255,0.28);
}

#chatBtn:hover {
    transform: translateY(-4px) scale(1.07);
    box-shadow: 0 18px 42px rgba(16, 144, 255, 0.58);
}

#chatbox {
    position: fixed;
    bottom: 98px;
    right: 24px;
    width: 360px;
    height: 520px;
    border-radius: 24px;
    border: 1px solid rgba(255,255,255,0.14);
    background:
        radial-gradient(circle at top right, rgba(72, 197, 255, 0.2), transparent 40%),
        radial-gradient(circle at bottom left, rgba(65, 255, 216, 0.16), transparent 35%),
        linear-gradient(160deg, rgba(14, 22, 33, 0.95), rgba(8, 12, 19, 0.98));
    box-shadow: 0 18px 55px rgba(0,0,0,0.45);
    display: none;
    flex-direction: column;
    overflow: hidden;
    z-index: 999;
}

#chatHeader {
    background: linear-gradient(120deg, #35d7b3, #0d8dff);
    color: white;
    padding: 14px 16px;
    font-weight: 700;
    font-size: 16px;
    letter-spacing: 0.5px;
    border-bottom: 1px solid rgba(255,255,255,0.18);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.chat-title {
    display: flex;
    flex-direction: column;
    line-height: 1.1;
}

.chat-sub {
    font-size: 11px;
    font-weight: 500;
    opacity: 0.92;
    margin-top: 4px;
}

.chat-status {
    width: 11px;
    height: 11px;
    border-radius: 50%;
    background: #b6ff63;
    box-shadow: 0 0 12px rgba(182,255,99,0.85);
}

#messages {
    flex: 1;
    padding: 16px 12px 12px;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    gap: 8px;
    background:
        radial-gradient(circle at 100% 0%, rgba(44, 83, 100, 0.22), transparent 40%),
        radial-gradient(circle at 0% 100%, rgba(7, 117, 133, 0.2), transparent 42%);
}

#messages::-webkit-scrollbar {
    width: 8px;
}

#messages::-webkit-scrollbar-track {
    background: rgba(255,255,255,0.06);
}

#messages::-webkit-scrollbar-thumb {
    background: linear-gradient(#35d7b3, #0d8dff);
    border-radius: 8px;
}

.message {
    padding: 10px 14px;
    border-radius: 16px;
    max-width: 75%;
    font-size: 14px;
    line-height: 1.4;
    word-break: break-word;
    color: #e6eef8;
    box-shadow: 0 8px 24px rgba(0,0,0,0.22);
    animation: popIn 0.25s ease;
    border: 1px solid rgba(255,255,255,0.08);
}

.user {
    background: linear-gradient(130deg, #1fb7ff, #0f8adf);
    align-self: flex-end;
    border-bottom-right-radius: 6px;
    color: #ffffff;
}

.bot {
    background: linear-gradient(130deg, #1d2939, #253245);
    align-self: flex-start;
    border-bottom-left-radius: 6px;
    border: 1px solid rgba(255,255,255,0.08);
}

#chatInputArea {
    display: flex;
    gap: 8px;
    padding: 12px;
    background: rgba(9, 14, 22, 0.92);
    border-top: 1px solid rgba(255,255,255,0.1);
    backdrop-filter: blur(8px);
}

#chatInputArea input {
    flex: 1;
    padding: 10px 12px;
    border-radius: 14px;
    border: 1px solid rgba(255,255,255,0.18);
    background: rgba(255,255,255,0.08);
    color: #f2f8ff;
    outline: none;
    font-weight: 500;
}

#chatInputArea input::placeholder {
    color: #a7b4c6;
}

#chatInputArea input:focus {
    border-color: #35d7b3;
    box-shadow: 0 0 0 3px rgba(53, 215, 179, 0.2);
}
.typing {
    font-style: italic;
    opacity: 0.7;
}
#chatInputArea button {
    margin-top: 0;
    width: auto;
    padding: 10px 14px;
    border: none;
    border-radius: 14px;
    background: linear-gradient(130deg, #35d7b3, #0d8dff);
    color: white;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 8px 22px rgba(13, 141, 255, 0.4);
}

#chatInputArea button:hover {
    transform: translateY(-2px);
}

@keyframes popIn {
    from {
        opacity: 0;
        transform: translateY(8px) scale(0.98);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@media (max-width: 640px) {
    #chatbox {
        width: calc(100vw - 24px);
        right: 12px;
        bottom: 86px;
        height: 70vh;
    }

    #chatBtn {
        right: 14px;
        bottom: 14px;
        width: 58px;
        height: 58px;
    }
}
</style>
<style>
body.products-page #chatBtn {
    background: linear-gradient(135deg, #f3c995, #e5a96b);
    color: #2f1b0c;
    box-shadow: 0 14px 35px rgba(107, 70, 41, 0.4);
}

body.products-page #chatBtn:hover {
    box-shadow: 0 18px 42px rgba(107, 70, 41, 0.54);
}

body.products-page #chatbox {
    border: 1px solid rgba(255, 229, 198, 0.35);
    background:
        radial-gradient(circle at top right, rgba(244, 197, 145, 0.2), transparent 42%),
        radial-gradient(circle at bottom left, rgba(198, 142, 85, 0.18), transparent 40%),
        linear-gradient(160deg, rgba(60, 40, 24, 0.95), rgba(41, 27, 16, 0.96));
}

body.products-page #chatHeader {
    background: linear-gradient(120deg, #edbe89, #cf9153);
    color: #26170d;
}

body.products-page #messages {
    background:
        radial-gradient(circle at 100% 0%, rgba(227, 178, 125, 0.2), transparent 40%),
        radial-gradient(circle at 0% 100%, rgba(145, 98, 55, 0.18), transparent 42%);
}

body.products-page #messages::-webkit-scrollbar-thumb {
    background: linear-gradient(#edbe89, #cf9153);
}

body.products-page .user {
    background: linear-gradient(130deg, #edbe89, #d69b5f);
    color: #2f1b0c;
}

body.products-page .bot {
    background: linear-gradient(130deg, #3f2b1b, #573a25);
    color: #f4e8db;
}

body.products-page #chatInputArea {
    background: rgba(34, 23, 14, 0.92);
}

body.products-page #chatInputArea input {
    border: 1px solid rgba(255, 228, 197, 0.24);
    background: rgba(255, 241, 223, 0.1);
    color: #f8eee3;
}

body.products-page #chatInputArea input:focus {
    border-color: #edbe89;
    box-shadow: 0 0 0 3px rgba(237, 190, 137, 0.2);
}

body.products-page #chatInputArea button {
    background: linear-gradient(130deg, #edbe89, #cf9153);
    color: #2d1a0f;
    box-shadow: 0 8px 22px rgba(112, 73, 42, 0.4);
}
</style>
<button id="chatBtn">&#128172;</button>

<div id="chatbox">
    <div id="chatHeader">
        <div class="chat-title">
            <span>Salon Assistant</span>
            <span class="chat-sub">Instant beauty help</span>
        </div>
        <span class="chat-status"></span>
    </div>

    <div id="messages"></div>

    <div id="chatInputArea">
        <input type="text" id="msg" placeholder="Type your message..." onkeypress="handleKey(event)">
        <button onclick="sendMsg()">Send</button>
    </div>
</div>
<script>
    let greeted=false;
document.getElementById("chatBtn").onclick = function() {
    let box = document.getElementById("chatbox");

    if (box.style.display === "none" || box.style.display === "") {
        box.style.display = "flex";

        if (!greeted) {
            let messagesDiv = document.getElementById("messages");

            let welcomeDiv = document.createElement("div");
            welcomeDiv.className = "message bot";
            welcomeDiv.innerText = "Hello! Welcome to Salon! How can I help you today?";
            
            messagesDiv.appendChild(welcomeDiv);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;

            greeted = true;
        }

    } else {
        box.style.display = "none";
    }
};

function handleKey(e) {
    if (e.key === "Enter") {
        sendMsg();
    }
}

function sendMsg() {
    let messageInput = document.getElementById("msg");
    let message = messageInput.value.trim();
    if (message === "") return;

    let messagesDiv = document.getElementById("messages");

    // Add user message
    let userDiv = document.createElement("div");
    userDiv.className = "message user";
    userDiv.innerText = message;
    messagesDiv.appendChild(userDiv);
    // Create typing indicator
let typingDiv = document.createElement("div");
typingDiv.className = "message bot typing";
typingDiv.innerText = "Typing...";
messagesDiv.appendChild(typingDiv);
messagesDiv.scrollTop = messagesDiv.scrollHeight;

fetch("http://localhost/SalonBookingPHP/chatbot.php", {
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "message=" + encodeURIComponent(message)
})
.then(response => response.text())
.then(data => {

    // Remove typing text
    typingDiv.remove();

    // Add real bot message
    let botDiv = document.createElement("div");
    botDiv.className = "message bot";
    botDiv.innerText = data;

    messagesDiv.appendChild(botDiv);
    messagesDiv.scrollTop = messagesDiv.scrollHeight;
});

    
    messageInput.value = "";
}
</script>
</body>
</html>





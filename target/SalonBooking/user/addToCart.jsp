<%@ page import="java.util.*" %>
<%
HashMap<Integer, Integer> cart =
    (HashMap<Integer, Integer>) session.getAttribute("cart");
if (cart == null) {
    cart = new HashMap<>();
}
String idParam = request.getParameter("productId");
if (idParam != null) {
    int productId = Integer.parseInt(idParam);
    int qty = cart.getOrDefault(productId, 0);
    cart.put(productId, qty + 1);
}
session.setAttribute("cart", cart);
response.sendRedirect(request.getContextPath() + "/user/products.jsp");
%>

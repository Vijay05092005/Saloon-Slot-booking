<%@ page import="java.util.*" %>
<%
HashMap<Integer, Integer> cart =
    (HashMap<Integer, Integer>) session.getAttribute("cart");
String idParam = request.getParameter("productId");
if (cart != null && idParam != null) {
    int productId = Integer.parseInt(idParam);
    cart.remove(productId);
}
session.setAttribute("cart", cart);
response.sendRedirect(request.getContextPath() + "/user/cart.jsp");
%>

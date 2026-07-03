<%@ page import="java.util.*" %>
<%
HashMap<Integer, Integer> cart =
    (HashMap<Integer, Integer>) session.getAttribute("cart");
String idParam = request.getParameter("productId");
String action = request.getParameter("action");

if (cart != null && idParam != null) {
    int productId = Integer.parseInt(idParam);
    if (cart.containsKey(productId)) {
        int qty = cart.get(productId);
        if ("inc".equals(action)) {
            cart.put(productId, qty + 1);
        } else if ("dec".equals(action)) {
            if (qty > 1) {
                cart.put(productId, qty - 1);
            } else {
                cart.remove(productId);
            }
        }
    }
}
session.setAttribute("cart", cart);
response.sendRedirect(request.getContextPath() + "/user/cart.jsp");
%>

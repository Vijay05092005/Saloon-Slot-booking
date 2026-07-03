<%@ page import="java.util.*" %>
<%
    session.removeAttribute("cart");
    response.sendRedirect(request.getContextPath() + "/user/cart.jsp");
%>

package servlets;
import util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("loginEmail");
        String password = request.getParameter("loginpassword");
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalidemail");
            return;
        }
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$")) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=weakpassword");
            return;
        }
        String role = request.getParameter("loginType");
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=? AND role=?"
            );
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("role", role);
                Cookie cookie = new Cookie("userEmail", email);
                cookie.setMaxAge(60 * 60);
                cookie.setPath("/");
                response.addCookie(cookie);
                PreparedStatement psCookie = con.prepareStatement(
                    "INSERT INTO user_cookies (user_id, cookie_name, cookie_value) VALUES (?, ?, ?)"
                );
                psCookie.setInt(1, rs.getInt("id"));
                psCookie.setString(2, "userEmail");
                psCookie.setString(3, email);
                psCookie.executeUpdate();
                PreparedStatement psSession = con.prepareStatement(
                    "INSERT INTO user_sessions (user_id, session_id, login_time, status) VALUES (?, ?, NOW(), ?)"
                );
                psSession.setInt(1, rs.getInt("id"));
                psSession.setString(2, session.getId());
                psSession.setString(3, "ACTIVE");
                psSession.executeUpdate();
                if ("admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/admin/viewProducts.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/products.jsp");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=server");
        }
    }
}
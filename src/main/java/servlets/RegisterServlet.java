package servlets;

import util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.*;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String email = request.getParameter("regEmail");
    	String password = request.getParameter("regpassword");

    	if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
    	    response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalidemail");
    	    return;
    	}

    	if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$")) {
    	    response.sendRedirect(request.getContextPath() + "/index.jsp?error=weakpassword");
    	    return;
    	}

        String name = request.getParameter("regName");
        String phone = request.getParameter("regPhone");
        String role = request.getParameter("regType");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password,phone,role) VALUES (?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, role);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/index.jsp?msg=registered");

        } catch (SQLIntegrityConstraintViolationException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=exists");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=server");
        }
    }
}

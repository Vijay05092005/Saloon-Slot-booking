package servlets;

import util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.*;


public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);

            if (session != null) {

                Connection con = DBConnection.getConnection();

                PreparedStatement ps = con.prepareStatement(
                	    "UPDATE user_sessions SET status = ?, logout_time = NOW() WHERE session_id = ?"
                	);

                	ps.setString(1, "INACTIVE");
                	ps.setString(2, session.getId());
                	ps.executeUpdate();


            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}

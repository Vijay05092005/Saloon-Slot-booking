package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class DeleteStaffServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM staff WHERE id=?"
            );
            ps.setInt(1, id);
            ps.executeUpdate();
            con.close();
            response.sendRedirect(request.getContextPath() + "/admin/viewStaff.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
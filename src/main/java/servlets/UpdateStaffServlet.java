package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import util.DBConnection;



public class UpdateStaffServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        int experience = Integer.parseInt(request.getParameter("experience"));
        String phone = request.getParameter("phone");
        double salary = Double.parseDouble(request.getParameter("salary"));
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE staff SET name=?, role=?, experience=?, phone=?, salary=? WHERE id=?"
            );
            ps.setString(1, name);
            ps.setString(2, role);
            ps.setInt(3, experience);
            ps.setString(4, phone);
            ps.setDouble(5, salary);
            ps.setInt(6, id);
            ps.executeUpdate();
            con.close();
            response.sendRedirect(request.getContextPath() + "/admin/viewStaff.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

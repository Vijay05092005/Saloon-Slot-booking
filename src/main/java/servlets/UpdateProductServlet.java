package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBConnection;

public class UpdateProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        String image = request.getParameter("image");
        int active = request.getParameter("active") != null ? 1 : 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE products SET name=?, price=?, image=?, active=? WHERE id=?"
             )) {

            ps.setString(1, name);
            ps.setInt(2, price);
            ps.setString(3, image);
            ps.setInt(4, active);
            ps.setInt(5, id);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/admin/viewProducts.jsp");
        } catch (Exception e) {
            throw new ServletException("Unable to update product", e);
        }
    }
}

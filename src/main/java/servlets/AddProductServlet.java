package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBConnection;

public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        String image = request.getParameter("image");
        int active = request.getParameter("active") != null ? 1 : 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO products (name, price, image, active) VALUES (?, ?, ?, ?)"
             )) {

            ps.setString(1, name);
            ps.setInt(2, price);
            ps.setString(3, image);
            ps.setInt(4, active);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/admin/viewProducts.jsp");
        } catch (Exception e) {
            throw new ServletException("Unable to add product", e);
        }
    }
}

<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
int id = Integer.parseInt(request.getParameter("id"));
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT * FROM staff WHERE id=?");
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();
rs.next();
%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-staff.css">

<div class="container">
    <h2>Edit Staff</h2>
    <a href="<%= request.getContextPath() %>/admin/viewProducts.jsp" class="back-btn">Back to Product Updation</a>

    <form action="<%= request.getContextPath() %>/UpdateStaffServlet" method="post">

        <input type="hidden" name="id" value="<%= id %>">

        <div class="form-group">
            <label>Name</label>
            <input type="text" name="name" value="<%= rs.getString("name") %>">
        </div>

        <div class="form-group">
            <label>Role</label>
            <input type="text" name="role" value="<%= rs.getString("role") %>">
        </div>

        <div class="form-group">
            <label>Experience</label>
            <input type="number" name="experience" value="<%= rs.getInt("experience") %>">
        </div>

        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" value="<%= rs.getString("phone") %>">
        </div>

        <div class="form-group">
            <label>Salary</label>
            <input type="number" step="0.01" name="salary" value="<%= rs.getDouble("salary") %>">
        </div>

        <button type="submit">Update Staff</button>

    </form>
</div>
<%
con.close();
%>

<%@ page import="java.sql.*,util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
HttpSession s = request.getSession(false);
if (s == null || !"admin".equals(s.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin-dashboard.css">
</head>
<script>
function updateClock() {
    const now = new Date();
    const dateOptions = {
        weekday: "short",
        year: "numeric",
        month: "short",
        day: "numeric"
    };

    const date = now.toLocaleDateString(undefined, dateOptions);
    const time = now.toLocaleTimeString();

    document.getElementById("digitalClock").innerHTML = date + " | " + time;
}

setInterval(updateClock, 1000);
updateClock();
</script>
<body>
<%
Connection conn = DBConnection.getConnection();
Statement stn = conn.createStatement();
ResultSet totalLoginsRs = stn.executeQuery("SELECT COUNT(*) FROM user_sessions");
totalLoginsRs.next();
int totalLogins = totalLoginsRs.getInt(1);

ResultSet activeLoginsRs = stn.executeQuery(
    "SELECT COUNT(*) FROM user_sessions WHERE status='ACTIVE'"
);
activeLoginsRs.next();
int activeLogins = activeLoginsRs.getInt(1);
%>
<div class="background">
    <div class="dashboard-layout">
        <aside class="dashboard-sidebar">
            <div class="sidebar-brand">
                <p class="sidebar-kicker">Admin Panel</p>
                <h2>Salon Control</h2>
                <p class="sidebar-copy">Quick access to product, staff, order, and session pages.</p>
            </div>

            <nav class="sidebar-nav">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewProducts.jsp">Product Updation</a>
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/addProduct.jsp">Add New Product</a>
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewStaff.jsp">Staff Management</a>
                <a class="sidebar-link active" href="<%= request.getContextPath() %>/adminDashboard.jsp">Session Information</a>
                <a class="sidebar-link" href="<%= request.getContextPath() %>/admin/viewOrders.jsp">Order Details</a>
                <a class="sidebar-link" href="http://localhost/SalonBookingPHP/admin/dashboard.php">Slot Updation</a>
            </nav>

            <form action="<%= request.getContextPath() %>/LogoutServlet" method="get" class="sidebar-logout-form">
                <button class="logout-btn">Logout</button>
            </form>
        </aside>

        <div class="dashboard-glass">
            <div class="top-header">
                <div>
                    <p class="section-label">Monitoring</p>
                    <h1>Session Information</h1>
                </div>
                <div class="digital-clock" id="digitalClock"></div>
            </div>

            <p class="tagline">Track login activity and review the latest session status for each user.</p>

            <div class="stats-container">
                <div class="stat-card">
                    <h4>Total Logins</h4>
                    <p><%= totalLogins %></p>
                </div>

                <div class="stat-card">
                    <h4>Active Sessions</h4>
                    <p><%= activeLogins %></p>
                </div>
            </div>

            <div class="glass-section">
                <h3>Latest Login Per User</h3>
                <table>
                    <tr>
                        <th>User</th>
                        <th>Session ID</th>
                        <th>Login Time</th>
                        <th>Logout Time</th>
                        <th>Status</th>
                    </tr>

                    <%
                    ResultSet rs = stn.executeQuery(
                        "SELECT u.name, s.session_id, s.login_time, s.logout_time, s.status " +
                        "FROM user_sessions s " +
                        "JOIN users u ON s.user_id = u.id " +
                        "JOIN (" +
                        "    SELECT user_id, MAX(login_time) AS latest_login " +
                        "    FROM user_sessions " +
                        "    GROUP BY user_id" +
                        ") latest ON latest.user_id = s.user_id AND latest.latest_login = s.login_time " +
                        "ORDER BY s.login_time DESC"
                    );

                    while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString(1) %></td>
                        <td><%= rs.getString(2) %></td>
                        <td><%= rs.getTimestamp(3) %></td>
                        <td><%= rs.getTimestamp(4) %></td>
                        <td class="<%= rs.getString("status").equals("ACTIVE") ? "active" : "inactive" %>">
                            <%= rs.getString("status") %>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>

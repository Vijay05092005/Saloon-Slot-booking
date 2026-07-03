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
    <div class="dashboard-glass">
        <div class="top-header">
            <h1>Session Information</h1>
            <div class="top-actions">
                <a class="header-link primary" href="<%= request.getContextPath() %>/admin/viewProducts.jsp">Back to Product Updation</a>
            </div>
            <div class="digital-clock" id="digitalClock"></div>
        </div>

        <p class="tagline">Session Monitoring</p>
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
            <h3>Active Sessions</h3>
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
                    "FROM user_sessions s JOIN users u ON s.user_id = u.id"
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

        <form action="<%= request.getContextPath() %>/LogoutServlet" method="get">
            <button class="logout-btn">Logout</button>
        </form>
    </div>
</div>
</body>
</html>

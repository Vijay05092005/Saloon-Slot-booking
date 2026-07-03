<?php
include '../db.php';

$selectedDate = trim($_GET['date'] ?? '');

$sql = "SELECT
            bookings.customer_name,
            bookings.customer_email,
            bookings.booking_date,
            bookings.payment_amount,
            bookings.payment_method,
            bookings.payment_status,
            bookings.transaction_id,
            slots.slot_date,
            slots.slot_time
        FROM bookings
        JOIN slots ON bookings.slot_id = slots.id";

if ($selectedDate !== '') {
    $sql .= " WHERE slots.slot_date = ?";
}

$sql .= " ORDER BY slots.slot_time ASC, bookings.booking_date DESC";

if ($selectedDate !== '') {
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('s', $selectedDate);
    $stmt->execute();
    $result = $stmt->get_result();
    $stmt->close();
} else {
    $result = $conn->query($sql);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Bookings</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../assets/styles.css">
</head>
<body class="slot-theme">
<main class="page">
<div class="slot-admin-layout">
<aside class="panel slot-sidebar">
<p class="slot-kicker">Admin Panel</p>
<h3 class="slot-sidebar-title">Salon Control</h3>
<p class="slot-sidebar-text">Move across product, staff, order, slot, and session pages from one place.</p>
<nav class="sidebar-nav" aria-label="Admin navigation">
<a class="sidebar-link" href="http://localhost:8080/SalonBooking/admin/viewProducts.jsp">Product Updation</a>
<a class="sidebar-link" href="http://localhost:8080/SalonBooking/admin/addProduct.jsp">Add New Product</a>
<a class="sidebar-link" href="http://localhost:8080/SalonBooking/admin/viewStaff.jsp">Staff Management</a>
<a class="sidebar-link" href="http://localhost:8080/SalonBooking/adminDashboard.jsp">Session Information</a>
<a class="sidebar-link" href="http://localhost:8080/SalonBooking/admin/viewOrders.jsp">Order Details</a>
<a class="sidebar-link active" href="http://localhost/SalonBookingPHP/admin/dashboard.php">Slot Updation</a>
</nav>
</aside>

<div class="slot-admin-main">
<section class="panel slot-hero">
<div class="slot-hero-grid">
<div class="slot-copy">
<p class="slot-kicker">Admin Studio</p>
<h2>View Bookings</h2>
<p class="subtitle">Filter the appointment list by date and review payment details in the same warm glass theme used on the other salon pages.</p>
</div>
<aside class="slot-note">
<span class="slot-note-label">Daily Review</span>
<p>Use the date filter to isolate one service day, or clear it to inspect the full booking history.</p>
</aside>
</div>
</section>

<section class="panel panel-gap slot-panel">
<form method="get">
<div class="slot-form-grid">
<label>
Filter by Date
<input type="date" name="date" value="<?= htmlspecialchars($selectedDate, ENT_QUOTES, 'UTF-8') ?>">
</label>
<div class="actions">
<button type="submit">Apply Filter</button>
<a class="btn btn-soft" href="view_bookings.php">Clear</a>
</div>
</div>
</form>

<?php if ($result && $result->num_rows > 0) { ?>
<div class="table-shell">
<table>
<tr>
<th>Customer Name</th>
<th>Email</th>
<th>Date</th>
<th>Time</th>
<th>Booked On</th>
<th>Advance</th>
<th>Method</th>
<th>Status</th>
<th>Transaction ID</th>
</tr>

<?php while ($row = $result->fetch_assoc()) { ?>
<tr>
<td><?= htmlspecialchars($row['customer_name'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['customer_email'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['slot_date'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['slot_time'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['booking_date'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars(number_format((float)$row['payment_amount'], 2), ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['payment_method'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['payment_status'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['transaction_id'] ?? '', ENT_QUOTES, 'UTF-8') ?></td>
</tr>
<?php } ?>
</table>
</div>
<?php } else { ?>
<p class="empty-state">No bookings found for the current filter.</p>
<?php } ?>

<a class="back" href="dashboard.php">Back to Dashboard</a>
</section>
</div>
</div>
</main>
</body>
</html>

<?php
include '../db.php';

$totals = [
    'slots' => 0,
    'available' => 0,
    'booked' => 0,
    'today' => 0
];

$recentBookings = [];

$q = $conn->query("SELECT COUNT(*) AS c FROM slots");
if ($q && ($r = $q->fetch_assoc())) {
    $totals['slots'] = (int)$r['c'];
}

$q = $conn->query("SELECT COUNT(*) AS c FROM slots WHERE status = 'Available'");
if ($q && ($r = $q->fetch_assoc())) {
    $totals['available'] = (int)$r['c'];
}

$q = $conn->query("SELECT COUNT(*) AS c FROM slots WHERE status = 'Booked'");
if ($q && ($r = $q->fetch_assoc())) {
    $totals['booked'] = (int)$r['c'];
}

$q = $conn->query("SELECT COUNT(*) AS c FROM slots WHERE slot_date = CURDATE() AND status = 'Booked'");
if ($q && ($r = $q->fetch_assoc())) {
    $totals['today'] = (int)$r['c'];
}

$q = $conn->query(
    "SELECT b.customer_name, s.slot_date, s.slot_time
     FROM bookings b
     JOIN slots s ON b.slot_id = s.id
     ORDER BY b.booking_date DESC
     LIMIT 5"
);
if ($q) {
    while ($row = $q->fetch_assoc()) {
        $recentBookings[] = $row;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
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
<h2>Salon Admin Dashboard</h2>
<p class="subtitle">Create daily slots, adjust the calendar, and monitor recent activity with the same salon backdrop used across the rest of the booking flow.</p>
</div>
<aside class="slot-note">
<span class="slot-note-label">Live Snapshot</span>
<p>Track open slots, filled appointments, and today&apos;s booking volume from one place.</p>
</aside>
</div>
</section>

<section class="panel panel-gap slot-panel">
<div class="stats-grid">
<article class="stat-card">
<p class="stat-label">Total Slots</p>
<p class="stat-value"><?= $totals['slots'] ?></p>
</article>
<article class="stat-card">
<p class="stat-label">Available Slots</p>
<p class="stat-value"><?= $totals['available'] ?></p>
</article>
<article class="stat-card">
<p class="stat-label">Booked Slots</p>
<p class="stat-value"><?= $totals['booked'] ?></p>
</article>
<article class="stat-card">
<p class="stat-label">Today's Bookings</p>
<p class="stat-value"><?= $totals['today'] ?></p>
</article>
</div>

<div class="actions">
<a class="btn btn-primary" href="create_slot.php">Create Slots by Date</a>
<a class="btn btn-soft" href="view_slots.php">Manage Slots</a>
<a class="btn btn-soft" href="view_bookings.php">View Bookings</a>
</div>
</section>

<section class="panel panel-gap slot-panel">
<h3 class="section-title">Recent Bookings</h3>
<?php if (count($recentBookings) === 0) { ?>
<p class="empty-state">No bookings have been recorded yet.</p>
<?php } else { ?>
<div class="table-shell">
<table>
<tr>
<th>Customer</th>
<th>Date</th>
<th>Time</th>
</tr>
<?php foreach ($recentBookings as $booking) { ?>
<tr>
<td><?= htmlspecialchars($booking['customer_name'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($booking['slot_date'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($booking['slot_time'], ENT_QUOTES, 'UTF-8') ?></td>
</tr>
<?php } ?>
</table>
</div>
<?php } ?>
</section>
</div>
</div>
</main>
</body>
</html>

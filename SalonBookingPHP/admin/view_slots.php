<?php
include '../db.php';
$selectedDate = trim($_GET['date'] ?? '');

if ($selectedDate !== '') {
    $stmt = $conn->prepare("SELECT * FROM slots WHERE slot_date = ? ORDER BY slot_time ASC");
    $stmt->bind_param('s', $selectedDate);
    $stmt->execute();
    $result = $stmt->get_result();
    $stmt->close();
} else {
    $result = $conn->query("SELECT * FROM slots ORDER BY slot_date ASC, slot_time ASC");
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Slots</title>
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
<p class="slot-kicker">Slot Studio</p>
<h2>All Slots</h2>
<p class="subtitle">Review, filter, and maintain the full slot calendar with a darker glass treatment matched to the salon background image.</p>
</div>
<aside class="slot-note">
<span class="slot-note-label">Quick Control</span>
<p>Filter by date to isolate one service day, then edit or remove slots directly from the table.</p>
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
<a class="btn btn-soft" href="view_slots.php">Clear</a>
</div>
</div>
</form>

<?php if (isset($_GET['updated'])) { ?>
<p class="status success">Slot updated successfully.</p>
<?php } ?>
<?php if (isset($_GET['deleted'])) { ?>
<p class="status success">Slot deleted successfully.</p>
<?php } ?>
<?php if (isset($_GET['error'])) { ?>
<p class="status error">Unable to complete the request.</p>
<?php } ?>

<?php if ($result && $result->num_rows > 0) { ?>
<div class="table-shell">
<table>
<tr>
<th>ID</th>
<th>Date</th>
<th>Time</th>
<th>Status</th>
<th>Action</th>
</tr>

<?php while ($row = $result->fetch_assoc()) { ?>
<tr>
<td><?= (int)$row['id'] ?></td>
<td><?= htmlspecialchars($row['slot_date'], ENT_QUOTES, 'UTF-8') ?></td>
<td><?= htmlspecialchars($row['slot_time'], ENT_QUOTES, 'UTF-8') ?></td>
<td>
<span class="chip <?= $row['status'] === 'Available' ? 'available' : 'booked' ?>">
<?= htmlspecialchars($row['status'], ENT_QUOTES, 'UTF-8') ?>
</span>
</td>
<td>
<div class="row-actions">
<a class="btn btn-soft" href="edit_slot.php?id=<?= (int)$row['id'] ?>">Edit</a>
<a class="btn btn-danger" href="delete_slot.php?id=<?= (int)$row['id'] ?>" onclick="return confirm('Delete this slot?');">Delete</a>
</div>
</td>
</tr>
<?php } ?>
</table>
</div>
<?php } else { ?>
<p class="empty-state">No slots found for the current filter.</p>
<?php } ?>

<a class="back" href="dashboard.php">Back to Dashboard</a>
</section>
</div>
</div>
</main>
</body>
</html>

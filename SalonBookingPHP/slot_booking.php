<?php
include 'db.php';

$error = '';
$success = '';
$selectedDate = trim($_GET['slot_date'] ?? $_POST['slot_date'] ?? '');
$slots = null;
$hasSlots = false;

if (isset($_POST['book'])) {
    $slot_id = filter_input(INPUT_POST, 'slot_id', FILTER_VALIDATE_INT);
    $slotDate = trim($_POST['slot_date'] ?? '');
    $name = trim($_POST['name'] ?? '');
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
    $paymentAmount = 500.00;
    $paymentMethod = trim($_POST['payment_method'] ?? '');
    $transactionId = trim($_POST['transaction_id'] ?? '');

    $validMethods = ['UPI'];

    if (!$slot_id || $slotDate === '' || $name === '' || !$email || $transactionId === '' || !in_array($paymentMethod, $validMethods, true)) {
        $error = "Please enter valid details and payment information.";
        $selectedDate = $slotDate;
    } else {
        $conn->begin_transaction();

        $updateStmt = $conn->prepare("UPDATE slots SET status = 'Booked' WHERE id = ? AND slot_date = ? AND status = 'Available'");
        $insertStmt = $conn->prepare(
            "INSERT INTO bookings(slot_id, customer_name, customer_email, payment_amount, payment_method, payment_status, transaction_id)
             VALUES(?, ?, ?, ?, ?, 'Paid', ?)"
        );

        if (!$updateStmt || !$insertStmt) {
            $conn->rollback();
            $error = "Unable to process booking right now.";
        } else {
            $updateStmt->bind_param("is", $slot_id, $slotDate);
            $updateStmt->execute();

            if ($updateStmt->affected_rows !== 1) {
                $conn->rollback();
                $error = "Selected slot is no longer available.";
            } else {
                $insertStmt->bind_param("issdss", $slot_id, $name, $email, $paymentAmount, $paymentMethod, $transactionId);
                if ($insertStmt->execute()) {
                    $conn->commit();
                    $success = "Slot booked and payment recorded successfully!";
                    $selectedDate = $slotDate;
                } else {
                    $conn->rollback();
                    $error = "Failed to save booking.";
                }
            }
        }

        if ($updateStmt) {
            $updateStmt->close();
        }
        if ($insertStmt) {
            $insertStmt->close();
        }
    }
}

if ($selectedDate !== '') {
    $slotStmt = $conn->prepare(
        "SELECT id, slot_time
         FROM slots
         WHERE slot_date = ? AND status = 'Available'
         ORDER BY STR_TO_DATE(slot_time, '%h:%i %p') ASC"
    );
    if ($slotStmt) {
        $slotStmt->bind_param('s', $selectedDate);
        $slotStmt->execute();
        $slots = $slotStmt->get_result();
        $hasSlots = $slots && $slots->num_rows > 0;
        $slotStmt->close();
    } else {
        $error = 'Unable to load slots for selected date.';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Book Slot</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="assets/styles.css">
</head>
<body class="slot-theme">
<main class="page">
<section class="panel slot-hero">
<div class="slot-hero-grid">
<div class="slot-copy">
<p class="slot-kicker">Salon Booking</p>
<h2>Book Your Slot</h2>
<p class="subtitle">Choose your date, select an open time, and confirm the advance payment with the same warm visual style used across the slot pages.</p>
</div>
<aside class="slot-note">
<span class="slot-note-label">Advance Payment</span>
<p>Scan the QR, pay the Rs. 500 advance by UPI, then submit the UPI reference to confirm the appointment.</p>
</aside>
</div>
</section>

<section class="panel panel-gap slot-panel">
<div class="slot-booking-layout">
<div class="slot-booking-main">

<?php if ($error !== '') { ?>
<p class="status error"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></p>
<?php } ?>
<?php if ($success !== '') { ?>
<p class="status success"><?= htmlspecialchars($success, ENT_QUOTES, 'UTF-8') ?></p>
<?php } ?>

<div class="slot-card">
<h3>Choose Appointment Date</h3>
<p>Changing the date refreshes the available time slots automatically.</p>
<form method="get">
<div class="slot-form-grid">
<label>
Choose Date
<input type="date" name="slot_date" value="<?= htmlspecialchars($selectedDate, ENT_QUOTES, 'UTF-8') ?>" required>
</label>
<div class="actions">
<button type="submit">Check Availability</button>
<a class="btn btn-soft" href="http://localhost:8080/SalonBooking/user/products.jsp">View Products</a>
</div>
</div>
</form>
</div>

<div class="slot-card slot-card-strong">
<h3>Booking Details</h3>
<p class="slot-inline-note">Only available slots for the selected day are shown below.</p>
<form method="post">
<input type="hidden" name="slot_date" value="<?= htmlspecialchars($selectedDate, ENT_QUOTES, 'UTF-8') ?>">
<div class="slot-form-grid">
<label>
Available Time Slot
<select class="slot-select" name="slot_id" <?= ($selectedDate !== '' && $hasSlots) ? '' : 'disabled' ?> required>
<?php if ($selectedDate === '') { ?>
<option value="">Select a date first</option>
<?php } elseif (!$hasSlots) { ?>
<option value="">No available slots for selected date</option>
<?php } else { ?>
<?php while ($row = $slots->fetch_assoc()) { ?>
<option value="<?= (int)$row['id'] ?>"><?= htmlspecialchars($row['slot_time'], ENT_QUOTES, 'UTF-8') ?></option>
<?php } ?>
<?php } ?>
</select>
</label>

<label>
Name
<input type="text" name="name" required>
</label>

<label>
Email
<input type="email" name="email" required>
</label>

<label>
Advance Payment
<input type="text" value="500" readonly>
</label>
<input type="hidden" name="payment_amount" value="500">
<input type="hidden" name="payment_method" value="UPI">

<label>
UPI Transaction ID
<input type="text" name="transaction_id" placeholder="Enter UPI reference number" required>
</label>

<div class="actions full-width">
<button type="submit" name="book" <?= ($selectedDate !== '' && $hasSlots) ? '' : 'disabled' ?>>Book and Pay</button>
</div>
</div>
</form>
</div>
</div>

<aside class="slot-booking-side">
<div class="slot-card">
<h3>Booking Summary</h3>
<p>Selected date</p>
<p class="slot-price"><?= $selectedDate !== '' ? htmlspecialchars($selectedDate, ENT_QUOTES, 'UTF-8') : 'Pick a date' ?></p>
<div class="slot-summary-meta">
<span class="slot-mini-chip"><?= $hasSlots ? 'Open slots available' : 'Select a date to begin' ?></span>
<span class="slot-mini-chip">Advance Rs. 500</span>
</div>
</div>
<div class="slot-card slot-qr-card">
<h3>Scan & Pay</h3>
<p>Use any UPI app to scan this QR code, then enter the transaction ID in the form.</p>
<img class="slot-qr-image" src="assets/qr.jpg" alt="UPI QR code for slot booking payment">
</div>
<div class="slot-card">
<h3>What Happens Next</h3>
<p>Your booking is saved immediately after payment details are submitted and the slot is still available.</p>
</div>
</aside>
</div>
<script>
const slotDateInput = document.querySelector('input[name="slot_date"]');

if (slotDateInput) {
    slotDateInput.addEventListener('change', function () {
        this.form.submit();
    });
}
</script>
</section>
</main>
</body>
</html>

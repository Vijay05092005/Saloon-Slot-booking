<?php
include '../db.php';
$error = '';
$success = '';
if (isset($_POST['create'])) {
    $date = trim($_POST['date'] ?? '');
    if ($date === '') {
        $error = 'Please choose a date.';
    } else {
        $existingSlots = [];
        $existingStmt = $conn->prepare("SELECT slot_time FROM slots WHERE slot_date = ?");
        if (!$existingStmt) {
            $error = 'Unable to check existing slots.';
        } else {
            $existingStmt->bind_param('s', $date);
            $existingStmt->execute();
            $existingResult = $existingStmt->get_result();
            while ($row = $existingResult->fetch_assoc()) {
                $existingSlots[$row['slot_time']] = true;
            }
            $existingStmt->close();
            $insertStmt = $conn->prepare("INSERT INTO slots(service_name, slot_date, slot_time, status) VALUES('Salon Slot', ?, ?, 'Available')");
            if (!$insertStmt) {
                $error = 'Unable to prepare slot creation query.';
            } else {
                $created = 0;
                for ($hour = 10; $hour <= 22; $hour++) {
                    $time = date('h:i A', strtotime(sprintf('%02d:00', $hour)));
                    if (!isset($existingSlots[$time])) {
                        $insertStmt->bind_param('ss', $date, $time);
                        if ($insertStmt->execute()) {
                            $created++;
                        }
                    }
                }
                $insertStmt->close();
                if ($created > 0) {
                    $success = "Created {$created} slots for {$date} (10:00 AM to 10:00 PM).";
                } else {
                    $error = "All slots already exist for {$date}.";
                }
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Slots</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../assets/styles.css">
</head>
<body class="slot-theme">
<main class="page">
<section class="panel slot-hero">
<div class="slot-hero-grid">
<div class="slot-copy">
<p class="slot-kicker">Slot Studio</p>
<h2>Create Daily Slots</h2>
<p class="subtitle">Build a polished day plan with one click and keep the slot schedule aligned with the salon atmosphere in the hero image.</p>
</div>
<aside class="slot-note">
<span class="slot-note-label">Schedule Window</span>
<p>Hourly slots are generated from 10:00 AM through 10:00 PM for the selected date.</p>
</aside>
</div>
</section>

<section class="panel panel-gap slot-panel">

<?php if ($error !== '') { ?>
<p class="status error"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></p>
<?php } ?>
<?php if ($success !== '') { ?>
<p class="status success"><?= htmlspecialchars($success, ENT_QUOTES, 'UTF-8') ?></p>
<?php } ?>

<form method="post">
<div class="slot-form-grid">
<label>
Date
<input type="date" name="date" required>
</label>
<div class="actions">
<button type="submit" name="create">Create Slots for Date</button>
</div>
</div>
</form>

<a class="back" href="dashboard.php">Back to Dashboard</a>
</section>
</main>
</body>
</html>

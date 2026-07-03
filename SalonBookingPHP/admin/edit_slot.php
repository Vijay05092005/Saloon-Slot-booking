<?php
include '../db.php';

$error = '';
$slot = null;

if (isset($_POST['update'])) {
    $id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);
    $date = trim($_POST['date'] ?? '');
    $time = trim($_POST['time'] ?? '');
    $status = trim($_POST['status'] ?? '');

    $validStatuses = ['Available', 'Booked'];

    if (!$id) {
        $error = 'Invalid slot id.';
    } elseif ($date === '' || $time === '' || !in_array($status, $validStatuses, true)) {
        $error = 'Please fill all fields correctly.';
    } else {
        $stmt = $conn->prepare(
            "UPDATE slots
             SET slot_date = ?, slot_time = ?, status = ?
             WHERE id = ?"
        );
        if ($stmt) {
            $stmt->bind_param('sssi', $date, $time, $status, $id);
            $stmt->execute();
            $stmt->close();
            header('Location: view_slots.php?updated=1');
            exit;
        } else {
            $error = 'Failed to prepare update query.';
        }
    }
}
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id && isset($_POST['id'])) {
    $id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);
}

if ($id) {
    $stmt = $conn->prepare("SELECT * FROM slots WHERE id = ?");
    if ($stmt) {
        $stmt->bind_param('i', $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $slot = $result->fetch_assoc();
        $stmt->close();
    } else {
        $error = 'Failed to load slot details.';
    }
} else {
    $error = 'No valid slot id provided.';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Slot</title>
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
<h2>Edit Slot</h2>
<p class="subtitle">Adjust timing and availability with the same warm, cinematic theme used across the slot workflow.</p>
</div>
<aside class="slot-note">
<span class="slot-note-label">Editing Focus</span>
<p>Keep each appointment window precise so the schedule stays clean for staff and clients.</p>
</aside>
</div>
</section>

<section class="panel panel-gap slot-panel">

<?php if ($error !== '') { ?>
<p class="status error"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></p>
<?php } ?>

<?php if ($slot) { ?>
<form method="post">
<input type="hidden" name="id" value="<?= (int)$slot['id'] ?>">

<div class="slot-form-grid">
<label>
Date
<input type="date" name="date" value="<?= htmlspecialchars($slot['slot_date'], ENT_QUOTES, 'UTF-8') ?>" required>
</label>

<label>
Time
<input type="text" name="time" value="<?= htmlspecialchars($slot['slot_time'], ENT_QUOTES, 'UTF-8') ?>" required>
</label>

<label>
Status
<select name="status" required>
<option value="Available" <?= $slot['status'] === 'Available' ? 'selected' : '' ?>>Available</option>
<option value="Booked" <?= $slot['status'] === 'Booked' ? 'selected' : '' ?>>Booked</option>
</select>
</label>

<div class="actions full-width">
<button type="submit" name="update">Update Slot</button>
</div>
</div>
</form>
<?php } ?>

<a class="back" href="view_slots.php">Back to Slots</a>
</section>
</main>
</body>
</html>

<?php
include '../db.php';
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id) {
    header("Location: view_slots.php?error=invalid_id");
    exit;
}
$stmt = $conn->prepare("DELETE FROM slots WHERE id = ?");
if (!$stmt) {
    header("Location: view_slots.php?error=delete_failed");
    exit;
}
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->close();
header("Location: view_slots.php?deleted=1");
exit;
?>
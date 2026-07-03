<?php
$conn = new mysqli("localhost", "root", "12345", "salon_db");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
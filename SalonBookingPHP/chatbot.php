<?php
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
$conn = new mysqli("localhost", "root", "12345", "salon_db");


$message = strtolower(trim($_POST['message']));
$response = "Sorry, I don't understand your question.";

$result = $conn->query("SELECT keywords, answer FROM chatbot");

while ($row = $result->fetch_assoc()) {
    $keywords = explode(",", $row['keywords']);
    
    foreach ($keywords as $word) {
        if (strpos($message, trim($word)) !== false) {
            $response = $row['answer'];
            break 2; // exit both loops
        }
    }
}

echo $response;
?>
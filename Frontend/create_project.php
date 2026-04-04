<?php
include 'db.php';

$title = $_POST['title'];
$genre = $_POST['genre'];

$conn->query("INSERT INTO Projects (title, genre) VALUES ('$title', '$genre')");

echo "✅ Project Created!";
?>

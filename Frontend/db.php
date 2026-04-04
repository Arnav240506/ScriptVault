<?php
$conn = new mysqli("localhost", "root", "", "scriptvault");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

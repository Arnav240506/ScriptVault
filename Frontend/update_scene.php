<?php
include 'db.php';

$scene_id = $_POST['scene_id'];
$content = $_POST['content'];

$result = $conn->query("SELECT MAX(version_number) AS max_ver FROM Scene_Versions WHERE scene_id=$scene_id");
$row = $result->fetch_assoc();
$new_version = $row['max_ver'] + 1;

$conn->query("UPDATE Scene_Versions SET is_current=FALSE WHERE scene_id=$scene_id");

$conn->query("INSERT INTO Scene_Versions (scene_id, content, version_number, is_current) 
VALUES ($scene_id, '$content', $new_version, TRUE)");

echo "✅ New Version Created!";
?>

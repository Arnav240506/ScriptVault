<?php
include 'db.php';

$project_id = $_POST['project_id'];
$title = $_POST['title'];
$content = $_POST['content'];

$conn->query("INSERT INTO Scenes (project_id, title, sequence_number) VALUES ($project_id, '$title', 1)");
$scene_id = $conn->insert_id;

$conn->query("INSERT INTO Scene_Versions (scene_id, content, version_number) VALUES ($scene_id, '$content', 1)");

echo "✅ Scene Added!";
?>

<?php
include 'db.php';

$q = $_GET['q'];

$result = $conn->query("SELECT * FROM Scene_Versions 
WHERE MATCH(content) AGAINST ('$q')");

echo "<h2>Search Results:</h2>";

while($row = $result->fetch_assoc()) {
    echo "<p><b>Scene:</b> ".$row['scene_id']."<br>".$row['content']."</p><hr>";
}
?>

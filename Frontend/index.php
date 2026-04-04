<!DOCTYPE html>
<html>
<head>
    <title>ScriptVault</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h1>🎬 ScriptVault</h1>

<div class="container">

<h2>Create Project</h2>
<form action="create_project.php" method="POST">
    <input type="text" name="title" placeholder="Project Title" required>
    <input type="text" name="genre" placeholder="Genre">
    <button type="submit">Create</button>
</form>

<h2>Add Scene</h2>
<form action="add_scene.php" method="POST">
    <input type="number" name="project_id" placeholder="Project ID" required>
    <input type="text" name="title" placeholder="Scene Title">
    <textarea name="content" placeholder="Scene Content"></textarea>
    <button type="submit">Add Scene</button>
</form>

<h2>Update Scene</h2>
<form action="update_scene.php" method="POST">
    <input type="number" name="scene_id" placeholder="Scene ID" required>
    <textarea name="content" placeholder="New Content"></textarea>
    <button type="submit">Update</button>
</form>

<h2>Search Script 🔍</h2>
<form action="search.php" method="GET">
    <input type="text" name="q" placeholder="Search dialogue...">
    <button type="submit">Search</button>
</form>

</div>

</body>
</html>

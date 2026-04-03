-- =========================
-- DATABASE
-- =========================
CREATE DATABASE scriptvault;
USE scriptvault;

-- =========================
-- USERS
-- =========================
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- =========================
-- PROJECTS
-- =========================
CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(100),
    description TEXT,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- =========================
-- SCENES
-- =========================
CREATE TABLE Scenes (
    scene_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    title VARCHAR(255),
    sequence_number INT,
    current_version_id INT,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE
);

-- =========================
-- SCENE VERSIONS
-- =========================
CREATE TABLE Scene_Versions (
    version_id INT AUTO_INCREMENT PRIMARY KEY,
    scene_id INT,
    content TEXT,
    version_number INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (scene_id) REFERENCES Scenes(scene_id) ON DELETE CASCADE
);

-- FULLTEXT SEARCH INDEX
ALTER TABLE Scene_Versions ADD FULLTEXT(content);

-- =========================
-- CHARACTERS
-- =========================
CREATE TABLE Characters (
    character_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    name VARCHAR(100),
    role VARCHAR(100),
    traits TEXT,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE
);

-- =========================
-- SCENE-CHARACTER (M:N)
-- =========================
CREATE TABLE Scene_Characters (
    scene_id INT,
    character_id INT,
    PRIMARY KEY (scene_id, character_id),
    FOREIGN KEY (scene_id) REFERENCES Scenes(scene_id) ON DELETE CASCADE,
    FOREIGN KEY (character_id) REFERENCES Characters(character_id) ON DELETE CASCADE
);

-- =========================
-- TAGS
-- =========================
CREATE TABLE Tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- =========================
-- SCENE-TAGS
-- =========================
CREATE TABLE Scene_Tags (
    scene_id INT,
    tag_id INT,
    PRIMARY KEY (scene_id, tag_id),
    FOREIGN KEY (scene_id) REFERENCES Scenes(scene_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id) ON DELETE CASCADE
);

-- =========================
-- ACTIVITY LOGS
-- =========================
CREATE TABLE Activity_Logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- =========================
-- TRIGGER: AUTO VERSION CONTROL
-- =========================
DELIMITER $$

CREATE TRIGGER after_scene_update
AFTER UPDATE ON Scenes
FOR EACH ROW
BEGIN
    DECLARE latest_version INT;

    -- Get latest version number
    SELECT IFNULL(MAX(version_number), 0)
    INTO latest_version
    FROM Scene_Versions
    WHERE scene_id = NEW.scene_id;

    -- Mark old versions as not current
    UPDATE Scene_Versions
    SET is_current = FALSE
    WHERE scene_id = NEW.scene_id;

    -- Insert new version
    INSERT INTO Scene_Versions(scene_id, content, version_number, is_current)
    VALUES (NEW.scene_id, 'Updated content placeholder', latest_version + 1, TRUE);

END$$

DELIMITER ;

-- =========================
-- STORED PROCEDURE: GET FULL SCRIPT
-- =========================
DELIMITER $$

CREATE PROCEDURE get_full_script(IN proj_id INT)
BEGIN
    SELECT s.scene_id, s.title, sv.content
    FROM Scenes s
    JOIN Scene_Versions sv ON s.current_version_id = sv.version_id
    WHERE s.project_id = proj_id
    ORDER BY s.sequence_number;
END$$

DELIMITER ;

-- =========================
-- STORED PROCEDURE: CHARACTER IMPORTANCE
-- =========================
DELIMITER $$

CREATE PROCEDURE character_importance(IN proj_id INT)
BEGIN
    SELECT c.name, COUNT(sc.scene_id) AS appearances
    FROM Characters c
    LEFT JOIN Scene_Characters sc ON c.character_id = sc.character_id
    WHERE c.project_id = proj_id
    GROUP BY c.character_id
    ORDER BY appearances DESC;
END$$

DELIMITER ;

-- =========================
-- VIEW: CHARACTER SCENE COUNT
-- =========================
CREATE VIEW character_scene_count AS
SELECT c.name, COUNT(sc.scene_id) AS total_scenes
FROM Characters c
LEFT JOIN Scene_Characters sc ON c.character_id = sc.character_id
GROUP BY c.character_id;

-- =========================
-- VIEW: PROJECT SUMMARY
-- =========================
CREATE VIEW project_summary AS
SELECT p.title,
       COUNT(DISTINCT s.scene_id) AS total_scenes,
       COUNT(DISTINCT c.character_id) AS total_characters
FROM Projects p
LEFT JOIN Scenes s ON p.project_id = s.project_id
LEFT JOIN Characters c ON p.project_id = c.project_id
GROUP BY p.project_id;

-- =========================
-- SAMPLE SEARCH QUERY
-- =========================
-- FULL TEXT SEARCH
-- SELECT * FROM Scene_Versions
-- WHERE MATCH(content) AGAINST ('blood alley');

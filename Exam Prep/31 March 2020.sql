CREATE SCHEMA `instd`;

USE `instd`;
--------------------------------------------------------------
Problem 1 
CREATE TABLE `users` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) UNIQUE NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `gender` CHAR(1) NOT NULL,
    `age` INT NOT NULL,
    `job_title` VARCHAR(40) NOT NULL,
    `ip` VARCHAR(30) NOT NULL
);

CREATE TABLE `addresses` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(30) NOT NULL,
    `town` VARCHAR(30) NOT NULL,
    `country` VARCHAR(30) NOT NULL,
    `user_id` INT NOT NULL,
    CONSTRAINT fk_users_users FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `photos` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    `views` INT NOT NULL DEFAULT 0
);

CREATE TABLE `comments` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `comment` VARCHAR(255) NOT NULL,
    `date` DATETIME NOT NULL,
    `photo_id` INT NOT NULL,
    CONSTRAINT fk_comments_photos FOREIGN KEY (`photo_id`)
        REFERENCES `photos` (`id`)
);

CREATE TABLE `users_photos` (
    `user_id` INT NOT NULL,
    `photo_id` INT NOT NULL,
    CONSTRAINT fk_users_photos_users FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`),
    CONSTRAINT fk_users_photos_photos FOREIGN KEY (`photo_id`)
        REFERENCES `photos` (`id`)
);

CREATE TABLE `likes` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `photo_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    CONSTRAINT fk_likes_photos FOREIGN KEY (`photo_id`)
        REFERENCES `photos` (`id`),
    CONSTRAINT fk_likes_users FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `addresses`(`address`, `town`,`country`,`user_id`) 
SELECT `username`,`password`,`ip`,`age` from `users` where `gender` = 'M';

--------------------------------------------------------------
Problem 3 
UPDATE `addresses` 
SET 
    country = CASE
        WHEN LEFT(`country`, 1) = 'B' THEN 'Blocked'
        WHEN LEFT(`country`, 1) = 'T' THEN 'Test'
        WHEN LEFT(`country`, 1) = 'P' THEN 'In Progress'
        ELSE `country`
    END;

--------------------------------------------------------------
Problem 4 
DELETE FROM `addresses` 
WHERE
    id % 3 = 0;

--------------------------------------------------------------
Problem 5
SELECT 
    `username`, `gender`, `age`
FROM
    `users`
ORDER BY `age` DESC , `username`;
 
--------------------------------------------------------------
Problem 6 
SELECT 
    p.`id`,
    p.`date` AS 'date_and_time',
    p.`description`,
    COUNT(p.`id`) AS 'commentsCount'
FROM
    `photos` AS p
        JOIN
    `comments` AS c ON p.`id` = c.`photo_id`
GROUP BY `photo_id`
ORDER BY `commentsCount` DESC , p.`id`
LIMIT 5;

--------------------------------------------------------------
Problem 7 
SELECT 
    CONCAT_WS(' ', u.`id`, u.`username`) AS 'id_username', `email`
FROM
    `users` AS u
        JOIN
    `users_photos` AS up ON u.`id` = up.`user_id`
WHERE
    `user_id` = `photo_id`;

--------------------------------------------------------------
Problem 8 
SELECT DISTINCT
    p.`id` AS 'photo_id',
    (SELECT 
            COUNT(*)
        FROM
            `likes`
        WHERE
            `photo_id` = p.`id`) AS 'likes_count',
    (SELECT 
            COUNT(*)
        FROM
            `comments`
        WHERE
            `photo_id` = p.`id`) AS 'comments_count'
FROM
    `photos` AS p
        LEFT JOIN
    `comments` AS c ON p.`id` = c.`photo_id`
        LEFT JOIN
    `likes` AS l ON p.`id` = l.`photo_id`
ORDER BY `likes_count` DESC , `comments_count` DESC , p.`id`;

--------------------------------------------------------------
Problem 9 
SELECT 
    CONCAT(SUBSTR(`description`, 1, 30), '...') AS 'summary',
    `date`
FROM
    `photos` AS p
WHERE
    DAY(`date`) = 10
ORDER BY `date` DESC;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_users_photos_count(username VARCHAR(30)) 
RETURNS INTEGER
DETERMINISTIC
BEGIN
RETURN (SELECT 
    COUNT(*)
FROM
    `users` AS u
        JOIN
    `users_photos` AS up ON u.`id` = up.`user_id`
WHERE
    u.`username` = username);
END

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_modify_user(address VARCHAR(30), town VARCHAR(30)) 
BEGIN
	UPDATE `users` AS u  
    JOIN `addresses` AS a ON u.id = a.user_id
		SET `age`=`age`+10
	WHERE
		a.`address` = address AND a.`town` = town;
END

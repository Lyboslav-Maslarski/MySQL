CREATE SCHEMA `softuni_imdb`;

USE `softuni_imdb`;
--------------------------------------------------------------
Problem 1 
CREATE TABLE `countries` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `continent` VARCHAR(30) NOT NULL,
    `currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `genres` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `actors` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `height` INT,
    `awards` INT,
    `country_id` INT NOT NULL,
    CONSTRAINT fk_actors_countries FOREIGN KEY (`country_id`)
        REFERENCES `countries` (`id`)
);

CREATE TABLE `movies_additional_info` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `rating` DECIMAL(10 , 2 ) NOT NULL,
    `runtime` INT NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `budget` DECIMAL(10 , 2 ),
    `release_date` DATE NOT NULL,
    `has_subtitles` BOOLEAN,
    `description` TEXT
);

CREATE TABLE `movies` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(70) NOT NULL UNIQUE,
    `country_id` INT NOT NULL,
    `movie_info_id` INT NOT NULL UNIQUE,
    CONSTRAINT fk_movies_countries FOREIGN KEY (`country_id`)
        REFERENCES `countries` (`id`),
    CONSTRAINT fk_movies_movies_additional_info FOREIGN KEY (`movie_info_id`)
        REFERENCES `movies_additional_info` (`id`)
);

CREATE TABLE `movies_actors` (
    `movie_id` INT,
    `actor_id` INT,
    CONSTRAINT fk_movies_actors_movies FOREIGN KEY (`movie_id`)
        REFERENCES `movies` (`id`),
    CONSTRAINT fk_movies_actors_actors FOREIGN KEY (`actor_id`)
        REFERENCES `actors` (`id`)
);

CREATE TABLE `genres_movies` (
    `genre_id` INT,
    `movie_id` INT,
    CONSTRAINT fk_genres_movies_genres FOREIGN KEY (`genre_id`)
        REFERENCES `genres` (`id`),
    CONSTRAINT fk_genres_movies_movies FOREIGN KEY (`movie_id`)
        REFERENCES `movies` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `actors` 
(`first_name`, `last_name`, `birthdate`, `height`, `awards`, `country_id`)
(SELECT 
reverse(`first_name`),
reverse(`last_name`),
DATE_SUB(`birthdate`,INTERVAL 2 DAY),
`height` + 10,
`country_id`,
(SELECT `id` FROM `countries` WHERE `name` = 'Armenia')
FROM `actors`
WHERE `id` <= 10);

--------------------------------------------------------------
Problem 3 
UPDATE `movies_additional_info` 
SET 
    `runtime` = `runtime` - 10
WHERE
    id BETWEEN 15 AND 25;

--------------------------------------------------------------
Problem 4 
DELETE `countries` FROM `countries`
        LEFT JOIN
    `movies` ON `countries`.`id` = `movies`.`country_id` 
WHERE
    `movies`.`country_id` IS NULL;

--------------------------------------------------------------
Problem 5
SELECT 
    *
FROM
    `countries`
ORDER BY `currency` DESC , `id`;
 
--------------------------------------------------------------
Problem 6 
SELECT 
    m.`id`,
    m.`title`,
    mai.`runtime`,
    mai.`budget`,
    mai.`release_date`
FROM
    `movies_additional_info` AS mai
        JOIN
    `movies` AS m ON m.`movie_info_id` = mai.`id`
WHERE
    YEAR(`release_date`) BETWEEN 1996 AND 1999
ORDER BY mai.`runtime` , m.`id`
LIMIT 20;

--------------------------------------------------------------
Problem 7 
SELECT 
    CONCAT(`first_name`, ' ', `last_name`) AS 'full_name',
    CONCAT(REVERSE(`last_name`),
            CHAR_LENGTH(`last_name`),
            '@cast.com') AS 'email',
    (2022 - YEAR(`birthdate`)) AS 'age',
    height
FROM
    actors
WHERE
    `id` NOT IN (SELECT 
            `actor_id`
        FROM
            `movies_actors`)
ORDER BY `height`;

--------------------------------------------------------------
Problem 8 
SELECT 
    c.`name`, COUNT(m.`id`) AS 'movies_count'
FROM
    `countries` AS c
        JOIN
    `movies` AS m ON c.`id` = m.`country_id`
GROUP BY c.`id`
HAVING `movies_count` >= 7
ORDER BY c.`name` DESC;

--------------------------------------------------------------
Problem 9 
SELECT 
    m.title,
    CASE
        WHEN mai.rating <= 4 THEN 'poor'
        WHEN mai.rating <= 7 THEN 'good'
        WHEN mai.rating > 7 THEN 'excellent'
    END AS 'rating',
    IF(mai.has_subtitles, 'english', '-') AS 'subtitles',
    mai.budget
FROM
    `movies` AS m
        JOIN
    `movies_additional_info` AS mai ON m.`movie_info_id` = mai.`id`
ORDER BY mai.`budget` DESC;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50)) 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE movie_count INT;
SET movie_count := (SELECT COUNT(a.`id`)
FROM
    `genres` AS g
        JOIN
    `genres_movies` AS gm ON g.`id` = gm.`genre_id`
        JOIN
    `movies_actors` AS ma ON gm.`movie_id` = ma.`movie_id`
        JOIN
    `actors` AS a ON ma.`actor_id` = a.`id`
WHERE
    g.`name` = 'History'
        AND CONCAT(a.`first_name`, ' ', a.`last_name`) = full_name);
    RETURN movie_count;
END

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50)) 
BEGIN
	UPDATE `actors` as a
	JOIN `movies_actors` AS ma ON a.`id` = ma.`actor_id`
	JOIN `movies` AS m ON ma.`movie_id` = m.`id`
	SET a.`awards` = a.`awards` + 1
	WHERE m.`title` = movie_title;
END
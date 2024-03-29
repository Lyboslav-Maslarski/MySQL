CREATE SCHEMA sgd ;
USE sgd ;

--------------------------------------------------------------
Problem 1 
CREATE TABLE `addresses` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL
);
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(10) NOT NULL
);
CREATE TABLE `offices` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `workspace_capacity` INT NOT NULL,
    `website` VARCHAR(50),
    `address_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`address_id`)
        REFERENCES `addresses` (`id`)
);
CREATE TABLE `employees` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `age` INT NOT NULL,
    `salary` DECIMAL(10,2) NOT NULL,
    `job_title` VARCHAR(20) NOT NULL,
    `happiness_level` CHAR(1) NOT NULL
);
CREATE TABLE `teams` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL,
    `office_id` INT NOT NULL,
    `leader_id` INT NOT NULL UNIQUE,
    CONSTRAINT FOREIGN KEY (`office_id`)
        REFERENCES `offices` (`id`),
    CONSTRAINT FOREIGN KEY (`leader_id`)
        REFERENCES `employees` (`id`)
);
CREATE TABLE `games` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` TEXT,
    `rating` FLOAT NOT NULL DEFAULT 5.5,
    `budget` DECIMAL(10 , 2 ) NOT NULL,
    `release_date` DATE,
    `team_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`team_id`)
        REFERENCES `teams` (`id`)
);
CREATE TABLE `games_categories` (
    `game_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    CONSTRAINT PRIMARY KEY (`game_id` , `category_id`),
    CONSTRAINT FOREIGN KEY (`game_id`)
        REFERENCES `games` (`id`),
    CONSTRAINT FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `games`(`name`,`rating`,`budget`,`team_id`)
SELECT lower(reverse(substr(`name`,2))),`id`,`leader_id`*1000,`id`
FROM `teams`
WHERE `id` BETWEEN 1 AND 9;
 
--------------------------------------------------------------
Problem 3 
UPDATE `employees` 
SET 
    `salary` = `salary` + 1000
WHERE
    `salary` < 5000 AND `age` < 40
        AND `id` IN (SELECT 
            `leader_id`
        FROM
            `teams`);

--------------------------------------------------------------
Problem 4 
DELETE g FROM `games` AS g
        LEFT JOIN
    `games_categories` AS gc ON g.`id` = gc.`game_id` 
WHERE
    g.`release_date` IS NULL
    AND gc.`game_id` IS NULL;

--------------------------------------------------------------
Problem 5
SELECT 
    `first_name`,
    `last_name`,
    `age`,
    `salary`,
    `happiness_level`
FROM
    `employees`
ORDER BY `salary` , `id`;
 
--------------------------------------------------------------
Problem 6 
SELECT 
    t.`name`,
    a.`name`,
    CHAR_LENGTH(a.`name`) AS 'count_of_characters'
FROM
    `teams` AS t
        JOIN
    `offices` AS o ON t.`office_id` = o.`id`
        JOIN
    `addresses` AS a ON o.`address_id` = a.`id`
WHERE
    o.`website` IS NOT NULL
ORDER BY t.`name` , a.`name`;

--------------------------------------------------------------
Problem 7 
SELECT 
    c.`name`,
    COUNT(g.`id`) AS 'games_count',
    ROUND(AVG(g.`budget`), 2) AS 'avg_budget',
    MAX(g.`rating`) AS 'max_rating'
FROM
    `categories` AS c
        JOIN
    `games_categories` AS gc ON c.`id` = gc.`category_id`
        JOIN
    `games` AS g ON gc.`game_id` = g.`id`
GROUP BY c.`id`
HAVING `max_rating` >= 9.5
ORDER BY `games_count` DESC , c.`name`;

--------------------------------------------------------------
Problem 8 
SELECT 
    g.`name`,
    g.`release_date`,
    CONCAT(SUBSTR(`description`, 1, 10), '...') AS 'summary',
    CASE
        WHEN MONTH(`release_date`) IN (1 , 2, 3) THEN 'Q1'
        WHEN MONTH(`release_date`) IN (4 , 5, 6) THEN 'Q2'
        WHEN MONTH(`release_date`) IN (7 , 8, 9) THEN 'Q3'
        ELSE 'Q4'
    END AS 'Quarters',
    t.`name` AS 'team_name'
FROM
    `games` AS g
        JOIN
    `teams` AS t ON g.`team_id` = t.`id`
WHERE
    YEAR(`release_date`) = 2022
        AND RIGHT(g.`name`, 1) = '2'
        AND MONTH(`release_date`) % 2 = 0
ORDER BY `Quarters`;

--------------------------------------------------------------
Problem 9 
SELECT 
    g.`name`,
    IF(g.`budget` < 50000,
        'Normal budget',
        'Insufficient budget') AS 'budget_level',
    t.`name` AS 'team_name',
    a.`name` AS 'address_name'
FROM
    `games` AS g
        LEFT JOIN
    `games_categories` AS gc ON g.`id` = gc.`game_id`
        JOIN
    `teams` AS t ON g.`team_id` = t.`id`
        JOIN
    `offices` AS o ON t.`office_id` = o.`id`
        JOIN
    `addresses` AS a ON o.`address_id` = a.`id`
WHERE
    gc.`game_id` IS NULL
        AND g.`release_date` IS NULL
ORDER BY g.`name`;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_game_info_by_name (`game_name` VARCHAR (20)) 
RETURNS VARCHAR(255)
DETERMINISTIC
RETURN (SELECT 
    concat('The ',g.`name`,' is developed by a ',t.`name`,' in an office with an address ',a.`name`)
FROM
    `games` AS g
        JOIN
    `teams` AS t ON g.`team_id` = t.`id`
    JOIN
    `offices` AS o ON t.`office_id` = o.`id`
    JOIN
    `addresses` AS a ON o.`address_id` = a.`id`
WHERE
    g.`name` = `game_name`);

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_update_budget (`min_game_rating` DECIMAL(19,2))
BEGIN
UPDATE `games` AS g
        LEFT JOIN
    `games_categories` AS gc ON g.`id` = gc.`game_id` 
SET 
    g.`budget` = g.`budget` + 100000,
	g.`release_date` = DATE_ADD(g.`release_date`,
        INTERVAL 1 YEAR)
WHERE
    gc.`category_id` IS NULL
        AND g.`release_date` IS NOT NULL
        AND g.`rating` > `min_game_rating`;
END
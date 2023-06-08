CREATE SCHEMA `cjms`;
USE `cjms`;

--------------------------------------------------------------
Problem 0 
CREATE TABLE `planets` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE `spaceports` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `planet_id` INT,
    CONSTRAINT fk_spaceports_planets FOREIGN KEY (`planet_id`)
        REFERENCES `planets` (`id`)
);

CREATE TABLE `spaceships` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `manufacturer` VARCHAR(30) NOT NULL,
    `light_speed_rate` INT DEFAULT 0
);

CREATE TABLE `colonists` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `ucn` CHAR(10) NOT NULL UNIQUE,
    `birth_date` DATE NOT NULL
);

CREATE TABLE `journeys` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `journey_start` DATETIME NOT NULL,
    `journey_end` DATETIME NOT NULL,
    `purpose` ENUM('Medical', 'Technical', 'Educational', 'Military'),
    `destination_spaceport_id` INT,
    `spaceship_id` INT,
    CONSTRAINT fk_journeys_spaceports FOREIGN KEY (`destination_spaceport_id`)
        REFERENCES `spaceports` (`id`),
    CONSTRAINT fk_journeys_spaceships FOREIGN KEY (`spaceship_id`)
        REFERENCES `spaceships` (`id`)
);

CREATE TABLE `travel_cards` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `card_number` CHAR(10) NOT NULL UNIQUE,
    `job_during_journey` ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'),
    `colonist_id` INT,
    `journey_id` INT,
    CONSTRAINT fk_travel_cards_colonists FOREIGN KEY (`colonist_id`)
        REFERENCES `colonists` (`id`),
    CONSTRAINT fk_travel_cards_journeys FOREIGN KEY (`journey_id`)
        REFERENCES `journeys` (`id`)
);

--------------------------------------------------------------
Problem 1 
INSERT INTO `travel_cards` (`card_number`,`job_during_journey`,`colonist_id`,`journey_id`) 
SELECT 
CASE
WHEN c.`birth_date` > '1980-01-01' THEN CONCAT(YEAR(c.`birth_date`),DAY(c.`birth_date`),LEFT(c.`ucn`,4))
ELSE CONCAT(YEAR(c.`birth_date`),MONTH(c.`birth_date`),RIGHT(c.`ucn`,4))
END,
CASE
WHEN c.`id` % 2 = 0 THEN 'Pilot'
WHEN c.`id` % 3 = 0 THEN 'Cook'
ELSE 'Engineer'
END ,
c.`id`,
LEFT(c.`ucn`,1) FROM colonists as c
WHERE `id` BETWEEN 96 AND 100;

--------------------------------------------------------------
Problem 2
UPDATE journeys 
SET 
    `purpose` = CASE
        WHEN id % 2 = 0 THEN 'Medical'
        WHEN id % 3 = 0 THEN 'Technical'
        WHEN id % 5 = 0 THEN 'Educational'
        WHEN id % 7 = 0 THEN 'Military'
    END
WHERE
    id % 2 = 0 OR id % 3 = 0 OR id % 5 = 0
        OR id % 7 = 0;
 
--------------------------------------------------------------
Problem 3 
DELETE c FROM colonists AS c
        LEFT JOIN
    travel_cards AS tc ON c.`id` = tc.`colonist_id`
WHERE
    tc.`journey_id` IS NULL;
    
--------------------------------------------------------------
Problem 4 
SELECT 
    `card_number`, `job_during_journey`
FROM
    travel_cards
ORDER BY `card_number`;
    
--------------------------------------------------------------
Problem 5
SELECT 
    `id`,
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'full_name',
    `ucn`
FROM
    colonists
ORDER BY `first_name` , `last_name` , `id`;

--------------------------------------------------------------
Problem 6 
SELECT 
    id, journey_start, journey_end
FROM
    journeys
WHERE
    `purpose` = 'Military'
ORDER BY `journey_start`;

--------------------------------------------------------------
Problem 7 
SELECT 
    c.`id`,
    CONCAT_WS(' ', c.`first_name`, c.`last_name`) AS 'full_name'
FROM
    colonists AS c
        JOIN
    travel_cards AS tc ON c.`id` = tc.`colonist_id`
WHERE
    `job_during_journey` = 'Pilot'
ORDER BY c.`id`;

--------------------------------------------------------------
Problem 8 
SELECT 
    COUNT(*) AS 'count'
FROM
    colonists AS c
        JOIN
    travel_cards AS tc ON c.`id` = tc.`colonist_id`
        JOIN
    journeys AS j ON tc.`journey_id` = j.`id`
WHERE
    `purpose` = 'Technical'
ORDER BY c.`id`;

--------------------------------------------------------------
Problem 9 
SELECT 
    ss.`name` AS 'spaceship_name', sp.`name` AS 'spaceport_name'
FROM
    spaceships AS ss
        JOIN
    journeys AS j ON ss.`id` = j.`spaceship_id`
        JOIN
    spaceports AS sp ON j.`destination_spaceport_id` = sp.`id`
ORDER BY light_speed_rate DESC
LIMIT 1;

--------------------------------------------------------------
Problem 10
SELECT 
    ss.`name`, ss.`manufacturer`
FROM
    spaceships AS ss
        JOIN
    journeys AS j ON ss.`id` = j.`spaceship_id`
        JOIN
    travel_cards AS tc ON j.`id` = tc.`journey_id`
        JOIN
    colonists AS c ON tc.`colonist_id` = c.`id`
WHERE
    tc.`job_during_journey` = 'Pilot'
        AND 2019 - YEAR(c.`birth_date`) < 30
ORDER BY ss.`name`;

--------------------------------------------------------------
Problem 11 
SELECT 
    p.`name` AS 'planet_name', sp.`name` AS 'spaceport_name'
FROM
    planets AS p
        JOIN
    spaceports AS sp ON p.`id` = sp.`planet_id`
        JOIN
    journeys AS j ON sp.`id` = j.`destination_spaceport_id`
WHERE
    `purpose` = 'Educational'
ORDER BY sp.`name` DESC;
        
--------------------------------------------------------------
Problem 12 
SELECT 
    p.`name` AS 'planet_name', COUNT(j.`id`) AS 'journey_count'
FROM
    planets AS p
        JOIN
    spaceports AS sp ON p.`id` = sp.`planet_id`
        JOIN
    journeys AS j ON sp.`id` = j.`destination_spaceport_id`
GROUP BY p.`name`
ORDER BY `journey_count` DESC , p.`name`;

--------------------------------------------------------------
Problem 13 
SELECT 
    j.`id`,
    p.`name` AS 'planet_name',
    sp.`name` AS 'spaceport_name',
    j.`purpose` AS 'journey_purpose'
FROM
    planets AS p
        JOIN
    spaceports AS sp ON p.`id` = sp.`planet_id`
        JOIN
    journeys AS j ON sp.`id` = j.`destination_spaceport_id`
ORDER BY journey_end - journey_start
LIMIT 1;

--------------------------------------------------------------
Problem 14 
SELECT 
    job_during_journey
FROM
    journeys AS j
        JOIN
    travel_cards AS tc ON j.`id` = tc.`journey_id`
GROUP BY j.`id` , `job_during_journey`
ORDER BY journey_end - journey_start DESC , COUNT(`job_during_journey`)
LIMIT 1;

--------------------------------------------------------------
Problem 15 
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR (30))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE count_colonists INT;
    
	SET count_colonists = (SELECT COUNT(c.`id`)
		FROM
			planets AS p
				JOIN
			spaceports AS sp ON p.`id` = sp.`planet_id`
				JOIN
			journeys AS j ON sp.`id` = j.`destination_spaceport_id`
				JOIN
			travel_cards AS tc ON j.`id` = tc.`journey_id`
				JOIN
			colonists AS c ON tc.`colonist_id` = c.`id`
		WHERE
			p.`name` = planet_name);
	RETURN count_colonists;
END

--------------------------------------------------------------
Problem 16 
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
BEGIN
    if (SELECT count(ss.name) FROM spaceships ss WHERE ss.name = spaceship_name > 0) 
	THEN
        UPDATE spaceships ss
        SET ss.light_speed_rate = ss.light_speed_rate + light_speed_rate_increse
        WHERE name = spaceship_name;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
    END IF;
END
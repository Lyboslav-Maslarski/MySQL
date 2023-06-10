CREATE SCHEMA stc ;
USE stc ;

--------------------------------------------------------------
Problem 1 
CREATE TABLE `addresses` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL
);
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(10) NOT NULL
);
CREATE TABLE `clients` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(20) NOT NULL
);
CREATE TABLE `drivers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `age` INT NOT NULL,
    `rating` FLOAT DEFAULT 5.5
);
CREATE TABLE `cars` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `make` VARCHAR(20) NOT NULL,
    `model` VARCHAR(20),
    `year` INT NOT NULL DEFAULT 0,
    `mileage` INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    `category_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
);
CREATE TABLE `courses` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `from_address_id` INT NOT NULL,
    `start` DATETIME NOT NULL,
    `bill` DECIMAL(10 , 2 ) DEFAULT 10,
    `car_id` INT NOT NULL,
    `client_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`from_address_id`)
        REFERENCES `addresses` (`id`),
    CONSTRAINT FOREIGN KEY (`car_id`)
        REFERENCES `cars` (`id`),
    CONSTRAINT FOREIGN KEY (`client_id`)
        REFERENCES `clients` (`id`)
);
CREATE TABLE `cars_drivers` (
    `car_id` INT NOT NULL,
    `driver_id` INT NOT NULL,
    CONSTRAINT PRIMARY KEY (`car_id` , `driver_id`),
    CONSTRAINT FOREIGN KEY (`car_id`)
        REFERENCES `cars` (`id`),
    CONSTRAINT FOREIGN KEY (`driver_id`)
        REFERENCES `drivers` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `clients`(`full_name`,`phone_number`)
SELECT concat_ws(' ', `first_name`,`last_name`), concat('(088) 9999',`id` * 2) 
FROM `drivers`
WHERE `id` BETWEEN 10 AND 20;
 
--------------------------------------------------------------
Problem 3 
UPDATE `cars` 
SET 
    `condition` = 'C'
WHERE
    (`mileage` >= 800000 OR (`mileage` IS NULL
        AND `year` < 2010))
        AND `make` <> 'Mercedes-Benz';

--------------------------------------------------------------
Problem 4 
DELETE cl FROM `clients` AS cl
        LEFT JOIN
    `courses` AS c ON cl.`id` = c.`client_id` 
WHERE
    CHAR_LENGTH(cl.`full_name`) > 3
    AND c.`client_id` IS NULL;

--------------------------------------------------------------
Problem 5
SELECT 
    `make`,`model`,`mileage`
FROM
    `cars`
ORDER BY `id`;
 
--------------------------------------------------------------
Problem 6 
SELECT 
    d.`first_name`,
    d.`last_name`,
    c.`make`,
    c.`model`,
    c.`mileage`
FROM
    `cars` AS c
        JOIN
    `cars_drivers` AS cd ON c.`id` = cd.`car_id`
        JOIN
    `drivers` AS d ON cd.`driver_id` = d.`id`
WHERE
    c.`mileage` IS NOT NULL
ORDER BY c.`mileage` DESC , d.`first_name`;

--------------------------------------------------------------
Problem 7 
SELECT 
    c.`id` AS 'car_id',
    c.`make`,
    c.`mileage`,
    COUNT(cs.`id`) AS 'count_of_courses',
    ROUND(AVG(cs.`bill`), 2) AS 'avg_bill'
FROM
    `cars` AS c
        LEFT JOIN
    `courses` AS cs ON c.`id` = cs.`car_id`
GROUP BY c.`id`
HAVING `count_of_courses` <> 2
ORDER BY `count_of_courses` DESC , c.`id`;

--------------------------------------------------------------
Problem 8 
SELECT 
    c.`full_name`,
    COUNT(cs.`id`) AS 'count_of_cars',
    ROUND(SUM(cs.`bill`), 2) AS 'total_sum'
FROM
    `clients` AS c
        JOIN
    `courses` AS cs ON c.`id` = cs.`client_id`
WHERE
    SUBSTR(`full_name`, 2, 1) = 'a'
GROUP BY c.`id`
HAVING `count_of_cars` > 1
ORDER BY c.`full_name`;

--------------------------------------------------------------
Problem 9 
SELECT 
    a.`name`,
    if(hour(cs.`start`) between 6 and 20,'Day','Night') AS 'day_time',
    cs.`bill`,
    cl.`full_name`,
    cr.`make`,
    cr.`model`,
    ct.`name`
FROM
    `addresses` AS a
        JOIN
    `courses` AS cs ON a.`id` = cs.`from_address_id`
        JOIN
    `clients` AS cl ON cs.`client_id` = cl.`id`
        JOIN
    `cars` AS cr ON cs.`car_id` = cr.`id`
        JOIN
    `categories` AS ct ON cr.`category_id` = ct.`id`
ORDER BY cs.`id`;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_courses_by_client (`phone_num` VARCHAR (20))
RETURNS INT
DETERMINISTIC
RETURN (SELECT 
    COUNT(cs.`id`)
FROM
    `clients` AS cl
        JOIN
    `courses` AS cs ON cl.`id` = cs.`client_id`
WHERE
    cl.`phone_number` = `phone_num`
GROUP BY cl.`id`);

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_courses_by_address (`address_name` VARCHAR (100))
BEGIN
SELECT 
    a.`name`,
    cl.`full_name`,
    CASE
        WHEN cs.`bill` <= 20 THEN 'Low'
        WHEN cs.`bill` <= 30 THEN 'Medium'
        ELSE 'High'
    END AS 'level_of_bill',
    cr.`make`,
    cr.`condition`,
    ct.`name` AS 'cat_name'
FROM
    `addresses` AS a
        JOIN
    `courses` AS cs ON a.`id` = cs.`from_address_id`
        JOIN
    `cars` AS cr ON cs.`car_id` = cr.`id`
        JOIN
    `categories` AS ct ON cr.`category_id` = ct.`id`
        JOIN
    `clients` AS cl ON cs.`client_id` = cl.`id`
WHERE
    a.`name` = `address_name`
ORDER BY cr.`make` , cl.`full_name`;
END;

CREATE SCHEMA ruk_database;
USE ruk_database;

--------------------------------------------------------------
Problem 1 
CREATE TABLE `branches` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL UNIQUE
);
CREATE TABLE `employees` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(10 , 2 ) NOT NULL,
    `started_on` DATE NOT NULL,
    `branch_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`branch_id`)
        REFERENCES `branches` (`id`)
);
CREATE TABLE `clients` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(50) NOT NULL,
    `age` INT NOT NULL
);
CREATE TABLE `employees_clients` (
    `employee_id` INT,
    `client_id` INT,
    CONSTRAINT FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`id`),
    CONSTRAINT FOREIGN KEY (`client_id`)
        REFERENCES `clients` (`id`)
);
CREATE TABLE `bank_accounts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_number` VARCHAR(10) NOT NULL,
    `balance` DECIMAL(10 , 2 ) NOT NULL,
    `client_id` INT NOT NULL UNIQUE,
    CONSTRAINT FOREIGN KEY (`client_id`)
        REFERENCES `clients` (`id`)
);
CREATE TABLE `cards` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `card_number` VARCHAR(19) NOT NULL,
    `card_status` VARCHAR(7) NOT NULL,
    `bank_account_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`bank_account_id`)
        REFERENCES `bank_accounts` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `cards`(`card_number`,`card_status`,`bank_account_id`)
SELECT REVERSE(`full_name`),'Active',`id` 
FROM `clients` 
WHERE id BETWEEN 191 AND 200;

--------------------------------------------------------------
Problem 3 
UPDATE `employees_clients` 
SET 
    `employee_id` = (SELECT 
            *
        FROM
            (SELECT 
                `employee_id`
            FROM
                `employees_clients`
            GROUP BY `employee_id`
            ORDER BY COUNT(`client_id`) , `employee_id`
            LIMIT 1) AS s)
WHERE
    `employee_id` = `client_id`;

--------------------------------------------------------------
Problem 4 
DELETE e FROM `employees` AS e
        LEFT JOIN
    `employees_clients` AS ec ON e.`id` = ec.`employee_id` 
WHERE
    `client_id` IS NULL;

--------------------------------------------------------------
Problem 5
SELECT 
    `id`, `full_name`
FROM
    `clients`
ORDER BY `id`;

--------------------------------------------------------------
Problem 6 
SELECT 
    `id`,
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'full_name',
    CONCAT('$', `salary`) AS 'salary',
    `started_on`
FROM
    `employees`
WHERE
    `salary` >= 100000
        AND `started_on` >= '2018-01-01'
ORDER BY `salary` DESC , `id`;

--------------------------------------------------------------
Problem 7 
SELECT 
    c.`id`,
    CONCAT(c.`card_number`, ' : ', cl.`full_name`) AS 'card_token'
FROM
    `cards` AS c
        JOIN
    `bank_accounts` AS ba ON c.`bank_account_id` = ba.`id`
        JOIN
    `clients` AS cl ON ba.`client_id` = cl.`id`
ORDER BY c.`id` DESC;

--------------------------------------------------------------
Problem 8 
SELECT 
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS 'name',
    `started_on`,
    COUNT(`client_id`) AS 'count_of_clients'
FROM
    `employees` AS e
        JOIN
    `employees_clients` AS ec ON e.`id` = ec.`employee_id`
GROUP BY `employee_id`
ORDER BY `count_of_clients` DESC , e.`id`
LIMIT 5;

--------------------------------------------------------------
Problem 9 
SELECT 
    b.`name`, COUNT(c.`id`) AS 'count_of_cards'
FROM
    `branches` AS b
        LEFT JOIN
    `employees` AS e ON b.`id` = e.`branch_id`
        LEFT JOIN
    `employees_clients` AS ec ON e.`id` = ec.`employee_id`
        LEFT JOIN
    `clients` AS cl ON ec.`client_id` = cl.`id`
        LEFT JOIN
    `bank_accounts` AS ba ON cl.`id` = ba.`client_id`
        LEFT JOIN
    `cards` AS c ON ba.`id` = c.`bank_account_id`
GROUP BY b.`name`
ORDER BY `count_of_cards` DESC , b.`name`;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_client_cards_count(name VARCHAR(30)) 
RETURNS INT 
DETERMINISTIC
BEGIN
DECLARE count INT;
SET count := (SELECT 
	COUNT(c.`id`)
FROM
    `clients` AS cl
        JOIN
    `bank_accounts` AS ba ON cl.`id` = ba.`client_id`
        JOIN
    `cards` AS c ON ba.`id` = c.`bank_account_id`
WHERE
    cl.full_name = name
GROUP BY cl.`id`);
RETURN count;
END

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_clientinfo(name VARCHAR(30)) 
BEGIN
SELECT 
    cl.`full_name`,
    cl.`age`,
    ba.`account_number`,
    CONCAT('$', ba.`balance`) AS 'balance'
FROM
    `clients` AS cl
        LEFT JOIN
    `bank_accounts` AS ba ON cl.`id` = ba.`client_id`
WHERE
    cl.`full_name` = name;
END

CREATE SCHEMA softuni_stores_system;
USE softuni_stores_system;

--------------------------------------------------------------
Problem 1 
CREATE TABLE `pictures` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `url` VARCHAR(100) NOT NULL,
    `added_on` DATETIME NOT NULL
);
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `best_before` DATE,
    `price` DECIMAL(10 , 2 ) NOT NULL,
    `description` TEXT,
    `category_id` INT NOT NULL,
    `picture_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`),
    CONSTRAINT FOREIGN KEY (`picture_id`)
        REFERENCES `pictures` (`id`)
);
CREATE TABLE `towns` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL UNIQUE
);
CREATE TABLE `addresses` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    `town_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`town_id`)
        REFERENCES `towns` (`id`)
);
CREATE TABLE `stores` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    `rating` FLOAT NOT NULL,
    `has_parking` BOOLEAN DEFAULT FALSE,
    `address_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`address_id`)
        REFERENCES `addresses` (`id`)
);
CREATE TABLE `products_stores` (
    `product_id` INT,
    `store_id` INT,
    CONSTRAINT PRIMARY KEY (`product_id` , `store_id`),
    CONSTRAINT FOREIGN KEY (`product_id`)
        REFERENCES `products` (`id`),
    CONSTRAINT FOREIGN KEY (`store_id`)
        REFERENCES `stores` (`id`)
);
CREATE TABLE `employees` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(15) NOT NULL,
    `middle_name` VARCHAR(1),
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(19 , 2 ) DEFAULT 0,
    `hire_date` DATE NOT NULL,
    `manager_id` INT,
    `store_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`manager_id`)
        REFERENCES `employees` (`id`),
    CONSTRAINT FOREIGN KEY (`store_id`)
        REFERENCES `stores` (`id`)
);
--------------------------------------------------------------
Problem 2
INSERT INTO `products_stores`(`product_id`,`store_id`)
SELECT 
    p.`id`,1
FROM
    `products` AS p
        LEFT JOIN
    `products_stores` AS ps ON p.`id` = ps.`product_id`
WHERE
    ps.`product_id` IS NULL;
 
--------------------------------------------------------------
Problem 3 
UPDATE `employees` 
SET 
    `manager_id` = 3,
    `salary` = `salary` - 500
WHERE
    YEAR(`hire_date`) > 2003
        AND `store_id` NOT IN (5 , 14);

--------------------------------------------------------------
Problem 4 
DELETE FROM `employees` 
WHERE
    `manager_id` IS NOT NULL
    AND `salary` >= 6000;

--------------------------------------------------------------
Problem 5
SELECT 
    `first_name`,
    `middle_name`,
    `last_name`,
    `salary`,
    `hire_date`
FROM
    `employees`
ORDER BY `hire_date` DESC;
 
--------------------------------------------------------------
Problem 6 
SELECT 
    pro.`name`,
    pro.`price`,
    pro.`best_before`,
    CONCAT(LEFT(pro.`description`, 10), '...'),
    pic.`url`
FROM
    `products` AS pro
        JOIN
    `pictures` AS pic ON pro.`picture_id` = pic.`id`
WHERE
    CHAR_LENGTH(pro.`description`) > 100
        AND YEAR(pic.`added_on`) < 2019
        AND pro.`price` > 20
ORDER BY pro.`price` DESC;

--------------------------------------------------------------
Problem 7 
SELECT 
    s.`name`,
    COUNT(p.`id`) AS 'product_count',
    ROUND(AVG(p.`price`), 2) AS 'avg'
FROM
    `products` AS p
		JOIN
    `products_stores` AS ps ON p.`id` = ps.`product_id`
        RIGHT JOIN
    `stores` AS s ON ps.`store_id` = s.`id`
GROUP BY s.`id`
ORDER BY `product_count` DESC , `avg` DESC , s.`id`;

--------------------------------------------------------------
Problem 8 
SELECT 
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS 'Full_name',
    s.`name` AS 'Store_name',
    a.`name` AS 'address',
    e.`salary`
FROM
    `employees` AS e
        JOIN
    `stores` AS s ON e.`store_id` = s.`id`
        JOIN
    `addresses` AS a ON s.`address_id` = a.`id`
WHERE
    e.`salary` < 4000
        AND a.`name` LIKE '%5%'
        AND CHAR_LENGTH(s.`name`) > 8
        AND RIGHT(e.`last_name`, 1) = 'n';

--------------------------------------------------------------
Problem 9 
SELECT 
    REVERSE(s.`name`) AS 'reversed_name',
    CONCAT_WS('-', UPPER(t.`name`), a.`name`) AS 'full_address',
    COUNT(e.`id`) AS 'employees_count'
FROM
    `employees` AS e
        JOIN
    `stores` AS s ON e.`store_id` = s.`id`
        JOIN
    `addresses` AS a ON s.`address_id` = a.`id`
        JOIN
    `towns` AS t ON a.`town_id` = t.`id`
GROUP BY s.`id`
ORDER BY `full_address`;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC 
BEGIN
DECLARE info VARCHAR(100);
SET info := (SELECT 
    CONCAT(CONCAT(e.`first_name`,
                    ' ',
                    e.`middle_name`,
                    '. ',
                    e.`last_name`),
            ' works in store for ',
            2020 - YEAR(e.`hire_date`),
            ' years') 
FROM
    `employees` AS e
        JOIN
    `stores` AS s ON e.`store_id` = s.`id`
WHERE
    s.`name` = store_name
        AND e.`salary` = (SELECT 
            MAX(e.`salary`)
        FROM
            `employees` AS e
                JOIN
            `stores` AS s ON e.`store_id` = s.`id`
        WHERE
            s.`name` = store_name
        GROUP BY s.`id`));
        RETURN info;
END

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_update_product_price (address_name VARCHAR (50))
BEGIN
UPDATE products AS p
        JOIN
    products_stores AS ps ON p.`id` = ps.`product_id`
        JOIN
    stores AS s ON ps.`store_id` = s.`id`
        JOIN
    addresses AS a ON s.`address_id` = a.`id` 
SET 
    price = IF(LEFT(a.`name`, 1) = '0',
        price + 100,
        price + 200)
WHERE
    a.`name` = address_name;
END
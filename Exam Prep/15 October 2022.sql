CREATE SCHEMA restaurant_db ;
USE restaurant_db ;

--------------------------------------------------------------
Problem 1 
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL UNIQUE,
    `type` VARCHAR(30) NOT NULL,
    `price` DECIMAL(10 , 2 ) NOT NULL
);
CREATE TABLE `clients` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `birthdate` DATE NOT NULL,
    `card` VARCHAR(50),
    `review` TEXT
);
CREATE TABLE `tables` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `floor` INT NOT NULL,
    `reserved` BOOLEAN,
    `capacity` INT NOT NULL
);
CREATE TABLE `waiters` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(50),
    `salary` DECIMAL(10 , 2 )
);
CREATE TABLE `orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `table_id` INT NOT NULL,
    `waiter_id` INT NOT NULL,
    `order_time` TIME NOT NULL,
    `payed_status` BOOLEAN,
    CONSTRAINT FOREIGN KEY (`table_id`)
        REFERENCES `tables` (`id`),
    CONSTRAINT FOREIGN KEY (`waiter_id`)
        REFERENCES `waiters` (`id`)
);
CREATE TABLE `orders_clients` (
    `order_id` INT,
    `client_id` INT,
    CONSTRAINT FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`id`),
    CONSTRAINT FOREIGN KEY (`client_id`)
        REFERENCES `clients` (`id`)
);
CREATE TABLE `orders_products` (
    `order_id` INT,
    `product_id` INT,
    CONSTRAINT FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`id`),
    CONSTRAINT FOREIGN KEY (`product_id`)
        REFERENCES `products` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `products`(`name`, `type`, `price`) 
SELECT concat_ws(' ', `last_name`, 'specialty'), 'Cocktail', ceil(`salary` * 0.01) 
FROM `waiters` WHERE `id` > 6;

--------------------------------------------------------------
Problem 3 
UPDATE `orders` 
SET 
    `table_id` = `table_id` - 1
WHERE
    `id` BETWEEN 12 AND 23;

--------------------------------------------------------------
Problem 4 
DELETE w FROM waiters AS w
        LEFT JOIN
    orders AS o ON w.id = o.waiter_id 
WHERE
    o.waiter_id IS NULL;

--------------------------------------------------------------
Problem 5
SELECT 
    *
FROM
    `clients`
ORDER BY `birthdate` DESC , `id` DESC;
 
--------------------------------------------------------------
Problem 6 
SELECT 
    `first_name`, `last_name`, `birthdate`, `review`
FROM
    `clients`
WHERE
    `card` IS NULL
        AND YEAR(`birthdate`) BETWEEN 1978 AND 1993
ORDER BY `last_name` DESC , `id`
LIMIT 5;

--------------------------------------------------------------
Problem 7 
SELECT 
    CONCAT(`last_name`,
            `first_name`,
            CHAR_LENGTH(`first_name`),
            'Restaurant') AS 'username',
    REVERSE(SUBSTR(`email`, 2, 12)) AS 'password'
FROM
    `waiters`
WHERE
    `salary` IS NOT NULL
ORDER BY `password` DESC;

--------------------------------------------------------------
Problem 8 
SELECT 
    p.`id`, p.`name`, COUNT(op.order_id) AS 'count'
FROM
    `products` AS p
        JOIN
    `orders_products` AS op ON p.`id` = op.`product_id`
GROUP BY p.`id`
HAVING `count` >= 5
ORDER BY `count` DESC , p.`name`;

--------------------------------------------------------------
Problem 9 
SELECT 
    `table_id`,
    `capacity`,
    COUNT(oc.`client_id`) AS 'count_clients',
    CASE
        WHEN COUNT(oc.`client_id`) < `capacity` THEN 'Free seats'
        WHEN COUNT(oc.`client_id`) = `capacity` THEN 'Full'
        ELSE 'Extra seats'
    END AS 'availability'
FROM
    `tables` AS t
        JOIN
    `orders` AS o ON t.`id` = o.`table_id`
        JOIN
    `orders_clients` AS oc ON o.`id` = oc.`order_id`
WHERE
    `floor` = 1
GROUP BY t.`id`
ORDER BY `table_id` DESC;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
RETURN (SELECT 
    SUM(p.`price`)
FROM
    `clients` AS c
        JOIN
    `orders_clients` AS oc ON c.`id` = oc.`client_id`
        JOIN
    `orders` AS o ON oc.`order_id` = o.`id`
        JOIN
    `orders_products` AS op ON o.`id` = op.`order_id`
        JOIN
    `products` AS p ON op.`product_id` = p.`id`
WHERE
    CONCAT_WS(' ', c.`first_name`, c.`last_name`) = full_name
GROUP BY c.`id`);
END

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_happy_hour(type VARCHAR(50))
BEGIN
UPDATE `products` 
SET 
    `price` = `price` * 0.8
WHERE
    `price` >= 10.00 AND `type` = type;
END
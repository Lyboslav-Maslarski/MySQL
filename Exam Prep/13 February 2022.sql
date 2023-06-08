CREATE SCHEMA online_store ;
USE online_store ;

--------------------------------------------------------------
Problem 1 
CREATE TABLE `brands` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `content` TEXT,
    `rating` DECIMAL(10 , 2 ) NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `published_at` DATETIME NOT NULL
);
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL,
    `price` DECIMAL(19 , 2 ) NOT NULL,
    `quantity_in_stock` INT,
    `description` TEXT,
    `brand_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `review_id` INT,
    CONSTRAINT FOREIGN KEY (`brand_id`)
        REFERENCES `brands` (`id`),
    CONSTRAINT FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`),
    CONSTRAINT FOREIGN KEY (`review_id`)
        REFERENCES `reviews` (`id`)
);
CREATE TABLE `customers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `phone` VARCHAR(30) NOT NULL UNIQUE,
    `address` VARCHAR(60) NOT NULL,
    `discount_card` BIT NOT NULL DEFAULT FALSE
);
CREATE TABLE `orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_datetime` DATETIME NOT NULL,
    `customer_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`id`)
);
CREATE TABLE `orders_products` (
    `order_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    CONSTRAINT FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`id`),
    CONSTRAINT FOREIGN KEY (`product_id`)
        REFERENCES `products` (`id`)
);

--------------------------------------------------------------
Problem 2
INSERT INTO `reviews` (`content`, `rating`, `picture_url`, `published_at`) 
SELECT left(`description` ,15), (`price` / 8), reverse(`name`), '2010-10-10' 
FROM `products` WHERE `id` >= 5;

--------------------------------------------------------------
Problem 3 
UPDATE `products` 
SET 
    `quantity_in_stock` = `quantity_in_stock` - 5
WHERE
    `quantity_in_stock` BETWEEN 60 AND 70;

--------------------------------------------------------------
Problem 4 
DELETE c FROM `customers` AS c
        LEFT JOIN
    `orders` AS o ON c.`id` = o.`customer_id` 
WHERE
    o.`customer_id` IS NULL;

--------------------------------------------------------------
Problem 5
SELECT 
    *
FROM
    `categories`
ORDER BY `name` DESC;

--------------------------------------------------------------
Problem 6 
SELECT 
    `id`, `brand_id`, `name`, `quantity_in_stock`
FROM
    `products`
WHERE
    `price` > 1000
        AND `quantity_in_stock` < 30
ORDER BY `quantity_in_stock` , `id`;

--------------------------------------------------------------
Problem 7 
SELECT 
    *
FROM
    `reviews`
WHERE
    LEFT(`content`, 2) = 'My'
        AND CHAR_LENGTH(`content`) > 61
ORDER BY `rating` DESC;

--------------------------------------------------------------
Problem 8 
SELECT 
    CONCAT(c.`first_name`, ' ', c.`last_name`) AS 'full_name',
    c.`address`,
    o.`order_datetime` AS 'order_date'
FROM
    `customers` AS c
        JOIN
    `orders` AS o ON c.`id` = o.`customer_id`
WHERE
    YEAR(o.`order_datetime`) <= 2018
ORDER BY `full_name` DESC;

--------------------------------------------------------------
Problem 9 
SELECT 
    COUNT(p.`id`) AS 'items_count',
    c.`name`,
    SUM(p.`quantity_in_stock`) AS 'total_quantity'
FROM
    `categories` AS c
        JOIN
    `products` AS p ON c.`id` = p.`category_id`
GROUP BY c.`id`
ORDER BY `items_count` DESC , `total_quantity`
LIMIT 5;

--------------------------------------------------------------
Problem 10
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT 
    COUNT(op.`product_id`)
FROM
    `customers` AS c
        JOIN
    `orders` AS o ON c.`id` = o.`customer_id`
        JOIN
    `orders_products` AS op ON o.`id` = op.`order_id`
WHERE
    c.`first_name` = name);
END

--------------------------------------------------------------
Problem 11 
CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
UPDATE `categories` AS c
        JOIN
    `products` AS p ON c.`id` = p.`category_id`
        JOIN
    `reviews` AS r ON p.`review_id` = r.`id` 
SET 
    p.`price` = p.`price` * 0.7
WHERE
    r.`rating` < 4
        AND c.`name` = category_name;
END
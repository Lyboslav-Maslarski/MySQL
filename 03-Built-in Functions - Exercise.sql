Problem 1 
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    `first_name` LIKE 'Sa%'
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 2
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    `last_name` LIKE '%ei%'
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 3
SELECT 
    `first_name`
FROM
    `employees`
WHERE
    `department_id` IN (3 , 10)
        AND year(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 4
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 5
SELECT 
    `name`
FROM
    `towns`
WHERE
    CHAR_LENGTH(`name`) IN (5 , 6)
ORDER BY `name`;

---------------------------------------------------------------
Problem 6
SELECT 
    `town_id`, `name`
FROM
    `towns`
WHERE
    `name` LIKE 'M%' OR `name` LIKE 'B%'
        OR `name` LIKE 'K%'
        OR `name` LIKE 'E%'
ORDER BY `name`;

---------------------------------------------------------------
Problem 7
SELECT 
    `town_id`, `name`
FROM
    `towns`
WHERE
    `name` NOT LIKE 'B%' AND `name` NOT LIKE 'R%'
        AND `name` NOT LIKE 'D%'
ORDER BY `name`;

---------------------------------------------------------------
Problem 8
CREATE VIEW v_employees_hired_after_2000 AS
    SELECT 
        `first_name`, `last_name`
    FROM
        `employees`
    WHERE
        YEAR(`hire_date`) > 2000;
SELECT 
    *
FROM
    v_employees_hired_after_2000;

---------------------------------------------------------------
Problem 9
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    CHAR_LENGTH(`last_name`) = 5;

---------------------------------------------------------------
Problem 10
SELECT 
    `country_name`, `iso_code`
FROM
    `countries`
WHERE
    `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;

---------------------------------------------------------------
Problem 11
SELECT 
    `peak_name`,
    `river_name`,
    CONCAT(LOWER(`peak_name`),
            LOWER(SUBSTR(`river_name`, 2))) AS 'mix'
FROM
    `peaks`,
    `rivers`
WHERE
    SUBSTR(`peak_name`, - 1) = SUBSTR(`river_name`, 1, 1)
ORDER BY `mix`;

---------------------------------------------------------------
Problem 12
SELECT 
    `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS 'start'
FROM
    `games`
WHERE
    YEAR(`start`) IN (2011 , 2012)
ORDER BY `start` , `name`
LIMIT 50;

---------------------------------------------------------------
Problem 13
SELECT 
    `user_name`,
    SUBSTR(`email`,
        LOCATE('@', `email`) + 1) AS `email provider`
FROM
    `users`
ORDER BY `email provider` , `user_name`;

---------------------------------------------------------------
Problem 14
SELECT 
    `user_name`, `ip_address`
FROM
    `users`
WHERE
    `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

---------------------------------------------------------------
Problem 15
SELECT 
    `name`,
    CASE
        WHEN
            HOUR(`start`) >= 0
                AND HOUR(`start`) < 12
        THEN
            'Morning'
        WHEN
            HOUR(`start`) >= 12
                AND HOUR(`start`) < 18
        THEN
            'Afternoon'
        ELSE 'Evening'
    END AS `start`,
    CASE
        WHEN `duration` <= 3 THEN 'Extra Short'
        WHEN `duration` > 3 AND `duration` <= 6 THEN 'Short'
        WHEN `duration` > 6 AND `duration` <= 10 THEN 'Long'
        ELSE 'Extra Long'
    END AS `duration`
FROM
    `games`;

---------------------------------------------------------------
Problem 16
SELECT 
    `product_name`,
    `order_date`,
    ADDDATE(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
    ADDDATE(`order_date`, INTERVAL 1 MONTH) AS `deliver_due`
FROM
    `orders`;

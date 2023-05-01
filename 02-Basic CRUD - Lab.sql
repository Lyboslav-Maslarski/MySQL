Problem 1 
SELECT `id`, `first_name`, `last_name`, `job_title` from employees
ORDER BY `id`;

---------------------------------------------------------------
Problem 2
SELECT 
    `id`,
    CONCAT_WS(' ', `first_name`, `last_name`) AS `full_name`,
    `job_title`,
    `salary`
FROM
    `employees`
WHERE
    `salary` > 1000
ORDER BY `id`;

---------------------------------------------------------------
Problem 3
UPDATE `employees` 
SET 
    `salary` = `salary` + 100
WHERE
    `job_title` = 'Manager';
SELECT 
    `salary`
FROM
    `employees`;

---------------------------------------------------------------
Problem 4
SELECT 
    *
FROM
    `employees`
ORDER BY `salary` DESC
LIMIT 1;

---------------------------------------------------------------
Problem 5
SELECT 
    *
FROM
    `employees`
WHERE
    `department_id` = 4 AND `salary` >= 1000
ORDER BY `id` ASC;

---------------------------------------------------------------
Problem 6
DELETE FROM `employees` 
WHERE
    `department_id` IN (1 , 2);
SELECT 
    *
FROM
    `employees`
ORDER BY `id` ASC;

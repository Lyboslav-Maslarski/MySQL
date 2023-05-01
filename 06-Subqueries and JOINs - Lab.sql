Problem 1 
SELECT 
    e.`employee_id`,
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS 'full_name',
    d.`department_id`,
    d.`name` AS 'deparment_name'
FROM
    `departments` AS d
        JOIN
    `employees` AS e ON d.`manager_id` = e.`employee_id`
ORDER BY e.`employee_id`
LIMIT 5;

---------------------------------------------------------------
Problem 2
SELECT 
    t.`town_id`, `name` AS 'town_name', `address_text`
FROM
    `towns` AS t
        JOIN
    `addresses` AS a ON t.`town_id` = a.`town_id`
WHERE
    `name` IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY `town_id` , `address_id`;

---------------------------------------------------------------
Problem 3
SELECT 
    e.`employee_id`,
    e.`first_name`,
    e.`last_name`,
    e.`department_id`,
    e.`salary`
FROM
    `employees` AS e
WHERE
    e.`manager_id` IS NULL;

---------------------------------------------------------------
Problem 4
SELECT 
    COUNT(*)
FROM
    `employees`
WHERE
    `salary` > (SELECT 
            AVG(`salary`)
        FROM
            `employees`);
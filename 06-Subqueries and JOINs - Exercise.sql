Problem 1 
SELECT 
    `employee_id`, `job_title`, e.`address_id`, `address_text`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
ORDER BY `address_id`
LIMIT 5;

---------------------------------------------------------------
Problem 2
SELECT 
    `first_name`, `last_name`, t.`name`, `address_text`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
        JOIN
    `towns` AS t ON a.`town_id` = t.`town_id`
ORDER BY `first_name`, `last_name`
LIMIT 5;

---------------------------------------------------------------
Problem 3
SELECT 
    `employee_id`, `first_name`, `last_name`, d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    d.`name` = 'Sales'
ORDER BY `employee_id` DESC, `last_name`;

---------------------------------------------------------------
Problem 4
SELECT 
    `employee_id`, `first_name`, `salary`, d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    `salary` > 15000
ORDER BY d.`department_id` DESC
LIMIT 5;

---------------------------------------------------------------
Problem 5
SELECT 
    e.`employee_id`, `first_name`
FROM
    `employees` AS e
        LEFT JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
WHERE
    ep.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

---------------------------------------------------------------
Problem 6
SELECT 
    `first_name`, `last_name`, `hire_date`, d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    `hire_date` > 1999 - 1 - 1
        AND d.`name` IN ('Sales' , 'Finance')
ORDER BY `hire_date`;

---------------------------------------------------------------
Problem 7
SELECT 
    e.`employee_id`, e.`first_name`, p.`name` AS 'project_name'
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
        JOIN
    `projects` AS p ON ep.`project_id` = p.`project_id`
WHERE
    DATE(p.`start_date`) > '2002-08-13'
        AND p.`end_date` IS NULL
ORDER BY e.`first_name`, `project_name`
LIMIT 5;

---------------------------------------------------------------
Problem 8
SELECT 
    e.`employee_id`,
    e.`first_name`,
    IF(DATE(p.`start_date`) < '2005-01-01',
        p.`name`,
        NULL) AS 'project_name'
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
        JOIN
    `projects` AS p ON ep.`project_id` = p.`project_id`
WHERE
    e.`employee_id` = 24
ORDER BY `project_name`;

---------------------------------------------------------------
Problem 9
SELECT 
    e1.`employee_id`,
    e1.`first_name`,
    e1.`manager_id`,
    (SELECT 
            `first_name`
        FROM
            `employees` AS e2
        WHERE
            e2.`employee_id` = e1.`manager_id`) AS 'manager_name'
FROM
    `employees` AS e1
WHERE
    e1.`manager_id` IN (3 , 7)
ORDER BY `first_name`;

---------------------------------------------------------------
Problem 10
SELECT 
    e1.`employee_id`,
    CONCAT_WS(' ', e1.`first_name`, e1.`last_name`) AS 'employee_name',
    (SELECT 
            CONCAT_WS(' ', e2.`first_name`, e2.`last_name`)
        FROM
            `employees` AS e2
        WHERE
            e2.`employee_id` = e1.`manager_id`) AS 'manager_name',
    d.`name` AS 'department_name'
FROM
    `employees` AS e1
        JOIN
    `departments` AS d ON e1.`department_id` = d.`department_id`
WHERE
    e1.`manager_id` IS NOT NULL
ORDER BY `employee_id`
LIMIT 5;

---------------------------------------------------------------
Problem 11
SELECT 
    AVG(`salary`) AS 'min_average_salary'
FROM
    `employees`
GROUP BY `department_id`
ORDER BY `min_average_salary`
LIMIT 1;

---------------------------------------------------------------
Problem 12
SELECT 
    c.`country_code`, `mountain_range`, `peak_name`, `elevation`
FROM
    `countries` AS c
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON p.`mountain_id` = m.`id`
WHERE
    `country_name` = 'Bulgaria'
        AND `elevation` > 2835
ORDER BY `elevation` DESC;

---------------------------------------------------------------
Problem 13
SELECT 
    `country_code`, COUNT(`mountain_id`) AS 'mountain_range'
FROM
    `mountains_countries`
WHERE
    `country_code` IN ('BG' , 'RU', 'US')
GROUP BY `country_code`
ORDER BY `mountain_range` DESC;
    
---------------------------------------------------------------
Problem 14
SELECT 
    `country_name`, `river_name`
FROM
    `countries` AS c
        LEFT JOIN
    `countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
        LEFT JOIN
    `rivers` AS r ON cr.`river_id` = r.`id`
WHERE
    `continent_code` = 'AF'
ORDER BY `country_name`
LIMIT 5;

---------------------------------------------------------------
Problem 15
SELECT 
    `continent_code`, `currency_code`, COUNT(*) AS 'currency_usage'
FROM
    `countries` AS c1
GROUP BY `continent_code`, `currency_code`
HAVING `currency_usage` > 1
    AND `currency_usage` = (SELECT 
        COUNT(*) AS 'most_used_currency'
    FROM
        `countries` AS c2
    WHERE
        c1.`continent_code` = c2.`continent_code`
    GROUP BY `currency_code`
    ORDER BY `most_used_currency` DESC
    LIMIT 1)
ORDER BY `continent_code`, `currency_code`;

---------------------------------------------------------------
Problem 16
SELECT 
    COUNT(c.`country_code`) AS 'country_count'
FROM
    `countries` AS c
        LEFT JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
WHERE
    `mountain_id` IS NULL;

---------------------------------------------------------------
Problem 17
SELECT 
    `country_name`,
    (SELECT 
            `elevation`
        FROM
            `peaks` AS p
                JOIN
            `mountains_countries` AS mc ON p.`mountain_id` = mc.`mountain_id`
                JOIN
            `countries` AS c1 ON mc.`country_code` = c1.`country_code`
        WHERE
            c1.`country_code` = c.`country_code`
        ORDER BY `elevation` DESC
        LIMIT 1) AS 'highest_peak_elevation',
    (SELECT 
            `length`
        FROM
            `rivers` AS r
                JOIN
            `countries_rivers` AS cr ON r.`id` = cr.`river_id`
                JOIN
            `countries` AS c2 ON cr.`country_code` = c2.`country_code`
        WHERE
            c2.`country_code` = c.`country_code`
        ORDER BY `length` DESC
        LIMIT 1) AS 'longest_river_length'
FROM
    `countries` AS c
ORDER BY `highest_peak_elevation` DESC , `longest_river_length` DESC , `country_name`
LIMIT 5;

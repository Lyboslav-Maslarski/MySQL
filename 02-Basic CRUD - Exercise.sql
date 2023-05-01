Problem 1 
SELECT 
    *
FROM
    `departments`
ORDER BY `department_id`;

---------------------------------------------------------------
Problem 2
SELECT 
    `name`
FROM
    `departments`
ORDER BY `department_id`;

---------------------------------------------------------------
Problem 3
SELECT 
    `first_name`,`last_name`,`salary`
FROM
    `employees`
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 4
SELECT 
    `first_name`, `middle_name`, `last_name`
FROM
    `employees`
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 5
SELECT 
    concat(`first_name`,'.',`last_name`,'@','softuni.bg') AS `full_email_address`
FROM
    `employees`
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 6
SELECT DISTINCT
    `salary`
FROM
    `employees`;

---------------------------------------------------------------
Problem 7
SELECT 
    *
FROM
    `employees`
WHERE
    `job_title` = 'Sales Representative'
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 8
SELECT
    `first_name`, `last_name`, `job_title`
FROM
    `employees`
WHERE
    `salary` BETWEEN 20000 AND 30000
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 9
SELECT 
    CONCAT_WS(' ',
            `first_name`,
            `middle_name`,
            `last_name`) AS `Full Name`
FROM
    `employees`
WHERE
    `salary` IN (25000 , 14000, 23600, 12500)
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 10
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    `manager_id` IS NULL
ORDER BY `employee_id`;

---------------------------------------------------------------
Problem 11
SELECT 
    `first_name`, `last_name`, `salary`
FROM
    `employees`
WHERE
    `salary` > 50000
ORDER BY `salary` DESC;

---------------------------------------------------------------
Problem 12
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
ORDER BY `salary` DESC
LIMIT 5;

---------------------------------------------------------------
Problem 13
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    `department_id` != 4;
---------------------------------------------------------------
Problem 14
SELECT 
    *
FROM
    `employees`
ORDER BY `salary` DESC, `first_name`, `last_name` DESC, `middle_name`, `employee_id`;

---------------------------------------------------------------
Problem 15
CREATE VIEW v_employees_salaries AS
    SELECT 
        `first_name`, `last_name`, `salary`
    FROM
        `employees`;
SELECT 
    *
FROM
    v_employees_salaries;

---------------------------------------------------------------
Problem 16
CREATE VIEW v_employees_job_titles AS
    SELECT 
        CONCAT_WS(' ',
                `first_name`,
                `middle_name`,
                `last_name`) AS `full_name`,
        `job_title`
    FROM
        `employees`;
SELECT 
    *
FROM
    v_employees_job_titles;

---------------------------------------------------------------
Problem 17
SELECT DISTINCT
    `job_title`
FROM
    `employees`
ORDER BY `job_title`;

---------------------------------------------------------------
Problem 18
SELECT 
    *
FROM
    `projects`
ORDER BY `start_date`, `name`, `project_id`
LIMIT 10;

---------------------------------------------------------------
Problem 19
SELECT 
    `first_name`, `last_name`, `hire_date`
FROM
    `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

---------------------------------------------------------------
Problem 20
UPDATE `employees` 
SET 
    `salary` = `salary` * 1.12
WHERE
    `department_id` IN (1 , 2, 4, 11);
SELECT 
    `salary`
FROM
    employees;

---------------------------------------------------------------
Problem 21
SELECT 
    `peak_name`
FROM
    `peaks`
ORDER BY `peak_name`;

---------------------------------------------------------------
Problem 22
SELECT 
    `country_name`, `population`
FROM
    `countries`
WHERE
    `continent_code` = 'EU'
ORDER BY `population` DESC , `country_name`
LIMIT 30;

---------------------------------------------------------------
Problem 23
SELECT 
    `country_name`,
    `country_code`,
    IF(`currency_code` = 'EUR',
        'Euro',
        'Not Euro') AS 'currency'
FROM
    `countries`
ORDER BY `country_name`;

---------------------------------------------------------------
Problem 24
SELECT 
    `name`
FROM
    `characters`
ORDER BY `name`;

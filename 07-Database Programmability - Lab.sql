Problem 1 
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(*) FROM `employees` as e 
JOIN `addresses` as a on e.`address_id` = a.`address_id` 
join `towns` as t on a.`town_id` = t.`town_id`
WHERE t.`name` = town_name);
END

---------------------------------------------------------------
Problem 2
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(100))
BEGIN
UPDATE `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
    SET `salary` = `salary` * 1.05
    WHERE d.`name` = department_name;
END

---------------------------------------------------------------
Problem 3
CREATE PROCEDURE usp_raise_salary_by_id(id INT) 
BEGIN
	IF ( (SELECT count(*) FROM `employees` WHERE `employee_id` = `id`) > 0) 
	THEN
		UPDATE `employees` AS e SET `salary` = `salary` * 1.05 WHERE e.`employee_id` = `id`;
	ELSE
        ROLLBACK;
	END IF;
END

---------------------------------------------------------------
Problem 4
CREATE TABLE IF NOT EXISTS `deleted_employees` (
    `employee_id` INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `middle_name` VARCHAR(50) DEFAULT NULL,
    `job_title` VARCHAR(50) NOT NULL,
    `department_id` INT(10) NOT NULL,
    `salary` DECIMAL(19 , 4 ) NOT NULL
);

CREATE 
    TRIGGER  save_deleted_employees
 BEFORE DELETE ON `employees` FOR EACH ROW 
    INSERT INTO deleted_employees (first_name , last_name , middle_name , job_title , department_id , salary) 
    VALUES (OLD.first_name , OLD.last_name , OLD.middle_name , OLD.job_title , OLD.department_id , OLD.salary);

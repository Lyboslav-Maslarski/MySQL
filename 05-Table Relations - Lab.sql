Problem 1 
CREATE TABLE `mountains` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)
);
CREATE TABLE `peaks` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains` FOREIGN KEY (`mountain_id`)
        REFERENCES `mountains` (`id`)
);

---------------------------------------------------------------
Problem 2
SELECT 
    v.`driver_id`,
    v.`vehicle_type`,
    CONCAT_WS(' ', c.`first_name`, c.`last_name`) AS 'driver_name'
FROM
    `vehicles` AS v
        JOIN
    `campers` AS c ON v.`driver_id` = c.`id`;

---------------------------------------------------------------
Problem 3
SELECT 
    r.`starting_point` AS 'route_starting_point',
    r.`end_point` AS 'route_ending_point',
    r.`leader_id`,
    CONCAT_WS(' ', c.`first_name`, c.`last_name`) AS 'leader_name'
FROM
    `routes` AS r
        JOIN
    `campers` AS c ON r.`leader_id` = c.`id`;

---------------------------------------------------------------
Problem 4
CREATE TABLE `mountains` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)
);
CREATE TABLE `peaks` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains` FOREIGN KEY (`mountain_id`)
        REFERENCES `mountains` (`id`)
        ON DELETE CASCADE
);
---------------------------------------------------------------
Problem 5
CREATE TABLE `employees` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30),
    `last_name` VARCHAR(30),
    `project_id` INT
);

CREATE TABLE `clients` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `client_name` VARCHAR(30)
);

CREATE TABLE `projects` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `project_lead_id` INT,
    `client_id` INT,
    CONSTRAINT fk_projects_employees FOREIGN KEY (`project_lead_id`)
        REFERENCES `employees` (`id`),
    CONSTRAINT fk_projects_clients FOREIGN KEY (`client_id`)
        REFERENCES `clients` (`id`)
);

ALTER TABLE `employees` ADD CONSTRAINT fk_employees_projects FOREIGN KEY (`project_id`)
        REFERENCES `projects` (`id`);
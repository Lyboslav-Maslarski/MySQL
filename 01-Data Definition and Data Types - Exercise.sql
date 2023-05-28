Problem 1 
create table `minions`(
	id int primary key auto_increment,
	name varchar(50) not null,
	age int not null
);
create table `towns`(
	town_id int primary key auto_increment,
	name varchar(50) not null
);

---------------------------------------------------------------
Problem 2
alter table `minions`
add column `town_id` int;
alter table `minions`
add constraint `fk_minions_towns`
foreign key `minions`(`town_id`)
references `towns`(`id`);

---------------------------------------------------------------
Problem 3
insert into `towns` (`id`,`name`)
VALUES
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');
insert into `minions` (`id`,`name`,`age`,`town_id`)
VALUES
(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',NULL,2);

---------------------------------------------------------------
Problem 4
truncate table `minions`;

---------------------------------------------------------------
Problem 5
DROP TABLE `minions`;
DROP TABLE `towns`;

---------------------------------------------------------------
Problem 6
CREATE TABLE `people` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB NULL,
    `height` DOUBLE(5 , 2 ) NULL,
    `weight` DOUBLE(5 , 2 ) NULL,
    `gender` CHAR(1) NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT NULL
);
INSERT INTO `people` (`name`,`height`,`weight`,`gender`,`birthdate`)
VALUES
('test1',1.7854,78.335,'m',DATE(NOW())),
('test2',1.7854,78.335,'m',DATE(NOW())),
('test3',1.7854,78.335,'m',DATE(NOW())),
('test4',1.7854,78.335,'m',DATE(NOW())),
('test5',1.7854,78.335,'m',DATE(NOW()));

---------------------------------------------------------------
Problem 7
CREATE TABLE `users` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(26) NOT NULL,
    `profile_picture` BLOB NULL,
    `last_login_time` DATE,
    `is_deleted` BOOLEAN
);
INSERT INTO `users` (`username`,`password`)
VALUES
('test1','pass'),
('test2','pass'),
('test3','pass'),
('test4','pass'),
('test5','pass');

---------------------------------------------------------------
Problem 8
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users2
PRIMARY KEY `users` (`id`,`username`);

---------------------------------------------------------------
Problem 9
ALTER TABLE `users`
CHANGE COLUMN `last_login_time` `last_login_time` DATETIME DEFAULT NOW();

---------------------------------------------------------------
Problem 10
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_user PRIMARY KEY `users`(`id`),
CHANGE COLUMN `username` `username` VARCHAR(30) UNIQUE;

---------------------------------------------------------------
Problem 11
CREATE TABLE `directors` (
	`id` INT PRIMARY KEY AUTO_INCREMENT, 
	`director_name` VARCHAR(25) NOT NULL, 
	`notes` TEXT
);
INSERT INTO `directors` (`director_name`)
VALUES 
('Test1'),
('Test2'),
('Test3'),
('Test4'),
('Test5');
CREATE TABLE `genres` (
	`id` INT PRIMARY KEY AUTO_INCREMENT, 
	`genre_name` VARCHAR(25) NOT NULL, 
	`notes` TEXT
);
INSERT INTO `genres` (`genre_name`)
VALUES 
('Test1'),
('Test2'),
('Test3'),
('Test4'),
('Test5');
CREATE TABLE `categories` (
	`id` INT PRIMARY KEY AUTO_INCREMENT, 
	`category_name` VARCHAR(25) NOT NULL, 
	`notes` TEXT
);
INSERT INTO `categories` (`category_name`)
VALUES 
('Test1'),
('Test2'),
('Test3'),
('Test4'),
('Test5');
CREATE TABLE `movies` (
	`id` INT PRIMARY KEY AUTO_INCREMENT, 
	`title` VARCHAR(30) NOT NULL, 
	`director_id` INT, 
	`copyright_year` YEAR, 
	`length` DOUBLE, 
	`genre_id` INT, 
	`category_id` INT, 
	`rating` DOUBLE, 
	`notes` TEXT
);
INSERT INTO `movies`(`title`)
VALUES 
('Test1'),
('Test2'),
('Test3'),
('Test4'),
('Test5');

---------------------------------------------------------------
Problem 12
CREATE TABLE `categories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `category` VARCHAR(25) NOT NULL,
    `daily_rate` DOUBLE,
    `weekly_rate` DOUBLE,
    `monthly_rate` DOUBLE,
    `weekend_rate` DOUBLE
);
INSERT INTO `categories` (`category`)
VALUES 
('Test1'),
('Test2'),
('Test3');

CREATE TABLE `cars` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `plate_number` VARCHAR(8) NOT NULL,
    `make` VARCHAR(25),
    `model` VARCHAR(25),
    `car_year` INT,
    `category_id` INT,
    `doors` INT,
    `picture` BLOB,
    `car_condition` VARCHAR(25),
    `available` BOOLEAN
);
INSERT INTO `cars` (`plate_number`)
VALUES 
('Test1'),
('Test2'),
('Test5');

CREATE TABLE `employees` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30),
    `last_name` VARCHAR(30),
    `title` VARCHAR(30),
    `notes` TEXT
);
INSERT INTO `employees` (`first_name`,`last_name`)
VALUES 
('Test1','Test1'),
('Test2','Test2'),
('Test3','Test3');

CREATE TABLE `customers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(30) NOT NULL,
    `full_name` VARCHAR(30) ,
    `address` VARCHAR(30) ,
    `city` VARCHAR(10) ,
    `zip_code` VARCHAR(10),
    `notes` TEXT
);
INSERT INTO `customers`(`driver_licence_number`)
VALUES 
('Test1'),
('Test2'),
('Test5');

CREATE TABLE `rental_orders` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT,
    `customer_id` INT,
    `car_id` INT,
    `car_condition` VARCHAR(20),
    `tank_level` VARCHAR(20),
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATE,
    `end_date` DATE,
    `total_days` INT,
    `rate_applied` DOUBLE,
    `tax_rate` DOUBLE,
    `order_status` VARCHAR(20),
    `notes` TEXT
);
INSERT INTO `rental_orders`(`employee_id`,`customer_id`)
VALUES 
('1','4'),
('2','5'),
('3','6');

---------------------------------------------------------------
Problem 13
INSERT INTO `towns`(`name`)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments`(`name`)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO `employees`(`first_name`,`middle_name`,`last_name`,`job_title`,`department_id`,`hire_date`,`salary`)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

---------------------------------------------------------------
Problem 14
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

---------------------------------------------------------------
Problem 15
SELECT * FROM `towns`
ORDER BY `name`;
SELECT * FROM `departments`
ORDER BY `name`;
SELECT * FROM `employees`
ORDER BY `salary` DESC;

---------------------------------------------------------------
Problem 16
SELECT `name` FROM `towns`
ORDER BY `name`;
SELECT `name` FROM `departments`
ORDER BY `name`;
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

---------------------------------------------------------------
Problem 17
UPDATE `employees`
SET `salary` = `salary` * 1.1;
SELECT `salary` FROM `employees`;

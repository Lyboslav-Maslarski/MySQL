Problem 1 
CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL
);
CREATE TABLE `categories`(
`id` INT primary key auto_increment,
`name` VARCHAR(50) not null
);
CREATE TABLE `products`(
`id` INT primary key auto_increment,
`name` VARCHAR(50) not null,
`category_id` INT not null
);

---------------------------------------------------------------
Problem 2
insert into `employees` (`first_name`,`last_name`) 
VALUES 
('Test','Test'),
('Test1','Test1'),
('Test2','Test2');

---------------------------------------------------------------
Problem 3
alter table `employees` 
add column `middle_name` varchar(50) not null;

---------------------------------------------------------------
Problem 4
alter table `products`
add constraint fk_products_categories
foreign key `products` (`category_id`)
references `categories`(`id`);

---------------------------------------------------------------
Problem 5
alter table `employees`
change column `middle_name` `middle_name` varchar(100);


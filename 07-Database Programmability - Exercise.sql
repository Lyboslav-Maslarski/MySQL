Problem 1 
CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN 
	SELECT `first_name`, `last_name`
    FROM `employees` 
    WHERE `salary` > 35000 
    ORDER BY `first_name`, `last_name`, `employee_id`;
END

---------------------------------------------------------------
Problem 2
CREATE PROCEDURE usp_get_employees_salary_above (filter_salary DECIMAL(10,4)) 
BEGIN 
	SELECT `first_name`, `last_name` 
    FROM `employees` 
    WHERE `salary` >= filter_salary 
    ORDER BY `first_name`, `last_name`, `employee_id`;
END

---------------------------------------------------------------
Problem 3
CREATE PROCEDURE usp_get_towns_starting_with (filter_str VARCHAR(10)) 
BEGIN 
	SELECT `name` 
    FROM `towns` 
    WHERE `name` LIKE concat(filter_str,'%')
    ORDER BY `name`;
END

---------------------------------------------------------------
Problem 4
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(10)) 
BEGIN 
	SELECT 
    `first_name`, `last_name`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
        JOIN
    `towns` AS t ON a.`town_id` = t.`town_id`
WHERE
    `name` = town_name
ORDER BY `first_name`, `last_name`, `employee_id`;
END

---------------------------------------------------------------
Problem 5
CREATE FUNCTION ufn_get_salary_level (employee_salary DECIMAL(10,2)) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN 
DECLARE `level` VARCHAR(10);
	IF employee_salary < 30000 THEN set `level` :='Low';
	ELSEIF employee_salary >= 30000 AND employee_salary <= 50000 THEN set `level` :='Average';
	ELSE set `level` :='High';
    END IF;
RETURN `level`;
END

---------------------------------------------------------------
Problem 6
CREATE PROCEDURE usp_get_employees_by_salary_level (level_of_salary  VARCHAR(10)) 
BEGIN 
	SELECT 
    `first_name`, `last_name`
FROM
    `employees` 
WHERE
   CASE
    WHEN level_of_salary = 'low' THEN salary < 30000
    WHEN level_of_salary = 'average' THEN salary BETWEEN 30000 AND 50000
	WHEN level_of_salary = 'high' THEN salary > 50000
    END
ORDER BY `first_name` DESC, `last_name` DESC, `employee_id`;
END

---------------------------------------------------------------
Problem 7
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))  
RETURNS BIT
DETERMINISTIC
RETURN word REGEXP(concat('^[',set_of_letters,']+$'));

---------------------------------------------------------------
Problem 8
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN 
	SELECT 
    concat_ws(' ', `first_name`, `last_name`) as 'full_name'
FROM
    account_holders 
ORDER BY `full_name`, `id`;
END

---------------------------------------------------------------
Problem 9
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(`number` DOUBLE(19,4))
BEGIN 
	SELECT 
	`first_name`, `last_name`
FROM
    `account_holders` as ah
	JOIN `accounts` as a on ah.`id` = a.`account_holder_id` 
GROUP BY ah.`id`
HAVING SUM(`balance`) > `number`
ORDER BY ah.`id`;
END

---------------------------------------------------------------
Problem 10
CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL(20,4), yearly_interest_rate DOUBLE, number_of_years INT) 
RETURNS DECIMAL(20,4)
DETERMINISTIC
BEGIN 
RETURN sum*pow(1 + yearly_interest_rate, number_of_years);
END

---------------------------------------------------------------
Problem 11
CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL(20,4), yearly_interest_rate DOUBLE, number_of_years INT) 
RETURNS DECIMAL(20,4)
DETERMINISTIC
BEGIN 
RETURN sum*pow(1 + yearly_interest_rate, number_of_years);
END;

CREATE PROCEDURE usp_calculate_future_value_for_account(`id` INT, interest_rate DOUBLE(19,4))
BEGIN 
	SELECT 
	`id` as 'account_id', `first_name`, `last_name`, `balance` as 'current_balance', 
    ufn_calculate_future_value(balance,interest_rate,5) as 'balance_in_5_years'
FROM
`accounts` AS a
	JOIN `account_holders` AS ah ON  a.`account_holder_id` = ah.`id`
    WHERE a.`id` = `id`;
END;

---------------------------------------------------------------
Problem 12
CREATE PROCEDURE usp_deposit_money(`account_id` INT, `money_amount` DOUBLE(19,4))
BEGIN 
IF (money_amount > 0) 
	THEN UPDATE `accounts` SET `balance` = `balance` + money_amount WHERE `id` = `account_id`;
ELSE ROLLBACK;
END IF;
END

---------------------------------------------------------------
Problem 13
CREATE PROCEDURE usp_withdraw_money(`account_id` INT, `money_amount` DOUBLE(19,4))
BEGIN 
	IF (money_amount > 0 AND (SELECT balance FROM accounts WHERE id = account_id) >= money_amount)
		THEN UPDATE `accounts` 
		SET `balance` = `balance` - money_amount
		WHERE `id` = `account_id`;
	ELSE ROLLBACK;
	END IF;
END

---------------------------------------------------------------
Problem 14
CREATE PROCEDURE usp_transfer_money(`from_account_id` INT,`to_account_id` INT, `money_amount` DOUBLE(19,4))
BEGIN 
START TRANSACTION;
	IF (from_account_id > 0 AND from_account_id <= (SELECT max(`id`) FROM `accounts`) 
    AND to_account_id > 0 AND to_account_id <= (SELECT max(`id`) FROM `accounts`)
    AND from_account_id != to_account_id 
    AND money_amount > 0 
    AND (SELECT `balance` FROM `accounts` WHERE `id` = from_account_id) >= money_amount)
		THEN 
        UPDATE `accounts` 
		SET `balance` = `balance` - money_amount
		WHERE `id` = from_account_id;
		UPDATE `accounts` 
		SET `balance` = `balance` + money_amount
		WHERE `id` = to_account_id;
	ELSE ROLLBACK;
	END IF;
END

---------------------------------------------------------------
Problem 15
CREATE TABLE IF NOT EXISTS `logs` (
  `log_id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
  `account_id` int(11) NOT NULL,
  `old_sum` decimal(19,4) DEFAULT '0.0000',
  `new_sum` decimal(19,4) DEFAULT '0.0000'
);

CREATE 
    TRIGGER  account_changes_log
 BEFORE UPDATE ON `accounts` FOR EACH ROW 
    INSERT INTO `logs` (account_id , old_sum , new_sum) VALUES (OLD.id , OLD.balance , NEW.balance);

---------------------------------------------------------------
Problem 16
CREATE TABLE IF NOT EXISTS `logs` (
  `log_id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
  `account_id` int(11) NOT NULL,
  `old_sum` decimal(19,4) DEFAULT '0.0000',
  `new_sum` decimal(19,4) DEFAULT '0.0000'
);

CREATE 
    TRIGGER  account_changes_log
 BEFORE UPDATE ON accounts FOR EACH ROW 
    INSERT INTO `logs` (account_id , old_sum , new_sum) VALUES (OLD.id , OLD.balance , NEW.balance);

CREATE TABLE IF NOT EXISTS `notification_emails` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
  `recipient` int(11) NOT NULL,
  `subject` VARCHAR(100),
  `body` TEXT
);

CREATE 
    TRIGGER  account_changes_log_emails
 AFTER INSERT ON `logs` FOR EACH ROW 
    INSERT INTO `notification_emails` (`recipient`, `subject`, `body`) 
    VALUES (NEW.account_id , concat('Balance change for account: ', NEW.account_id) ,
    concat('On ', NOW(),' your balance was changed from ', NEW.old_sum ,' to ', NEW.new_sum, '.'));



Problem 1 
SELECT 
    `title`
FROM
    `books`
WHERE
    SUBSTRING(`title`, 1, 3) = 'The'
ORDER BY `id`;

---------------------------------------------------------------
Problem 2
SELECT 
    REPLACE(`title`, 'The', '***') AS `title`
FROM
    `books`
WHERE
    SUBSTRING(`title`, 1, 3) = 'The'
ORDER BY `id`;

---------------------------------------------------------------
Problem 3
SELECT 
    ROUND(SUM(`cost`), 2)
FROM
    `books`;

---------------------------------------------------------------
Problem 4
SELECT 
    CONCAT_WS(' ', `first_name`, `last_name`) AS 'Full Name',
    TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days Lived'
FROM
    `authors`;

---------------------------------------------------------------
Problem 5
SELECT 
    `title`
FROM
    `books`
WHERE
    `title` LIKE 'Harry Potter%'
ORDER BY `id`;

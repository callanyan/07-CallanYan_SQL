use sakila;

#1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name
, last_name 
FROM `sakila`.`actor`;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT (UPPER(first_name)
, ' '
, UPPER(last_name)) 
AS "Actor Name" 
FROM `sakila`.`actor`;


#2.a You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?
SELECT `first_name`
, `last_name`
, `actor_id`
FROM `sakila`.`actor` 
WHERE `first_name` = "Joe";

#2b. Find all actors whose last name contain the letters GEN:
SELECT `first_name`
, `last_name`
, `actor_id`
FROM `sakila`.`actor` 
WHERE `last_name` LIKE "%GEN%";

#2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, 
#in that order:
SELECT `first_name`
, `last_name`
, `actor_id`
FROM `sakila`.`actor` 
WHERE `last_name` LIKE "%LI%"
ORDER BY `last_name` ASC, `first_name` ASC;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, 
#and China:
 SELECT country_id, country
 FROM sakila.country
 WHERE country IN
	(
	SELECT country
	FROM sakila.country
	WHERE country = 'Afghanistan' OR country = 'Bangladesh' OR country = 'China'
	);


#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
#so create a column in the table `actor` named `description` and use the data type `BLOB` (
#Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD COLUMN `description` BLOB;
SELECT * FROM actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN `description`;
SELECT * FROM actor;


#4a. List the last names of actors, as well as how many actors have that last name.
SELECT `actor`.`last_name`
, COUNT(`actor`.`last_name`) AS `number of actors`
FROM `sakila`.`actor`
GROUP BY `actor`.`last_name`;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared 
#by at least two actors
SELECT `actor`.`last_name`
, COUNT(`actor`.`last_name`) AS `number of actors`
FROM `sakila`.`actor`
GROUP BY `actor`.`last_name`
HAVING `number of actors` >  1;

#4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
#Write a query to fix the record.
SELECT * FROM actor
ORDER BY `first_name`; #check error

UPDATE `sakila`.`actor` 
SET `first_name` = 'HARPO' 
WHERE `first_name` = 'GROUCHO' AND `last_name` = 'WILLIAMS';

SELECT * FROM actor
ORDER BY `first_name`; # check error was corrected

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` 
#was the correct name after all! 
#In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE `sakila`.`actor` 
SET `first_name` = 'GROUCHO' 
WHERE `first_name` = 'HARPO';

SELECT * FROM actor
ORDER BY `first_name`; # check error was corrected


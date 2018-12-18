USE `sakila`;

#1a. Display the first and last names of all actors from the table `actor`.
SELECT `first_name`
, `last_name`
FROM `sakila`.`actor`;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(UPPER(`first_name`)
, " "
, UPPER(`last_name`)) 
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
 SELECT `country_id`, `country`
 FROM `sakila`.`country`
 WHERE `country` IN
	(
	SELECT `country`
	FROM `sakila`.`country`
	WHERE `country` = "Afghanistan" OR `country` = "Bangladesh" OR `country` = "China"
	);


#3a. You want to keep a description of each actor. You don"t think you will be performing queries on a description,
#so create a column in the table `actor` named `description` and use the data type `BLOB` (
#Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE `actor`
ADD COLUMN `description` BLOB;
SELECT * FROM `actor`;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE `actor`
DROP COLUMN `description`;
SELECT * FROM `actor`;


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
SELECT * FROM `actor`
ORDER BY `first_name`; #check error

UPDATE `sakila`.`actor` 
SET `first_name` = "HARPO" 
WHERE `first_name` = "GROUCHO" AND `last_name` = "WILLIAMS";

SELECT * FROM `actor`
ORDER BY `first_name`; # check error was corrected

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` 
#was the correct name after all! 
#In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE `sakila`.`actor` 
SET `first_name` = "GROUCHO" 
WHERE `first_name` = "HARPO";

SELECT * FROM `actor`
ORDER BY `first_name`; # check error was corrected


#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
#SHOW TABLES;
DESCRIBE `address`;


#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
#Use the tables `staff` and `address`:
SELECT `staff`.`first_name`, `staff`.`last_name`, `address`.`address`
FROM `sakila`.`staff`
LEFT JOIN `sakila`.`address`
ON `staff`.`staff_id` = `address`.`address_id`;

##6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
#Use tables `staff` and `payment`.
SELECT `staff`.`staff_id`, `staff`.`first_name`, `staff`.`last_name`, SUM(`payment`.`amount`) AS "Total Sales"#, `payment`.`payment_date` 
FROM `sakila`.`staff`
LEFT JOIN `sakila`.`payment`
ON `staff`.`staff_id` = `payment`.`staff_id`
WHERE `payment`.`payment_date` LIKE "2005-08%"
GROUP BY `payment`.`staff_id`;

#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT `film`.`title`, COUNT(`film_actor`.`actor_id`) AS "Total Actors" 
FROM `sakila`.`film_actor`
LEFT JOIN `sakila`.`film`
ON `film`.`film_id` = `film_actor`.`film_id`
GROUP BY `film`.`title`;

#6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT `film`.`title`, COUNT(`inventory`.`film_id`) AS "Total Copies" 
FROM `sakila`.`inventory`
LEFT JOIN `sakila`.`film`
ON `film`.`film_id` = `inventory`.`film_id`
WHERE `film`.`title` = "Hunchback Impossible"
GROUP BY `film`.`title`;

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
#List the customers alphabetically by last name:
SELECT `customer`.`customer_id`, `customer`.`first_name`, `customer`.`last_name`,  SUM(`payment`.`amount`) AS "Total Paid" 
FROM `sakila`.`payment`
LEFT JOIN `sakila`.`customer`
ON `payment`.`customer_id` = `customer`.`customer_id`
GROUP BY `customer`.`customer_id`;


#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters `K` and `Q` have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT `film`.`title`
FROM `sakila`.`film`
WHERE `film`.`language_id` IN
(
	SELECT `language`.`language_id`
	FROM `sakila`.`language`
	WHERE `language`.`name` = "english"
    )
    HAVING  `film`.`title` LIKE "Q%"  OR  `film`.`title` LIKE "K%";

#7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
#actor: actor name - actor id
#film actor: actor id - film id
#film: film_id - film name
SELECT `actor`.`first_name`, `actor`.`last_name`
FROM `sakila`.`actor`
WHERE `actor`.`actor_id` IN
	(
	SELECT `film_actor`.`actor_id`
	FROM `sakila`.`film_actor`
	WHERE `film_actor`.`film_id` IN
	(
		SELECT `film`.`film_id`
		FROM `sakila`.`film`
		WHERE `film`.`title` = "Alone Trip"
		));

#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT `customer`.`customer_id`, `customer`.`email` #, `address`.`address_id`, `city`.`city_id`, `country`.`country_id`
FROM `sakila`.`customer`
LEFT JOIN `sakila`.`address`
ON `customer`.`address_id` = `address`.`address_id`
LEFT JOIN `sakila`.`city`
ON `sakila`.`address`.`city_id` = `city`.`city_id`
LEFT JOIN `sakila`.`country`
ON `city`.`country_id` = `country`.`country_id`
WHERE `country`.`country` = "canada";

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
#Identify all movies categorized as _family_ films.
SELECT `film`.`title`, `film`.`rating`
FROM `sakila`.`film` 
WHERE `film`.`rating` = "G";

#7e. Display the most frequently rented movies in descending order.
#film: film title - film id
#invintory: film id - invintory id
#rental: invintory id - rental id
SELECT `film`.`title`, COUNT(`rental`.`rental_id`)
FROM`sakila`.`film`
LEFT JOIN `sakila`.`inventory`
ON `inventory`.`film_id` = `film`.`film_id`
LEFT JOIN `sakila`.`rental`
ON `rental`.`inventory_id` = `inventory`.`inventory_id`
GROUP BY `film`.`title`;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT `store`.`store_id`, SUM(`payment`.`amount`)
FROM `sakila`.`store`
LEFT JOIN `sakila`.`staff`
ON `staff`.`store_id` = `store`.`store_id`
LEFT JOIN `sakila`.`payment`
ON `staff`.`staff_id` = `payment`.`staff_id` 
GROUP BY `store`.`store_id`;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT `store`.`store_id`, `city`.`city`, `country`.`country`
FROM `sakila`.`store`
LEFT JOIN `sakila`.`address`
ON `address`.`address_id` = `store`.`address_id`
LEFT JOIN `sakila`.`city`
ON `city`.`city_id` = `address`.`city_id`
LEFT JOIN `sakila`.`country`
ON `country`.`country_id` = `city`.`country_id`;

#7h. List the top five genres in gross revenue in descending order. 
#(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT `category`.`name`, SUM(`payment`.`amount`) AS `gross revenue`
FROM `sakila`.`category`
LEFT JOIN `sakila`.`film_category` 
ON `film_category`.`category_id` = `category`.`category_id` 
LEFT JOIN `sakila`.`inventory`
ON `inventory`.`film_id` = `film_category`.`film_id`
LEFT JOIN `sakila`.`rental`
ON `rental`.`inventory_id` = `inventory`.`inventory_id`
LEFT JOIN `sakila`.`payment`
ON `payment`.`rental_id` = `rental`.`rental_id` 
GROUP BY `category`.`name`
ORDER BY `gross revenue` DESC
LIMIT 5;


#8a. In your new role as an executive, you would like to have an easy way of viewing the 
#Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven"t solved 7h, you can substitute another query to create a view.
CREATE VIEW `sakila`.`rentalRevenue_topFiveGenres`
AS
SELECT `category`.`name`, SUM(`payment`.`amount`) AS `gross revenue`
FROM `sakila`.`category`
LEFT JOIN `sakila`.`film_category` 
ON `film_category`.`category_id` = `category`.`category_id` 
LEFT JOIN `sakila`.`inventory`
ON `inventory`.`film_id` = `film_category`.`film_id`
LEFT JOIN `sakila`.`rental`
ON `rental`.`inventory_id` = `inventory`.`inventory_id`
LEFT JOIN `sakila`.`payment`
ON `payment`.`rental_id` = `rental`.`rental_id` 
GROUP BY `category`.`name`
ORDER BY `gross revenue` DESC
LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM `sakila`.`rentalRevenue_topFiveGenres`;

#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW `sakila`.`rentalRevenue_topFiveGenres`;



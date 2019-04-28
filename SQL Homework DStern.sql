-- Devin Stern SQL Homework Data Visualization Cohort 3

-- 1A) Display the first and last name of each actor from the actor table--

USE sakila;

SELECT * FROM actor;

SELECT first_name, last_name
FROM actor;

-- 1B) Combine first and last name into one column called "Actor Name" --

SELECT CONCAT(actor.first_name, " " , actor.last_name) 
AS "Actor Name"
FROM actor;

-- 2A) Find the ID #, First Name, and Last Name of an actor, but we only know the first name: Joe

SELECT * from actor
WHERE first_name = "Joe";

-- 2B) Find all actors whose last names contain the letters "GEN"

SELECT * from actor
WHERE last_name
LIKE '%GEN%';

-- 2C)Find all actors with the last names that contain LI. 
-- Order the rows by last name and first name in that order

SELECT * from actor
WHERE last_name
LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2D) Using IN, display the country_id and 
-- country coulumns of Afghanistan, Bangladesh, and China

SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3A) Create a column in the table actor named description and use 
-- the data type BLOB

ALTER TABLE actor
ADD actor_description BLOB;

-- 3B) Drop the description column

ALTER TABLE actor
DROP COLUMN actor_description;

-- 4A) List the names of actors, as well as how many actors have that last name

SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name;

-- 4B) list names of actors, and # of actors who have that last name, but only 
-- if 2 or more actors share a name

SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1;

-- 4C) Fix Harpo William's name from Groucho Williams to Harpo Williams

 SELECT * from actor
WHERE first_name
LIKE '%Groucho%';

UPDATE actor
SET first_name = 'Harpo'
WHERE actor_id = 172;

-- 4D) Change Harpo Williams' name back to Groucho using a single line query
UPDATE actor
SET first_name = 'Groucho'
WHERE actor_id = 172;

-- 5A) Re-create schema of address table
SHOW CREATE TABLE address;

-- 6A) Display first and last names of each staff member (tables staff and address)

SELECT staff.first_name, staff.last_name
FROM staff
JOIN address
ON staff.address_id = address.address_id;

-- 6B) Display total amount rung up by staff member (tables staff and payment)

SELECT SUM(amount), first_name, last_name
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id;

-- 6C) List each film and the number of actors who are listed for each film. 
-- Inner Join. Tables Film Actor and Film

SELECT COUNT(actor_id), title
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6D) # of copies of "Hunchback Impossible" in inventory

SELECT COUNT(title), title
FROM inventory
INNER JOIN film
ON inventory.film_id = film.film_id
WHERE title = "Hunchback Impossible";

-- 6E) List total paid by each customer. Tables: payment and customer. Use Join.

SELECT SUM(amount), first_name, last_name
FROM payment
JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY first_name, last_name
ORDER BY last_name ASC;

-- 7A) Display the titles of movies starting with K and Q and whose language is English

SELECT * 
FROM film
WHERE language_id = 1
AND title LIKE 'Q%' OR title LIKE 'K%';

-- 7B) Display all actors that appear in the film "alone trip"
SELECT * from film
WHERE title = "alone trip";

SELECT * from film_actor
WHERE film_id = 17;

-- 7C) Retrieve names and email addresses of all Canadian customers

SELECT * 
FROM city
JOIN address ON city.city_id = address.city_id
WHERE country_id = "20";

SELECT first_name, last_name, email
FROM customer
JOIN address ON address.address_id = customer.address_id
WHERE city_id IN ("179", "196", "300", "383", "430", "565");

-- 7D) ID all films categorized as 'family' films
-- Film category for 'family' is 8.

SELECT * 
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
WHERE category_id = "8";

-- 7E) Display the most frequently rented movies in descending order

SELECT COUNT(inventory_id), inventory_id
FROM rental
GROUP BY inventory_id 
ORDER BY COUNT(inventory_id) DESC;

-- 7F How much business did each store bring in, in dollars?

SELECT SUM(amount), store_id
FROM payment
JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY store_id;

-- 7G For each store, display store ID, city, and country
-- Store ID 1: Lethbridge Canada
-- Store ID 2: Woodridge Australia
SELECT store_id, city_id
FROM store
JOIN address
ON store.address_id = address.address_id;

SELECT * 
FROM city
JOIN country
ON city.country_id = country.country_id
WHERE city_id IN ("300", "576");

-- 7H) Top 5 genres in gross revenue descending order

SELECT name, SUM(amount)
FROM film_category
JOIN category
ON film_category.category_id = category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8A) Create a view for the top 5 genres. 

CREATE VIEW Top_5_genres AS(
SELECT name, SUM(amount)
FROM film_category
JOIN category
ON film_category.category_id = category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5
);

-- 8B) How would I dispay the view I created above?
SELECT * FROM Top_5_genres;

-- 8C) Delete the view 'Top_5_genres'

DROP VIEW Top_5_genres;
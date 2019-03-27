USE sakila;
SHOW TABLES;
-- 1a
SELECT first_name,last_name FROM actor;

-- 1b
ALTER TABLE actor 
ADD COLUMN `Actor Name` VARCHAR(90);
SELECT CONCAT(first_name, ' ', last_name) from actor;
SET sql_mode='';
UPDATE actor
SET `Actor Name` = CONCAT(first_name, ' ', last_name);
SELECT * FROM actor;

-- 2a 
SELECT actor_id, first_name, last_name FROM actor WHERE first_name='joe';

-- 2b
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

-- 2c
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name,first_name;

-- 2d
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE Actor ADD description BLOB;
SELECT * FROM Actor LIMIT 1;

-- 3b 
ALTER TABLE Actor DROP description;
SELECT * FROM Actor LIMIT 1;

-- 4a
SELECT last_name, count(*) FROM actor GROUP BY last_name;

-- 4b
SELECT last_name, count(*) FROM actor GROUP BY last_name HAVING count(*) >=2;

-- 4c
UPDATE actor 
SET first_name='Harpo', last_name='Williams', `Actor Name` = 'Harpo Williams' WHERE `Actor Name` = 'Groucho Williams';
SELECT * FROM Actor WHERE last_name="Williams";

-- 4d 
UPDATE actor
SET first_name = 'Groucho', last_name='Williams', `Actor Name` = 'Groucho Williams' WHERE `Actor Name` = 'Harpo Williams';
SELECT * FROM Actor WHERE last_name="Williams";

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT s.first_name, s.last_name, a.address FROM
staff s INNER JOIN address a ON a.address_id = s.address_id;

-- 6b 
SELECT s.first_name, s.last_name, sum(p.amount) as Total FROM 
staff s INNER JOIN payment p ON s.staff_id = p.staff_id WHERE p.payment_date LIKE '2005-08%' GROUP BY p.staff_id;

-- 6c
SELECT f.title, count(fa.actor_id) FROM film as f INNER JOIN film_actor as fa ON f.film_id=fa.film_id GROUP BY f.title;

-- 6d
SELECT f.title, count(f.film_id) FROM
inventory i INNER JOIN film f ON i.film_id = f.film_id WHERE f.title="Hunchback Impossible";

-- 6e 
SELECT c.first_name, c.last_name, sum(p.amount) as `Total` FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.last_name, c.first_name ORDER BY c.last_name;

-- 7a
SELECT title from film WHERE language_id IN (SELECT language_id FROM language WHERE name='English') AND title LIKE 'K%' OR title LIKE 'Q%';

-- 7b 
SELECT first_name, last_name FROM actor WHERE actor_id IN (
	SELECT actor_id FROM film_actor WHERE film_id IN (
		SELECT film_id FROM film WHERE title = 'Alone Trip'
	)
);

-- 7c    
SELECT first_name, last_name, email FROM customer c 
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id WHERE country = 'Canada';

-- 7d 
SELECT title from film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'family';

-- 7e 
SELECT title, f.film_id, count(f.film_id) as times_rented FROM inventory i
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY film_id
ORDER BY times_rented DESC;

-- 7f 
SELECT s.store_id, sum(amount) as Total FROM payment p 
JOIN customer c ON p.customer_id = c.customer_id
JOIN store s ON c.store_id = s.store_id
GROUP BY s.store_id;

-- 7g 
SELECT store_id, s.address_id, c.city, co.country FROM store s 
JOIN address a ON a.address_id = s.address_id
JOIN city c ON c.city_id = a.city_id
JOIN country co ON c.country_id = co.country_id;

-- 7h
SELECT c.name as Category, sum(p.amount) as Total FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.category_id
ORDER BY Total DESC LIMIT 5;

-- 8a 
CREATE VIEW View1 AS 
SELECT c.name as Category, sum(p.amount) as Total FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.category_id
ORDER BY Total DESC LIMIT 5;

-- 8b
SELECT * FROM View1;

-- 8c 
DROP VIEW View1;

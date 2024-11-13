-- 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT i.film_id, COUNT(i.inventory_id) as number_of_copies FROM inventory as i
group by i.film_id;

SELECT f.film_id from film as f
Where f.title = "Hunchback Impossible";

SELECT COUNT(i.inventory_id) as number_of_copies FROM inventory as i
WHERE i.film_id = (SELECT f.film_id from film as f
Where f.title = "Hunchback Impossible"
);

-- 2 List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT avg(length) from film;

SELECT title from film
WHERE length > (SELECT avg(length) from film);

-- 3 Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT film_id from film
where title = 'Alone Trip';

SELECT actor_id from film_actor
Where film_id = (SELECT film_id from film
where title = 'Alone Trip');

SELECT first_name, last_name from actor
Where actor_id in (SELECT actor_id from film_actor
Where film_id = (SELECT film_id from film
where title = 'Alone Trip'));

-- Bonus
-- 4 Sales have been lagging among young families, and you want to target family movies for a promotion.
-- Identify all movies categorized as family films.
Select category_id from category where name = 'Family';

Select film_id from film_category WHERE category_id =
(Select category_id from category where name = 'Family');

Select title from film where film_id in 
(Select film_id from film_category WHERE category_id =
(Select category_id from category where name = 'Family'));

-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins.
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT country_id from sakila.country
Where country = 'Canada';

Select city_id from sakila.city
WHERE country_id = (
SELECT country_id from sakila.country
Where country = 'Canada');

SELECT address_id from sakila.address
WHERE address_id in (Select city_id from sakila.city
WHERE country_id = (
SELECT country_id from sakila.country
Where country = 'Canada'));

SELECT first_name, last_name, email FROM customer
WHERE address_id in (
SELECT address_id from sakila.address
WHERE city_id in (Select city_id from sakila.city
WHERE country_id = (
SELECT country_id from sakila.country
Where country = 'Canada')));

SELECT cu.first_name, cu.last_name, cu.email FROM customer as cu
JOIN address as a ON cu.address_id = a.address_id
JOIN city as ci ON ci.city_id = a.city_id
JOIN country as co ON co.country_id = ci.country_id
WHERE co.country = "Canada"
;

-- 6 Determine which films were starred by the most prolific actor in the Sakila database.
-- A prolific actor is defined as the actor who has acted in the most number of films.
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT actor_id, count(actor_id) FROM film_actor
GROUP By actor_id
ORDER BY count(actor_id) DESC
LIMIT 1;

SELECT actor_id from (SELECT actor_id, count(actor_id) FROM film_actor
GROUP By actor_id
ORDER BY count(actor_id) DESC
LIMIT 1) as a;

SELECT film_id from film_actor where actor_id in (SELECT actor_id from (SELECT actor_id, count(actor_id) FROM film_actor
GROUP By actor_id
ORDER BY count(actor_id) DESC
LIMIT 1) as a);

SELECT title from film where film_id in (
SELECT film_id from film_actor where actor_id in (
SELECT actor_id from (SELECT actor_id, count(actor_id) FROM film_actor
GROUP By actor_id
ORDER BY count(actor_id) DESC
LIMIT 1) as a));

-- 7 Find the films rented by the most profitable customer in the Sakila database.
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT customer_id from (
select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) DESC
Limit 1) as c;

SELECT inventory_id from rental
where customer_id = (
SELECT customer_id from (
select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) DESC
Limit 1) as c);

SELECT film_id from inventory
where inventory_id in (
SELECT inventory_id from rental
where customer_id = (
SELECT customer_id from (
select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) DESC
Limit 1) as c));

SELECT title from film
where film_id in (
SELECT film_id from inventory
where inventory_id in (
SELECT inventory_id from rental
where customer_id = (
SELECT customer_id from (
select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) DESC
Limit 1) as c)));

-- 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average 
-- of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT customer_id, sum(amount) as total_amount_spent FROM payment
group by customer_id; 

SELECT avg(total_amount_spent)
FROM (SELECT customer_id, sum(amount) as total_amount_spent FROM payment
group by customer_id) as p;

SELECT customer_id, sum(amount) as total_amount_spent FROM payment
group by customer_id
HAVING sum(amount) > (SELECT avg(total_amount_spent)
FROM (SELECT customer_id, sum(amount) as total_amount_spent FROM payment
group by customer_id) as p)
;
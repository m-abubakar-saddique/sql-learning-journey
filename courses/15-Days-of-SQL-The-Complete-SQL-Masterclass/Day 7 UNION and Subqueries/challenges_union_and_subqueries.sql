-- Show only those movie titles, their associated
-- film_id and replacement_cost with the lowest replacement_costs 
-- for in each rating category also show the
-- rating.
SELECT title, film_id, replacement_cost, rating
FROM film f1
WHERE replacement_cost = (SELECT MIN(replacement_cost) FROM film f2
						  WHERE f1.rating = f2.rating)


-- Show only those movie titles, their associated film_id 
-- and the length that have the highest length in each 
-- rating category also show the rating.


SELECT title, film_id, length, rating
FROM film f1
WHERE replacement_cost = (SELECT MAX(length) FROM film f2
						  WHERE f1.rating = f2.rating)
	
	
-- Show all the payments together with how much 
-- the payment amount is below the maximum payment amount.						  
SELECT *,(SELECT MAX(amount) 
		  FROM payment)- amount AS difference
FROM payment


-- Select all the films where length is longer than the average of all films.
SELECT *
FROM film
WHERE length > (SELECT AVG(length) FROM film)


-- Return all the films that are available in the inventory in store 2 more than 3 times.
SELECT * FROM film
WHERE film_id IN
(SELECT film_id FROM inventory
WHERE store_id = 2
GROUP BY film_id
HAVING COUNT(*) > 3)


-- What is the average total amount spent per day (average daily revenue)

SELECT
AVG(amount_per_day)
FROM
(SELECT
SUM(amount) AS amount_per_day,
DATE(payment_date)
FROM payment
GROUP BY DATE(payment_date))


-- Show all the payments plus the total amount for every customer as well as the
-- number of payments of each customer.
SELECT 
payment_id,
customer_id,
staff_id, amount,
(SELECT SUM(amount) AS sum_amount
FROM payment p2
WHERE p1.customer_id = p2.customer_id),
(SELECT COUNT(amount) AS count_payments
FROM payment p2
WHERE p1.customer_id = p2.customer_id)
FROM payment p1
ORDER BY customer_id, amount DESC


-- Show only those films with the highest replacement costs in their rating
-- category plus show the average replacement cost in their rating category.
SELECT title, replacement_cost, rating,
(SELECT AVG(replacement_cost) FROM film f2
	WHERE f1.rating = f2.rating)
FROM film f1
WHERE replacement_cost = 
(SELECT MAX(replacement_cost) FROM film f3
WHERE f1.rating = f3.rating)	
							

-- Show only those payments with the highest payment for each customer's first
-- name including the payment_id of that payment.
-- How would you solve it if you would not need to see the payment_id?
SELECT first_name, amount, payment_id
FROM payment p1
INNER JOIN customer category
ON p1.customer_id = c.customer_id
WHERE amount = 
(SELECT MAX(amount) FROM payment p2
WHERE p1.customer_id = p2.customer_id)


-- Return all customers' first names and last names that have made
-- a payment on '2020-01-25'
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id
					  FROM payment
					  WHERE DATE(payment_date) = '2020-01-25')



-- Return all customers' first_names and email addresses that have spent
-- a more than $30
SELECT first_name, email
FROM customer
WHERE customer_id IN (SELECT customer_id
					  FROM payment
					  GROUP BY customer_id
					  HAVING SUM(amount) > 30)


-- Return all the customers' first and last names that are from California
-- and have spent more than 100 in total
SELECT first_name, email
FROM customer
WHERE customer_id IN (SELECT customer_id
					  FROM payment
					  GROUP BY customer_id
					  HAVING SUM(amount) > 100)
AND customer_id IN (SELECT customer_id
					FROM customer
					INNER JOIN address
					ON address.address_id = customer.address_id
					WHERE district = 'California'
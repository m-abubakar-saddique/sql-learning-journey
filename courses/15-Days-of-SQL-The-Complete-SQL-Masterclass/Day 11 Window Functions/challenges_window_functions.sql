-- Write a query that returns the list of movies including
-- - film_id,
-- - title,
-- - length,
-- - category,
-- - average length of movies in that category.
-- Order the results by film_id.
SELECT f.film_id, f.title, f.length, c.name category,
ROUND(AVG(f.length) OVER (PARTITION BY c.name), 2) avg_length_in_category
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
ORDER BY 1


-- Write a query that returns all payment details including
-- - the number of payments that were made by this customer 
-- and that amount
-- Order the results by payment_id.
SELECT *,
COUNT(*) OVER (PARTITION BY customer_id, amount) 
FROM payment
ORDER BY payment_id


-- Write a query that returns the running total of how late the flights are 
-- (difference between actual_arrival and scheduled arrival) ordered by flight_id 
-- including the departure airport.
-- As a second query, calculate the same running total but partition also by the 
-- departure airport.
SELECT
flight_id,
departure_airport,
SUM(actual_arrival - scheduled_arrival) 
	OVER (PARTITION BY departure_airport ORDER BY flight_id)
FROM flights


-- Write a query that returns the customers' name, the country and how many 
-- payments they have. For that use the existing view customer_list.
SELECT *
FROM
	(SELECT name, 
	country,
	COUNT(*),
	RANK() OVER (PARTITION BY country ORDER BY COUNT(*))
	FROM customer_list 
	INNER JOIN payment 
	ON id = customer_id
	GROUP BY name, country) a
WHERE rank in (1, 2, 3)


-- Write a query that returns the revenue of the day and the revenue of the 
-- previous day. 
SELECT date(payment_date), SUM(amount),
LAG(SUM(amount)) OVER (ORDER BY date(payment_date))as previous_day,
SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY date(payment_date)) as difference,
ROUND((SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY date(payment_date)))/ 
LAG(SUM(amount)) OVER (ORDER BY date(payment_date)) * 100, 2) as percent_growth
FROM payment
GROUP BY date(payment_date)
ORDER BY 1
-- The airline company wants to understand in which category they sell most
-- tickets.
-- How many people choose seats in the category
-- - Business
-- - Economy or
-- - Comfort?
-- You need to work on the seats table and the boarding_passes table.

SELECT 
fare_conditions AS seat_category,
COUNT(*) AS  total_seats
FROM boarding_passes AS  BP
INNER JOIN seats AS S
ON BP.seat_no = S.seat_no
GROUP BY fare_conditions


-- Find the tickets that don't have a boarding pass related to it!
SELECT * FROM boarding_passes b
FULL OUTER JOIN tickets t
ON b.ticket_no = t.ticket_no
WHERE b.ticket_no IS NULL
ORDER BY passenger_name


-- Find all aircrafts that have not been used in any flight!
SELECT * FROM aircrafts_data a
LEFT JOIN flights f
ON a.aircraft_code = f.aircraft_code
WHERE f.flight_id IS NULL


-- The flight company is trying to find out what their most popular
-- seats are.
-- Try to find out which seat has been chosen most frequently.
-- Make sure all seats are included even if they have never been
-- booked.
-- Are there seats that have never been booked?

Select s.seat_no, COUNT(*)
from seats s
LEFT JOIN boarding_passes bp
ON s.seat_no = bp.seat_no
GROUP BY s.seat_no
ORDER BY COUNT(*) DESC


-- Try to find out which line (A, B, …, H) has been chosen most
-- frequently.
Select RIGHT(s.seat_no, 1), COUNT(*)
from seats s
LEFT JOIN boarding_passes bp
ON s.seat_no = bp.seat_no
GROUP BY RIGHT(s.seat_no, 1)
ORDER BY COUNT(*) DESC


-- The company wants to run a phone call campaing on all customers in
-- Texas (=district).
-- What are the customers (first_name, last_name, phone number and their
-- district) from Texas?
-- Are there any (old) addresses that are not related to any customer?

SELECT first_name, last_name, phone, district
FROM address a
INNER JOIN customer c
ON a.address_id = c.address_id
WHERE a.district = 'Texas'


SELECT a.address_id, address
FROM address a
LEFT JOIN customer c
ON a.address_id = c.address_id
WHERE customer_id  IS NULL
ORDER BY a.address_id


-- Get the average price (amount) for the different seat_no!
SELECT seat_no, ROUND(AVG(amount), 2)
FROM boarding_passes b
INNER JOIN ticket_flights t
ON b.ticket_no = t.ticket_no AND b.flight_id = t.flight_id
GROUP BY seat_no
ORDER BY 2 DESC


SELECT t.ticket_no, passenger_name, scheduled_departure
FROM tickets t
INNER JOIN ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN flights f
ON f.flight_id = tf.flight_id


-- The company wants customize their campaigns to customers depending on
-- the country they are from.
-- Which customers are from Brazil?
-- Write a query to get first_name, last_name, email and the country from all
-- customers from Brazil.

SELECT c.first_name, c.last_name, c.email, co.country
FROM customer c
INNER JOIN address ad
ON ad.address_id = c.address_id
INNER JOIN city ci
ON ci.city_id = ad.city_id
INNER JOIN country co
ON co.country_id = ci.country_id
WHERE country = 'Brazil'


-- Which passenger (passenger_name) has spent most amount in their bookings (total_amount)?
SELECT SUM(total_amount) AS total_amount, passenger_name
FROM tickets t
INNER JOIN bookings b
ON t.book_ref = b.book_ref
GROUP BY passenger_name
ORDER BY SUM(total_amount) DESC LIMIT 1


-- Which fare_condition has ALEKSANDR IVANOV used the most?
SELECT passenger_name, fare_conditions, COUNT(*)
FROM tickets t
INNER JOIN ticket_flights tf
ON t.ticket_no = tf.ticket_no
AND t.passenger_name = 'ALEKSANDR IVANOV'
GROUP BY fare_conditions, passenger_name
ORDER BY COUNT(*) DESC LIMIT 1


-- Which title has GEORGE LINTON rented the most often?
SELECT title, first_name, last_name, COUNT(*)
FROM rental r
INNER JOIN customer c
ON r.customer_id = c.customer_id
INNER JOIN inventory i
ON i.inventory_id = r.inventory_id
INNER JOIN film f
ON f.film_id = i.film_id
WHERE c.first_name = 'GEORGE' AND c.last_name = 'LINTON'
GROUP BY title, first_name, last_name
ORDER BY COUNT(*) DESC LIMIT 1


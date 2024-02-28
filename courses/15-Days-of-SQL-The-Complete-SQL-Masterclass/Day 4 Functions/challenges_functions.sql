-- In the email system there was a problem with names where
-- either the first name or the last name is more than 10 characters
-- long.
-- Find these customers and output the list of these first and last
-- names in all lower case.
Select lower(first_name), 
lower(last_name), lower(email) 
from public.customer
WHERE LENGTH(first_name) > 10 OR LENGTH(last_name) > 10


-- Extract the last 5 characters of the email address first.
-- The email address always ends with '.org'.
-- How can you extract just the dot '.' from the email address? 

Select 
right(email, 5), 
left(right(email, 4), 1)
from public.customer


-- You need to create an anonymized form of the email addresses
Select 
LEFT(email, 1) ||  '***' || RIGHT (email, 19) AS anonymized_email
from public.customer


-- In this challenge you only have the email address and 
-- the last name of the customers
-- You need to extract the first name from email address and concatenate
-- it with the last name. It should be in the form:
-- "Last Name, First name".

SELECT last_name || ', ' || LEFT(email, POSITION(last_name IN email)-2)
from public.customer

-- OR

SELECT last_name || ', ' || LEFT(email, POSITION('.' IN email)-1)
from public.customer


-- You need to create an anonymized form of the email addresses
-- in the following way:
-- In a second query create an anonymized form of the email
-- addresses in the following way: 

SELECT 
LEFT(email, 1) || 
'***' || 
SUBSTRING(email from POSITION('.' in email) for 2) || 
'***' 
|| SUBSTRING(email from POSITION('@' in email))
from public.customer

SELECT 
'***' ||
SUBSTRING(email from POSITION('.' in email)-1 for 3) || 
'***' 
|| SUBSTRING(email from POSITION('@' in email))
from public.customer


-- You need to analyze the payments and find out the following:
-- What's the month with the highest total payment amount?
-- What's the day of week with the highest total payment amount?
-- (0 is Sunday)
-- What's the highest amount one customer has spent in a week?

SELECT
EXTRACT(month from payment_date) AS Month,
SUM(amount) AS total_payment_amount
FROM public.payment
GROUP BY EXTRACT(month from payment_date)
ORDER by SUM(amount) DESC
LIMIT 2

SELECT
EXTRACT(DOW from payment_date) AS Day_Of_Week,
SUM(amount) AS total_payment_amount
FROM public.payment
GROUP BY EXTRACT(DOW from payment_date)
ORDER by SUM(amount) DESC
LIMIT 2

SELECT
customer_id,
EXTRACT(WEEK from payment_date) AS Week,
SUM(amount) AS total_payment_amount
FROM public.payment
GROUP BY customer_id,
EXTRACT(WEEK from payment_date)
ORDER BY SUM(amount) DESC
LIMIT 2


-- You need to sum payments and group in the following formats:
SELECT 
SUM(amount) AS total_payment,
TO_CHAR (payment_date, 'Dy, DD/MM/YYYY') as day
FROM payment
GROUP BY day
ORDER BY total_payment DESC

SELECT 
SUM(amount) AS total_payment,
TO_CHAR (payment_date, 'Mon, YYYY') as mon_year
FROM payment
GROUP BY mon_year
ORDER BY total_payment DESC

SELECT 
SUM(amount) AS total_payment,
TO_CHAR (payment_date, 'Dy, HH:MI') as Day_time
FROM payment
GROUP BY Day_time
ORDER BY total_payment DESC


-- You need to create a list for the suppcity team of all rental
-- durations of customer with customer_id 35.
-- Also you need to find out for the suppcity team
-- which customer has the longest average rental duration?
SELECT
return_date-rental_date AS rental_duration,
customer_id
FROM public.rental
WHERE customer_id = 35

SELECT
AVG(return_date-rental_date) AS avg_rental_duration,
customer_id
FROM public.rental
GROUP BY customer_id
ORDER BY avg_rental_duration DESC


-- Your manager is thinking about increasing the prices for films
-- that are more expensive to replace.
-- For that reason, you should create a list of the films including the
-- relation of rental rate / replacement cost where the rental rate
-- is less than 4% of the replacement cost.
-- Create a list of that film_ids together with the percentage rounded
-- to 2 decimal places. For example 3.54 (=3.54%).

SELECT 
title,
ROUND(rental_rate / replacement_cost*100, 2) AS percentage
FROM public.film
WHERE ROUND(rental_rate / replacement_cost*100, 2) < 4
ORDER BY 2 DESC

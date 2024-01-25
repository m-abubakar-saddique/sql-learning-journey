-- You need to find out how many tickets you have sold in the
-- following categories:
-- • Low price ticket: total_amount < 20,000
-- • Mid price ticket: total_amount between 20,000 and 150,000
-- • High price ticket: total_amount >= 150,000
-- How many high price tickets has the company sold?
SELECT
count(*),
CASE
WHEN total_amount < 20000 THEN 'low price ticket'
WHEN total_amount < 150000 THEN 'mid price ticket'
ELSE 'high price ticket'
END as ticket_price
FROM bookings
GROUP BY ticket_price
order by count(*)


-- You need to find out how many flights have departed in the
-- following seasons:
-- • Winter: December, January, Februar
-- • Spring: March, April, May
-- • Summer: June, July, August
-- • Fall: September, October, November
SELECT 
COUNT(*) as flights,
CASE
WHEN EXTRACT(month from scheduled_departure) IN (12,1,2) THEN 'Winter'
WHEN EXTRACT (month from scheduled_departure) <= 5 THEN 'Spring'
WHEN EXTRACT (month from scheduled_departure) <= 8 THEN 'Summer'
ELSE 'Fall' 
END as season
FROM flights
GROUP BY season


-- You want to create a tier list in the following way:
-- 1. Rating is 'PG' or 'PG-13' or length is more then 210 min:
-- 'Great rating or long (tier 1)
-- 2. Description contains 'Drama' and length is more than 90min:
-- 'Long drama (tier 2)'
-- 3. Description contains 'Drama' and length is not more than 90min:
-- 'Shcity drama (tier 3)'
-- 4. Rental_rate less than $1:
-- 'Very cheap (tier 4)'
-- If one movie can be in multiple categories it gets the higher tier assigned.
-- How can you filter to only those movies that appear in one of these 4 tiers?
SELECT
title,
CASE
WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length>90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' THEN 'Short drama (tier 3)'
WHEN rental_rate<1 THEN 'Very cheap (tier 4)'
END as tier_list
FROM film
WHERE 
CASE
WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length>90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' THEN 'Short drama (tier 3)'
WHEN rental_rate<1 THEN 'Very cheap (tier 4)'
END is not null


-- pivot table
SELECT
SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS "G",
SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS "R",
SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS "NC-17",
SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS "PG-13",
SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS "PG"
FROM film

-- CAST, COALESCE & REPLACE
SELECT 
rental_date,
COALESCE (CAST(return_date AS VARCHAR), 'not returned')
FROM rental
ORDER BY rental_date DESC

SELECT flight_no,
CAST(REPLACE(flight_no, 'PG', '') AS INT)
FROM flights
/*

Your manager wants to get a better understanding of the
films.
That's why you are asked to write a query to see the
• Minimum
• Maximum
• Average (rounded)
• Sum
of the replacement cost of the films.
*/
SELECT
MIN(replacement_cost),
MAX(replacement_cost),
ROUND(AVG(replacement_cost),2) AS AVG,
SUM(replacement_cost)
FROM film

/*
Your manager wants to which of the two employees (staff_id)
is responsible for more payments?
Which of the two is responsible for a higher overall payment
amount?
*/
SELECT staff_id,
SUM(amount),
COUNT(staff_id)
FROM payment
GROUP BY staff_id
ORDER BY 2 ASC
LIMIT 2;
/*
How do these amounts change if we don't consider amounts
equal to 0?
*/
SELECT staff_id,
SUM(amount),
COUNT(staff_id)
FROM payment
WHERE amount > 0
GROUP BY staff_id
LIMIT 2;
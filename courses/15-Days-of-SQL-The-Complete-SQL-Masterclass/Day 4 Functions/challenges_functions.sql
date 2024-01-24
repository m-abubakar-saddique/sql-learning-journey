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
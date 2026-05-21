-- GROUP BY in SQL
DROP TABLE IF EXISTS walmart_sales;
CREATE TABLE walmart_sales(
                            invoice_id VARCHAR(15),
                            branch	CHAR(1),	
                            city  VARCHAR(25),  
                            customer_type	VARCHAR(15),
                            gender	VARCHAR(15),
                            product_line VARCHAR(55),	
                            unit_price	FLOAT,
                            quantity    INT, 	
                            vat	FLOAT,
                            total	FLOAT,
                            date	date,	
                            time time,
                            payment_method	VARCHAR(15),
                            rating FLOAT
                        );

SELECT * FROM walmart_sales;
/*
-- ---------------------------------------------
-- Business Problems :: Basic Level
-- ---------------------------------------------
Q.1 Find the total sales amount for each branch
Q.2 Calculate the average customer rating for each city.
Q.3 Count the number of sales transactions for each customer type.
Q.4 Find the total quantity of products sold for each product line.
Q.4 v1 Calculate the total VAT collected for each payment method.



-- ---------------------------------------------
-- Business Problems :: Medium Level
-- ---------------------------------------------
Q.5 Find the total sales amount and average customer rating for each branch.
Q.6 Calculate the total sales amount for each city and gender combination.
Q.7 Find the average quantity of products sold for each product line to female customers.
Q.8 Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)




-- ---------------------------------------------
-- Business Problems :: Advanced Level
-- ---------------------------------------------
Q.9 Calculate the total sales amount for each hour of the day
Q.10 Find the total sales amount for each month. (return month name and their sales)
Q.11 Calculate the total sales amount for each branch where the average customer rating is greater than 8.
Q.12 Find the total VAT collected for each product line where the total sales amount is more than 500.
Q.13 Calculate the average sales amount for each gender in each branch.
Q.14 Count the number of sales transactions for each day of the week.
Q.15 Find the total sales amount for each city and customer type combination where the number of sales transactions is greater than 50.
Q.16 Calculate the average unit price for each product line and payment method combination.
Q.17 Find the total sales amount for each branch and hour of the day combination.
Q.18 Calculate the total sales amount and average customer rating for each product line where the total sales amount is greater than 1000.
Q.19 Calculate the total sales amount for morning (6 AM to 12 PM), afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.

*/




SELECT * FROM walmart_sales;

-- Q.1 Find the total sales amount for each branch

SELECT 
    SUM(total)
FROM walmart_sales;

SELECT 
    COUNT(total)
FROM walmart_sales;

-- SUM, COUNT(), MIN, MAX, AVERAGE

SELECT 
     branch,
     SUM(total)
FROM walmart_sales
GROUP BY branch


-- Q.2 Calculate the average customer rating for each city.

SELECT
    city,
    AVG(rating) ratings
FROM walmart_sales
GROUP BY city
ORDER BY ratings

-- Q.3 Count the number of sales transactions for each customer type.

SELECT 
    customer_type,
    COUNT(invoice_id) as total_trans
FROM walmart_sales
GROUP BY customer_type

--4 Find the total quantity of products sold for each product line.

select  product_line, sum(quantity) from walmart_sales 
group by product_line


-- MEDIUM DIFFICULTY
-- Q.5 Find the total sales amount and average customer rating for each branch.

SELECT 
    branch,
    SUM(total) as total_sales,
    AVG(rating) as avg_rating
FROM walmart_sales
GROUP BY branch


-- Q.6 Calculate the total sales amount for each city and gender combination.

SELECT 
    city, --- 1
    gender, --- 2
    SUM(total)
FROM walmart_sales
GROUP BY 1, 2
ORDER BY 1

-- Q.7 Find the average quantity of products sold for each product line to female customers.

SELECT 
    product_line,
    AVG(quantity) as avg_qty_sold
    -- gender
FROM walmart_sales
WHERE gender = 'Male'
GROUP BY product_line


-- Q.8 Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)

SELECT
    TO_CHAR(date, 'Day') as day_name,
    SUM(total) as total_sale
FROM walmart_sales
GROUP BY day_name
ORDER BY total_sale DESC



-- Advanced 
-- Q.9 Calculate the total sales amount for each hour of the day


SELECT 
    EXTRACT (HOUR FROM time) as hours,
    SUM(total) as total_sale
FROM walmart_sales
GROUP BY 1
ORDER BY 2 



-- Q.10 Find the total sales amount for each month. (return month name and their sales)




SELECT
    TO_CHAR(date, 'Mon') as month_name,
    SUM(total) as total_sale
FROM walmart_sales
GROUP BY month_name
ORDER BY total_sale DESC


-- Q.11 Calculate the total sales amount for each branch where the average customer rating is greater than 7.

SELECT 
    branch,
    SUM(total) as total_sale, --- having
    AVG(rating) as avg_rating -- having
FROM walmart_sales
GROUP BY 1
HAVING AVG(rating) > 7

-- 12  Find the total VAT collected for each product line where the total sales amount is more than 500.

select product_line, 
       sum(vat) as vat,
	   sum(total) as total_sales
from walmart_sales 
group by product_line 
having sum(total) >500

--13 Calculate the average sales amount for each gender in each branch.

select branch, gender, avg(total) from walmart_sales 
group by 1,2
order by 1 

--14 Count the number of sales transactions for each day of the week.

select 
      to_char(date,'day')as day,
      count(*) as sales_transactions
from walmart_sales 
group by day
order by day

-- 15 Find the total sales amount for each city and customer type combination where the number of sales transactions is greater than 50.

select city, customer_type, sum(total) as total_sales, count(*) as sales_transactions from walmart_sales 
group by 1,2
having count(*) > 50
order by 1

-- 16 Calculate the average unit price for each product line and payment method combination.

select product_line, payment_method, avg(unit_price) from walmart_sales 
group by 1,2 
order by 1

-- 17 Find the total sales amount for each branch and hour of the day combination.

select
      branch,
      extract(hour from time) as hour_of_the_day,
	  sum(total)
from walmart_sales
group by branch, hour_of_the_day 
order by 1,2

-- 18 Calculate the total sales amount and average customer rating for each product line where the total sales amount is greater than 50000.

select 
      product_line,
	  sum(total) as total_sales,
	  avg(rating)
from walmart_sales
group by 1
having sum(total) > 50000

-- 19 Calculate the total orders  amount for morning (6 AM to 12 PM), afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.

with new_table
as
(select *,
    case 
      when extract(hour from time) between 6 and 12 then 'Morning'
	  when extract (hour from time) >12 and extract(hour from time)<=18 then 'Afternoon'
	  else 'Evening'
	end as shift
from walmart_sales
)
select 
      shift,
	  count(invoice_id),
	  sum(total) as total_orders_amount
from new_table 
group by 1










CREATE TABLE Customers (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE,
 Amount INT
 );


 INSERT INTO Customers
 VALUES
( 1,1,'2024-03-01',100),
( 2,1,'2024-03-04',150),
( 3,1,'2024-03-06',200),
( 4,2,'2024-03-01',90),
( 5,2,'2024-03-09',120),
( 6,2,'2024-03-17',150),
( 7,2,'2024-03-21',200),
( 8,3,'2024-03-08',120),
( 9,3,'2024-03-10',180),
( 10,3,'2024-03-18',220),
( 11,3,'2024-03-20',220);


-- Find Premium Customers
--Those who order within 7 days from their last order purchase

WITH x AS(
SELECT *, LAG(Order_date, 1, Order_date) OVER(PARTITION BY customer_id ORDER BY Order_date) AS prev_date
FROM orders2),
y AS (
SELECT *, COUNT(*) OVER (PARTITION BY customer_id) AS orders, TIMESTAMPDIFF(DAY, prev_date, Order_date) AS days_between
FROM x),
z AS(
SELECT *,
CASE WHEN days_between <7 THEN 1 ELSE 0 END AS flag
FROM y),
m AS (
SELECT *, sum(flag) OVER(PARTITION BY customer_id) AS flag_sum
FROM z)
SELECT DISTINCT(Customer_id)
FROM m
WHERE orders = flag_sum;

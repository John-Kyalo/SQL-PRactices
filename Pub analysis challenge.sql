CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);
INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');

CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);
INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content, price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);


CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');

CREATE TABLE ratings (
rating_id INT PRIMARY KEY, 
pub_id INT, 
customer_name VARCHAR(50),
rating FLOAT,
review TEXT, 
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id) );

INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');


--CASE STUDY QUESTIONS AND SOLUTIONS:

--QN 1: HOW MANY PUBS ARE LOCATED IN EACH COUNTRY
SELECT country, COUNT(pub_name) AS "Total pub"
FROM pubs
GROUP BY country;

--Qn 2: TOTAL SALES AMOUNT FOR EACH PUB INCLUDING THE BEVERAGE PRICES AND QUANTITY SOLD
SELECT pub_name, sum(price_per_unit * quantity) AS "total sales amount"
FROM pubs
JOIN sales ON sales.pub_id = pubs.pub_id
JOIN beverages ON sales.beverage_id = beverages.beverage_id
GROUP BY pub_name
ORDER BY [total sales amount] DESC;

--Qn 3: WHICH PUB HAS THE HIGHEST AVERAGE RATING?
SELECT pub_name, ROUND(AVG(rating),2) AS "Highest average rating"
FROM pubs
JOIN ratings ON  pubs.pub_id = ratings.pub_id
GROUP BY pub_name
ORDER BY [Highest average rating] DESC;

--QN 4: TOP 5 BEVERAGES BY SALES QUANTITY ACROSS ALL PUBS
SELECT beverage_name, SUM(quantity) AS "Top sold beverages"
FROM beverages
JOIN sales ON sales.beverage_id = beverages.beverage_id
GROUP BY beverage_name
ORDER BY  "Top sold beverages" DESC;

--Qn 5: HOW MANY SALES TRANSACTIONS OCCURRED ON EACH DATE
SELECT transaction_date, COUNT(quantity) AS "sales transactions"
FROM sales
GROUP BY transaction_date;

--QN 6: FIND THE NAME OF SOMEONE THAT HAD COCKTAILS AND WHICH PUB THEY HAD IT IN
SELECT pub_name, customer_name, category
FROM beverages
JOIN sales ON sales.beverage_id = beverages.beverage_id
JOIN pubs ON sales.pub_id = pubs.pub_id
JOIN ratings ON ratings.pub_id = pubs.pub_id
WHERE category='Cocktail';

-- QN 7: WHAT IS AVERAGE PRICE PER UNIT FOR EACH CATEGORY OF BEVERAGES EXCLUDING SPIRIT
SELECT category,  ROUND(AVG(price_per_unit),2) AS " avg price per unit for each category"
FROM beverages
WHERE NOT category = 'Spirit'
GROUP BY category
ORDER BY " avg price per unit for each category" DESC;

--QN 8: WHICH PUBS HAVE A RATING HIGHER THAN THE AVERAGE RATING OF ALL PUBS?
SELECT pub_name, ROUND(AVG(rating), 4) AS "AVG rating"
FROM pubs 
JOIN ratings ON ratings.pub_id = pubs.pub_id
GROUP BY pub_name
HAVING AVG(rating) > (SELECT AVG(rating) FROM ratings)
ORDER BY [AVG rating] DESC;

-- OR USE CTE's
WITH CTE1
AS(
SELECT AVG(rating) AS "overall average rating"
FROM ratings),
CTE2 AS(
SELECT pub_name, AVG(rating) AS "average rating of each pub"
FROM pubs
JOIN ratings ON ratings.pub_id = pubs.pub_id
GROUP BY pub_name)
SELECT pub_name, "overall average rating", "average rating of each pub"
FROM CTE1, CTE2
WHERE "average rating of each pub" > "overall average rating"
ORDER BY [average rating of each pub] DESC;


-- QN 9: WHAT IS THE RUNNING TOTAL OF SALES AMOUNT FOR EACH PUB ORDERED BY TRANSACTION DATE
SELECT pub_name, transaction_date, SUM(price_per_unit *quantity) AS "total amount by transaction date",
SUM(SUM(price_per_unit * quantity)) OVER (PARTITION BY pub_name ORDER BY transaction_date ASC) AS running_total
FROM pubs
JOIN sales ON sales.pub_id = pubs.pub_id
JOIN beverages ON beverages.beverage_id = sales.beverage_id
GROUP BY pub_name, transaction_date;

--QN 10: FOR EACH COUNTRY, FIND THE AVERAGE PRICE PER UNIT OF BEVERAGES IN EACH CATEGORY 
-- THEN, WHAT IS THE OVERALL AVERAGE PRICE PER UNIT OF BEVERAGES ACROSS ALL CATEGORIES

SELECT category,country, ROUND(AVG(price_per_unit),1) AS "avg price in diff countries for various bev category",
AVG(ROUND(AVG(price_per_unit),1)) OVER (PARTITION BY category) AS "avg price across all categories"
FROM pubs
JOIN sales ON pubs.pub_id = sales.pub_id
JOIN beverages ON beverages.beverage_id = sales.beverage_id
GROUP BY category, country;

--QN 11: FOR EACH PUB, FIND THE PERCENTAGE CONTRIBUTION OF EACH CATEGORY OF BEVERAGES TO 
-- THE TOTAL SALES AMOUNT 
-- THEN FIND THE PUB'S OVERALL SALES AMOUNT

SELECT m.*, ROUND((m."pub bev category revenue"/m."pub revenue") * 100, 0) AS "contribution"
FROM (
SELECT pub_name, category, SUM(price_per_unit * quantity) AS "pub bev category revenue",
SUM(SUM(price_per_unit * quantity)) OVER (PARTITION BY pub_name) AS "pub revenue"
FROM pubs
JOIN sales ON pubs.pub_id = sales.pub_id
JOIN beverages ON beverages.beverage_id = sales.beverage_id
GROUP BY pub_name, category) AS m
ORDER BY pub_name;
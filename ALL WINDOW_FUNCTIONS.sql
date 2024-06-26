 CREATE TABLE MONTHLY_REVENUE_DETAILS
    (MONTH_ID INT,
    MONTH_NAME TEXT,
    REVENUE NUMERIC(10,2));

INSERT INTO MONTHLY_REVENUE_DETAILS
VALUES (1, 'JANUARY', 50500),
        (2, 'FEBRUARY', 42500),
        (3, 'MARCH', 65000),
        (4, 'APRIL', 71000),
        (5, 'MAY', 68000),
        (6, 'JUNE', 59000),
        (7, 'JULY', 81000),
        (8, 'AUGUST', 71500),
        (9, 'SPETEMBER', 64000),
        (10, 'OCTOBER', 87000),
        (11, 'NOVEMBER', 89000),
        (12, 'DECEMBER', 125000);

CREATE TABLE TESLA_YEARLY_STOCK_PRICE_HISTORY(
YEAR INT,
REVENUE FLOAT);

 INSERT INTO TESLA_YEARLY_STOCK_PRICE_HISTORY
 VALUES (2009, 112000000),
           (2010, 117000000),
           (2011, 204000000),
           (2012, 413000000),
           (2013, 2013000000),
           (2014, 3198000000),
           (2015, 4046000000),
           (2016, 7000000000),
           (2017, 11759000000),
           (2018, 21461000000),
           (2019, 24578000000),
           (2020, 31536000000),
           (2021, 53823000000),
           (2022, 81462000000),
           (2023, 96773000000);


-- UNDERSTANDING LAG  LAG()
-- Showing month over month revenue change
-- Shows values from the previous row

--LAG(COULUMN_NAME, N) with N being the numbe rof rows you need to go back
SELECT MONTH_ID, MONTH_NAME,
LAG(REVENUE, 1) OVER(ORDER BY MONTH_ID) AS PREVIOUS_MONTH_REVENUE,
REVENUE AS CURRENT_MONTH_REVENUE
FROM MONTHLY_REVENUE_DETAILS;

--YOU CAN COMPARE REVENUE CHANGE OVER MONTH AS EITHER GROWTH/DECLINE IN PERCENTAGE

--MONTHLY_PERCENTAGE_REVENUE_CHANGE = (CURRENT_MONTH_REVENUE - PREVIOUS_MONTH_REVENUE)/PREVIOUS_MONTH_REVENUE *100

SELECT MONTH_ID, MONTH_NAME,
LAG(REVENUE, 1) OVER(ORDER BY MONTH_ID) AS PREVIOUS_MONTH_REVENUE,
REVENUE AS CURRENT_MONTH_REVENUE,
FORMAT((REVENUE - LAG(REVENUE, 1) OVER(ORDER BY MONTH_ID))/
LAG(REVENUE, 1) OVER(ORDER BY MONTH_ID), 'P') AS REVENUE_CHANGE_PERCENT
FROM MONTHLY_REVENUE_DETAILS;

--UNDERSTANDING LEAD  LEAD()
-- OPPOSITE OF LAG
--Provides the value in the new row

--LEAD(COLUMN_NAME, N)
SELECT MONTH_ID, MONTH_NAME, REVENUE, 
LEAD(REVENUE, 1) OVER(ORDER BY MONTH_ID) AS NEXT_MONTH_REVENUE
FROM MONTHLY_REVENUE_DETAILS;

--ALSO CALCULATE PERCENTAGE GROWTH
SELECT MONTH_ID, MONTH_NAME, REVENUE, 
LEAD(REVENUE, 1) OVER(ORDER BY MONTH_ID) AS NEXT_MONTH_REVENUE,
FORMAT((LEAD(REVENUE, 1) OVER(ORDER BY MONTH_ID) - REVENUE)/
REVENUE, 'P') AS REVENUE_CHANGE_PERCENT
FROM MONTHLY_REVENUE_DETAILS;

--UNDERSTAND ROW_NUMBER(), RANK(), DENSE_RANK()
--ROW_NUMBER(): assigns a new number for each row regardless of whether the number is the same or not
-- RANK(): assigns the same number for similar numbers but then skips based on the number of rows it has assigned that same number
--DENSE_RANK(): assigns the same number to each row as far as their numbers are the same but does not skips rows unlike rank





--UNDERSTANDING FIRST_VALUE() AND LAST_VALUE()
--CALCULATE TESLA'S GROWTH IN REVENUE FROM 2009-2023 AND SHOW THIS AS A PERCENTAGE

--use the first_value and last_value to get the first value and last value 

--FIRST_VALUE(COLUMN_NAME) OVER(ORDER BY COLUMN) AS FIRST_VALUE
--LAST_VALUE(COLUMN_NAME) OVER(ORDER BY COLUMN) AS LAST_VALUE

SELECT TOP 1
YEAR, REVENUE,
FIRST_VALUE(REVENUE) OVER (ORDER BY YEAR) AS "FIRST YEAR REVENUE",
LAST_VALUE(REVENUE) OVER (ORDER BY YEAR DESC) AS "MOST RECENT YEAR REVENUE"
FROM TESLA_YEARLY_STOCK_PRICE_HISTORY

--NOW THE REVENUE CHANGE FORMULA:
--REVENUE CHANGE = ((MOST_RECENT_REVENUE - FIRST_YEAR_REVENUE)/FIRST_YEAR_REVENUE) * 100

SELECT TOP 1
YEAR, 
FIRST_VALUE(REVENUE) OVER (ORDER BY YEAR) AS "FIRST YEAR REVENUE",
LAST_VALUE(REVENUE) OVER (ORDER BY YEAR DESC) AS "MOST RECENT YEAR REVENUE",
FORMAT(LAST_VALUE(REVENUE) OVER (ORDER BY YEAR DESC) - FIRST_VALUE(REVENUE) OVER (ORDER BY YEAR)/
FIRST_VALUE(REVENUE) OVER (ORDER BY YEAR), 'P') AS "PRICE CHANGE SINCE FIRST YEAR"
FROM TESLA_YEARLY_STOCK_PRICE_HISTORY
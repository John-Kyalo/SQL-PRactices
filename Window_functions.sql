CREATE TABLE Window_functions(
Name VARCHAR(20),
Age INT,
Department VARCHAR(20),
Salary BIGINT
);

INSERT INTO Window_functions 
VALUES
('Ramesh', 20, 'Finance', 50000),
('Deep', 20, 'Sales', 30000),
('Suresh', 20, 'Finance', 50000),
('Ram', 20, 'Finance', 20000),
('Pradeep', 20, 'Sales', 20000);


SELECT Name, Age, Department, Salary,
AVG(SALARY) OVER(PARTITION BY Department) AS Avg_Salary
FROM Window_functions
ORDER BY Age

CREATE TABLE Employee(
employee_id INT PRIMARY KEY,
team_id INT
);

INSERT INTO Employee 
VALUES
(1,8),
(2,8),
(3,8),
(4,7),
(5,9),
(6,9);

--Find the team size of each of the employees

SELECT
employee_id,
COUNT(employee_id) OVER(PARTITION BY team_id) AS team_size
FROM Employee;


--Accounts Table and problem on Leetcode

CREATE TABLE Accounts(
id INT PRIMARY KEY,
name VARCHAR(20)
);

CREATE TABLE Logins(
id INT,
login_date DATE
);

INSERT INTO Logins 
VALUES
(7, '2020-05-30'),
(1, '2020-05-30'),
(7, '2020-05-31'),
(7, '2020-06-01'),
(7, '2020-06-02'),
(7, '2020-06-02'),
(7, '2020-06-03'),
(1, '2020-06-07'),
(7, '2020-06-10');

-- Find out Active users (who login in within 5 or more consecutive days)
-- assume they login at most once per day


-- STEPS TO Calculation
-- check difference between login dates, the 5th time they logged in versus the first time the logged in
-- if the difference is 4, user must have logged in for 5 consecutive days

SELECT 
DISTINCT l.id, a.name
FROM(
	SELECT 
	id, login_date,
	LAG(login_date, 4) OVER (PARTITION BY id ORDER BY login_date) AS lag4
	FROM (SELECT DISTINCT id, login_date FROM Logins) l
) l
JOIN Accounts a
ON a.id=l.id
WHERE DATEDIFF(day,lag4, login_date) = 4
ORDER BY l.id;

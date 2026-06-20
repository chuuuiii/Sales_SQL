-- STAGING
CREATE TABLE data_cleaning AS
SELECT *
FROM sales_dirty;

SELECT *
FROM data_cleaning
ORDER BY 1;

-- Check row count
SELECT COUNT(*) FROM data_cleaning;

-- Check distinct values
SELECT DISTINCT Region
FROM data_cleaning
ORDER BY 1;

-- Check missing values
SELECT *
FROM data_cleaning
WHERE Customer_Name IS NULL
	OR Customer_Name = ''
ORDER BY 1;

-- Remove Leading and Trailing Spaces;
SELECT Order_ID
FROM data_cleaning
ORDER BY 1;

-- UPDATE - 
UPDATE data_cleaning
SET Order_ID = TRIM(Order_ID);

UPDATE data_cleaning
SET 
    Customer_Name = TRIM(Customer_Name),
    Region = TRIM(Region),
    Country = TRIM(Country),
    Product = TRIM(Product),
    Category = TRIM(Category),
    Order_Date = TRIM(Order_Date),
    Revenue = TRIM(Revenue),
    Profit = TRIM(Profit),
    Sales_Rep = TRIM(Sales_Rep)
WHERE 
    Customer_Name LIKE ' %' OR Customer_Name LIKE '% '
    OR Region LIKE ' %' OR Region LIKE '% ' 
    OR Country LIKE ' %' OR Country LIKE '% ' 
    OR Product LIKE ' %' OR Product LIKE '% '
    OR Category LIKE ' %' OR Category LIKE '% '
    OR Order_Date LIKE ' %' OR Order_Date LIKE '% '
    OR Revenue LIKE ' %' OR Revenue LIKE '% '
    OR Profit LIKE ' %' OR Profit LIKE '% '
    OR Sales_Rep LIKE ' %' OR Sales_Rep LIKE '% ';

SELECT *
FROM data_cleaning
ORDER BY 1;

-- Count how many rows still have spaces
SELECT COUNT(*)
FROM data_cleaning
WHERE Customer_Name != TRIM(Customer_Name)
	OR Region != TRIM(Region)
    OR Country != TRIM(Country);


-- Standardized values
-- UPDATE sales_clean
-- SET Region = 'EMEA'
-- WHERE LOWER(TRIM(Region)) = 'emea';

-- Standardized values
-- Region
UPDATE data_cleaning
SET Region = CASE
	WHEN LOWER(TRIM(Region)) = 'emea' THEN 'EMEA'
    WHEN LOWER (TRIM(Region)) = 'apac' THEN 'APAC'
    ELSE Region -- keep the original value if does not match emea and apac
END
WHERE LOWER(TRIM(Region)) IN ('emea', 'apac');

SELECT Sales_Rep
FROM data_cleaning;

UPDATE data_cleaning
SET Sales_Rep = CASE
	WHEN LOWER(TRIM(Sales_Rep)) = 'john doe' THEN 'John Doe'
    ELSE Sales_Rep
END
WHERE LOWER(TRIM(Sales_Rep)) = ('john doe');

UPDATE data_cleaning
SET Category = CASE
	WHEN LOWER(TRIM(Category)) = 'hardware' THEN 'Hardware'
    ELSE Category
END
WHERE LOWER(TRIM(Category)) = ('hardware');

-- Product Name
SELECT Product
FROM data_cleaning
ORDER BY Product;

-- Product Name
UPDATE data_cleaning
SET Product = 'Monitor'
WHERE LOWER(TRIM(Product)) = 'monitor';

-- Customer Name
SELECT Customer_Name
FROM data_cleaning;

UPDATE data_cleaning
SET Customer_Name = 'Alice Corp'
WHERE UPPER(TRIM(Customer_Name)) = 'ALICE CORP';

UPDATE data_cleaning
SET Country = 'Philippines'
WHERE Country = 'philippines';

UPDATE data_cleaning
SET Customer_Name = 'Unknown'
WHERE Customer_Name = 'Null';

SELECT Customer_Name
FROM data_cleaning
GROUP BY Customer_Name
ORDER BY 1;

SELECT COUNT(*)
FROM data_cleaning
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT *
FROM data_cleaning;
-- Handle missing values
SELECT *
FROM data_cleaning;
WHERE Customer_Name = ''
	OR Customer_Name IS NULL;
    
UPDATE data_cleaning
SET Customer_Name = 'Unknown'
WHERE Customer_Name = ''
	OR Customer_Name IS NULL;

-- Convert N/A and NULL STRINGS

SELECT Revenue
FROM data_cleaning;
-- check 
SELECT *
FROM data_cleaning
WHERE Revenue IN ('N/A','');

-- Convert
-- Revenue
UPDATE data_cleaning
SET Revenue = NULL
WHERE Revenue IN ('N/A','');

-- Profit
SELECT Profit
FROM data_cleaning;

UPDATE data_cleaning
SET Profit = NULL 
WHERE LOWER(TRIM(Profit)) = 'null'
	OR Profit = '';
    
-- Clean Revenue values
SELECT Revenue
FROM data_cleaning;

-- Remove symbols
UPDATE data_cleaning
SET Revenue = REPLACE(Revenue,'$','');

UPDATE data_cleaning
SET Revenue = REPLACE(Revenue,',','');

SELECT COUNT(*)
FROM data_cleaning
WHERE Revenue != TRIM(Revenue);

-- Clean Profit values
SELECT Profit
FROM data_cleaning;
SELECT COUNT(*)
FROM data_cleaning
WHERE Profit != TRIM(Profit);

UPDATE data_cleaning
SET Profit = REPLACE(Profit,',','');


-- Convert Data Types
SELECT Revenue
FROM data_cleaning;

ALTER TABLE data_cleaning
MODIFY Revenue DECIMAL(12,2);

SELECT Profit
FROM data_cleaning;
ALTER TABLE data_cleaning
MODIFY Profit DECIMAL(12,2);

-- Standardaized dates
SELECT *
FROM data_cleaning;

UPDATE data_cleaning
SET Order_Date = STR_TO_DATE(Order_Date, '%Y/%/%d')
WHERE Order_Date IS NOT NULL AND Order_Date != '';

ALTER TABLE data_cleaning
ADD COLUMN New_Order_Date DATE;

ALTER TABLE data_cleaning
DROP COLUMN New_Order_Date;

SELECT Order_Date
FROM data_cleaning
GROUP BY Order_Date;

-- Fix the 'DD-MM-YYYY' format (e.g., 24-02-2025)
UPDATE data_cleaning
SET Order_Date = DATE_FORMAT(STR_TO_DATE(Order_Date, '%d-%m-%Y'), '%Y-%m-%d')
WHERE Order_Date LIKE '__-__-____';

-- Fix the 'YYYY-MM-DD' format (Ensures consistency, e.g., 2025-10-29)
UPDATE data_cleaning
SET Order_Date = DATE_FORMAT(STR_TO_DATE(Order_Date, '%Y-%m-%d'), '%Y-%m-%d')
WHERE Order_Date LIKE '____-__-__';

-- Identify duplicates
SELECT Order_ID, COUNT(*) Duplicate
FROM data_cleaning
GROUP BY Order_ID
HAVING COUNT(*) > 1;

--  See the Full Row Data for Duplicates
WITH duplicate_cte AS
(
	SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY Order_ID, Customer_Name
            ORDER BY Order_ID
		) AS row_num
        FROM data_cleaning
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Remove duplicate
DELETE i 
FROM data_cleaning i
INNER JOIN(
	SELECT Order_ID, Customer_Name,
		ROW_NUMBER() OVER(
			PARTITION BY Order_ID, Customer_Name
            ORDER BY Order_ID
        ) AS row_num
        FROM data_cleaning
) sub
ON i.Order_ID = sub.Order_ID
AND i.Customer_Name = sub.Customer_Name
WHERE sub.row_num > 1;

SELECT *
FROM data_cleaning;

-- DATA VALIDATION
-- Revenue should not be negative
SELECT *
FROM data_cleaning
WHERE Revenue < 0;

-- Future Date
SELECT *
FROM data_cleaning
WHERE Order_Date > CURDATE();

SELECT CURDATE();

-- Filter for today revenue
SELECT * FROM data_cleaning 
WHERE Revenue = CURDATE();

-- MISSING SALES REP
SELECT *
FROM data_cleaning
WHERE Sales_Rep IS NULL;

-- 1. CREATE BUSINESS KPI
-- REVENUE
SELECT SUM(Revenue) as Revenue
FROM data_cleaning;

-- Profit
SELECT SUM(Profit) AS Profit
FROM data_cleaning;

-- Profit Marin
SELECT SUM(Profit) / SUM(Revenue) * 100 AS ProfitMargin
FROM data_cleaning;

-- Average Order value
SELECT AVG(Revenue) Avg
FROM data_cleaning;

SELECT *
FROM data_cleaning;

SELECT *
FROM data_cleaning
WHERE Customer_Name = 'Null';

SELECT *
FROM Customer_Name u 
WHERE EXISTS(
	SELECT 1 FROM Customer_Name u1
    WHERE u.Customer_Name = u1.Customer_Name
    AND u.Order_ID = u1.Order_ID
);
-- EDA
SELECT *
FROM data_cleaning;

-- Revenue by region
SELECT 
	Region,
	SUM(Revenue) AS RevenueByRegion
FROM data_cleaning
GROUP BY Region;

-- Revenue By Product
SELECT 
	Product,
    SUM(Revenue) AS RevenueByProduct
FROM data_cleaning
GROUP BY Product;

-- TOP SALES REP 
SELECT
	Sales_Rep,
    SUM(Revenue)
FROM data_cleaning
GROUP BY Sales_Rep
ORDER BY SUM(Revenue) DESC;
 
 SELECT COUNT(Revenue) AS total_revenue
 FROM data_cleaning;
  SELECT COUNT(Profit) AS total_profit
  FROM data_cleaning;
SELECT COUNT(*) AS total_orders
FROM data_cleaning;




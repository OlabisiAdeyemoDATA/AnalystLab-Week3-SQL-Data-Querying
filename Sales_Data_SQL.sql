USE analystlab_sales;


SELECT *
FROM sales_data
LIMIT 10;

DESCRIBE sales_data_sample;

-- Query 1: Total Revenue

SELECT
ROUND(SUM(SALES),2) AS Total_Revenue
FROM sales_data_sample;

-- Query 2: Total Orders

SELECT
COUNT(DISTINCT ORDERNUMBER) AS Total_Orders
FROM sales_data_sample;

-- Query 3: Revenue by Year

SELECT
YEAR_ID,
ROUND(SUM(SALES),2) AS Revenue
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY YEAR_ID;

-- Query 4: Revenue by Product Line

SELECT
PRODUCTLINE,
ROUND(SUM(SALES),2) AS Revenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Revenue DESC;

-- Query 5: Top 10 Customers

SELECT
CUSTOMERNAME,
ROUND(SUM(SALES),2) AS Total_Spent
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Spent DESC
LIMIT 10;

-- Query 6: Customer Purchasing Behavior

SELECT
CUSTOMERNAME,
COUNT(DISTINCT ORDERNUMBER) AS Number_Of_Orders,
ROUND(SUM(SALES),2) AS Total_Spent,
ROUND(AVG(SALES),2) AS Average_Purchase
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Spent DESC;

-- Query 7: Monthly revenue trend

SELECT
    YEAR_ID,
    MONTH_ID,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data_sample
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;

-- Query 8: Revenue by country

SELECT
    COUNTRY,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data_sample
GROUP BY COUNTRY
ORDER BY Revenue DESC;

-- Query 9: Revenue by deal size

SELECT
    DEALSIZE,
    COUNT(DISTINCT ORDERNUMBER) AS Total_Orders,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data_sample
GROUP BY DEALSIZE
ORDER BY Revenue DESC;

-- Query 10: Product lines with revenue above average product-line revenue

SELECT
    PRODUCTLINE,
    ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
HAVING SUM(SALES) > (
    SELECT AVG(Product_Revenue)
    FROM (
        SELECT SUM(SALES) AS Product_Revenue
        FROM sales_data_sample
        GROUP BY PRODUCTLINE
    ) avg_product_revenue
)
ORDER BY Revenue DESC;

-- Query 11: Rank customers by revenue

SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES), 2) AS Total_Spent,
    RANK() OVER (ORDER BY SUM(SALES) DESC) AS Customer_Rank
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Customer_Rank;

-- Query 12: Top customer in each country

SELECT
    COUNTRY,
    CUSTOMERNAME,
    Total_Spent
FROM (
    SELECT
        COUNTRY,
        CUSTOMERNAME,
        ROUND(SUM(SALES), 2) AS Total_Spent,
        ROW_NUMBER() OVER (
            PARTITION BY COUNTRY
            ORDER BY SUM(SALES) DESC
        ) AS Row_Num
    FROM sales_data_sample
    GROUP BY COUNTRY, CUSTOMERNAME
) ranked_customers
WHERE Row_Num = 1
ORDER BY Total_Spent DESC;


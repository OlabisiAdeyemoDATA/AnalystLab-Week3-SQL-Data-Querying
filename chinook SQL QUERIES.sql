Week3_SQL_Queries.sql
 Query 1: View all customers

SELECT *
FROM Customer;

 Query 2: Customers from the USA

SELECT
    FirstName,
    LastName,
    City,
    Country
FROM Customer
WHERE Country = 'USA'
ORDER BY LastName;

-- Query 3: Customer count by country

SELECT
    Country,
    COUNT(*) AS Total_Customers
FROM Customer
GROUP BY Country
ORDER BY Total_Customers DESC;

-- Query 4: Countries with more than one customer

SELECT
    Country,
    COUNT(*) AS Total_Customers
FROM Customer
GROUP BY Country
HAVING COUNT(*) > 1
ORDER BY Total_Customers DESC;

-- Query 5: Total revenue

SELECT
ROUND(SUM(Total),2) AS Total_Revenue
FROM Invoice;

-- Query 6: Average invoice value

SELECT
ROUND(AVG(Total),2) AS Average_Invoice_Value
FROM Invoice;
 Query 7: Total invoices

SELECT
COUNT(*) AS Total_Invoices
FROM Invoice;

-- Query 8: Top 10 customers by spending

SELECT
c.CustomerId,
CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
ROUND(SUM(i.Total),2) AS Total_Spent
FROM Customer c
INNER JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY
c.CustomerId,
Customer_Name
ORDER BY Total_Spent DESC
LIMIT 10;

-- Query 9: Revenue by country

SELECT
c.Country,
ROUND(SUM(i.Total),2) AS Revenue
FROM Customer c
INNER JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY Revenue DESC;

-- Query 10: Top selling genres

SELECT
g.Name AS Genre,
COUNT(il.InvoiceLineId) AS Total_Sales
FROM Genre g
INNER JOIN Track t
ON g.GenreId = t.GenreId
INNER JOIN InvoiceLine il
ON t.TrackId = il.TrackId
GROUP BY Genre
ORDER BY Total_Sales DESC;

-- Query 11: Employee performance

SELECT
CONCAT(e.FirstName,' ',e.LastName) AS Employee,
ROUND(SUM(i.Total),2) AS Revenue_Generated
FROM Employee e
INNER JOIN Customer c
ON e.EmployeeId = c.SupportRepId
INNER JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY Employee
ORDER BY Revenue_Generated DESC;

-- Query 12: Monthly revenue trend

SELECT
DATE_FORMAT(InvoiceDate,'%Y-%m') AS Month,
ROUND(SUM(Total),2) AS Revenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

-- Query 13: Customer purchase behavior

SELECT
CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
COUNT(i.InvoiceId) AS Number_Of_Purchases,
ROUND(SUM(i.Total),2) AS Total_Spent,
ROUND(AVG(i.Total),2) AS Average_Purchase
FROM Customer c
INNER JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY Customer_Name
ORDER BY Total_Spent DESC;

-- Query 14: Customers whose total spending is above the average customer spending

SELECT
    Customer_Name,
    Total_Spent
FROM (
    SELECT
        c.CustomerId,
        CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
        ROUND(SUM(i.Total),2) AS Total_Spent
    FROM Customer c
    INNER JOIN Invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY
        c.CustomerId,
        Customer_Name
) customer_spending

WHERE Total_Spent > (
    SELECT AVG(Total_Spent)
    FROM (
        SELECT
            CustomerId,
            SUM(Total) AS Total_Spent
        FROM Invoice
        GROUP BY CustomerId
    ) avg_spending
)
ORDER BY Total_Spent DESC;

-- Query 15: Rank customers by total spending

SELECT
    Customer_Name,
    Total_Spent,
    RANK() OVER (ORDER BY Total_Spent DESC) AS Spending_Rank
FROM (
    SELECT
        c.CustomerId,
        CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
        ROUND(SUM(i.Total),2) AS Total_Spent
    FROM Customer c
    INNER JOIN Invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY
        c.CustomerId,
        Customer_Name
) customer_spending;

-- Query 16: Top customer in each country using ROW_NUMBER

SELECT
    Country,
    Customer_Name,
    Total_Spent
FROM (
    SELECT
        c.Country,
        CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
        ROUND(SUM(i.Total),2) AS Total_Spent,
        ROW_NUMBER() OVER (
            PARTITION BY c.Country
            ORDER BY SUM(i.Total) DESC
        ) AS Row_Num
    FROM Customer c
    INNER JOIN Invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY
        c.Country,
        c.CustomerId,
        Customer_Name
) ranked_customers
WHERE Row_Num = 1
ORDER BY Total_Spent DESC;

-- Query 17: Customer revenue ranking within each country

SELECT
    c.Country,
    CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
    ROUND(SUM(i.Total),2) AS Total_Spent,
    RANK() OVER (
        PARTITION BY c.Country
        ORDER BY SUM(i.Total) DESC
    ) AS Country_Revenue_Rank
FROM Customer c
INNER JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY
    c.Country,
    c.CustomerId,
    Customer_Name
ORDER BY
    c.Country,
    Country_Revenue_Rank;
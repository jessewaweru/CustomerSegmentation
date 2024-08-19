-- Frequent Buyers
SELECT
    SUM(quantity) AS total_quantity,
    ROUND(SUM(CAST(quantity*unitprice AS numeric)),2) AS Total_spent,
    customerid
FROM
    online_retail
WHERE
    customerid IS NOT NULL
GROUP BY
    customerid
ORDER BY
    total_quantity DESC
LIMIT
    30

--Periodic Purchasers by month

WITH ranked_monthlypurchases AS(
    SELECT
        SUM(quantity) AS total_quantity,
        ROUND(SUM(CAST(quantity*unitprice AS numeric)),2) AS Total_spent,
        EXTRACT(MONTH FROM invoicedate) AS date_month,
        TO_CHAR(invoicedate, 'Month') AS month_name,
        customerid,
        ROW_NUMBER () OVER (PARTITION BY EXTRACT(MONTH FROM invoicedate) ORDER BY SUM(quantity) DESC) AS rank
    FROM
        online_retail
    WHERE
        invoicedate IS NOT NULL
        AND customerid IS NOT NULL
    GROUP BY
        customerid,
        date_month,
        month_name
    ORDER BY
        total_spent DESC
)
SELECT
    *
FROM
    ranked_monthlypurchases
WHERE
    rank = 1
ORDER BY
    total_spent DESC



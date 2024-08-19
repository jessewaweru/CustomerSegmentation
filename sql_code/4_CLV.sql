-- Average Purchase Value
WITH avg_purchase_value AS (
    SELECT
        customerid,
        SUM(quantity * unitprice) / COUNT(DISTINCT invoiceno) AS average_purchase_value
    FROM
        online_retail
    GROUP BY
        customerid
),

-- Purchase Frequency
purchase_frequency AS (
    SELECT
        customerid,
        COUNT(DISTINCT invoiceno) / COUNT(DISTINCT EXTRACT(YEAR FROM invoicedate)) AS purchase_frequency
    FROM
        online_retail
    GROUP BY
        customerid
),

-- Average Customer Lifespan
average_customer_lifespan AS (
    SELECT
        customerid,
        EXTRACT(YEAR FROM AGE(MAX(invoicedate), MIN(invoicedate))) AS customer_lifespan_years
    FROM
        online_retail
    GROUP BY
        customerid
),

-- Customer Value
customer_value AS (
    SELECT
        apv.customerid,
        ROUND(CAST(apv.average_purchase_value * pf.purchase_frequency AS numeric), 2) AS customer_value
    FROM
        avg_purchase_value AS apv
    JOIN
        purchase_frequency AS pf 
        ON apv.customerid = pf.customerid
),

-- Customer Lifetime Value
customer_lifetime_value AS (
    SELECT
        cv.customerid,
        ROUND(cv.customer_value * acl.customer_lifespan_years, 2) AS customer_lifetime_value
    FROM
        customer_value AS cv
    JOIN
        average_customer_lifespan AS acl 
        ON cv.customerid = acl.customerid
)

-- Final Selection
SELECT
    *
FROM
    customer_lifetime_value
ORDER BY
    customer_lifetime_value DESC
LIMIT
    30;






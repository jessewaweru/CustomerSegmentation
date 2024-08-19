WITH purchase_times AS (
    SELECT
        CustomerID,
        InvoiceDate,
        LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS previous_purchase_time
    FROM
        online_retail
),

time_diffs AS (
    SELECT
        CustomerID,
        EXTRACT(EPOCH FROM (InvoiceDate - previous_purchase_time))/86400 AS days_between_purchases
    FROM
        purchase_times
    WHERE
        previous_purchase_time IS NOT NULL
)

SELECT
    CustomerID,
    ROUND(AVG(days_between_purchases), 2) AS avg_days_between_purchases
FROM
    time_diffs
GROUP BY
    CustomerID
ORDER BY
    avg_days_between_purchases DESC;

--Matching customers

WITH avg_days AS (

    WITH purchase_times AS (
        SELECT
            CustomerID,
            InvoiceDate,
            LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS previous_purchase_time
        FROM
            online_retail
    ),
    time_diffs AS (
        SELECT
            CustomerID,
            EXTRACT(EPOCH FROM (InvoiceDate - previous_purchase_time))/86400 AS days_between_purchases
        FROM
            purchase_times
        WHERE
            previous_purchase_time IS NOT NULL
    )
    SELECT
        CustomerID,
        ROUND(AVG(days_between_purchases), 2) AS avg_days_between_purchases
    FROM
        time_diffs
    GROUP BY
        CustomerID
),

top_customers AS (

    SELECT
        SUM(quantity) AS total_quantity,
        ROUND(SUM(CAST(quantity * unitprice AS numeric)), 2) AS Total_spent,
        customerid AS top_customerid
    FROM
        online_retail
    WHERE
        customerid IS NOT NULL
    GROUP BY
        customerid
    ORDER BY
        total_spent DESC
    LIMIT
        30
)

SELECT
    tc.top_customerid AS CustomerID,
    tc.Total_spent,
    ad.avg_days_between_purchases
FROM
    top_customers AS tc
JOIN
    avg_days AS ad
    ON tc.top_customerid = ad.CustomerID
ORDER BY
    ad.avg_days_between_purchases DESC;

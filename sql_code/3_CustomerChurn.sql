WITH TOP_PURCHASES AS(
    SELECT
        SUM(quantity) AS total_quantity,
        ROUND(SUM(CAST(quantity*unitprice AS numeric)),2) AS Total_spent,
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
    TP.top_customerid,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 1 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_january,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 2 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_february,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 3 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_march,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 4 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_april,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 5 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_may,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 6 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_june,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 7 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_july,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 8 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_august,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 9 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_september,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 10 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_october,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 11 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_november,
    ROUND(SUM(CAST(CASE WHEN EXTRACT(MONTH FROM ORT.invoicedate) = 12 THEN ORT.quantity * ORT.unitprice ELSE 0 END AS numeric)), 2) AS total_spent_december,
    ROUND(SUM(CAST(ORT.quantity * ORT.unitprice AS numeric)), 2) AS overall_total_spent
FROM
    TOP_PURCHASES AS TP
JOIN
    Online_Retail AS ORT
    ON TP.top_customerid = ORT.customerid
GROUP BY
    TP.top_customerid
ORDER BY
    overall_total_spent DESC


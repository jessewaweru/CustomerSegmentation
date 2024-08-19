# Introduction
The Dataset I used is called Customer segmentation that belongs to [M Yasser H](/https://www.kaggle.com/datasets/yasserh/customer-segmentation-dataset/). It contains purchase history of over 2400 customers and has over 541,000 rows of data.

Here are the SQL queires I used to generate my various insights:
[Customer_Segmentation](sql_code)

# Background
I wanted a dataset that could provide me with a chance to perform customer segmentation using SQL and also showcase other valuable metrics that a business has to focus on when it comes to performance, operations and customers especially when it comes to the buying behavior of customers. The metrics identified could also be helpful in formulating or improving the current marketing strategies already in place. 

### Problem statements I decided to use to answer my SQL queries
1. What are the major customer segments for the store?
2. Which customers are at risk of churning?
3. Who are the store's top customers in terms of Customer lifetime value?
4. What's the average time per purchase for customers and which ones out of the top purchasers have the highest average time to purchase?
5. What are some of the more popular products bought from the store(considering the lack of product categories from the dataset)?

# Tools I used
The tools I used to generate my insights for the project include the following:
- **SQL**
- **Python**
- **PostgreSQL :** My ideal database management that is linked to my code editor.
- **Visual Studio Code**: My ideal code editor for SQL queries
- **Git and GitHub:** Needed a version control to showcase the steps and changes  made as I progressed with my analysis. It's also ideal for sharing and collaboration purposes.

# The Analysis

### 1. What are the major customer segments for the store?

```SQL
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

```

#### **Insights I gained from the problem statement:**
| total_quantity | total_spent | date_month | month_name | customerid | rank |
|----------------|-------------|------------|------------|------------|------|
| 25662          | 70246.50     | 9          | September  | 17450      | 1    |
| 26742          | 39995.95     | 10         | October    | 14646      | 1    |
| 29107          | 39655.81     | 8          | August     | 14646      | 1    |
| 19577          | 28408.14     | 5          | May        | 14646      | 1    |
| 20300          | 26476.68     | 1          | January    | 14646      | 1    |
| 11665          | 26464.99     | 7          | July       | 14156      | 1    |
| 18320          | 25375.41     | 11         | November   | 14646      | 1    |
| 18663          | 25288.99     | 6          | June       | 14646      | 1    |
| 16271          | 22752.46     | 2          | February   | 14646      | 1    |
| 14125          | 21462.40     | 3          | March      | 14646      | 1    |
| 14672          | 20319.90     | 12         | December   | 14646      | 1    |
| 13662          | 9656.85      | 4          | April      | 14298      | 1    |


The first section of the code showcases the top 30 customers for the business regarding total spent by their customerid. The second section shows the top customer purchasers by month. This could help the business with targeted marketing promotions and discounts to entice even more purchases both by sending seasonal promotions for monthly top purchasers and specialized promotions for the top 30 customers for the year.

### 2. Which customers are at risk of churning?
Next, I wanted to indentify which customers, out of the top 30 purchasers, are at risk of churning so I filtered the data and compiled a table showcasing the month by month total spent for each customer and then to plot the results. I used the final 3 months of the fiscal year to identify a declining trend.

```SQL
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
```

#### **Insights I gained from the problem statement:**

![Customer_Churn](images/C_churn_plot.png)
*Bar graph showcasing the final three-month trend of total spent by customers*

From the results of the plot, It is clear that customer id number 12415, 14646 and 16684. The business could target these customers through digital marketing and start offering personalized promotions an discounts for the beginning of the next fiscal year such as bulk order discounting.

### 3. Who are the store's most valuable customers in terms of Customer lifetime value?

```SQL
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
    customer_lifetime_value DESC;

```

#### **Insights I gained from the problem statement:**
- The code generated the top 30 most valuable customers as per C.L.V. This data could help the business in the event they decide to introduce more products into the market, they already have an idea of some of the customers who coul decide to target through advertising and product positioning.
- The store could even use such customers to generate valubale feedback about their customers to improve upon their future or current products, their services or even get future ideas on how to improve their business model if need be.

### 4. What's the average time per purchase for customers and which ones out of the top purchasers have the highest average time to purchase?

```SQL
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
```

#### **Insights I gained from the problem statement:**
- The first section of the code generated the customers who averaged the most days before making another purchase. The second section highlights the same but now the top 30 purchasers. Such data could prove ciritical when changing marketing strategies especially when it comes to promotions and identifying specific bottlenecks in a customer's buying journey.
- The business could offer promotions that are catered to logisitic solutions due to possible issues such as high cost of shipping and delivery

### 5. What are some of the more popular products bought from the store(considering the lack of product categories from the dataset)?

The code I used to generate the products from the descriptions column:

[Popular_Products](sql_code/PopularProducts.ipynb)

#### **Insights I gained from the problem statement:**
- Ignoring the other categories which includes a majority of the products that I couldn't be able to categorize, some of the more popular products based on the descriptions column of the data include the following:

![Popular_Products](images/Popular_Products.png)
*Bar graph showcasing some of the more popular products offerd by the business*

- The business could decide to set up marketing strategies dedicated at maximizing the sale and purchase of such popular items across the entire product line. This could involve a series of digital marketing promotions, a website redesign prioritising such products as the first to be seen across designated landing pages etc.

# Conclusions
- Being able to identify trends be it positive or negative is also crucial i.e. in the case of Customer churn, ends up helping a business to identify the customers who need priority attention especially if the historical data shows that they are consistently top purchasers and help avoid any risk of churning in the future.

- Identifying both positive and negative trends is essential. For instance, analyzing customer churn can pinpoint high-value customers at risk of attrition, enabling proactive retention strategies.

# What I learned
- It was another great experience in futhering my skills in python and SQL. I learnt a new way of using regular expressions to identify key words in a description for categorical purposes and I continued to work with more window functions in SQL.
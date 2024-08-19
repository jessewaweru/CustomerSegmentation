CREATE TABLE Online_Retail
(
    InvoiceNo VARCHAR(100),
    StockCode VARCHAR(50),
    Description VARCHAR(300),
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice FLOAT,
    CustomerID INT,
    Country VARCHAR(200) 
)

\copy Online_Retail FROM 'C:\Users\Jesse\OneDrive\Desktop\CustomerSegmentation\Online Retail.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
*/

-- Create an index on InvoiceNo
CREATE INDEX idx_invoice_no ON Online_Retail(InvoiceNo);

-- Create an index on StockCode
CREATE INDEX idx_stock_code ON Online_Retail(StockCode);

-- Create an index on InvoiceDate
CREATE INDEX idx_invoice_date ON Online_Retail(InvoiceDate);

-- Create an index on CustomerID
CREATE INDEX idx_customer_id ON Online_Retail(CustomerID);

ALTER TABLE Online_Retail
ALTER COLUMN InvoiceDate TYPE TIMESTAMP USING TO_TIMESTAMP(InvoiceDate, 'MM/DD/YYYY HH24:MI');

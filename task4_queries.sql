CREATE DATABASE ecommerce;
USE ecommerce;

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Transactions;

SELECT * FROM Customers WHERE Region = 'East';
SELECT * FROM Products ORDER BY Price DESC LIMIT 5;
SELECT * FROM Transactions WHERE TransactionDate > '2024-01-01';

-- Aggregate Functions with GROUP BY
SELECT CustomerID, COUNT(*) AS NumTransactions
FROM Transactions
GROUP BY CustomerID;

SELECT ProductID, SUM(TotalValue) AS Revenue
FROM Transactions
GROUP BY ProductID
ORDER BY Revenue DESC;

SELECT ProductID, AVG(Quantity) AS AvgQuantity
FROM Transactions
GROUP BY ProductID;


DESCRIBE Products;
DESCRIBE Transactions;

ALTER TABLE Transactions
  CHANGE COLUMN `ï»¿TransactionID` TransactionID VARCHAR(10);
  
ALTER TABLE Customers
  CHANGE COLUMN `ï»¿CustomerID` CustomerID VARCHAR(10);
  
ALTER TABLE Products
  CHANGE COLUMN `ï»¿ProductID` ProductID VARCHAR(10);

-- JOINs
SELECT t.TransactionID, p.ProductName, t.Quantity, t.TotalValue
FROM Transactions t
JOIN Products p ON t.ProductID = p.ProductID;

SELECT c.CustomerName, p.ProductName, t.TransactionDate, t.Quantity, t.TotalValue
FROM Transactions t
JOIN Customers c ON t.CustomerID = c.CustomerID
JOIN Products p ON t.ProductID = p.ProductID;



-- SUBQUERIES
SELECT DISTINCT CustomerID
FROM Transactions
WHERE TotalValue > (SELECT AVG(TotalValue) FROM Transactions);

SELECT ProductID, SUM(Quantity) AS TotalSold
FROM Transactions
GROUP BY ProductID
ORDER BY TotalSold DESC
LIMIT 1;



-- VIEWs

CREATE VIEW TopSpenders AS
SELECT CustomerID, SUM(TotalValue) AS TotalSpent
FROM Transactions
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

SELECT * FROM TopSpenders;



-- Indexes for Optimization

USE ecommerce;
DESCRIBE Transactions;

-- Create a backup column just in case
ALTER TABLE Transactions ADD COLUMN CustomerID_int INT;

-- Copy the numeric part over
UPDATE Transactions
   SET CustomerID = CAST(CustomerID AS UNSIGNED);

-- Drop old column and rename
ALTER TABLE Transactions DROP COLUMN CustomerID;
ALTER TABLE Transactions CHANGE COLUMN CustomerID_int CustomerID INT;
ALTER TABLE Transactions CHANGE COLUMN ProductID_int ProductID INT;
-- switch into the correct database for safety
USE ecommerce;

-- add index on CustomerID
ALTER TABLE `Transactions`
  ADD INDEX `idx_customerID` (`CustomerID`) USING BTREE;

SHOW INDEX FROM Transactions;

USE ecommerce;         

ALTER TABLE `Transactions`
  ADD INDEX `idx_productID_fix` (`ProductID`) USING BTREE;
  
  ALTER TABLE Transactions ADD COLUMN ProductID_int INT;
UPDATE Transactions
   SET ProductID_int = CAST(ProductID AS UNSIGNED);
ALTER TABLE Transactions DROP COLUMN ProductID;
ALTER TABLE Transactions CHANGE COLUMN ProductID_int ProductID INT;
ALTER TABLE Transactions ADD INDEX idx_productID_fix (ProductID);

SHOW INDEX FROM Transactions;
























CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    TransactionDate DATE,
    Quantity INT,
    TotalValue DECIMAL(10, 2),
    Price DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

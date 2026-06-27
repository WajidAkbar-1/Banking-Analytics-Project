CREATE TABLE Transactions
(
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    TransactionType VARCHAR(20),
    Amount DECIMAL(18,2)
);

WITH Numbers AS
(
    SELECT TOP 5000
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)

INSERT INTO Transactions
(TransactionID, AccountID, TransactionDate, TransactionType, Amount)
SELECT
    N,
    ABS(CHECKSUM(NEWID())) % 300 + 1,
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETDATE()),
    CASE ABS(CHECKSUM(NEWID())) % 3
        WHEN 0 THEN 'Deposit'
        WHEN 1 THEN 'Withdrawal'
        ELSE 'Transfer'
    END,
    CAST((ABS(CHECKSUM(NEWID())) % 200000) + 1000 AS DECIMAL(18,2))
FROM Numbers;


SELECT *  FROM Transactions
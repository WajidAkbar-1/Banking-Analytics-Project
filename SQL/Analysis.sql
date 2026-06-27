--KPI 
--Total Customers
SELECT COUNT(CustomerID) AS BankCustomers
FROM Customers
--Total Deposit Balance
SELECT SUM(Amount) AS TotalDepositBalance
FROM Transactions
WHERE TransactionType = 'Deposit'
--Total Loans
SELECT COUNT(LoanID) AS TotalActiveLoans 
FROM Loans
WHERE LoanStatus = 'Active'
--Average Balance in Account
SELECT AVG(Balance) AS AverageBalance
FROM Accounts
--Active Accounts
SELECT COUNT(DISTINCT AccountID) AS ActiveAccounts
FROM Accounts
--Top Branch
SELECT TOP 5 BranchName, SUM(TR.Amount) TotalAmount
FROM Accounts AC
JOIN Transactions TR
    ON AC.AccountID = TR.AccountID
JOIN Branches BR
    ON AC.BranchID = BR.BranchID
GROUP BY BranchName
ORDER BY TotalAmount DESC
--Top Depositor
SELECT AC.AccountID, CU.CustomerName,
        SUM
        (CASE
            WHEN TR.TransactionType = 'Deposit' THEN TR.Amount END
         )AS Deposit
FROM Accounts AC
JOIN Transactions TR
    ON AC.AccountID = TR.AccountID
JOIN Customers CU
    ON CU.CustomerID = AC.CustomerID
GROUP BY AC.AccountID,CU.CustomerName
ORDER BY Deposit DESC 
--add column
ALTER TABLE Accounts
ADD AccountStatus VARCHAR(50)
UPDATE Accounts
SET AccountStatus = 
    CASE
		WHEN Balance < 80000 THEN 'Basic'
		WHEN Balance < 100000 THEN 'Silver'
		WHEN Balance < 150000 THEN 'Gold'
		ELSE 'Premium'
	END 

--Counting Accounting and AccountStatus
SELECT AccountStatus, COUNT(DISTINCT(CustomerID)) TotalCustomers
FROM Accounts
GROUP BY AccountStatus
--Branch Ranking By Account Balance
SELECT BR.BranchName, SUM(AC.Balance) AS TotalBalance, RANK() OVER(ORDER BY SUM(AC.Balance) DESC) AS RankNo
FROM Branches BR
JOIN Accounts AC
    ON BR.BranchID = AC.BranchID
GROUP BY BR.BranchName
--Branch Ranking By Transactions
SELECT BR.BranchName, SUM(TR.Amount) AS TotalTransactions, RANK() OVER(ORDER BY SUM(TR.Amount) DESC) AS RankNo
FROM Branches BR
JOIN Accounts AC
    ON BR.BranchID = AC.BranchID
JOIN Transactions TR
    ON AC.AccountID = TR.AccountID
GROUP BY BR.BranchName
--Customer Counting By Branch
SELECT BR.BranchName, COUNT(CU.CustomerID) AS TotalCustomers
FROM Accounts AC
JOIN Customers CU
    ON AC.CustomerID = CU.CustomerID
JOIN Branches BR
    ON BR.BranchID = AC.BranchID
GROUP BY BR.BranchName
ORDER BY TotalCustomers DESC


--Running Balance
SELECT AccountID, TransactionID, Amount,
	SUM(Amount) OVER (PARTITION BY AccountID ORDER BY TransactionID) RunnigBalance
FROM Transactions

--Top Depositor
SELECT AccountID, SUM(Amount) AS Deposit,
    RANK() OVER (ORDER BY SUM(Amount) DESC) RankNo
FROM Transactions
WHERE TransactionType = 'Deposit'
GROUP BY AccountID

--Monthly Transaction Trend
SELECT Year(TransactionDate) AS Year,
	Month(TransactionDate) AS Month,
	--TransactionType,
	SUM(Amount) TotalAmount
FROM Transactions
GROUP BY
	YEAR(TransactionDate),
	MONTH(TransactionDate)
	--TransactionType
ORDER BY Year, Month

--Branch Ranking
SELECT 
	BR.BranchName,
	SUM(Amount) AS TotalBalance,
	DENSE_RANK() OVER(ORDER BY SUM(Amount) DESC) BranchRank
FROM Transactions TR
JOIN Accounts AC
	ON TR.AccountID = AC.AccountID
JOIN Branches BR
	ON AC.BranchID = BR.BranchID
GROUP BY BR.BranchName


--Customer Segmentation
SELECT *, 
	CASE
		WHEN Balance < 80000 THEN 'Basic'
		WHEN Balance < 100000 THEN 'Silver'
		WHEN Balance < 150000 THEN 'Gold'
		ELSE 'Premium'
	END
FROM Accounts

--ROW_NUMBER()
SELECT
    CustomerID,
    Balance,
    ROW_NUMBER() OVER
    (
        ORDER BY Balance DESC
    ) AS RowNum
FROM Accounts;

--RANK()
SELECT
    CustomerID,
    Balance,
    RANK() OVER
    (
        ORDER BY Balance DESC
    ) AS RankNo
FROM Accounts;

--DENSE_RANK()
SELECT
    CustomerID,
    Balance,
    DENSE_RANK() OVER
    (
        ORDER BY Balance DESC
    ) AS DenseRankNo
FROM Accounts;

--Customer above average balance
WITH AverageBalance As 
(
    SELECT AVG(Balance) AS AvgBalance
    FROM Accounts
)
SELECT AccountID, AccountType, Balance
    FROM Accounts AC
    JOIN Customers CU
        ON AC.CustomerID = CU.CustomerID
WHERE Balance > (
    SELECT AvgBalance
    FROM AverageBalance
)

--Store Procedure
CREATE PROCEDURE TopCustomers
AS
BEGIN
SELECT TOP 10
    CustomerID,
    SUM(Balance) TotalBalance
FROM Accounts
GROUP BY CustomerID
ORDER BY TotalBalance DESC
END
EXEC TopCustomers

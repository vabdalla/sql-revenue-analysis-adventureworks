--Perguntas de negócio
--1.	Quem são os 10 clientes que mais faturaram?
--2.	Qual o ticket médio por cliente?

SELECT TOP 10
	SSOH.CustomerID,
	PP.FirstName + ' ' + PP.LastName AS NOME_COMPLETO,
	SUM(SSOH.TotalDue) AS TOTAL_FATURADO,
	SUM(SSOH.TotalDue) / COUNT(SSOH.SalesOrderID) AS TICKET_MEDIO
FROM Sales.SalesOrderHeader AS SSOH
	JOIN Sales.Customer SC ON SC.CustomerID = SSOH.CustomerID
	JOIN Person.Person PP ON SC.PersonID = PP.BusinessEntityID
GROUP BY SSOH.CustomerID, PP.FirstName, PP.LastName
ORDER BY TOTAL_FATURADO DESC;

--3.	Qual o faturamento total da base?

SELECT 
	ROUND(SUM(TotalDue) , 2) AS FATURAMENTO_TOTAL
FROM Sales.SalesOrderHeader;

--4.	Quanto os Top 10 representam (%) do total?

SELECT (
	SUM(SOMA_PEDIDOS) * 100) / 
	(SELECT 
		SUM(TotalDue)
		FROM Sales.SalesOrderHeader
	)
	 AS PERCENTUAL_TOP
FROM (
SELECT TOP 10
	CustomerID ,
	SUM(TotalDue) AS SOMA_PEDIDOS
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY SOMA_PEDIDOS DESC)
AS BASE;

--5.	Quantos clientes fizeram apenas 1 pedido?

SELECT COUNT(*) AS QTD_CLIENTES_UNICO_PEDIDO

FROM (
	SELECT CustomerID
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
		HAVING COUNT(SalesOrderID) = 1
) AS BASE ;

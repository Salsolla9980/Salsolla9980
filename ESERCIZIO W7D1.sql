use AdventureWorksDW;

#PUNTO 1
#voglio verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
#Per capire se è una chiave primaria innanzitutto deve essere unica per ogni riga e deve essere not null
#innanzitutto possiamo vedere la definizione della tabella o la descrizione della tabella
show create table dimproduct;
describe dimproduct;
#per vedere se ci sono duplicati o valori null faccio in questo modo
select count(*)
from dimproduct
where ProductKey is null;

SELECT distinct ProductKey, COUNT(ProductKey) as NoProductKey
FROM dimproduct 
GROUP BY ProductKey
Having COUNT(ProductKey) > 1;

#PUNTO 2
#voglio verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK
#posso verificare la definizione della tabella o la descrizione della tabella
show create table factresellersales;
describe factresellersales;
#per vedere se ci sono valori null
select count(*)
from factresellersales
where SalesOrderNumber is null OR SalesOrderLineNumber is null;
#per vedere se i due attributi sono unici
SELECT SalesOrderNumber, SalesOrderLineNumber, COUNT(SalesOrderNumber AND SalesOrderLineNumber) as NoOrder
FROM factresellersales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING COUNT(SalesOrderNumber AND SalesOrderLineNumber) > 1;
#da qui posso vedere che entrambe le entità SalesOrderNumber e SalesOrderLineNumber se sono da sole 
-- non possono essere chiavi primarie perchè ci sono duplicati; invece insieme formano una riga unica e quindi una chiave primaria

#PUNTO 3
#Conta il numero transazioni SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020
SELECT SalesOrderNumber, SalesOrderLineNumber, OrderDate, COUNT(SalesOrderNumber AND SalesOrderLineNumber) as NumeroSales FROM factresellersales
Group By SalesOrderNumber, SalesOrderLineNumber, OrderDate
HAVING OrderDate >= '2020-01-01';

#PUNTO 4
#Calcola il fatturato totale SalesAmount, la quantità totale venduta OrderQuantity 
#e il prezzo medio di vendita UnitPrice per prodotto a partire dal 1 Gennaio 2020.
select 
	P.ProductKey, 
	P.EnglishProductName, 
	SUM(V.SalesAmount) as TotalSales, 
	SUM(V.OrderQuantity) as TotalQuantity, 
    ROUND(AVG(V.UnitPrice),2) as AVGPrice, 
    V.OrderDate
from dimproduct P
join factresellersales V on P.productkey = V.productkey
where V.OrderDate >= '2020-01-01'
group by P.ProductKey
order by TotalSales DESC;

#PUNTO 5
#Calcola il fatturato totale (SalesAmount) e la quantità totale venduta (OrderQuantity) per Categoria prodotto(DimProductCategory). 
select C.EnglishProductCategoryName, SUM(V.SalesAmount) as TotaleVendite, SUM(V.OrderQuantity) as TotaleQuantità
from dimproduct P
join dimproductsubcategory S on P.productsubcategorykey = S.productsubcategorykey
join dimproductcategory C on S.ProductCategorykey = C.productcategorykey
join factresellersales V on P.ProductKey = V.ProductKey
group by C.EnglishProductCategoryName;

#PUNTO 5
#Calcola il fatturato totale per CITTà(City) realizzato a partire dal 1 Gennaio 2020 con fatturato realizzato superiore a 60K.
select V.ProductKey, G.City, SUM(V.SalesAmount) AS TotalSales, V.OrderDate
from factresellersales V
join dimreseller R on V.ResellerKey = R.ResellerKey
join dimgeography G on R.GeographyKey = G.GeographyKey
where V.OrderDate >= '2020-01-01'
GROUP BY G.City
HAVING SUM(V.SalesAmount) > 60000
ORDER BY TotalSales DESC;

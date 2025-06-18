#voglio vedere gli attributi sia di dimproduct sia di dimproductsubcategory per capire quale campo è in comune
select * from dimproduct;
select * from dimproductsubcategory;

#per mostrare tutti i prodotti e la rispettiva sottocategoria faccio una inner join selezionando soltanto i campi che mi interessano
select P.ProductKey, P.ProductAlternateKey, P.EnglishProductName, P.StandardCost, P.FinishedGoodsFlag, P.ListPrice, S.ProductSubcategoryKey, S.EnglishProductSubcategoryName
from dimproduct P
join dimproductsubcategory S on P.productsubcategorykey = S.productsubcategorykey;

#voglio vedere il campo in comune della categoria con la sottocategoria oppure con i prodotti
select * from dimproductcategory;

#per mostrare tutti i prodotti e la rispettiva categoria e sottocategoria faccio una inner join selezionando soltanto i campi che mi interessano facendo attenzione che la categoria è legata con subcategoria e non con prodotti
select P.ProductKey, P.ProductAlternateKey, P.EnglishProductName, P.StandardCost, P.FinishedGoodsFlag, P.ListPrice, S.ProductSubcategoryKey, S.EnglishProductSubcategoryName, C.ProductCategoryKey, C.EnglishProductCategoryName
from dimproduct P
join dimproductsubcategory S on P.productsubcategorykey = S.productsubcategorykey
join dimproductcategory C on S.ProductCategorykey = C.productcategorykey;

#vedo nell'entità delle vendite quali sono le entità per capire il campo in comune con i prodotti
select * from factresellersales;

#voglio mostrare l'elenco dei prodotti che sono stati venduti (dunque con alcune condizioni specifiche sotto riportate con where)
select P.ProductKey, P.ProductAlternateKey, P.EnglishProductName, P.FinishedGoodsFlag, V.SalesOrderNumber, V.OrderDate, V.OrderQuantity, V.UnitPrice, V.TotalProductCost, V.SalesAmount
from dimproduct P
join factresellersales V on P.productkey = V.productkey
where P.FinishedGoodsFlag = 1 AND V.OrderQuantity >= 1 AND V.SalesAmount > 0;

#voglio vedere l'elenco dei prodotti FINITI ma non venduti
#seleziono i prodotti che sono stati venduti con la query righe 30 e 31
#con una subquery gli chiedo di mostrarmi i prodotti finiti che non sono presenti nella query precedente (che contiene appunto i prodotti venduti)
select distinct ProductKey
from factresellersales;

select distinct P.ProductKey, P.EnglishProductName, P.FinishedGoodsFlag
from dimproduct P
where P.FinishedGoodsFlag = 1 AND P.ProductKey NOT IN (select distinct ProductKey
from factresellersales);

# voglio vedere le transazioni di vendita indicando anche il nome del prodotto venduto
select P.ProductKey, P.EnglishProductName, P.FinishedGoodsFlag, V.SalesOrderNumber, V.OrderDate, V.OrderQuantity, V.UnitPrice, V.TotalProductCost, V.SalesAmount
from dimproduct P
join factresellersales V on P.productkey = V.productkey
where P.FinishedGoodsFlag = 1 AND V.OrderQuantity >= 1 AND V.SalesAmount > 0;

# voglio vedere lʼelenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.
select P.ProductKey, P.EnglishProductName, P.FinishedGoodsFlag, S.EnglishProductSubcategoryName, C.EnglishProductCategoryName, V.SalesOrderNumber, V.OrderDate, V.OrderQuantity, V.UnitPrice, V.TotalProductCost, V.SalesAmount
from dimproduct P
join dimproductsubcategory S on P.productsubcategorykey = S.productsubcategorykey
join dimproductcategory C on S.ProductCategorykey = C.productcategorykey
join factresellersales V on P.ProductKey = V.ProductKey;

# esploriamo la tabella dimreseller
select * from dimreseller;
# esploriamo la tabella dimgeography
select * from dimgeography;

#mostriamo l'elenco dei reseller con la relativa area geografica
select R.ResellerKey, R.ResellerAlternateKey, R.Phone, R.BusinessType, R.ResellerName, R.ProductLine, R.AnnualSales, R.AnnualRevenue, R.YearOpened, G.City, G.StateProvinceName, G.EnglishCountryRegionName, G.PostalCode
from dimreseller R
join dimgeography G on R.GeographyKey = G.GeographyKey;

#Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
#Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e lʼarea geografica.
select P.ProductKey, P.EnglishProductName, P.FinishedGoodsFlag, S.EnglishProductSubcategoryName, C.EnglishProductCategoryName, V.SalesOrderNumber, V.OrderDate, V.OrderQuantity, V.UnitPrice, V.TotalProductCost, V.SalesAmount, R.ResellerName, R.BusinessType, R.ProductLine, R.AnnualSales, R.AnnualRevenue, R.YearOpened, G.City, G.StateProvinceName, G.EnglishCountryRegionName, G.PostalCode
from dimproduct P
join dimproductsubcategory S on P.productsubcategorykey = S.productsubcategorykey
join dimproductcategory C on S.ProductCategorykey = C.productcategorykey
join factresellersales V on P.ProductKey = V.ProductKey
join dimreseller R on V.ResellerKey = R.ResellerKey
join dimgeography G on R.GeographyKey = G.GeographyKey;
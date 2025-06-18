#ho selezionato il db AdventureWorksDW come "Default Schema" e esplorato tutte le entità della tabella "dimproduct" con la query qui di sotto
select * from dimproduct;

#ho interrogato la tabella per mostrare soltanto le entità che indicava la traccia
select  ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag from dimproduct;

#ho fatto un passaggio in più per mostrare che ho usato un alias per finishedgoodflags come "FGF"
select  ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag as FGF from dimproduct;

#ho interrogato la tabella in modo tale che si mostrassero soltanto i prodotti finiti ponendo come condizione FGF = 1
select  ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag as FGF from dimproduct where FinishedGoodsFlag = 1;

#ho interrogato la tabella, usando un alias per ProductAlternateKey come "Model", in modo tale che si mostrassero solo i prodotti che hanno il modello che inizia con "FR" o "BK" e ho inserito l'entità ListPrice
select  ProductKey, ProductAlternateKey as Model, EnglishProductName, StandardCost, ListPrice from dimproduct where ProductAlternateKey like 'FR%' or ProductAlternateKey like 'BK%';

#per la stessa tabella di prima la traccia chiede di mostrare il Markup, dunque ho usato un campo calcolato dato dalla sottrazione tra ListPrice e StandardCost che ho appunto chiamato "Markup"
select  ProductKey, ProductAlternateKey as Model, EnglishProductName, StandardCost, ListPrice, ListPrice - StandardCost as Markup from dimproduct where ProductAlternateKey like 'FR%' or ProductAlternateKey like 'BK%';

#ho interrogato la tabella in modo tale che si mostrassero solo i prodotti finiti (quindi FGF = 1) il cui prezzo di listino è compreso tra 1000 e 2000
select  ProductKey, ProductAlternateKey as Model, EnglishProductName, StandardCost, ListPrice, ListPrice - StandardCost as Markup, FinishedGoodsFlag from dimproduct where (ListPrice >1000 AND ListPrice <2000) AND (ProductAlternateKey like 'FR%' or ProductAlternateKey like 'BK%') and (FinishedGoodsFlag = 1);
#oppure in alternativa
select  ProductKey, ProductAlternateKey as Model, EnglishProductName, StandardCost, ListPrice, ListPrice - StandardCost as Markup, FinishedGoodsFlag from dimproduct where (ListPrice BETWEEN 1000 AND 2000) AND (ProductAlternateKey like 'FR%' or ProductAlternateKey like 'BK%') and (FinishedGoodsFlag = 1);

#ho esplorato tutte le entità della tabella "dimemployee"
select * from dimemployee;

#ho interrogato la tabella in modo tale che mi mostrasse soltanto gli agenti (gli agenti sono dati dove il campo SalesPersonFlag è uguale a 1)
select * from dimemployee where SalesPersonFlag = 1;

#ho esplorato tutte le entità della tabella "factresellersales"
select * from factresellersales;

#ho interrogato la tabella in modo che mi mostrasse le transazioni registrate dal primo Gennaio 2020 e soltanto per i prodotti che hanno il codice 597, 598, 477, 214
select * from factresellersales where (OrderDate > '2020-01-01') AND (ProductKey in (597, 598, 477, 214));

#ho deciso di scegliere solo alcune entità per svolgere l'ultimo punto della traccia che chiede il profitto, dunque ho inserito un campo calcolato dato dalla sottrazione tra SalesAmount e TotalProductCost che ho chiamato "Markup"
select SalesOrderNumber, OrderDate, ProductKey, OrderQuantity, UnitPrice, TotalProductCost, SalesAmount, SalesAmount - TotalProductCost as Markup from factresellersales where (OrderDate > '2020-01-01') AND (ProductKey in (597, 598, 477, 214));
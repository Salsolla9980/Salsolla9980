#PER PRIMA COSA ANDIAMO A CREARE UN DATABASE COL NOME TOYS GROUP
CREATE DATABASE ToysGroup;

USE ToysGroup;

# ADESSO VADO A CREARE UNA TABELLA CHE CONTIENE I PRODOTTI DELL'AZIENDA
CREATE TABLE Product (
ProductID INT AUTO_INCREMENT PRIMARY KEY,
ProductName VARCHAR (50),
Price DECIMAL (10,2),
CategoryID INT,
CategoryName VARCHAR (25)
);

#QUI ANDIAMO AD INSERIRE LE REGIONI DOVE TOYSGROUP VENDE I PRORPI PRODOTTI
CREATE TABLE Region (
RegionID INT AUTO_INCREMENT PRIMARY KEY,
RegionName VARCHAR (50)
);
# qui andiamo a creare una tabella che contiene GLI STATI in cui l'azienda vende
CREATE TABLE State (
StateID INT AUTO_INCREMENT PRIMARY KEY,
StateName VARCHAR (50),
RegionID INT,
FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);
# ora creiamo una tabella che contiene le vendite di ogni prodotto, in modo che productID e stateID siano FOREIGN KEY
CREATE TABLE Sales (
SalesID INT AUTO_INCREMENT PRIMARY KEY,
ProductID INT,
StateID INT,
SaleDate DATE,
Quantity INT,
TotalAmount DECIMAL (10,2),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
FOREIGN KEY (StateID) REFERENCES State(StateID)
);
# adesso andiamo a creare dei veri e propri prodotti così che la tabella abbia un vero senso
INSERT INTO Product (ProductName, Price, CategoryID, CategoryName)
VALUES
  ('Smartphone Android', 399.99, 1, 'Elettronica'),
  ('Bicicletta da Corsa', 499.99, 2, 'Sport'),
  ('Tostapane Elettrico', 29.99, 3, 'Casa e Cucina'),
  ('Puzzle 1000 pezzi', 19.99, 4, 'Giocattoli'),
  ('Romanzo di Fantascienza', 12.99, 5, 'Libri'),
  ('Cuffie Wireless', 69.99, 6, 'Musica'),
  ('Kit di Pittura', 39.99, 7, 'Arte e Creatività'),
  ('Maglione di Lana', 49.99, 8, 'Abbigliamento'),
  ('Orologio da Polso', 99.99, 9, 'Accessori'),
  ('Laptop Gaming', 999.99, 10, 'Informatica'),
  ('Tablet Android', 299.99, 1, 'Elettronica'),
  ('Tuta da Sci', 79.99, 2, 'Sport'),
  ('Frullatore Elettrico', 49.99, 3, 'Casa e Cucina'),
  ('Lego City', 49.99, 4, 'Giocattoli'),
  ('Dizionario Inglese', 19.99, 5, 'Libri');

#qui andiamo ad inserire la regionName  
  INSERT INTO Region (RegionName)
VALUES
  ('Sud Europa'),
  ('Centro Europa'),
  ('Nord Ovest'),
  ('Est Europa'),
  ('Sud Ovest'),
  ('Nord Est'),
  ('Isole'),
  ('Europa Atlantica'),
  ('Nord Europa'),
  ('Sud Est');

#qua invece ci mettiamo gli stati 
INSERT INTO State (StateName, RegionID)
VALUES
  ('Italia', 1),
  ('Toscana', 2),
  ('Ungheria', 3),
  ('Belgio', 4),
  ('Austria', 5),
  ('Lettonia', 6),
  ('Croazia', 7),
  ('Scozia', 8),
  ('Andalusia', 9),
  ('Svizzera', 10),
  ('Finlandia', 1),
  ('Lussemburgo', 4),
  ('Serbia', 3),
  ('Malta', 2),
  ('Liechtenstein', 5);
  
  
  INSERT INTO Sales (ProductID, StateID, SaleDate, Quantity, TotalAmount)
VALUES
  (2, 3, '2024-03-20', 15, 299.85),
  (10, 12, '2024-04-15', 30, 569.70),
  (15, 7, '2024-05-10', 20, 895.00),
  (1, 1, '2025-01-05', 8, 239.92),
  (2, 2, '2025-02-12', 12, 239.88),
  (3, 3, '2025-03-18', 5, 124.95),
  (4, 4, '2025-04-22', 6, 239.94),
  (5, 7, '2024-11-25', 15, 749.85),
  (5, 5, '2025-05-01', 8, 399.92),
  (6, 6, '2025-06-18', 4, 139.96),
  (7, 7, '2025-07-12', 11, 307.89),
  (8, 8, '2025-08-15', 6, 137.94),
  (9, 9, '2025-09-20', 3, 194.99),
  (10, 10, '2025-10-01', 5, 94.95),
  (11, 11, '2025-11-10', 6, 131.94),
  (12, 12, '2025-12-12', 14, 237.86),
  (13, 13, '2024-09-15', 10, 285.00),
  (14, 14, '2024-10-20', 9, 332.10),
  (15, 15, '2024-11-25', 5, 223.75);
 
 #controlliamo adesso che le chavi primarie date siano assolutamente univoche
 show create table Region;
describe Region;
select count(*)
from Region
where RegionID is null;

  #Se il risultato restituisce 0, significa che la PK è univoca e stiamo procedendo bene
SELECT distinct RegionID, COUNT(RegionID) as N°RegionID
FROM Region 
GROUP BY RegionID
Having COUNT(RegionID) > 1;

show create table State;
describe State;
select count(*)
from State
where StateID is null;

#lo stesso procedimento va fatto anche con StateID
SELECT distinct StateID, COUNT(StateID) as N°StateID
FROM State 
GROUP BY StateID
Having COUNT(StateID) > 1;

show create table Sales;
describe Sales;
select count(*)
from Sales
where SalesID is null;

#e anche qui
SELECT distinct SalesID, COUNT(SalesID) as N°SalesID
FROM Sales 
GROUP BY SalesID
Having COUNT(SalesID) > 1;

/*ora vedremo l'elenco delle transazioni, creando un campo booleano dato
dalla condizione che siano passati più giorni dalla data della vendita, o di meno*/
SELECT V.SalesID, 
V.SaleDate, 
P.ProductName, 
P.CategoryName, 
S.StateName, 
R.RegionName, 
IF(DATEDIFF('2024-10-05', V.SaleDate) > 180, 'Yes', 'No') AS 180Giorni_DaDataDiVendita
FROM Sales V
JOIN Product P ON V.ProductID = P.ProductID
JOIN State S ON V.StateID = S.StateID
JOIN Region R ON S.RegionID = R.RegionID;

/* La traccia ci chiede di 
Esporre l’elenco dei prodotti che hanno venduto, 
in totale, una quantità maggiore della media 
delle vendite realizzate nell’ultimo anno censito.*/
 
SELECT MAX(YEAR(SaleDate)) AS UltimoAnnoCensito
FROM Sales;

#Ora calcoliamo la media nell'ultimo anno
SELECT AVG(Quantity) AS MediaQuantitàVenduta
FROM Sales
WHERE YEAR(SaleDate) = (SELECT MAX(YEAR(SaleDate)) AS UltimoAnnoCensito FROM Sales);

# ora esponiamo l'elenco dei prodotti venduti che hanno una quantità maggiore della media del venduto
SELECT P.ProductID, 
P.ProductName, 
SUM(S.Quantity) AS Totale_Venduto
FROM Sales S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.ProductID
HAVING Totale_Venduto > (SELECT AVG(Quantity) AS MediaQuantitàVenduta
FROM Sales
WHERE YEAR(SaleDate) = (SELECT MAX(YEAR(SaleDate)) AS UltimoAnnoCensito FROM Sales));


SELECT P.ProductID, 
P.ProductName, 
SUM(V.TotalAmount) AS FatturatoTotale, 
YEAR(V.SaleDate) AS Anno
FROM Product P
JOIN Sales V ON P.ProductID = V.ProductID
GROUP BY P.ProductID, P.ProductName, YEAR(V.SaleDate);

/*Esporre il fatturato totale per stato per anno. 
Ordina il risultato per data e per fatturato decrescente.*/
SELECT SUM(V.TotalAmount) AS FatturatoTotale, S.StateName, YEAR(V.SaleDate) AS Anno
FROM Sales V
JOIN State S ON V.StateID = S.StateID
GROUP BY  S.StateName, YEAR(V.SaleDate)
ORDER BY Anno DESC, FatturatoTotale DESC;

#qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT P.CategoryName, SUM(V.Quantity) AS QuantitàTotaliVendutePerProdotto
FROM Sales V
JOIN Product P ON V.ProductID = P.ProductID
GROUP BY P.CategoryName
ORDER BY QuantitàTotaliVendutePerProdotto DESC
LIMIT 1;

#quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
#Primo approccio risolutivo
SELECT P.CategoryName
FROM Product P 
JOIN Sales V ON P.ProductID = V.ProductID
WHERE V.Quantity = (SELECT  MAX(V.Quantity) AS QuantitàVendutaMaggiormente
FROM Sales V);

#quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
#Secondo approccio più facile veloce ed intuitivo
SELECT P.ProductID
FROM Product P 
LEFT JOIN Sales V ON P.ProductID = V.ProductID
WHERE V.ProductID IS NULL;

/*Prima ho saltato un passaggio per ProductID quando ho fatto il procedimento per controllare se le chavi primarie
 ovvero PK fossero univoque, ma posso ancora farlo tranquillamente e controllare
 se effettivamnete la PrimaryKey è univoca*/
show create table Product;
describe Product;

select count(*)
from Product
where ProductID is null;

 SELECT distinct ProductID, COUNT(ProductID) as N°ProductID
FROM Product 
GROUP BY ProductID
Having COUNT(ProductID) > 1;

/*Come ho appena detto un procedimento mancato 
può essere recuperato successivamente senza alcun problema
e in effetti la chiave primaria è univoca*/
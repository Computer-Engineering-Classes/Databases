use master;

CREATE DATABASE Biblioteca;
USE Biblioteca;
/*
IF OBJECT_ID('Aluno', 'U') IS NOT NULL 
BEGIN
PRINT 'Table Aluno already exists.';
END
*/
CREATE TABLE Aluno(
	Numero		INTEGER		NOT NULL, -- PRIMARY KEY
	Nome		VARCHAR(50) NOT NULL,
	Garantia	MONEY		NOT NULL DEFAULT 0,
	End_Morada	VARCHAR(50)	NOT NULL,
	End_CP		CHAR(8)		NOT NULL,
	End_Local	VARCHAR(50)	NOT NULL,
	PRIMARY KEY (Numero),
	CHECK (Garantia >= 0)
);

CREATE TABLE Livro(
	Numero		INTEGER		NOT NULL,
	Titulo		VARCHAR(50)	NOT NULL,
	Autor		VARCHAR(50) NOT NULL,
	Editor		VARCHAR(50)	NOT NULL,
	Data_Compra DATE		NOT NULL,
	Estado		BIT			NOT NULL DEFAULT 0,	
	PRIMARY KEY (Numero)
);

CREATE TABLE Emprestimo(
	Num_Al	  INTEGER	NOT NULL,
	Num_Liv	  INTEGER	NOT NULL,
	Data_Req  DATETIME	NOT NULL DEFAULT GETDATE(),
	Data_Ent  DATETIME,
	PRIMARY KEY (Num_Al, Num_Liv, Data_Req),
	FOREIGN KEY (Num_Al)  REFERENCES Aluno(Numero),
	FOREIGN KEY (Num_Liv) REFERENCES Livro(Numero),
	CHECK (Data_Ent > Data_Req)
);

INSERT INTO Aluno
VALUES (70633, 'Diogo António Costa Medeiros', 20, 'Rua Santo António 25', '5000-607', 'Vila Real');

INSERT INTO Aluno
VALUES (70579, 'João Henrique Constâncio Rodrigues', 30, 'Rua Santo António 25', '5000-607', 'Vila Real');

DELETE FROM Aluno
WHERE End_Local = 'Vila Real';

UPDATE Aluno 
SET Garantia = 10
WHERE Numero = 70633;

SELECT * FROM Aluno;

INSERT INTO Livro
VALUES
(1001, 'Lord Of The Rings', 'J.R.R. Tolkien', 'Porto Editora', '2021/04/15', 0),
(1002, 'Harry Potter: The Prisoner of Azkaban', 'J.K. Rowling', 'Editorial Presença', '2021/04/15', 0),
(1003, 'Umbrella Academy Volume 3: Hotel Oblivion', 'Gerard Way', 'Dark Horse Books', '2021/04/15', 0);

SELECT * FROM Livro;

INSERT INTO Emprestimo(Num_Al, Num_Liv, Data_Req)
VALUES
(70633, 1003, '2021/04/15'),
(70579, 1002, '2021/04/15');

SELECT * FROM Emprestimo;
-- Ficha Pratica No. 5 
-- Exercicio 1 - BIBLIOTECA
-- Correccao Proposta
--
-- SQL para Microsoft SQL Server
-- --------------------------------
-- Paulo Martins (pmartins@utad.pt)
-- --------------------------------

-- CRIACAO DA BASE DE DADOS (a)
USE master
GO

CREATE DATABASE Biblioteca
GO

-- CRIACAO DAS TABELAS (b)
USE Biblioteca
GO

CREATE TABLE Aluno(
	Numero_Mecanografico	INTEGER		NOT NULL,
	Nome					VARCHAR(50) NOT NULL,
	Endereco_Morada			VARCHAR(50) NOT NULL,
	Endereco_Localidade		VARCHAR(50) NOT NULL,
	Endereco_CodigoPostal	CHAR(8)		NOT NULL,
	Garantia				MONEY		NOT NULL DEFAULT 0,
	CHECK (Numero_Mecanografico > 0), 
	CHECK (Endereco_CodigoPostal LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	CHECK (Garantia >= 0), 
	PRIMARY KEY (Numero_Mecanografico)
)

CREATE TABLE Livro(
	Numero		INTEGER			NOT NULL IDENTITY(1,1),
	Titulo 		VARCHAR(50)		NOT NULL,
	Autor		VARCHAR(50)		NOT NULL,
	Editor		VARCHAR(50)		NOT NULL,
	Data_Compra	SMALLDATETIME	NOT NULL DEFAULT GETDATE(), 
	Estado		BIT				NOT NULL DEFAULT 0,
	-- estado pode ser: requisitado (´1´) ou nao requisitado (´0´)
	PRIMARY KEY (Numero)
)

CREATE TABLE Emprestimo(
	Numero_Mecanografico	INTEGER			NOT NULL,
	Numero					INTEGER			NOT NULL,
	Data_Requisicao			SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	Data_Entrega			SMALLDATETIME,
	CHECK (Data_Entrega > Data_Requisicao),
	PRIMARY KEY (Numero_Mecanografico, Numero, Data_Requisicao),
	FOREIGN KEY (Numero_Mecanografico) REFERENCES Aluno(Numero_Mecanografico),
	FOREIGN KEY (Numero) REFERENCES Livro(Numero)
)
GO
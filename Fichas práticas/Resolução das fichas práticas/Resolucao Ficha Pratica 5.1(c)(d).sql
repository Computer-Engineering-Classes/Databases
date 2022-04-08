-- Ficha Pratica No. 5 
-- Exercicio 1 - BIBLIOTECA
-- Correccao Proposta
--
-- SQL para Microsoft SQL Server
-- --------------------------------
-- Paulo Martins (pmartins@utad.pt)
-- --------------------------------

-- REMOCAO DAS TABELAS (c)
USE Biblioteca
GO

-- Errado!!!
DROP TABLE Livro

-- Errado!!!
DROP TABLE Aluno

DROP TABLE Emprestimo
DROP TABLE Livro
DROP TABLE Aluno
GO

-- REMOCAO DA BASE DE DADOS (d)
USE master
GO

--Caso surga a mensagem "Cannot drop database "Biblioteca" because it is currently in use.", deve executar o seguinte código antes do comando "DROP DATABASE Biblioteca":
--ALTER DATABASE biblioteca SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--GO

DROP DATABASE Biblioteca
GO
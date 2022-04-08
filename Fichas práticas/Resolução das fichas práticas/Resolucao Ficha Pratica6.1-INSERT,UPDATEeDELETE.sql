-- Ficha Pratica No. 6
-- Exercicio 1 - BIBLIOTECA
-- Correccao Proposta
--
-- SQL para Microsoft SQL Server
-- -------------------------------------------------------------------------
-- Paulo Martins (pmartins@utad.pt) & Daniel Alexandre (daniel@utad.pt)
-- -------------------------------------------------------------------------

-- INSERCAO DE DADOS (a)
USE Biblioteca
GO

INSERT INTO Aluno(Numero_Mecanografico, Nome, Endereco_Morada, Endereco_Localidade, Endereco_CodigoPostal, Garantia)
VALUES (5757, 'Manuel Silva', 'Rua Nova de Baixo, n.º 1', 'Vila Real', '5000-408', 5)

INSERT INTO Livro(Titulo, Autor, Editor, Data_Compra, Estado)
VALUES ('SQL - Structured Query Language', 'Luís Damas', 'FCA - Editora Informática', '01 Feb 2018', 0)

-- Início requisição de livro

INSERT INTO Emprestimo(Numero_Mecanografico, Numero, Data_Requisicao, Data_Entrega)
VALUES (5757, 1, '02 Feb 2018', NULL)

SELECT * FROM Aluno

SELECT * FROM Livro

SELECT * FROM Emprestimo

-- ACTUALIZACAO DE DADOS (b)
USE Biblioteca
GO

UPDATE Livro
SET Estado = 1
WHERE Numero = 1

-- Fim requisição de livro

-- Início entrega de livro

UPDATE Emprestimo
SET Data_entrega = GETDATE()
WHERE Numero_Mecanografico = 5757 AND Numero = 1 AND Data_Requisicao = '02 Feb 2018'

UPDATE Livro
SET Estado = 0
WHERE Numero = 1

-- Fim entrega de livro

-- REMOCAO DE DADOS (c)
USE Biblioteca
GO

-- Errado!!!
DELETE FROM Aluno
WHERE Numero_Mecanografico = 5757

-- Errado!!!
DELETE FROM Livro
WHERE Numero = 1

-- Correcto
DELETE FROM Emprestimo
WHERE Numero_Mecanografico = 5757 AND Numero = 1 AND Data_Requisicao = '02 Feb 2018'

DELETE FROM Aluno
WHERE Numero_Mecanografico = 5757

DELETE FROM Livro
WHERE Numero = 1
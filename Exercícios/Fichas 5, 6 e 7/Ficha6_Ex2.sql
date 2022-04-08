-- 1

SELECT * 
FROM Autor;

-- 2

SELECT * 
FROM Autor 
WHERE Pseudonimo IS NOT NULL;

-- 3

SELECT COUNT(*) as 'NoLivros' 
FROM Livro;

-- 4

SELECT COUNT(*) as 'NoLivros por Manuel Antonio'  
FROM Escrever, Autor 
WHERE Escrever.Cod_Autor = Autor.Cod_Autor 
AND Nome = 'Manuel' AND Apelido = 'António';

-- 5 [Titulo, Quantidade, Data]

SELECT Titulo, Quantidade, Data_Compra
FROM Livro, Livreiro, Comprar
WHERE Comprar.Cod_Livreiro = Livreiro.Cod_Livreiro
AND Comprar.ISBN = Livro.ISBN 
AND Livreiro.Nome = 'O Meu Livreiro';

-- 6 [Nome, Apelido]

SELECT DISTINCT Autor.Nome, Apelido
FROM Autor, Livro, Livreiro, Comprar, Escrever
WHERE Livreiro.Nome = 'O Meu Livreiro'
AND Livreiro.Cod_Livreiro = Comprar.Cod_Livreiro
AND Comprar.ISBN = Livro.ISBN
AND Livro.ISBN = Escrever.ISBN
AND Escrever.Cod_Autor = Autor.Cod_Autor;

-- 7

SELECT SUM(Escrever.Royalty * Preco_Venda * Quantidade) as Royalties
FROM Autor, Livro, Escrever, Comprar
WHERE Nome = 'Manuel' AND Apelido = 'António'
AND Autor.Cod_Autor = Escrever.Cod_Autor
AND Comprar.ISBN = Escrever.ISBN
AND Livro.ISBN = Comprar.ISBN;

-- 8

SELECT DISTINCT Livreiro.Nome
FROM Livreiro, Autor, Livro, Comprar, Escrever
WHERE Livreiro.Cod_Livreiro = Comprar.Cod_Livreiro
AND Comprar.ISBN = Livro.ISBN
AND Livro.ISBN = Escrever.ISBN
AND Escrever.Cod_Autor = Autor.Cod_Autor
AND Autor.Nome = 'Manuel' AND Apelido = 'António';

-- 9

SELECT DISTINCT Livreiro.Nome
FROM Livreiro, Livro, Comprar
WHERE Livreiro.Cod_Livreiro = Comprar.Cod_Livreiro
AND Comprar.ISBN = Livro.ISBN AND Titulo = 'Bases de Dados';

-- 10

SELECT Livro.ISBN, Titulo, Nome, Apelido
FROM Livro, Autor, Escrever
WHERE Livro.ISBN = Escrever.ISBN
AND Escrever.Cod_Autor = Autor.Cod_Autor
ORDER BY Titulo, Apelido;

-- 11

SELECT Livro.ISBN, Titulo, Total
FROM Livro, 
    -- Agrupa os livros pela quantidade total
    (SELECT ISBN, SUM(Quantidade) as Total
     FROM Comprar
     GROUP BY ISBN) SQ1,
    -- Seleciona o livro com a quantidade maxima
    (SELECT MAX(Total) as Maximo
     FROM (SELECT ISBN, SUM(Quantidade) as Total
           FROM Comprar
           GROUP BY ISBN) SQ1) SQ2
WHERE SQ1.Total = SQ2.Maximo
AND Livro.ISBN = SQ1.ISBN;

-- 12

SELECT  Nome as Livreiro, L.ISBN, L.Titulo, Maximo
FROM Livro L, Livreiro,
    -- Agrupa os livros por total e livreiro
    (SELECT Cod_Livreiro, ISBN, SUM(Quantidade) as Total
     FROM Comprar
     GROUP BY Cod_Livreiro, ISBN) SQ1,
	 -- Seleciona o total maximo por livreiro
	(SELECT MAX(Total) as Maximo, Cod_Livreiro
	 FROM (SELECT Cod_Livreiro, ISBN, SUM(Quantidade) as Total
		   FROM Comprar
           GROUP BY Cod_Livreiro, ISBN) SQ1 
	       GROUP BY Cod_Livreiro) SQ2
WHERE L.ISBN = SQ1.ISBN
AND SQ1.Total = SQ2.Maximo
AND SQ2.Cod_Livreiro = SQ1.Cod_Livreiro
AND SQ2.Cod_Livreiro = Livreiro.Cod_Livreiro;

select *
from Livro
select *
from Livreiro
select *
from Comprar
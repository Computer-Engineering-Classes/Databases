
-- (a) Quais os alunos inscritos na biblioteca?

SELECT * 
FROM Aluno;

-- (b) Quais os alunos inscritos na biblioteca cujo nome começa por "João"?

SELECT * 
FROM Aluno 
WHERE Nome LIKE 'João%';

-- (c) Qual o nome dos alunos com uma garantia igual ou superior a 10 Euros?

SELECT Nome 
FROM Aluno 
WHERE Garantia >= 10;

-- (c2) Qual o nome dos alunos com uma garantia entre 5 e 15 Euros?

SELECT Nome 
FROM Aluno 
WHERE Garantia BETWEEN 5 AND 15;

-- (d) Quais os livros existentes na biblioteca?

SELECT * 
FROM Livro;

-- (e) Qual o título dos livros escritos pelo autor com o nome "Manuel António"?

SELECT Titulo, Autor 
FROM Livro 
WHERE Autor = 'Manuel António';

-- (f) Qual o estado dos livros que contêm "Bases de Dados" no título?

SELECT Titulo, Estado 
FROM Livro 
WHERE Titulo LIKE '%Bases de Dados%';

-- (g) Qual o valor em caixa da biblioteca fruto das garantias dos alunos?

SELECT SUM(Garantia) AS 'Valor em caixa' 
FROM Aluno;

-- (h) Quais os livros requisitados pelo aluno "João Pedro"?

SELECT Titulo, Autor 
FROM Emprestimo, Livro, Aluno 
WHERE Num_Liv = Livro.Numero 
AND Num_Al = Aluno.Numero 
AND Nome = 'João Pedro';

-- (i) Quantos livros foram requisitados no dia "22-05-2004"?

SELECT COUNT(*) AS 'Livros requisitados a 22-05-2004' 
FROM Emprestimo 
WHERE Data_Req LIKE '2004-05-22%';

-- (j) Quantos livros estão requisitados a mais de 5 dias?

SELECT COUNT(*) AS 'N.º livros req. >= 5 dias' 
FROM Emprestimo 
WHERE DATEDIFF(DAY, Data_Req, GETDATE()) > 5;

-- (k) Quantos livros requisitou o aluno com o número "16954"?

SELECT COUNT(*) AS 'Total livros req. pelo aluno n.º 16954' 
FROM Emprestimo 
WHERE Num_Al = 16954;

-- (l) Quantos livros foram requisitados?

SELECT COUNT(DISTINCT(Num_Liv)) as 'N.º de livros requisitados' 
FROM Emprestimo;

-- (m) Qual o primeiro livro requisitado?

SELECT Titulo, Autor, Data_Req 
FROM Livro, Emprestimo 
WHERE Num_Liv = Numero 
ORDER BY Data_Req ASC;
-- OU
SELECT Titulo, Autor, Data_Req 
FROM Livro, Emprestimo 
WHERE Num_Liv = Numero 
AND Data_Req IN (SELECT Min(Data_Req) 
				FROM Emprestimo);
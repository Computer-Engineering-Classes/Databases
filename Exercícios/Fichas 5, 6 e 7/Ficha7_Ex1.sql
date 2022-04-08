-- (i) Quando o sistema entra em funcionamento valide a sua consist�ncia e caso tal n�o se verifique, atualize o sistema.EXECUTE sp_configure 'show advanced options', 1RECONFIGURE  EXECUTE sp_configure 'scan for startup procs', 1RECONFIGUREUSE master

-- (a) Dado o c�digo de um livro e o valor do seu estado (requisitado � �1�; n�o requisitado � �0�) atualize o valor do estado desse livro.

CREATE PROCEDURE SetEstado (@Numero INTEGER, @Estado BIT)
AS
BEGIN
	UPDATE Biblioteca.dbo.Livro
	SET Estado = @Estado
	WHERE Numero = @Numero
END

-- (b) Dado o c�digo de um livro verifique se este se encontra requisitado ou n�o.

CREATE PROCEDURE VerifyEstado (@Numero INTEGER)
AS
BEGIN
	DECLARE @Estado INTEGER
	SELECT @Estado = Estado
	FROM Biblioteca.dbo.Livro
	WHERE Numero = @Numero
	RETURN @Estado
END

-- (c) Dado o n�mero de um aluno verifique se � poss�vel requisitar um livro, sabendo que tal s� se verifica caso o aluno tenha requisitado menos de garantia/5 livros.

CREATE PROCEDURE N_ReqsDisp (@Numero INTEGER)
AS
BEGIN
	DECLARE @NReqs INTEGER
	SELECT @NReqs = COUNT(E.Num_Liv)
	FROM Biblioteca.dbo.Aluno A, Biblioteca.dbo.Emprestimo E
	WHERE A.Numero = @Numero
	AND A.Numero = E.Num_Al
	AND E.Data_Ent IS NULL
	
	SELECT @NReqs = (FLOOR(A.Garantia/5) - @NReqs)
	FROM Biblioteca.dbo.Aluno A
	WHERE A.Numero = @Numero
	RETURN @NReqs
END

-- (d) Tendo em considera��o os pressupostos das al�neas (a), (b) e (c), insira uma requisi��o.

CREATE PROCEDURE Requisitar (@NumAl INTEGER, @NumLiv INTEGER)
AS
BEGIN
	DECLARE @Estado INTEGER
	EXECUTE @Estado = VerifyEstado @NumLiv
	IF (@Estado = 1)
		BEGIN
			PRINT ('Livro j� requisitado')
			RETURN -1
		END
	DECLARE @NReqs INTEGER
	EXECUTE @NReqs = N_ReqsDisp @NumAl
	IF (@NReqs <= 0)
		BEGIN
			PRINT ('Aluno n�o pode requisitar mais livros')
			RETURN -1
		END
	INSERT INTO Biblioteca.dbo.Emprestimo (Num_Al, Num_Liv)
	VALUES (@NumAl, @NumLiv)
	EXECUTE SetEstado @NumLiv, 1
	RETURN 1
END

-- (e) Dados o n�mero do aluno, o c�digo do livro e a data de requisi��o, entregue uma requisi��o.

CREATE PROCEDURE Entregar (@NumAl INTEGER, @NumLiv INTEGER, @DataReq DATE)
AS
BEGIN
	UPDATE Biblioteca.dbo.Emprestimo
	SET Data_Ent = GETDATE()
	WHERE Num_Al = @NumAl
	AND Num_Liv = @NumLiv
	AND Data_Req = @DataReq

	IF (@@ROWCOUNT = 1)
		BEGIN
			EXECUTE SetEstado @NumLiv, 0
			RETURN 1
		END
	RETURN -1
END

-- (f) Dado o c�digo de um livro verifique se este se encontra realmente requisitado.

CREATE PROCEDURE VerifyReq (@NumLiv INTEGER)
AS
BEGIN
	DECLARE @Data DATE
	SELECT TOP 1 @Data = Data_Ent
	FROM Biblioteca.dbo.Emprestimo
	WHERE Num_Liv = @NumLiv
	ORDER BY Data_Req DESC

	IF (@Data IS NOT NULL OR @@ROWCOUNT = 0)
		RETURN 0
	RETURN 1
END

-- (g) Dado o c�digo de um livro, caso haja inconsist�ncia no sistema relativamente ao valor do seu estado, corrija esse estado

CREATE PROCEDURE FixEstado (@NumLiv INTEGER)
AS
BEGIN
	DECLARE @Req INTEGER
	EXECUTE @Req = VerifyReq @NumLiv

	DECLARE @Estado INTEGER
	EXECUTE @Estado = VerifyEstado @NumLiv

	IF (@Estado != @Req)
		EXECUTE SetEstado @NumLiv, @Req
END

-- (h) Tendo em considera��o os pressupostos das al�neas (f) e (g), verifique a consist�ncia do sistema.

CREATE PROCEDURE FixAll
AS
BEGIN
	DECLARE cursor_estado CURSOR
		FOR SELECT Numero FROM Biblioteca.dbo.Livro
	DECLARE @NumLiv INTEGER
	OPEN cursor_estado
	FETCH NEXT FROM cursor_estado INTO @NumLiv

	IF @@FETCH_STATUS = -1
		BEGIN
			PRINT 'N�o existem livros registados.'
			CLOSE cursor_estado
			DEALLOCATE cursor_estado
			RETURN
		END

	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			EXECUTE FixEstado @NumLiv
			FETCH NEXT FROM cursor_estado INTO @NumLiv
		END
	CLOSE cursor_estado
	DEALLOCATE cursor_estado
END

-- (i) Continua��o
EXECUTE sp_procoption @ProcName = 'FixAll', @OptionName = 'startup', @OptionValue = 'on'

-- (j) Crie dois triggers para manter consistente o 'estado' da tabela Livro quando, respetivamente, insere ou entrega um livro na tabela Emprestimo.

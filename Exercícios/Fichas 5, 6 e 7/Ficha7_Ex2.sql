/*(a) Dado o código de um livro (ISBN) verifique se o valor dos direitos de autor são uma percentagem do 
preço de venda ao público, ou seja, que o valor das royalties são inferiores ao preço de venda ao público do livro.*/

create proc VerifyRoyalties (@ISBN VARCHAR(17))
as
begin
	select *
	from Livro L, Escrever E
	where L.ISBN = @ISBN
	and L.ISBN = E.ISBN
	and E.Royalty < 1

	if(@@ROWCOUNT = 0)
	begin
		print 'Os royalties estão errados'
		return -1
	end
	return 0
end

/*(b) Caso não se verifique a condição da alínea anterior, estabeleça o valor dos direitos de autor igual a 20% do preço de venda ao público.*/

create proc FixRoyalties (@ISBN VARCHAR(17))
as
begin
	declare @flag integer

	exec @flag = VerifyRoyalties @ISBN

	if(@flag = -1)
	begin
		update Escrever
		set Royalty = 0.2
		where ISBN = @ISBN

		return -1
	end
	return 0
end

/*(c) Verifique e corrija os valores dos direitos de autor para todos os livros existentes no sistema.*/

create proc FixAllRoyalties
as
begin
	declare cursor_royalty cursor
	for select ISBN from Escrever

	declare @ISBN VARCHAR(17)
	open cursor_royalty

	fetch next from cursor_royalty into @ISBN
	while (@@FETCH_STATUS = 0)
	begin
		exec FixRoyalties @ISBN
		fetch next from cursor_royalty into @ISBN
	end

	close cursor_royalty
	deallocate cursor_royalty
end

/*(d) Dado o código de um livro (ISBN), o código do seu autor e o valor dos direitos 
do autor, registe esta informação no sistema, validando os pressupostos anteriores.*/

create proc InsertEscrever (@ISBN VARCHAR(17), @Cod_Autor integer, @Royalty float)
as 
begin
	select *
	from Autor
	where Cod_Autor = @Cod_Autor

	if(@@ROWCOUNT = 0)
		return -1

	insert into Escrever (Cod_Autor, ISBN, Royalty)
	values (@Cod_Autor, @ISBN, @Royalty)

	exec FixRoyalties @ISBN

	return 0
end

/*(e) Dado o código de um livro (ISBN) verifique se a quantidade comprada é inferior ao número de livros editados.*/

create proc VerifyQuantity (@ISBN VARCHAR(17))
as
begin
	declare @comprados integer,
			@editados integer

	select @editados = Ed_Ex
	from Livro
	where ISBN = @ISBN

	select @comprados = SUM(Quantidade)
	from Comprar C, Livro L
	where C.ISBN = L.ISBN
	and L.ISBN = @ISBN

	if(@comprados >= @editados)
		return -1
	return 0
end

/*(f) Verifique qual a quantidade máxima de um livro que pode ser comprada numa 
determinada data (tenha em consideração todas as compras e o valor dos livros editados).*/

create proc VerifyMaxQuantity (@ISBN VARCHAR(17), @Data date)
as
begin
	declare @comprados integer,
			@editados integer,
			@max integer

	select @editados = Ed_Ex
	from Livro
	where ISBN = @ISBN

	select @comprados = SUM(Quantidade)
	from Comprar C, Livro L
	where CAST(Data_Compra as date) <= @Data 
	and C.ISBN = L.ISBN
	and L.ISBN = @ISBN

	set @max = @editados - @comprados
	if (@max < 0)
		set @max = 0
	return @max
end

/*(g) Caso não se verifique a condição da alínea (e), atualize o valor da quantidade do livro especificado para a quantidade máxima disponível.*/

create proc FixQuantity (@ISBN VARCHAR(17), @liv integer, @date date)
as
begin
	declare @flag integer,
			@max integer

	exec @flag = VerifyQuantity @ISBN

	if(@flag = -1)
	begin
		exec @max = VerifyMaxQuantity @ISBN, @date
		
		if (@max = 0)
		begin
			delete Comprar
			where Cod_Livreiro = @liv
			and ISBN = @ISBN
			and CAST(Data_Compra as date) = @date
			return
		end
		update Comprar
		set Quantidade = @max
		where CAST(Data_Compra as date) = @date
		and Cod_Livreiro = @liv
		and ISBN = @ISBN
	end
end

-- (h) Verifique e corrija as quantidades de todas as compras registadas no sistema.

create proc FixAllQuantities
as
begin
	declare cursor_compra cursor
	for select ISBN, Cod_Livreiro, Data_Compra from Comprar order by Data_Compra ASC
	open cursor_compra

	declare @ISBN VARCHAR(17),
			@Livreiro integer,
			@Data date

	fetch next from cursor_compra into @ISBN, @Livreiro, @Data

	while (@@FETCH_STATUS != -1)
	begin
		exec FixQuantity @ISBN, @Livreiro, @Data
		fetch next from cursor_compra into @ISBN, @Livreiro, @Data
	end

	close cursor_compra
	deallocate cursor_compra
end

select * from Livro
select * from Comprar

-- (i) Dado o código de um livro (ISBN), o código do livreiro e a quantidade comprada, registe uma compra no sistema, validando os pressupostos anteriores.

create proc InsertComprar (@ISBN VARCHAR(17), @Livreiro integer, @Quantidade integer)
as
begin
	declare @date date
	set @date = GETDATE()

	insert into Comprar (ISBN, Cod_Livreiro, Quantidade, Data_Compra)
	values (@ISBN, @Livreiro, @Quantidade, @date)

	exec FixQuantity @ISBN, @Livreiro, @date
end
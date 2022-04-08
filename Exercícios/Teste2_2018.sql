
-- 1.1. Assumindo a base de dados vazia, insira a primeira pe�a e o primeiro vendedor.

insert into Utilizador (idUtil, nome, telefone)
values (1001, 'Diogo Medeiros', 931245678)

insert into Vendedor (idVend, email, morada)
values (1001, 'al70633@utad.eu', 'Rua abc, Vila Real')

insert into Pecas (idPeca, titulo, preco, descricao)
values (101, 'escape', 24.95, 'Tubo de escape - Golf 1999')


-- 1.2. Quais as pe�as existentes no sistema? [idPe�a, T�tulo]

select idPeca, titulo
from Pecas;

-- 1.3. Quantas pe�as foram compradas pelo �Jo�o Dias�? [NumPecas]

select COUNT(*) NumPecas
from Comprar, Comprador, Utilizador
where codComp = idComp
and idComp = idUtil
and nome like 'Jo�o Dias';

-- 1.4. Qual o total ganho pelo �Ant�nio� nas pe�as que vendeu ao �Jo�o Dias�? [Ganho Total]

select SUM(valorPago) 'Ganho Total'
from Utilizador Uv, Utilizador Uc, 
Vendedor, Comprador, Comprar
where Uv.nome like 'Ant�nio'
and Uv.idUtil = idVend
and idVend = codVend
and Uc.nome like 'Jo�o Dias'
and Uc.idUtil = idComp
and idComp = codComp;

-- 1.5. Quantas pe�as vendeu cada vendedor? [nome, Quant]

select nome, Quant
from Utilizador, Vendedor, 
	(select codVend, COUNT(*) Quant
	 from Comprar
	 group by codVend) sq1
where idUtil = idVend
and idVend = codVend;

-- 1.6. Crie um procedimento que dado o id do vendedor devolva o n�mero de pe�as por ele vendidas?

create proc NPecasVendidas (@idVend integer)
as
begin
	declare @Npecas integer

	select @Npecas = COUNT(*)
	from Comprar
	where @idVend = codVend

	return @Npecas
end

-- 1.7. Crie um procedimento que dado o nome do utilizador devolva se este � vendedor �1�, comprador �2� ou ambos �3�.

create proc TipoUtil (@nome varchar)
as
begin
	declare @Id integer,
			@f1 integer,
			@f2 integer

	select @Id = idUtil
	from Utilizador
	where nome like @nome

	select *
	from Vendedor
	where idVend = @Id
	if (@@rowcount = 1)
		set @f1 = 1
	
	select *
	from Comprador
	where idComp = @Id
	if (@@rowcount = 1)
		set @f2 = 1

	if (@f1 = 1 and @f2 = 1)
		return 3
	if (@f1 = 1)
		return 1
	return 2
end
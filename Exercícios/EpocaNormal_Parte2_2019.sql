use master
create database Galeria
use Galeria

create table Func (
	numero int primary key,
	nome varchar(50) not null,
	contacto varchar(50) not null,
	titulo varchar(20),
	vencimento money
)

create table FuncMan (
	numero int references Func,
	lugar int not null,
	primary key (numero)
)

create table FuncEsc (
	numero int references Func,
	cargo varchar(50) not null,
	primary key (numero)
)

create table Quadro (
	numero int primary key,
	titulo varchar(50) not null,
	data_ date not null,
	descricao varchar(50) not null
)

create table Reparacao (
	num_quadro int references Quadro,
	num_funcMan int references FuncMan,
	data_inicio date not null,
	data_fim date,
	primary key (num_quadro, num_funcMan, data_inicio)
)

create table Vender (
	num_quadro int references Quadro,
	num_funcEsc int references FuncEsc,
	data_ date not null,
	valor money,
	primary key (num_quadro, num_funcEsc, data_)
)

-- 1.1. Insira um novo FuncMan na base de dados.

insert into Func (numero, nome, contacto, titulo, vencimento)
values (70633, 'Diogo Medeiros', 'al70633@utad.eu', 'Engenheiro', 950);

insert into FuncMan (numero, lugar)
values (70633, 13);

-- 1.2. Quais os Quadros existentes no sistema contém “ Sol ” no título? Ordene-os alfabeticamente pelo título [numero, titulo]

select numero, titulo
from Quadro
where titulo like '%Sol%'
order by titulo;

-- 1.3. Quantos Quadros já foram vendidos? [Numero_Quadros_Vendidos]

select COUNT(distinct(num_quadro)) Numero_Quadros_Vendidos
from Vender;

-- 1.4. Que Quadros cada Funcionario já vendeu? Agrupe-os por Funcionário. [Nome, Titulo]

select nome Funcionario, Q.titulo Quadro
from Func F, FuncEsc FE, Vender, Quadro Q
where F.numero = FE.numero
and FE.numero = num_funcEsc
and num_quadro = Q.numero
order by num_funcEsc;

-- 1.5. Qual o último Quadro que sofreu uma Manutenção? [Titulo, Data]

select titulo, data_inicio, data_fim
from Quadro, Reparacao
where data_inicio = (select MAX(data_inicio)
					from Reparacao
					where data_fim is not null)
and data_fim is not null;

/*1.6. Crie um procedimento que dado o nome de um Funcionario e o título de um
Quadro verifique se estes já tiveram contacto. Deve devolver 1 no caso de
uma manutenção, 2 no caso de uma venda e 0 caso não tenha havido
contacto.*/

create proc VerifyContact (@nome varchar(50), @titulo varchar(50))
as
begin
	select *
	from Func F, FuncMan FM, Reparacao R, Quadro Q
	where F.nome = @nome
	and F.numero = FM.numero
	and FM.numero = R.num_funcMan
	and R.num_quadro = Q.numero
	and Q.titulo = @titulo

	if (@@ROWCOUNT > 0)
		return 1

	select *
	from Func F, FuncEsc FE, Vender V, Quadro Q
	where F.nome = @nome
	and F.numero = FE.numero
	and FE.numero = V.num_funcEsc
	and V.num_quadro = Q.numero
	and Q.titulo = @titulo

	if (@@ROWCOUNT > 0)
		return 2

	return 0
end

/*1.7. Crie um procedimento que fazendo uso do procedimento anterior, apresente
uma mensagem:
- o valor no caso de uma venda ou
- a duração no caso de uma reparação ou
- nada caso não tenha havido contacto.*/

create proc FuncMessage (@nome varchar(50), @titulo varchar(50))
as
begin
	declare @flag integer
	exec @flag = VerifyContact @nome, @titulo

	if (@flag = 1)
	begin
		declare @duracao int

		select @duracao = DATEDIFF(day, data_inicio, ISNULL(data_fim, GETDATE()))
		from Func F, FuncMan FM, Reparacao, Quadro Q
		where F.nome = @nome
		and F.numero = FM.numero
		and FM.numero = num_funcMan
		and num_quadro = Q.numero
		and Q.titulo = @titulo

		print CONCAT('Duracao: ', @duracao, ' dias') 
		return
	end

	if (@flag = 2)
	begin
		declare @valor money

		select @valor = valor
		from Func F, FuncEsc FE, Vender, Quadro Q
		where F.nome = @nome
		and F.numero = FE.numero
		and FE.numero = num_funcEsc
		and num_quadro = Q.numero
		and Q.titulo = @titulo

		print CONCAT('Valor: ', @valor) 
		return
	end

	print 'O funcionario não teve contacto com o quadro'
end
1.1.1

select cod_rev, titulo
from Mensal, Revistas
where codigo = cod_rev

1.1.2

select nome, titulo, preco
from Pessoas P, Semanal, Revistas R
where preco = (select max(preco)
		from Comprar)
and cod_rev_s = cod_rev
and cod_rev = R.codigo
and cod_pes = P.codigo

1.1.3

select count(distinct(cod_pes_Escritor)) N_Pessoas
from Escrever, Mensal, Revistas
where cod_rev_M = cod_rev
and cod_rev = codigo
and titulo like 'Dia Azul'

1.1.4

select distinct cod_rev, titulo
from Pessoas P, Escrever, Mensal, Revistas R
where nome like 'António'
and P.codigo = cod_pes_Editor
and cod_rev_M = cod_rev
and cod_rev = R.codigo

1.1.5

select nome, titulo
from Pessoas P, Escrever, Mensal, Revistas R
where P.codigo = cod_pes_Escritor
and cod_rev_M = cod_rev
and cod_rev = R.codigo
order by titulo

2.1

create proc NewRevM (@codigo int, @titulo varchar(50), @num_pag int)
as
begin
	select *
	from Revistas
	where codigo = @codigo
	
	if (@@rowcount != 0)
		return -1

	if (@num_pag <= 0)
		return -1

	insert into Revistas (codigo, titulo, num_pag)
	values (@codigo, @titulo, @num_pag)

	insert into Mensal (cod_rev)
	values (@codigo)

	return 0
end

2.2

create trigger TotalGasto
on Comprar
after insert
as
begin
	select nome, sum(preco) Total_Gasto
	from Comprar C, inserted I, Pessoas
	where C.cod_pes = I.cod_pes
	and C.cod_pes = codigo
	group by nome
end
































-- (a) Quantas aeronaves tem o proprietário “Manuel Rocha”? Quais as suas matrículas?

select COUNT(matricula) N_Aeronaves
from Proprietario Pr, Pertencer Pe
where nome like 'Manuel Rocha'
and Pr.cod_proprietario = Pe.cod_proprietario;

select matricula
from Proprietario Pr, Pertencer Pe
where nome like 'Manuel Rocha'
and Pr.cod_proprietario = Pe.cod_proprietario;

-- (b) Quantos tipos de aeronaves distintos tem o proprietário “João Pereira”?

select COUNT(distinct(cod_tipo)) N_Tipos
from Proprietario Pr, Pertencer Pe, Aeronave A, Identificar I
where Pr.nome like 'João Pereira'
and Pr.cod_proprietario = Pe.cod_proprietario
and Pe.matricula = A.matricula
and A.matricula = I.matricula;

-- (c) Qual o número total de horas de voo que tem o piloto “António João” em todos os tipos de aeronaves?

select SUM(horas_voo) 'Total de horas de voo'
from Piloto Po, Pilotar Pr
where Po.nome = 'António João'
and Po.brevet = Pr.brevet;

-- (d) Quantos tipos distintos de aeronaves pode pilotar o piloto “António João”?

select COUNT(distinct(cod_tipo)) N_Tipos
from Piloto Po, Pilotar Pr
where Po.nome like 'António João'
and Po.brevet = Pr.brevet

-- (e) Quais as datas e durações das manutenções às aeronaves do proprietário “Manuel Rocha”?

select A.matricula, data_M, duracao
from Proprietario Po, Pertencer Pe, Aeronave A, Manutencao M
where Po.nome like 'Manuel Rocha'
and Po.cod_proprietario = Pe.cod_proprietario
and Pe.matricula = A.matricula
and A.matricula = M.matricula;

-- (f) Em quantas manutenções participou o mecânico “Joaquim Teixeira”? Quais foram elas?

select COUNT(*) N_Manutencoes
from Mecanico, Manutencao
where nome like 'Joaquim Teixeira'
and (cod_mecanico = cod_mecanico1
or cod_mecanico = cod_mecanico2);

select nome, Ma.*
from Mecanico Me, Manutencao Ma
where nome like 'Joaquim Teixeira'
and (cod_mecanico = cod_mecanico1
or cod_mecanico = cod_mecanico2);
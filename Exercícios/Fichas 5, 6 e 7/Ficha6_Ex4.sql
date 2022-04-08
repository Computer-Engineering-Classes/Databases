-- (a) Quantas aeronaves tem o propriet�rio �Manuel Rocha�? Quais as suas matr�culas?

select COUNT(matricula) N_Aeronaves
from Proprietario Pr, Pertencer Pe
where nome like 'Manuel Rocha'
and Pr.cod_proprietario = Pe.cod_proprietario;

select matricula
from Proprietario Pr, Pertencer Pe
where nome like 'Manuel Rocha'
and Pr.cod_proprietario = Pe.cod_proprietario;

-- (b) Quantos tipos de aeronaves distintos tem o propriet�rio �Jo�o Pereira�?

select COUNT(distinct(cod_tipo)) N_Tipos
from Proprietario Pr, Pertencer Pe, Aeronave A, Identificar I
where Pr.nome like 'Jo�o Pereira'
and Pr.cod_proprietario = Pe.cod_proprietario
and Pe.matricula = A.matricula
and A.matricula = I.matricula;

-- (c) Qual o n�mero total de horas de voo que tem o piloto �Ant�nio Jo�o� em todos os tipos de aeronaves?

select SUM(horas_voo) 'Total de horas de voo'
from Piloto Po, Pilotar Pr
where Po.nome = 'Ant�nio Jo�o'
and Po.brevet = Pr.brevet;

-- (d) Quantos tipos distintos de aeronaves pode pilotar o piloto �Ant�nio Jo�o�?

select COUNT(distinct(cod_tipo)) N_Tipos
from Piloto Po, Pilotar Pr
where Po.nome like 'Ant�nio Jo�o'
and Po.brevet = Pr.brevet

-- (e) Quais as datas e dura��es das manuten��es �s aeronaves do propriet�rio �Manuel Rocha�?

select A.matricula, data_M, duracao
from Proprietario Po, Pertencer Pe, Aeronave A, Manutencao M
where Po.nome like 'Manuel Rocha'
and Po.cod_proprietario = Pe.cod_proprietario
and Pe.matricula = A.matricula
and A.matricula = M.matricula;

-- (f) Em quantas manuten��es participou o mec�nico �Joaquim Teixeira�? Quais foram elas?

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
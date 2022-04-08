-- (a) Quais os alunos inscritos na disciplina “Bases de Dados”? Qual a sua distribuição pelas turmas existentes?

select distinct Aluno.*
from Disciplina D, Funcionar F, 
Turma T, Inscricao I, Aluno A
where D.nome = 'Bases de Dados'
and D.cod_disciplina = F.cod_disciplina
and F.cod_turma = T.cod_turma
and T.cod_turma = I.cod_turma
and I.numero_mecanografico = A.numero_mecanografico;

select I.cod_turma, COUNT(distinct(I.numero_mecanografico))
from Disciplina D, Funcionar F, 
Turma T, Inscricao I
where D.nome = 'Bases de Dados'
and D.cod_disciplina = F.cod_disciplina
and F.cod_turma = T.cod_turma
and T.cod_turma = I.cod_turma
group by I.cod_turma;

-- (b) Quais os professores da disciplina “Bases de Dados”? Qual a sua distribuição pelas turmas existentes?

select distinct P.*
from Professor P, Lecionar L, Turma T, 
Funcionar F, Disciplina D
where D.nome like 'Bases de Dados'
and D.cod_disciplina = F.cod_disciplina
and F.cod_turma = T.cod_turma
and T.cod_turma = L.cod_turma
and L.matricula = P.matricula;

select L.cod_turma, COUNT(distinct(L.matricula))
from Disciplina D, Funcionar F, 
Turma T, Lecionar L
where D.nome = 'Bases de Dados'
and D.cod_disciplina = F.cod_disciplina
and F.cod_turma = T.cod_turma
and T.cod_turma = L.cod_turma
group by L.cod_turma;

-- (c) Quantas aulas houve, em cada turma, da disciplina “Bases de Dados”?

select I.cod_turma, COUNT(distinct(dia))
from Turma T, Inscricao I, Funcionar F, Disciplina D
where D.nome like 'Bases de Dados'
and D.cod_disciplina = F.cod_disciplina
and F.cod_turma = T.cod_turma
and T.cod_turma = I.cod_turma
group by I.cod_turma;

-- (d) Qual o número de faltas do aluno “João Carlos” às turmas da disciplina “Bases de Dados”?

select COUNT(*) N_faltas
from Aluno A, Inscricao I, Turma T,
Funcionar F, Disciplina D
where A.nome like 'João Carlos'
and A.numero_mecanografico = I.numero_mecanografico
and I.frequencia = 0
and I.cod_turma = T.cod_turma
and T.cod_turma = F.cod_turma
and F.cod_disciplina = D.cod_disciplina
and D.nome like 'Bases de Dados'

-- (e) Em que datas faltou o aluno “Filipe Fernandes” às turmas da disciplina “Bases de Dados”?

select I.dia, Diario.*
from Aluno A, Inscricao I, Turma T,
Funcionar F, Disciplina D, Diario
where A.nome like 'João Carlos'
and A.numero_mecanografico = I.numero_mecanografico
and I.frequencia = 0
and I.cod_turma = T.cod_turma
and T.cod_turma = F.cod_turma
and F.cod_disciplina = D.cod_disciplina
and D.nome like 'Bases de Dados'
and I.cod_diario = Diario.cod_diario;
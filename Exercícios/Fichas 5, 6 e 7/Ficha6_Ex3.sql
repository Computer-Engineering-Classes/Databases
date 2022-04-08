--(a) Quais os discos existentes na loja?

select *
from Disco;

--(b) Quais as músicas do disco com o nome “Música Pimba”?

select M.nome
from Musica M, Disco D, Musica_Disco MD
where M.cod_musica = MD.cod_musica
and MD.cod_disco = D.cod_disco
and D.nome like 'Música Pimba';

--(c) Quais os estilos de música existentes na loja?

select *
from Estilo;

--(d) Quantos discos têm o intérprete “Manuel Fernandes”?

select COUNT(distinct(MD.cod_disco)) N_Discos
from Interprete I, Musica_Interprete MI, Musica M, Musica_Disco MD
where I.nome like 'Manuel Fernandes' 
and I.cod_interprete = MI.cod_interprete
and MI.cod_musica = M.cod_musica
and M.cod_musica = MD.cod_musica;

--(e) Quantas músicas tem o compositor “António José” em todos os discos?

select COUNT(cod_musica) N_Musicas
from Compositor C, Musica_Compositor MC
where C.nome like 'António José'
and C.cod_compositor = MC.cod_compositor;

--(f) Quantas editoras estão representadas na loja de discos? Com que títulos?

select count(*) N_Editoras
from Editora

select E.nome, D.nome
from Editora E, Disco_Editora DE, Disco D
where E.cod_editora = DE.cod_editora
and DE.cod_disco = D.cod_disco

--(g) Quais os estilos das músicas do disco “Música Pimba”?

select M.nome, E.nome
from Disco D, Musica_Disco MD, Musica M, Musica_Estilo ME, Estilo E
where D.nome like 'Música Pimba'
and D.cod_disco = MD.cod_disco
and MD.cod_musica = M.cod_musica
and M.cod_musica = ME.cod_musica
and ME.cod_estilo = E.cod_estilo;
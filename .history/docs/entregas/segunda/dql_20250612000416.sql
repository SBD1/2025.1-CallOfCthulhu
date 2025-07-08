Ok! Com o DDL corrigido e o DML que você forneceu executado (assumindo que os INSERTs de personagens_jogaveis, salas e corredores foram bem-sucedidos), podemos agora realizar a consulta para saber em qual sala (ou corredor) cada personagem está.

A consulta é a mesma que eu forneci anteriormente, pois ela é genérica e funciona com os dados que você está inserindo.

Consulta para Verificar a Localização do Personagem
Esta consulta listará todos os seus personagens jogáveis e sua localização atual (seja em uma sala ou um corredor), junto com a descrição desse local.

SQL

SELECT
    pj.id AS id_personagem,
    pj.nome AS nome_personagem,
    pj.ocupacao,
    CASE
        WHEN pj.id_sala IS NOT NULL THEN 'Sala'
        WHEN pj.id_corredor IS NOT NULL THEN 'Corredor'
        ELSE 'Local Desconhecido (erro ou sem localização)' -- Caso inesperado
    END AS tipo_local,
    COALESCE(s.descricao, c.descricao) AS descricao_do_local
FROM
    public.personagens_jogaveis pj
LEFT JOIN
    public.salas s ON pj.id_sala = s.id
LEFT JOIN
    public.corredores c ON pj.id_corredor = c.id;
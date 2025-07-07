
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
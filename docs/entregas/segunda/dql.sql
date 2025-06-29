/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 12/06/2025
Descrição: Criando a versão inicial do DQL com consultas básicas que envolvem somente uma tabela.
Autor: Luiz Guilherme

Versão: 0.2
Data: 28/06/2025
Descrição: Atualizando DQL para refletir a unificação de 'salas' e 'corredores' na tabela 'public.local'.
           Correção de erros de sintaxe em consultas de item e feitiço.
Autor: Luiz Guilherme, Gemini

*/

-- ===============================================

--          CONSULTAS DE PERSONAGEM

-- ===============================================

-- MOSTRAR OS ATRIBUTOS DE UM PERSONAGEM JOGÁVEL
SELECT
    forca,
    constituicao,
    poder,
    destreza,
    aparencia,
    tamanho,
    inteligencia,
    educacao,
    ideia,
    conhecimento,
    sorte
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;

-- MOSTRAR A VIDA ATUAL E MÁXIMA DO PERSONAGEM JOGÁVEL
SELECT 
    pts_de_vida,
    pontos_de_vida_atual
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;

-- MOSTRAR A SANIDADE ATUAL E MÁXIMA DO PERSONAGEM JOGÁVEL
SELECT 
    sanidade_maxima AS sanidade, -- A view retorna 'sanidade_maxima', renomeado para 'sanidade' para consistência
    sanidade_atual
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;
    
-- MOSTRAR SE O PERSONAGEM ESTÁ EM UMA SALA OU CORREDOR (AGORA USANDO A TABELA 'LOCAL')
SELECT
    pj.id AS id_personagem,
    pj.nome AS nome_personagem,
    pj.ocupacao,
    l.tipo_local, -- Diretamente da tabela 'local'
    l.descricao AS descricao_do_local
FROM
    public.personagens_jogaveis pj
JOIN -- Usamos JOIN porque id_local não pode ser NULL (assumindo que todo personagem está em um local)
    public.local l ON pj.id_local = l.id
WHERE
    pj.id = %s; -- Adicionado WHERE para buscar um personagem específico, %s para ID do personagem

-- ===============================================

--          CONSULTAS DE NPC

-- ===============================================

-- MOSTRAR TODAS AS INFORMAÇÕES DE UM NPC
SELECT
    nome,
    ocupacao,
    idade,
    sexo,
    residencia,
    local_nascimento
FROM 
    public.npcs
WHERE 
    id = %s;

-- ===============================================

--          CONSULTAS DE DIÁLOGOS

-- ===============================================

-- MOSTRAR OS DIÁLOGOS DE UM NPC
SELECT 
    script_dialogo
FROM 
    public.dialogos
WHERE 
    npc_id = %s;

-- ===============================================

--          CONSULTAS DE INVENTÁRIOS

-- ===============================================

-- MOSTRAR O INVENTÁRIO DE UM PERSONAGEM JOGÁVEL
SELECT
    i.id AS id_inventario,
    i.tamanho,
    ii.id AS id_instancia_item,
    it.nome AS nome_item,
    it.descricao AS descricao_item,
    ii.durabilidade
FROM
    public.inventarios inv
JOIN
    public.personagens_jogaveis pj ON pj.id_inventario = inv.id
LEFT JOIN
    public.inventarios_possuem_instancias_item ipii ON inv.id = ipii.id_inventario
LEFT JOIN
    public.instancias_de_itens ii ON ipii.id_instancias_de_item = ii.id
LEFT JOIN
    public.itens it ON ii.id_item = it.id
WHERE
    pj.id = %s; -- ID do personagem jogável

-- ===============================================

--          CONSULTAS DE TEMPLOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM TEMPLO
SELECT 
    nome,
    descricao
FROM 
    public.templos
WHERE
    id = %s;

-- ===============================================

--          CONSULTAS DE ANDARES

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM ANDAR
SELECT 
    a.descricao,
    t.nome AS nome_templo,
    l.descricao AS descricao_local_inicial,
    l.tipo_local AS tipo_local_inicial
FROM 
    public.andares a
JOIN
    public.templos t ON a.id_templo = t.id
JOIN
    public.local l ON a.sala_inicial = l.id
WHERE
    a.id = %s;

-- ===============================================

--          CONSULTAS DE LOCAIS (Antigas Salas e Corredores)

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM LOCAL (SALA OU CORREDOR)
SELECT 
    descricao,
    tipo_local,
    status, -- Será NULL para Salas, FALSE/TRUE para Corredores
    sul,
    norte,
    leste,
    oeste,
    cima,
    baixo
FROM 
    public.local
WHERE
    id = %s;

-- ===============================================

--          CONSULTAS DE PERÍCIAS

-- ===============================================

-- MOSTRAR PERÍCIAS DE UM PERSONAGEM JOGÁVEL
SELECT
    p.nome AS nome_pericia,
    ppp.valor_atual,
    p.eh_de_ocupacao
FROM
    public.personagens_possuem_pericias ppp
JOIN
    public.pericias p ON ppp.id_pericia = p.id
WHERE
    ppp.id_personagem = %s; -- ID do personagem jogável

-- ===============================================

--          CONSULTAS MONSTROS AGRESSIVOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM MONSTRO AGRESSIVO
SELECT 
    nome,
    descricao,
    defesa,
    vida,
    catalisador_agressividade,
    poder,
    tipo_agressivo,
    velocidade_ataque,
    loucura_induzida,
    dano
FROM 
    public.agressivos
WHERE 
    id = %s;

-- ===============================================

--          CONSULTAS MONSTROS PACÍFICOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM MONSTRO PACÍFICO
SELECT 
    nome,
    descricao,
    defesa,
    vida,
    motivo_passividade,
    tipo_pacifico,
    conhecimento_geografico,
    conhecimento_proibido
FROM 
    public.pacificos
WHERE 
    id = %s;

-- ===============================================

--          CONSULTAS INSTÂNCIAS DE MONSTRO

-- ===============================================

-- MOSTRAR DETALHES DE UMA INSTÂNCIA DE MONSTRO E ONDE ESTÁ
SELECT
    im.id AS id_instancia_monstro,
    tm.tipo AS tipo_monstro_geral, -- Se você tiver uma tabela de tipos de monstro
    COALESCE(ag.nome, pa.nome) AS nome_monstro_base,
    COALESCE(ag.descricao, pa.descricao) AS descricao_monstro_base,
    l.descricao AS localizacao,
    l.tipo_local AS tipo_localizacao
FROM
    public.instancias_monstros im
JOIN
    public.local l ON im.id_local = l.id
LEFT JOIN
    public.agressivos ag ON im.id_monstro = ag.id AND (SELECT tipo FROM public.tipos_monstro WHERE id = ag.id_tipo_monstro) = 'agressivo'
LEFT JOIN
    public.pacificos pa ON im.id_monstro = pa.id AND (SELECT tipo FROM public.tipos_monstro WHERE id = pa.id_tipo_monstro) = 'pacífico'
LEFT JOIN
    public.tipos_monstro tm ON COALESCE(ag.id_tipo_monstro, pa.id_tipo_monstro) = tm.id
WHERE
    im.id = %s; -- ID da instância de monstro


-- ===============================================

--          CONSULTAS MISSÕES

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA MISSÃO
SELECT
    nome,
    descricao,
    tipo,
    ordem,
    n.nome AS npc_solicitante
FROM
    public.missoes m
JOIN
    public.npcs n ON m.id_npc = n.id
WHERE 
    m.id = %s;

-- ===============================================

--          CONSULTAS ITENS MÁGICOS

-- ===============================================

-- MOSTRA AS INFORMAÇÕES DE UM ITEM MÁGICO
SELECT
    i.nome,
    i.descricao,
    i.valor,
    m.funcao,
    m.qts_usos,
    m.custo_sanidade
FROM
    public.magicos m
JOIN 
    public.itens i ON m.id = i.id
WHERE 
    m.id = %s;

-- ===============================================

--          CONSULTAS ITENS DE CURA

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM ITEM DE CURA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    c.funcao,
    c.qts_usos,
    c.qtd_pontos_sanidade_recupera,
    c.qtd_pontos_vida_recupera
FROM
    public.curas c
JOIN 
    public.itens i ON c.id = i.id
WHERE 
    c.id = %s;

-- ===============================================

--          CONSULTAS ARMADURAS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA ARMADURA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    a.atributo_necessario,
    a.durabilidade,
    a.funcao,
    a.qtd_atributo_necessario,
    a.qtd_atributo_recebe,
    a.qtd_dano_mitigado,
    p.nome AS pericia_necessaria_nome
FROM
    public.armaduras a
JOIN 
    public.itens i ON a.id = i.id
JOIN
    public.pericias p ON a.id_pericia_necessaria = p.id
WHERE 
    a.id = %s;

-- ===============================================

--          CONSULTAS ARMAS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA ARMA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    a.atributo_necessario,
    a.durabilidade,
    a.funcao,
    a.qtd_atributo_necessario,
    a.alcance,
    a.tipo_municao,
    a.tipo_dano,
    a.dano,
    p.nome AS pericia_necessaria_nome
FROM
    public.armas a 
JOIN 
    public.itens i ON a.id = i.id
JOIN
    public.pericias p ON a.id_pericia_necessaria = p.id
WHERE 
    a.id = %s;

-- ===============================================

--          CONSULTAS FEITIÇOS DE STATUS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM FEITIÇO DE STATUS
SELECT
    fs.nome, 
    fs.descricao,
    fs.qtd_pontos_de_magia,
    fs.buff_debuff,
    fs.qtd_buff_debuff,
    fs.status_afetado,
    tf.tipo AS tipo_feitico_geral -- Se você tiver uma FK para tipos_feitico aqui
FROM
    public.feiticos_status fs
JOIN
    public.tipos_feitico tf ON fs.id = tf.id -- Assumindo que id em feiticos_status é FK para tipos_feitico.id
WHERE 
    fs.id = %s;

-- ===============================================

--          CONSULTAS FEITIÇOS DE DANO

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM FEITIÇO DE DANO
SELECT
    fd.nome, 
    fd.descricao,
    fd.qtd_pontos_de_magia,
    fd.tipo_dano,
    fd.qtd_dano,
    tf.tipo AS tipo_feitico_geral -- Se você tiver uma FK para tipos_feitico aqui
FROM
    public.feiticos_dano fd
JOIN
    public.tipos_feitico tf ON fd.id = tf.id -- Assumindo que id em feiticos_dano é FK para tipos_feitico.id
WHERE 
    fd.id = %s;

-- ===============================================

--          CONSULTAS DE UM ITEM

-- ===============================================

-- MOSTRAR INFORMAÇÕES GERAIS DE UM ITEM
SELECT
    id,
    tipo,
    nome,
    descricao,
    valor
FROM
    public.itens
WHERE
    id = %s;

/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 12/06/2025
Descrição: Criando a versão inicial do DQL com consultas básicas que envolvem somente uma tabela.
Autor: Luiz Guilherme

*/

-- ===============================================

--           CONSULTAS DE PERSONAGEM

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
    sanidade,
    sanidade_atual
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;

-- ===============================================

--           CONSULTAS DE NPC

-- ===============================================

-- MOSTRAR TODAS AS INFORMAÇÕES DE UM NPC
SELECT
    nome,
    ocupacao,
    idade,
    sexo,
    residencia,
    local_nascimento,
FROM 
    public.npcs
WHERE 
    id = %s;

-- ===============================================

--           CONSULTAS DE DIÁLOGOS

-- ===============================================

-- MOSTRAR OS DIÁLOGOS DE UM NPC
SELECT 
    script_dialogo
FROM 
    public.dialogos
WHERE 
    npc_id = %s;

-- ===============================================

--           CONSULTAS DE INVENTÁRIOS

-- ===============================================

-- ===============================================

--           CONSULTAS DE TEMPLOS

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

--           CONSULTAS DE ANDARES

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM ANDAR
SELECT 
    descricao
FROM 
    public.andares
WHERE
    id = %s;

-- ===============================================

--           CONSULTAS DE SALAS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA SALA
SELECT 
    descricao
FROM 
    public.salas
WHERE
    id = %s;

-- ===============================================

--           CONSULTAS DE CORREDORES

-- ===============================================

-- ===============================================

--           CONSULTAS DE PERÍCIAS

-- ===============================================

-- ===============================================

--         CONSULTAS MONSTROS AGRESSIVOS

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

--         CONSULTAS MONSTROS PACÍFICOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM MONSTRO PACÍFICOS
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

--         CONSULTAS INSTÂNCIAS DE MOSNTRO

-- ===============================================

-- ===============================================

--              CONSULTAS MISSÕES

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA MISSÃO
SELECT
    nome,
    descricao,
    tipo,
    ordem
FROM
    public.missoes
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ITENS MÁGICOS

-- ===============================================

--  MOSTRA AS INFORMAÇÕES DE UM ITEM MÁGICO
SELECT
    i.nome,
    i.descricao,
    i.valor,
    m.funcao,
    m.qtd_usos,
    m.custo_sanidade
SELECT
    public.magicos m
JOIN 
    public.itens i ON m.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ITENS DE CURA

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UM ITEM DE CURA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    c.funcao,
    c.qtd_usos,
    c.qtd_pontos_sanidade_recupera,
    c.qtd_pontos_vida_recupera
SELECT
    public.curas c
JOIN 
    public.itens i ON c.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ARMADURAS

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UMA ARMADURA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    a.atributo_necessario,
    a.durabilidade,
    a.funcao,
    a.qtd_atributo_necessario,
    a.qtd_atributo_recebe,
    a.qtd_dano_mitigado
SELECT
    public.armaduras a
JOIN 
    public.itens i ON a.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ARMAS

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UMA ARMA
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
    a.dano
SELECT
    public.armas a 
JOIN 
    public.itens i ON a.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS FEITIÇOS DE STATUS

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UM FEITÇO DE STATUS
SELECT
    nome, 
    descricao,
    qtd_pontos_de_magia,
    buff_debuff,
    qtd_buff_debuff,
    status_afetado
SELECT
    public.feitico_status
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS FEITIÇOS DE DANO

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UM FEITÇO DE DANO
SELECT
    nome, 
    descricao,
    qtd_pontos_de_magia,
    tipo_dano,
    qtd_dano
SELECT
    public.feitico_dano
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS DE UM ITEM

-- ===============================================

--  Não possui consultas diretas


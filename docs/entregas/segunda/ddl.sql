/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 28/05/2025
Descrição: Criando a versão inicial do ddl com base no código do dbdiagram.io
Autor: Luiz Guilherme

Versão: 0.2
Data 29/05/2025
Descrição: Adicionando os domínios para tipos personalizados para as tabelas do banco
Autor: Luiz Guilherme

Versão: 0.3
Data: 30/05/2025
Descrição Criação da seção de drop tables do ddl
Autor: Luiz Guilherme

Versão: 0.4 
Data: 02/06/2025
Descrição: Resolvendo bugs na criação das tabelas
Autor: Luiz Guilherme

Versão: 0.5 
Data: 03/06/2025
Descrição: Normalização do banco, resolução de erros de projeto e solucionamento de bugs
Autor: Luiz Guilherme

Versão: 0.6
Data: 08/06/2025
Descrição: Solucionando o bug referente a tabela de instâncias de itens, adição de novos domínios para as tabelas do banco, correção dos drop tables
Autor: Luiz Guilherme

Versão: 0.7
Data: 10/06/2025
Descrição: Ajustando o DDL para condizer com as informações presentes no dicionário de dados
Autor: Luiz Guilherme

Versão: 0.8
Data: 11/06/2025
Descrição: Ajustando as tabelas CREATE DOMAIN public.tipo_personagem AS CHARACTER e CREATE DOMAIN public.sexo AS CHARACTER para varying e comentando a ultima chave estrangeira que e tipo personagem pois estava dando erro verificar depois.
Autor: Christopher e João Marcos

*/

-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;

-- ===============================================

--            DROP TABLES

-- ===============================================

-- PASSO 1: remover os triggers e VIEWS

DROP VIEW IF EXISTS public.view_personagens_jogaveis_completos;

-- PASSO 2: remover as restrições de chave estrangeira

-- da tabela de personagens jogaveis
ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_inventario;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_salas;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_corredores;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_inventario_instancia_arma;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_inventario_instancia_armadura;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_tipos_personagem;

-- da tabela personagens_ possuem_pericias
ALTER TABLE public.personagens_possuem_pericias
DROP CONSTRAINT IF EXISTS fk_personagens_possuem_pericias_pj;

ALTER TABLE public.personagens_possuem_pericias
DROP CONSTRAINT IF EXISTS fk_personagens_possuem_pericias_pericia;

-- da tabela de NPCS
ALTER TABLE public.npcs
DROP CONSTRAINT IF EXISTS fk_npcs_salas;

ALTER TABLE public.npcs
DROP CONSTRAINT IF EXISTS fk_npcs_corredores;

ALTER TABLE public.npcs
DROP CONSTRAINT IF EXISTS fk_npcs_tipos_personagem;

-- da tabela de dialogos
ALTER TABLE public.dialogos
DROP CONSTRAINT IF EXISTS fk_dialogos_npc;

-- da tabela de andares
ALTER TABLE public.andares
DROP CONSTRAINT IF EXISTS fk_andares_templo;

ALTER TABLE public.andares
DROP CONSTRAINT IF EXISTS fk_andares_salas;

-- da tabela corredores_salas_destino
ALTER TABLE public.corredores_salas_destino
DROP CONSTRAINT IF EXISTS fk_corredores_salas_destino_corredores;

ALTER TABLE public.corredores_salas_destino
DROP CONSTRAINT IF EXISTS fk_corredores_salas_destino_salas;

ALTER TABLE public.instancias_de_itens
DROP CONSTRAINT IF EXISTS fk_instancias_de_item_salas;

-- da tabela curas
ALTER TABLE public.curas
DROP CONSTRAINT IF EXISTS fk_curas_itens;

-- da tabela inventarios_possuem_instancias_de_itens
ALTER TABLE public.inventarios_possuem_instancias_item 
DROP CONSTRAINT IF EXISTS fk_inventarios_possuem_instancias_de_item;

ALTER TABLE public.inventarios_possuem_instancias_item 
DROP CONSTRAINT IF EXISTS fk_inventarios_possuem_instancias_de_item_inventario;

-- da tabela magicos
ALTER TABLE public.magicos 
DROP CONSTRAINT IF EXISTS fk_magicos_tipos_feitico;

ALTER TABLE public.magicos 
DROP CONSTRAINT IF EXISTS fk_magicos_itens;

-- da tabela feiticos_status
ALTER TABLE public.feiticos_status 
DROP CONSTRAINT IF EXISTS fk_feiticos_status_tipo_feitico;

-- da tabela feiticos_dano
ALTER TABLE public.feiticos_dano 
DROP CONSTRAINT IF EXISTS fk_feiticos_dano_tipo_feitico;

-- da tabela instancias_monstro
ALTER TABLE public.instancias_monstros
DROP CONSTRAINT IF EXISTS fk_instancias_de_monstro_tipo_monstro;

ALTER TABLE public.instancias_monstros
DROP CONSTRAINT IF EXISTS fk_instancias_monstro_salas;

ALTER TABLE public.instancias_monstros
DROP CONSTRAINT IF EXISTS fk_instancias_monstro_corredores;

ALTER TABLE public.instancias_monstros
DROP CONSTRAINT IF EXISTS fk_instancias_monstro_instancia_de_item;

-- da tabela pacificos
ALTER TABLE public.pacificos
DROP CONSTRAINT IF EXISTS fk_pacificos_tipo_monstro;

-- da tabela agressivos
ALTER TABLE public.agressivos
DROP CONSTRAINT IF EXISTS fk_agressivos_tipo_monstro;

-- da tabela batalhas
ALTER TABLE public.batalhas
DROP CONSTRAINT IF EXISTS fk_batalhas_personagens_jogaveis;

ALTER TABLE public.batalhas
DROP CONSTRAINT IF EXISTS fk_batalhas_monstro;

-- da tabela missoes
ALTER TABLE public.missoes
DROP CONSTRAINT IF EXISTS fk_missoes_npcs;

-- da tabela entregas_missoes
ALTER TABLE public.entregas_missoes
DROP CONSTRAINT IF EXISTS fk_entregas_missoes_personagens_jogaveis;

ALTER TABLE public.entregas_missoes
DROP CONSTRAINT IF EXISTS fk_entregas_missoes_npcs;

-- da tabela de itens
ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_cura;

ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_magicos;

ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_armaduras;

ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_armas;

-- da tabela invetario
ALTER TABLE public.inventarios
DROP CONSTRAINT IF EXISTS fk_inventarios_instancia_de_item;

-- da tabela agressivos
ALTER TABLE public.agressivos
DROP CONSTRAINT IF EXISTS fk_agressivos_tipos_de_feitico;

-- da tabela tipo_feitico
ALTER TABLE public.tipos_feitico
DROP CONSTRAINT IF EXISTS fk_tipos_feitico_feitico_status;

ALTER TABLE public.tipos_feitico
DROP CONSTRAINT IF EXISTS fk_tipos_feitico_feitico_dano;

-- da tabela tipos_monstros
ALTER TABLE public.tipos_monstro
DROP CONSTRAINT IF EXISTS fk_tipos_monstro_pacificos;

ALTER TABLE public.tipos_monstro
DROP CONSTRAINT IF EXISTS fk_tipos_monstro_agressivo;

-- da tabela instancias_de_itens
ALTER TABLE public.instancias_de_itens
DROP CONSTRAINT IF EXISTS fk_instancias_de_itens_missoes_recompensa;

ALTER TABLE public.instancias_de_itens
DROP CONSTRAINT IF EXISTS fk_instancias_de_itens_missoes_requer;

ALTER TABLE public.instancias_de_itens
DROP CONSTRAINT IF EXISTS fk_instancias_de_item_itens;

-- da tabela armaduras
ALTER TABLE public.armaduras
DROP CONSTRAINT IF EXISTS fk_armaduras_pericia_necessaria;

ALTER TABLE public.armaduras
DROP CONSTRAINT IF EXISTS fk_armaduras_itens;

-- da tabela armas
ALTER TABLE public.armas
DROP CONSTRAINT IF EXISTS fk_armas_pericia_necessaria;

ALTER TABLE public.armas
DROP CONSTRAINT IF EXISTS fk_armas_itens;

-- da tabela tipos_personagem
ALTER TABLE public.tipos_personagem
DROP CONSTRAINT IF EXISTS fk_tipos_personagem_personagens_jogaveis;

ALTER TABLE public.tipos_personagem
DROP CONSTRAINT IF EXISTS fk_tipos_personagem_npc;

-- PASSO 3: remover as tabelas

-- tabelas de juncao primeiro

DROP TABLE IF EXISTS public.personagens_possuem_pericias; --
DROP TABLE IF EXISTS public.inventarios_possuem_instancias_item; --
DROP TABLE IF EXISTS public.corredores_salas_destino; --
DROP TABLE IF EXISTS public.entregas_missoes; --
DROP TABLE IF EXISTS public.batalhas; --

-- tabelas com muitas referencias por ultimo

DROP TABLE IF EXISTS public.tipos_personagem; --
DROP TABLE IF EXISTS public.tipos_feitico; --
DROP TABLE IF EXISTS public.tipos_monstro; --
DROP TABLE IF EXISTS public.instancias_de_itens; --
DROP TABLE IF EXISTS public.itens; --
DROP TABLE IF EXISTS public.pacificos; --
DROP TABLE IF EXISTS public.agressivos; --
DROP TABLE IF EXISTS public.feiticos_dano; --
DROP TABLE IF EXISTS public.feiticos_status; --
DROP TABLE IF EXISTS public.armas; --
DROP TABLE IF EXISTS public.armaduras; --
DROP TABLE IF EXISTS public.curas; --
DROP TABLE IF EXISTS public.magicos; --
DROP TABLE IF EXISTS public.missoes; --
DROP TABLE IF EXISTS public.instancias_monstros; --
DROP TABLE IF EXISTS public.pericias; --
DROP TABLE IF EXISTS public.salas; --
DROP TABLE IF EXISTS public.andares; --
DROP TABLE IF EXISTS public.templos; --
DROP TABLE IF EXISTS public.inventarios; --
DROP TABLE IF EXISTS public.dialogos; --
DROP TABLE IF EXISTS public.npcs; --
DROP TABLE IF EXISTS public.corredores; --
DROP TABLE IF EXISTS public.personagens_jogaveis; --

-- PASSO 4: remover as funções

DROP FUNCTION IF EXISTS public.atualizar_atributos_do_personagem();
DROP FUNCTION IF EXISTS public.calcular_sanidade(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_ideia(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_conhecimento(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_sorte(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_pts_de_vida(INTEGER, INTEGER);

-- PASSO 5: remover os domínios
DROP DOMAIN IF EXISTS public.gatilho_agressividade;
DROP DOMAIN IF EXISTS public.comportamento_pacifico;
DROP DOMAIN IF EXISTS public.funcao_magica;
DROP DOMAIN IF EXISTS public.funcao_cura;
DROP DOMAIN IF EXISTS public.funcao_arma;
DROP DOMAIN IF EXISTS public.tipo_missao;
DROP DOMAIN IF EXISTS public.tipo_atributo_personagem;
DROP DOMAIN IF EXISTS public.tipo_de_status;
DROP DOMAIN IF EXISTS public.funcao_feitico;
DROP DOMAIN IF EXISTS public.tipo_dano;
DROP DOMAIN IF EXISTS public.funcao_armadura;
DROP DOMAIN IF EXISTS public.tipo_municao;
DROP DOMAIN IF EXISTS public.tipo_item;
DROP DOMAIN IF EXISTS public.tipo_personagem;
DROP DOMAIN IF EXISTS public.tipo_monstro;
DROP DOMAIN IF EXISTS public.tipo_monstro_pacifico;
DROP DOMAIN IF EXISTS public.tipo_monstro_agressivo;
DROP DOMAIN IF EXISTS public.idade;
DROP DOMAIN IF EXISTS public.atributo;
DROP DOMAIN IF EXISTS public.sexo;
DROP DOMAIN IF EXISTS public.dano;
DROP DOMAIN IF EXISTS public.script_dialogo;
DROP DOMAIN IF EXISTS public.local_nascimento;
DROP DOMAIN IF EXISTS public.residencia;
DROP DOMAIN IF EXISTS public.ocupacao;
DROP DOMAIN IF EXISTS public.descricao;
DROP DOMAIN IF EXISTS public.nome;
DROP DOMAIN IF EXISTS public.id;

-- ===============================================

--            DOMÍNIOS CRIADOS

-- ===============================================
/*

Essa seção do código é destinada a conter todos os domínios que foram criados ao longo do projeto para garantir uma maior personalização nos tipos de dados que podem ser utilizados no banco. Os domínios facilitam a manuteção do código além de garantir uma maior segurança evitando com que dados incorretos sejam inseridos nas tabelas do banco.

*/

CREATE DOMAIN public.id AS INTEGER
    CONSTRAINT id_check CHECK (
        VALUE >= 1 AND VALUE <= 999999999
    );

CREATE DOMAIN public.dano AS SMALLINT
    CONSTRAINT dano_check CHECK (
        VALUE >= 1 AND VALUE <= 500
    );  

CREATE DOMAIN public.sexo AS CHARACTER(9)
    CONSTRAINT sexo_check CHECK (
        VALUE = ANY (ARRAY[
            ('masculino'::character(9)), 
            ('feminino'::character(9))
        ])
    );

CREATE DOMAIN public.atributo AS SMALLINT
    CONSTRAINT atributo_check CHECK (
        VALUE >= 3 AND VALUE <= 18
    );

CREATE DOMAIN public.idade AS SMALLINT
    CONSTRAINT idade_check CHECK (
        VALUE >= 1 AND VALUE <= 120
    );

CREATE DOMAIN public.tipo_monstro_agressivo AS CHARACTER VARYING(8)
    CONSTRAINT tipo_monstro_agressivo_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('psiquico'::character VARYING)::text, 
            ('magico'::character VARYING)::text,
            ('fisico'::character VARYING)::text
        ])
    );

CREATE DOMAIN public.tipo_monstro_pacifico AS CHARACTER VARYING(12)
    CONSTRAINT tipo_monstro_pacifico_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('humanoide'::character VARYING)::text, 
            ('sobrenatural'::character VARYING)::text
        ])
    );

CREATE DOMAIN public.tipo_monstro AS CHARACTER VARYING(9)
    CONSTRAINT tipo_monstro_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('agressivo'::character VARYING)::text, 
            ('pacífico'::character VARYING)::text
        ])
    );

CREATE DOMAIN public.tipo_personagem AS CHARACTER VARYING(18)
    CONSTRAINT tipo_personagem_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('personagem jogavel'::CHARACTER VARYING)::text, 
            ('NPC'::CHARACTER VARYING)::text
        ])
    );

 CREATE DOMAIN public.tipo_item AS CHARACTER VARYING(8)
    CONSTRAINT tipo_item_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('armadura'::character VARYING)::text, 
            ('arma'::character VARYING)::text,
            ('cura'::character VARYING)::text
        ])
    );   

 CREATE DOMAIN public.tipo_municao AS CHARACTER(13)
    CONSTRAINT tipo_municao_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('baixo-calibre'::character)::text, 
            ('medio-calibre'::character)::text,
            ('alto-calibre'::character)::text
        ])
    );  
    
 CREATE DOMAIN public.funcao_armadura AS CHARACTER(8)
    CONSTRAINT funcao_armadura_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('cabeca'::character)::text, 
            ('peitoral'::character)::text,
            ('bracos'::character)::text,
            ('pernas'::character)::text,
            ('pes'::character)::text,
            ('mao'::character)::text
        ])
    );    

 CREATE DOMAIN public.tipo_dano AS CHARACTER(5)
    CONSTRAINT tipo_dano_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('area'::character)::text, 
            ('unico'::character)::text
        ])
    );     

CREATE DOMAIN public.funcao_feitico AS CHARACTER(6)
    CONSTRAINT funcao_feitico_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('status'::character)::text, 
            ('dano'::character)::text
        ])
    );  

 CREATE DOMAIN public.tipo_de_status AS CHARACTER(8)
    CONSTRAINT tipo_de_status_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('vida'::character)::text, 
            ('sanidade'::character)::text
        ])
    );  

CREATE DOMAIN public.tipo_atributo_personagem AS CHARACTER(12)
    CONSTRAINT tipo_atributo_personagem_check CHECK (
        VALUE IN ('forca', 'constituicao', 'poder', 'destreza', 'aparencia', 'tamanho', 'inteligencia', 'educacao')
    ); 


-- Pode ser alterado a qualquer momento para garantir que mais tuplas se comportem no dml
CREATE DOMAIN public.tipo_missao AS CHARACTER(16)
    CONSTRAINT tipo_missao_check CHECK (
        VALUE IN ('principal', 'secundaria', 'coleta', 'eliminacao', 'escolta')
    );   

-- Pode ser alterado a qualquer momento para garantir que mais tuplas se comportem no dml
CREATE DOMAIN public.funcao_arma AS CHARACTER(32)
    CONSTRAINT funcao_arma_check CHECK (
        VALUE IN ('corpo_a_corpo_leve', 'corpo_a_corpo_pesada', 'arremesso', 'disparo_unico', 'disparo_rajada')
    );   

-- Pode ser alterado a qualquer momento para garantir que mais tuplas se comportem no dml
CREATE DOMAIN public.funcao_cura AS CHARACTER(32)
    CONSTRAINT funcao_cura_check CHECK (
        VALUE IN ('restaurar_vida', 'restaurar_sanidade', 'remover_veneno', 'remover_maldicao', 'antidoto_insanidade')
    );

-- Pode ser alterado a qualquer momento para garantir que mais tuplas se comportem no dml
CREATE DOMAIN public.funcao_magica AS CHARACTER(32)
    CONSTRAINT funcao_magica_check CHECK (
        VALUE IN ('revelar_invisivel', 'abrir_fechadura', 'encantar_arma', 'invocar_criatura', 'teleporte', 'protecao_elemental')
    );

-- Pode ser alterado a qualquer momento para garantir que mais tuplas se comportem no dml
CREATE DOMAIN public.gatilho_agressividade AS CHARACTER(32)
    CONSTRAINT gatilho_agressividade_check CHECK (
        VALUE IN ('proximidade', 'ataque_direto', 'barulho_alto', 'alvo_especifico', 'horario_noturno', 'ver_item_sagrado')
    );

-- Pode ser alterado a qualquer momento para garantir que mais tuplas se comportem no dml
CREATE DOMAIN public.comportamento_pacifico AS CHARACTER(32)
    CONSTRAINT comportamento_pacifico_check CHECK (
        VALUE IN ('indiferente', 'medroso', 'amigavel', 'sob_controle_mental', 'adormecido', 'curioso')
    );


CREATE DOMAIN public.nome AS CHARACTER(128);

CREATE DOMAIN public.descricao AS CHARACTER(5000);

CREATE DOMAIN public.ocupacao AS CHARACTER(64);

CREATE DOMAIN public.residencia AS CHARACTER(96);

CREATE DOMAIN public.local_nascimento AS CHARACTER(96);

CREATE DOMAIN public.script_dialogo AS CHARACTER(512);  

-- ===============================================

--      FUNÇÕES PARA CALCULAR ATRIBUTOS

-- ===============================================

CREATE FUNCTION calcular_sanidade(valor_poder INTEGER)
RETURNS SMALLINT AS $calcular_sanidade$
BEGIN
    RETURN valor_poder * 5;
END
$calcular_sanidade$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION calcular_ideia(valor_inteligencia INTEGER)
RETURNS SMALLINT AS $calcular_ideia$
BEGIN
    RETURN valor_inteligencia * 5;
END
$calcular_ideia$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION calcular_conhecimento(valor_educacao INTEGER)
RETURNS SMALLINT AS $calcular_conhecimento$
BEGIN
    RETURN valor_educacao * 5;
END
$calcular_conhecimento$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION calcular_sorte(valor_poder INTEGER)
RETURNS SMALLINT AS $calcular_sorte$
BEGIN
    RETURN valor_poder * 5;
END
$calcular_sorte$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION calcular_pts_de_vida(valor_constituicao INTEGER, valor_tamanho INTEGER)
RETURNS INTEGER AS $calcular_pts_de_vida$
BEGIN
    RETURN (valor_constituicao + valor_tamanho) / 2;
END
$calcular_pts_de_vida$ LANGUAGE plpgsql IMMUTABLE;

-- ===============================================

--             TABELAS DO RPG

-- ===============================================

CREATE TABLE public.personagens_jogaveis(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL,
    ocupacao public.ocupacao NOT NULL,
    residencia public.residencia NOT NULL,
    local_nascimento public.local_nascimento NOT NULL,

    idade public.idade DEFAULT 18 NOT NULL,
    sexo public.sexo NOT NULL,

    forca public.atributo NOT NULL, -- 3d6
    constituicao public.atributo NOT NULL, -- 3d6
    poder public.atributo NOT NULL, -- 3d6
    destreza public.atributo NOT NULL, -- 3d6
    aparencia public.atributo NOT NULL, -- 3d6
    tamanho public.atributo NOT NULL, -- 3d6
    inteligencia public.atributo NOT NULL, -- 3d6
    educacao public.atributo NOT NULL, -- 3d6


    movimento SMALLINT NOT NULL, -- (destreza < tamanho) && (forca < tamanho) ? movimento = 7; (destreza = tamanho) || (forca = tamanho) ? movimento = 8; (destreza > tamanho) && (forca > tamanho) ? movimento = 9;

    sanidade_atual SMALLINT NOT NULL, -- = forca 
    insanidade_temporaria BOOLEAN, 
    insanidade_indefinida BOOLEAN, -- quando sanidade é 0
    
   	PM_base SMALLINT NOT NULL, 
    PM_max SMALLINT NOT NULL,

    pontos_de_vida_atual SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_sala public.id,  
    id_corredor public.id, 
    id_inventario public.id NOT NULL, 
    id_armadura public.id, 
    id_arma public.id,
    id_tipo_personagem public.id NOT NULL

    /*

    São atributos originalmente da tabela personagens_jogaveis, contudo, ferem a terceira forma normal devido a transitividade de atributos. Assim, foi criado uma view que extende esses atributos e deixa o banco normalizado.

    ideia SMALLINT, -- inteligencia x 5
    conhecimento SMALLINT, -- educacao x 5
    sorte SMALLINT,  -- poder x 5
    pts_de_vida_maximo INTEGER, -- (constituicao + tamanho) / 2
    sanidade_maxima SMALLINT, -- poder x 5
    */
);

CREATE TABLE public.npcs(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL,
    ocupacao public.ocupacao NOT NULL,

    idade public.idade DEFAULT 18 NOT NULL,
    sexo public.sexo NOT NULL,

    residencia public.residencia NOT NULL,
    local_nascimento public.local_nascimento DEFAULT 'arkham' NOT NULL,

    -- FOREIGN KEYS
    id_sala public.id, 
    id_corredor public.id,
    id_tipo_personagem public.id NOT NULL
);

CREATE TABLE public.dialogos(
    id public.id NOT NULL PRIMARY KEY,
    script_dialogo public.script_dialogo NOT NULL,

    -- FOREIGN KEYS
    npc_id public.id NOT NULL 

);

CREATE TABLE public.inventarios(
    id public.id NOT NULL PRIMARY KEY,
    tamanho SMALLINT NOT NULL
);

CREATE TABLE public.templos(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.andares(
    id public.id NOT NULL PRIMARY KEY,
    descricao public.descricao NOT NULL,

    -- FOREIGN KEYS
    id_templo public.id NOT NULL,
    sala_inicial public.id NOT NULL
);

CREATE TABLE public.salas(
    id public.id NOT NULL PRIMARY KEY,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.corredores(
    id public.id NOT NULL PRIMARY KEY,
    status BOOLEAN NOT NULL,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.pericias(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    valor SMALLINT,
    eh_de_ocupacao BOOLEAN
);

CREATE TABLE public.agressivos(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    defesa SMALLINT,
    vida SMALLINT NOT NULL,
    catalisador_agressividade public.gatilho_agressividade,
    poder SMALLINT,
    tipo_agressivo public.tipo_monstro_agressivo NOT NULL,
    velocidade_ataque SMALLINT,
    loucura_induzida SMALLINT,
    ponto_magia SMALLINT,
    dano public.dano NOT NULL
);

CREATE TABLE public.pacificos(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    defesa SMALLINT NOT NULL,
    vida SMALLINT NOT NULL,
    motivo_passividade public.comportamento_pacifico,
    tipo_pacifico public.tipo_monstro_pacifico NOT NULL,
    conhecimento_geografico CHARACTER(128),
    conhecimento_proibido CHARACTER(128)
);

CREATE TABLE public.instancias_monstros(
    id public.id NOT NULL PRIMARY KEY,

    -- FOREING KEYS
    id_instancia_de_item public.id NOT NULL,
    id_sala public.id,  
    id_corredor public.id,
    id_monstro public.id NOT NULL
);

CREATE TABLE public.missoes(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao CHARACTER(512) NOT NULL,
    tipo public.tipo_missao NOT NULL,
    ordem CHARACTER(128) NOT NULL,

    -- FOREIGN KEYS
    id_npc public.id NOT NULL 
);

CREATE TABLE public.magicos(
    id public.id NOT NULL PRIMARY KEY,
    funcao public.funcao_magica NOT NULL,
    qts_usos SMALLINT NOT NULL,
    custo_sanidade SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_feitico public.id NOT NULL
);

CREATE TABLE public.curas(
    id public.id NOT NULL PRIMARY KEY,
    funcao public.funcao_cura NOT NULL,
    qts_usos SMALLINT NOT NULL,
    qtd_pontos_sanidade_recupera SMALLINT NOT NULL,
    qtd_pontos_vida_recupera SMALLINT NOT NULL
);

CREATE TABLE public.armaduras(
    id public.id NOT NULL PRIMARY KEY,
    atributo_necessario public.tipo_atributo_personagem,
    durabilidade SMALLINT NOT NULL,
    funcao funcao_armadura NOT NULL,
    qtd_atributo_recebe SMALLINT NOT NULL,
    qtd_atributo_necessario SMALLINT NOT NULL,
    tipo_atributo_recebe public.tipo_atributo_personagem,
    qtd_dano_mitigado SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_pericia_necessaria public.id NOT NULL
);

CREATE TABLE public.armas(
    id public.id NOT NULL PRIMARY KEY,
    atributo_necessario public.tipo_atributo_personagem,
    qtd_atributo_necessario SMALLINT NOT NULL,
    durabilidade SMALLINT NOT NULL,
    funcao public.funcao_arma,
    alcance SMALLINT,
    tipo_municao public.tipo_municao DEFAULT NULL,
    tipo_dano public.tipo_dano NOT NULL,
    dano public.dano NOT NULL,
    
    -- FOREIGN KEYS
    id_pericia_necessaria public.id NOT NULL
);

CREATE TABLE public.feiticos_status(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    qtd_pontos_de_magia SMALLINT NOT NULL,
    buff_debuff BOOLEAN NOT NULL,
    qtd_buff_debuff SMALLINT,
    status_afetado public.tipo_de_status NOT NULL
);

CREATE TABLE public.feiticos_dano(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    qtd_pontos_de_magia SMALLINT NOT NULL,
    tipo_dano public.tipo_dano NOT NULL,
    qtd_dano public.dano NOT NULL
);


CREATE TABLE public.itens(
    id public.id NOT NULL PRIMARY KEY,
    tipo public.tipo_item NOT NULL,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    valor SMALLINT
);

CREATE TABLE public.instancias_de_itens(
    id public.id NOT NULL PRIMARY KEY,
    durabilidade SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_sala public.id,
    id_missao_requer public.id,
    id_missao_recompensa public.id,
    id_item public.id NOT NULL
);

-- ===============================================

--             TABELAS DE TIPOS

-- =============================================== 

CREATE TABLE public.tipos_personagem(
    id public.id NOT NULL PRIMARY KEY,
    tipo public.tipo_personagem NOT NULL
);

CREATE TABLE public.tipos_feitico(
	id public.id NOT NULL PRIMARY KEY,
    tipo public.funcao_feitico NOT NULL
);

CREATE TABLE public.tipos_monstro(
    id public.id NOT NULL PRIMARY KEY,
    tipo public.tipo_monstro NOT null
);

-- ===============================================

--  TABELAS DE RELACIONAMENTOS MUITOS PARA MUITOS

-- =============================================== 

/*
Essa seção contém as tabelas derivadas de relacionamentos N para N
*/

CREATE TABLE public.batalhas(
    id_jogador public.id NOT NULL,
    id_monstro public.id NOT NULL,
    PRIMARY KEY (id_jogador, id_monstro)
);

CREATE TABLE public.entregas_missoes(
    id_jogador public.id NOT NULL,
    id_npc public.id NOT NULL,
    PRIMARY KEY (id_jogador, id_npc)
);

CREATE TABLE public.corredores_salas_destino(
    id_sala public.id NOT NULL,
    id_corredor public.id NOT NULL, 
    PRIMARY KEY (id_sala, id_corredor)
);

CREATE TABLE public.inventarios_possuem_instancias_item(
    id_instancias_de_item public.id NOT NULL,
    id_inventario public.id NOT NULL,
    PRIMARY KEY (id_instancias_de_item, id_inventario)
);

CREATE TABLE public.personagens_possuem_pericias (
    valor_atual SMALLINT NOT NULL,
    PRIMARY KEY (id_personagem, id_pericia),

    -- FOREIGN KEYS
    id_personagem public.id NOT NULL,
    id_pericia public.id NOT NULL
);

-- ===============================================

--                  VIEWS

-- =============================================== 

/* 
A view view_personagens_jogaveis_completos extende da tabela de personagens jogaveis criando os atributos: ideia, conhecimento, sorte, pts_de_vida e sanidade máxima. Esses atributos originalmente estavam na tabela personagens_jogaveis, contudo eles são derivações de outros atributos da mesma tabela. Isso fere a terceira forma normal. Assim, a view criada busca garantir que esses atributos continuem a ser utilizados mas, que ao mesmo tempo deixa o banco normalizado.
*/

CREATE OR REPLACE VIEW public.view_personagens_jogaveis_completos AS
SELECT
    pj.*, -- seleciona todas as colunas originais de personagens_jogaveis
    public.calcular_ideia(pj.inteligencia) AS ideia,
    public.calcular_conhecimento(pj.educacao) AS conhecimento,
    public.calcular_sorte(pj.poder) AS sorte,
    public.calcular_pts_de_vida(pj.constituicao, pj.tamanho) AS pts_de_vida,
    public.calcular_sanidade(pj.poder) AS sanidade_maxima
FROM
    public.personagens_jogaveis pj;

-- ===============================================

--                RESTRIÇÕES

-- ===============================================

/*
Essas próximas três restrições garantem que o personagem ou NPC não esteja em uma sala ou corredor ao mesmo tempo, ou não esteja em nenhum dos dois ao mesmo tempo
*/

ALTER TABLE public.personagens_jogaveis
ADD CONSTRAINT chk_pj_local_exclusivo
    CHECK ((id_sala IS NOT NULL AND id_corredor IS NULL) OR 
            (id_sala IS NULL AND id_corredor IS NOT NULL));

ALTER TABLE public.npcs
ADD CONSTRAINT chk_pj_local_exclusivo
    CHECK ((id_sala IS NOT NULL AND id_corredor IS NULL) OR 
            (id_sala IS NULL AND id_corredor IS NOT NULL));  

ALTER TABLE public.instancias_monstros
ADD CONSTRAINT chk_pj_local_exclusivo
    CHECK ((id_sala IS NOT NULL AND id_corredor IS NULL) OR 
            (id_sala IS NULL AND id_corredor IS NOT NULL)); 

-- ===============================================

--              CHAVES ESTRAGEIRAS 

-- ===============================================
/*
Seção destinada a conter todos os relacionamentos que envolvem chaves estrageiras do banco, elas estão dividas em seções menores, cada uma para as relações daquela tabela em específico.
*/

--  PERSONAGENS JOGÁVEIS

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario 
    FOREIGN KEY (id_inventario) 
    REFERENCES public.inventarios (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_salas 
    FOREIGN KEY (id_sala) 
    REFERENCES public.salas (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_corredores 
    FOREIGN KEY (id_corredor) 
    REFERENCES public.corredores (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario_instancia_arma
    FOREIGN KEY (id_arma) 
    REFERENCES public.instancias_de_itens (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario_instancia_armadura 
    FOREIGN KEY (id_armadura) 
    REFERENCES public.instancias_de_itens (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_tipos_personagem 
    FOREIGN KEY (id_tipo_personagem) 
    REFERENCES public.tipos_personagem (id);  

-- PERSONAGENS POSSUEM PERÍCIAS

ALTER TABLE public.personagens_possuem_pericias
ADD CONSTRAINT fk_personagens_possuem_pericias_pj
    FOREIGN KEY (id_personagem)
    REFERENCES public.personagens_jogaveis(id);

ALTER TABLE public.personagens_possuem_pericias
ADD CONSTRAINT  fk_personagens_possuem_pericias_pericia
    FOREIGN KEY (id_pericia) 
    REFERENCES public.pericias(id);

-- NPCS

ALTER TABLE public.npcs 
ADD CONSTRAINT fk_npcs_salas 
    FOREIGN KEY (id_sala) 
    REFERENCES public.salas (id);

ALTER TABLE public.npcs 
ADD CONSTRAINT fk_npcs_corredores 
    FOREIGN KEY (id_corredor) 
    REFERENCES public.corredores (id);

ALTER TABLE public.npcs 
ADD CONSTRAINT fk_npcs_tipos_personagem 
    FOREIGN KEY (id_tipo_personagem) 
    REFERENCES public.tipos_personagem (id);    

-- DIÁLOGOS

ALTER TABLE public.dialogos 
ADD CONSTRAINT fk_dialogos_npc
    FOREIGN KEY (npc_id) 
    REFERENCES public.npcs (id);

-- ANDARES

ALTER TABLE public.andares 
ADD CONSTRAINT fk_andares_templo 
    FOREIGN KEY (id_templo) 
    REFERENCES public.templos (id);

ALTER TABLE public.andares 
ADD CONSTRAINT fk_andares_salas 
    FOREIGN KEY (sala_inicial) 
    REFERENCES public.salas (id);

-- CORREDORES E SALAS
ALTER TABLE public.corredores_salas_destino 
ADD CONSTRAINT fk_corredores_salas_destino_corredores 
    FOREIGN KEY (id_corredor) 
    REFERENCES public.corredores (id);

ALTER TABLE public.corredores_salas_destino 
ADD CONSTRAINT fk_corredores_salas_destino_salas 
    FOREIGN KEY (id_sala) 
    REFERENCES public.salas (id);

-- CURAS

ALTER TABLE public.curas
ADD CONSTRAINT fk_curas_itens
    FOREIGN KEY (id)
    REFERENCES public.itens (id);

-- INVENTÁRIO

ALTER TABLE public.inventarios_possuem_instancias_item 
ADD CONSTRAINT fk_inventarios_possuem_instancias_de_item 
    FOREIGN KEY (id_instancias_de_item) 
    REFERENCES public.instancias_de_itens (id);

ALTER TABLE public.inventarios_possuem_instancias_item 
ADD CONSTRAINT fk_inventarios_possuem_instancias_de_item_inventario 
    FOREIGN KEY (id_inventario) 
    REFERENCES public.inventarios (id);    

-- MÁGICOS E FEITIÇOS

ALTER TABLE public.magicos 
ADD CONSTRAINT fk_magicos_tipos_feitico 
    FOREIGN KEY (id_feitico) 
    REFERENCES public.tipos_feitico (id);

ALTER TABLE public.magicos 
ADD CONSTRAINT fk_magicos_itens 
    FOREIGN KEY (id) 
    REFERENCES public.itens (id);    

-- FEITIÇOS STATUS

ALTER TABLE public.feiticos_status 
ADD CONSTRAINT fk_feiticos_status_tipo_feitico 
    FOREIGN KEY (id) 
    REFERENCES public.tipos_feitico (id);

-- FEITIÇOS DANO

ALTER TABLE public.feiticos_dano 
ADD CONSTRAINT fk_feiticos_dano_tipo_feitico 
    FOREIGN KEY (id) 
    REFERENCES public.tipos_feitico (id);

-- INSTÂNCIAS DE MONSTRO

ALTER TABLE public.instancias_monstros
ADD CONSTRAINT fk_instancias_de_monstro_tipo_monstro 
    FOREIGN KEY (id_monstro) 
    REFERENCES public.tipos_monstro (id);

ALTER TABLE public.instancias_monstros 
ADD CONSTRAINT fk_instancias_monstro_salas 
    FOREIGN KEY (id_sala) 
    REFERENCES public.salas (id);

ALTER TABLE public.instancias_monstros 
ADD CONSTRAINT fk_instancias_monstro_corredores 
    FOREIGN KEY (id_corredor) 
    REFERENCES public.corredores (id);

ALTER TABLE public.instancias_monstros
ADD CONSTRAINT fk_instancias_monstro_instancia_de_item 
    FOREIGN KEY (id_instancia_de_item) 
    REFERENCES public.instancias_de_itens (id);

-- MONSTROS PACÍFICOS

ALTER TABLE public.pacificos 
ADD CONSTRAINT fk_pacificos_tipo_monstro 
    FOREIGN KEY (id) 
    REFERENCES public.tipos_monstro (id);

-- MONSTROS AGRESSIVOS

ALTER TABLE public.agressivos 
ADD CONSTRAINT fk_agressivos_tipo_monstro 
    FOREIGN KEY (id) 
    REFERENCES public.tipos_monstro (id);

-- BATALHAS

ALTER TABLE public.batalhas 
ADD CONSTRAINT fk_batalhas_personagens_jogaveis 
    FOREIGN KEY (id_jogador) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.batalhas 
ADD CONSTRAINT fk_batalhas_monstro 
    FOREIGN KEY (id_monstro) 
    REFERENCES public.instancias_monstros (id);

-- MISSÕES

ALTER TABLE public.missoes 
ADD CONSTRAINT fk_missoes_npcs 
    FOREIGN KEY (id_npc) 
    REFERENCES public.npcs (id);

-- ENTREGAS DE MISSÕES

ALTER TABLE public.entregas_missoes 
ADD CONSTRAINT fk_entregas_missoes_personagens_jogaveis 
    FOREIGN KEY (id_jogador) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.entregas_missoes 
ADD CONSTRAINT fk_entregas_missoes_npcs 
    FOREIGN KEY (id_npc) 
    REFERENCES public.npcs (id);

-- INSTÂNCIAS DE ITENS

ALTER TABLE public.instancias_de_itens 
ADD CONSTRAINT fk_instancias_de_itens_missoes_recompensa
    FOREIGN KEY (id_missao_recompensa) 
    REFERENCES public.missoes (id);

ALTER TABLE public.instancias_de_itens 
ADD CONSTRAINT fk_instancias_de_itens_missoes_requer
    FOREIGN KEY (id_missao_requer) 
    REFERENCES public.missoes (id);

ALTER TABLE public.instancias_de_itens 
ADD CONSTRAINT fk_instancias_de_item_itens
    FOREIGN KEY (id_item) 
    REFERENCES public.itens (id);  

ALTER TABLE public.instancias_de_itens 
ADD CONSTRAINT fk_instancias_de_item_salas 
    FOREIGN KEY (id_sala) 
    REFERENCES public.salas (id);  

-- ARMADURAS

ALTER TABLE public.armaduras 
ADD CONSTRAINT fk_armaduras_pericia_necessaria
    FOREIGN KEY (id_pericia_necessaria) 
    REFERENCES public.pericias (id);

ALTER TABLE public.armaduras 
ADD CONSTRAINT fk_armaduras_itens
    FOREIGN KEY (id) 
    REFERENCES public.itens (id);    

 -- ARMAS

ALTER TABLE public.armas 
ADD CONSTRAINT fk_armas_pericia_necessaria
    FOREIGN KEY (id_pericia_necessaria) 
    REFERENCES public.pericias (id);   

ALTER TABLE public.armas 
ADD CONSTRAINT fk_armas_itens
    FOREIGN KEY (id) 
    REFERENCES public.itens (id); 

-- TIPOS PERSONAGEM
/*
ALTER TABLE public.tipos_personagem
ADD CONSTRAINT fk_tipos_personagem_personagens_jogaveis
    FOREIGN KEY (id)
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.tipos_personagem
ADD CONSTRAINT fk_tipos_personagem_npc
    FOREIGN KEY (id)
    REFERENCES public.npcs (id);
*/

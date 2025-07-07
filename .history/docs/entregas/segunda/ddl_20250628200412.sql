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

Versão: 0.9
Data: 12/06/2025
Descrição: Ajustando as tabelas CREATE TABLE public.personagens_jogaveis e adicionando o id integer para criar IDs sem ser manualmente id INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
e a tabela inventario.
Autor: João Marcos

Versão: 0.10
Data: 13/06/2025
Descrição: Criação de ids especilizados para cada tabela do banco
Autor: Luiz Guilherme

Versão: 0.11
Data: 13/06/2025
Descrição: Melhorando os novos domínios de IDs especializados para cada tabela utilizando o id_geral como base
Autor: Luiz Guilherme

Versão: 0.12
Data: 13/06/2025
Descrição: Adicionando as funções que geram os IDs do personagem_jogavel e do inventário de forma automática garantindo a integridade do banco
Autor: Luiz Guilherme


Versão: 1.0
Data: 14/06/2025
Descrição: Adicionando geradores de IDs para as tabelas do banco de dados
Autor: Luiz Guilherme


*/

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- ===============================================

--            DROP TABLES

-- ===============================================

-- PASSO 1: remover os triggers e VIEWS
/*
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

DROP DOMAIN IF EXISTS public.id_geral;
DROP DOMAIN IF EXISTS public.id_personagem;
DROP DOMAIN IF EXISTS public.id_personagem_jogavel;
DROP DOMAIN IF EXISTS public.id_personagem_npc;
DROP DOMAIN IF EXISTS public.id_monstro
DROP DOMAIN IF EXISTS public.id_monstro_agressivo;
DROP DOMAIN IF EXISTS public.id_monstro_pacifico;
DROP DOMAIN IF EXISTS public.id_item;
DROP DOMAIN IF EXISTS public.id_item_magico;
DROP DOMAIN IF EXISTS public.id_item_de_cura;
DROP DOMAIN IF EXISTS public.id_item_de_armadura;
DROP DOMAIN IF EXISTS public.id_item_arma;
DROP DOMAIN IF EXISTS public.id_localizacao;
DROP DOMAIN IF EXISTS public.id_templo;
DROP DOMAIN IF EXISTS public.id_andar;
DROP DOMAIN IF EXISTS public.id_local;
DROP DOMAIN IF EXISTS public.id_corredor;
DROP DOMAIN IF EXISTS public.id_missao;
DROP DOMAIN IF EXISTS public.id_feitico;
DROP DOMAIN IF EXISTS public.id_feitico_de_status;
DROP DOMAIN IF EXISTS public.id_feitico_de_dano;
DROP DOMAIN IF EXISTS public.id_dialogo;
DROP DOMAIN IF EXISTS public.id_pericia;
DROP DOMAIN IF EXISTS public.id_instancia_de_item;
DROP DOMAIN IF EXISTS public.id_instancia_de_monstro;

*/
-- ===============================================

--            DOMÍNIOS CRIADOS

-- ===============================================
/*

Essa seção do código é destinada a conter todos os domínios que foram criados ao longo do projeto para garantir uma maior personalização nos tipos de dados que podem ser utilizados no banco. Os domínios facilitam a manuteção do código além de garantir uma maior segurança evitando com que dados incorretos sejam inseridos nas tabelas do banco.

*/

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


CREATE DOMAIN public.nome AS CHARACTER VARYING(128);

CREATE DOMAIN public.descricao AS CHARACTER VARYING(5000);

CREATE DOMAIN public.ocupacao AS CHARACTER(64);

CREATE DOMAIN public.residencia AS CHARACTER(96);

CREATE DOMAIN public.local_nascimento AS CHARACTER(96);

CREATE DOMAIN public.script_dialogo AS CHARACTER(512); 


-- ===============================================

--            DOMÍNIOS PARA OS IDS

-- ===============================================

-- CRIAÇÃO DE UM DOMÍNIO BASE
CREATE DOMAIN public.id_geral AS BIGINT
    CONSTRAINT id_geral CHECK (
        VALUE BETWEEN 10000000 AND 99999999
    );

-- ========== IDS PARA PERSONAGENS =========

-- CRIAÇÃO DO DOMÍNIO DOS PERSONAGENS
-- TODO PERSONAGEM TEM ID QUE COMEÇA COM 01
CREATE DOMAIN public.id_personagem AS public.id_geral
    CONSTRAINT id_personagem_check CHECK (
        VALUE BETWEEN 10000000 AND 19999999
);

-- CRIAÇÃO DO DOMÍNIO DOS PERSONAGENS JOGÁVEIS
-- TODO PERSONAGEM JOGÁVEL TEM ID QUE COMEÇA COM 0101
CREATE DOMAIN public.id_personagem_jogavel AS public.id_personagem
    CONSTRAINT id_personagem_jogavel_check CHECK (
        VALUE BETWEEN 10100000 AND 10199999
);

-- CRIAÇÃO DO DOMÍNIO DOS PERSONAGENS NPCS
-- TODO PERSONAGEM NPC COM 0102
CREATE DOMAIN public.id_personagem_npc AS public.id_personagem
    CONSTRAINT id_personagem_npc_check CHECK (
        VALUE BETWEEN 10200000 AND 10209999
);

-- ========== IDS PARA MONSTROS =========

-- CRIAÇÃO DO DOMÍNIO DOS PERSONAGENS
-- TODO MONSTRO TEM ID QUE COMEÇA COM 02
CREATE DOMAIN public.id_monstro AS public.id_geral
    CONSTRAINT id_monstro_check CHECK (
        VALUE BETWEEN 20000000 AND 29999999
);

-- CRIAÇÃO DO DOMÍNIO DOS MONSTROS AGRESSIVOS
-- TODO MONSTRO AGRESSIVOS TEM ID QUE COMEÇA COM 0201
CREATE DOMAIN public.id_monstro_agressivo AS public.id_monstro
    CONSTRAINT id_monstro_agressivo_check CHECK (
        VALUE BETWEEN 20100000 AND 20199999
);

-- CRIAÇÃO DO DOMÍNIO DOS MONSTROS PACÍFICOS
-- TODO MONSTRO PACÍFICOS TEM ID QUE COMEÇA COM 0202
CREATE DOMAIN public.id_monstro_pacifico AS public.id_monstro
    CONSTRAINT id_monstro_pacifico_check CHECK (
        VALUE BETWEEN 20200000 AND 20299999
);

-- ========== IDS PARA ITENS =========

-- CRIAÇÃO DO DOMÍNIO DOS ITENS
-- TODO ITEM TEM ID QUE COMEÇA COM 03
CREATE DOMAIN public.id_item AS public.id_geral
    CONSTRAINT id_item_check CHECK (
        VALUE BETWEEN 30000000 AND 39999999
);

-- CRIAÇÃO DO DOMÍNIO DOS ITENS MÁGICOS
-- TODO ITEM MÁGICO TEM ID QUE COMEÇA COM 0301
CREATE DOMAIN public.id_item_magico AS public.id_item
    CONSTRAINT id_item_magico_check CHECK (
        VALUE BETWEEN 30100000 AND 30199999
);

-- CRIAÇÃO DO DOMÍNIO DOS ITENS DE CURA
-- TODO ITEM DE CURA TEM ID QUE COMEÇA COM 0302
CREATE DOMAIN public.id_item_de_cura AS public.id_item
    CONSTRAINT id_item_de_cura_check CHECK (
        VALUE BETWEEN 30200000 AND 30299999
);

-- CRIAÇÃO DO DOMÍNIO DOS ITENS DE ARMADURA
-- TODO ITEM DE ARMADURA TEM ID QUE COMEÇA COM 0303
CREATE DOMAIN public.id_item_de_armadura AS public.id_item
    CONSTRAINT id_item_de_armadura_check CHECK (
        VALUE BETWEEN 30300000 AND 30399999
);

-- CRIAÇÃO DO DOMÍNIO DOS ITENS DO TIPO ARMA
-- TODO ITEM DO TIPO ARMA TEM ID QUE COMEÇA COM 0304
CREATE DOMAIN public.id_item_arma AS public.id_item
    CONSTRAINT id_item_arma_check CHECK (
        VALUE BETWEEN 30400000 AND 30499999
);

-- ========== IDS PARA LOCALIZAÇÕES =========

-- TODO ITEM DE LOCALIZAÇÃO COMEÇA COM 04

CREATE DOMAIN public.id_localizacao AS public.id_geral
    CONSTRAINT id_localizacao_check CHECK (
        VALUE BETWEEN 40000000 AND 49999999
);

-- CRIAÇÃO DO DOMÍNIO DOS TEMPLOS
-- TODO TEMPLOS TEM ID QUE COMEÇA COM 0401
CREATE DOMAIN public.id_templo AS public.id_localizacao
    CONSTRAINT id_templo_check CHECK (
        VALUE BETWEEN 40100000 AND 40199999
);

-- CRIAÇÃO DO DOMÍNIO DOS ANDARES
-- TODO ANDAR TEM ID QUE COMEÇA COM 0402
CREATE DOMAIN public.id_andar AS public.id_localizacao
    CONSTRAINT id_andar_check CHECK (
        VALUE BETWEEN 40200000 AND 40299999
);

-- CRIAÇÃO DO DOMÍNIO DAS SALAS
-- TODA SALA TEM ID QUE COMEÇA COM 0403
CREATE DOMAIN public.id_local AS public.id_localizacao
    CONSTRAINT id_local_check CHECK (
        VALUE BETWEEN 40300000 AND 40399999
);


-- ========== IDS PARA MISSÕES =========

-- CRIAÇÃO DO DOMÍNIO DAS MISSÕES
-- TODA MISSÃO TEM ID QUE COMEÇA COM 05
CREATE DOMAIN public.id_missao AS public.id_geral
    CONSTRAINT id_missao_check CHECK (
    VALUE BETWEEN 50000000 AND 59999999
);

-- ========== IDS PARA FEITIÇOS =========

-- CRIAÇÃO DO DOMÍNIO DOS FEITIÇOS
-- TODO FEITIÇO TEM ID QUE COMEÇA COM 06
CREATE DOMAIN public.id_feitico AS public.id_geral
    CONSTRAINT id_feitico_check CHECK (
    VALUE BETWEEN 60000000 AND 69999999
);

-- CRIAÇÃO DO DOMÍNIO DOS FEITIÇOS DE STATUS
-- TODO FEITIÇO DE STATUS TEM ID QUE COMEÇA COM 0601
CREATE DOMAIN public.id_feitico_de_status AS public.id_feitico
    CONSTRAINT id_feitico_de_status_check CHECK (
    VALUE BETWEEN 60100000 AND 60199999
);

-- CRIAÇÃO DO DOMÍNIO DOS FEITIÇOS DE DANO
-- TODO FEITIÇO DE DANO TEM ID QUE COMEÇA COM 0602
CREATE DOMAIN public.id_feitico_de_dano AS public.id_feitico
    CONSTRAINT id_feitico_de_dano_check CHECK (
    VALUE BETWEEN 60200000 AND 60299999
);

-- ========== IDS PARA OS DIÁLOGOS =========

-- CRIAÇÃO DO DOMÍNIO DOS DIÁLOGOS
-- TODO DIÁLOGO TEM ID QUE COMEÇA COM 07
CREATE DOMAIN public.id_dialogo AS public.id_geral
    CONSTRAINT id_dialogo_check CHECK (
    VALUE BETWEEN 70000000 AND 79999999
);

-- ========== IDS PARA AS PERÍCIAS =========

-- CRIAÇÃO DO DOMÍNIO DAS PERÍCIAS
-- TODA PERÍCIA TEM ID QUE COMEÇA COM 08
CREATE DOMAIN public.id_pericia AS public.id_geral
    CONSTRAINT id_pericia_check CHECK (
    VALUE BETWEEN 80000000 AND 89999999
);

-- ========== IDS PARA OS INVETÁRIOS =========

-- CRIAÇÃO DO DOMÍNIO DOS INVETÁRIOS
-- TODO INVETÁRIO TEM ID QUE COMEÇA COM 09
CREATE DOMAIN public.id_inventario AS public.id_geral
    CONSTRAINT id_inventario_check CHECK (
    VALUE BETWEEN 90000000 AND 99999999
);

-- ========== IDS PARA PERSONAGENS POSSUEM PERÍCIAS =========

-- CRIAÇÃO DO DOMÍNIO DOS PERSONAGENS POSSUEM PERÍCIAS
-- TODO PERSONAGENS POSSUEM PERÍCIAS TEM ID QUE COMEÇA COM 13
CREATE DOMAIN public.id_personagens_possuem_pericias AS public.id_geral
    CONSTRAINT id_personagens_possuem_pericias_check CHECK (
    VALUE BETWEEN 13000000 AND 13999999
);

-- ========== IDS PARA INSTÂNCIAS DE ITEM =========

-- CRIAÇÃO DO DOMÍNIO DAS INSTÂNCIAS DE ITEM
-- TODA INSTÂNCIA DE ITEM TEM ID QUE COMEÇA COM 88
CREATE DOMAIN public.id_instancia_de_item AS public.id_geral
    CONSTRAINT id_instancia_de_item_check CHECK (
    VALUE BETWEEN 88000000 AND 88999999
);

-- ========== IDS PARA INSTÂNCIAS DE MONSTRO =========

-- CRIAÇÃO DO DOMÍNIO DAS INSTÂNCIAS DE MONSTRO
-- TODA INSTÂNCIA DE MONSTRO TEM ID QUE COMEÇA COM 99
CREATE DOMAIN public.id_instancia_de_monstro AS public.id_geral
    CONSTRAINT id_instancia_de_monstro_check CHECK (
    VALUE BETWEEN 99000000 AND 99999999
);

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

--      FUNÇÕES GERADORAS DE ID

-- ===============================================

/*
Essas funções servem para garantir a integridade dos dados do banco, elas geram os ids das tabelas seguindo a regra de ids do banco de forma automática.
*/

-- GERA O ID DO PRÓXIMO PERSONAGEM JOGAVEL SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.personagem_jogavel_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_personagem_jogavel()
RETURNS BIGINT AS $gerar_id_personagem_jogavel$
BEGIN
    RETURN 10100000 + nextval('public.personagem_jogavel_id_seq');
END;
    $gerar_id_personagem_jogavel$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO NPC SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.personagem_npc_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_personagem_npc()
RETURNS BIGINT AS $gerar_id_personagem_npc$
BEGIN
    RETURN 10200000 + nextval('public.personagem_npc_id_seq');
END;
    $gerar_id_personagem_npc$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO MONSTRO AGRESSIVO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.monstro_agressivo_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_monstro_agressivo()
RETURNS BIGINT AS $gerar_id_monstro_agressivo$
BEGIN
    RETURN 20100000 + nextval('public.monstro_agressivo_id_seq');
END;
    $gerar_id_monstro_agressivo$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO MONSTRO PACÍFICO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.monstro_pacifico_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_monstro_pacifico()
RETURNS BIGINT AS $gerar_id_monstro_pacifico$
BEGIN
    RETURN 20200000 + nextval('public.monstro_pacifico_id_seq');
END;
    $gerar_id_monstro_pacifico$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM MÁGICO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.item_magico_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_item_magico()
RETURNS BIGINT AS $gerar_id_item_magico$
BEGIN
    RETURN 30100000 + nextval('public.item_magico_id_seq');
END;
    $gerar_id_item_magico$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM O PADRÃO DE IDS
CREATE SEQUENCE public.item_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_item()
RETURNS BIGINT AS $gerar_id_item$
BEGIN
    RETURN 30000000 + nextval('public.item_id_seq');
END;
    $gerar_id_item$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE CURA SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.item_de_cura_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_item_de_cura()
RETURNS BIGINT AS $gerar_id_item_de_cura$
BEGIN
    RETURN 30200000 + nextval('public.item_de_cura_id_seq');
END;
    $gerar_id_item_de_cura$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE ARMADURA SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.item_de_armadura_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_item_de_armadura()
RETURNS BIGINT AS $gerar_id_item_de_armadura$
BEGIN
    RETURN 30300000 + nextval('public.item_de_armadura_id_seq');
END;
    $gerar_id_item_de_armadura$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DO TIPO ARMA SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.item_arma_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_item_arma()
RETURNS BIGINT AS $gerar_id_item_arma$
BEGIN
    RETURN 30400000 + nextval('public.item_arma_id_seq');
END;
    $gerar_id_item_arma$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE TEMPLO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.templo_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_templo()
RETURNS BIGINT AS $gerar_id_templo$
BEGIN
    RETURN 40100000 + nextval('public.templo_id_seq');
END;
    $gerar_id_templo$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE ANDAR SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.andar_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_andar()
RETURNS BIGINT AS $gerar_id_andar$
BEGIN
    RETURN 40200000 + nextval('public.andar_id_seq');
END;
    $gerar_id_andar$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE LOCAL SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.local_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_local()
RETURNS BIGINT AS $gerar_id_local$
BEGIN
    RETURN 40300000 + nextval('public.local_id_seq');
END;
    $gerar_id_local$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE MISSÃO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.missao_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_missao()
RETURNS BIGINT AS $gerar_id_missao$
BEGIN
    RETURN 50000000 + nextval('public.missao_id_seq');
END;
    $gerar_id_missao$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE FEITIÇO DE STATUS SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.feitico_de_status_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_feitico_de_status()
RETURNS BIGINT AS $gerar_id_feitico_de_status$
BEGIN
    RETURN 60100000 + nextval('public.feitico_de_status_id_seq');
END;
    $gerar_id_feitico_de_status$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE FEITIÇO DE DANO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.feitico_de_dano_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_feitico_de_dano()
RETURNS BIGINT AS $gerar_id_feitico_de_dano$
BEGIN
    RETURN 60200000 + nextval('public.feitico_de_dano_id_seq');
END;
    $gerar_id_feitico_de_dano$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE DIÁLOGOS SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.dialogos_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_dialogos()
RETURNS BIGINT AS $gerar_id_dialogos$
BEGIN
    RETURN 70000000 + nextval('public.dialogos_id_seq');
END;
    $gerar_id_dialogos$ LANGUAGE plpgsql;

-- GERA O ID DO PRÓXIMO ITEM DE PERÍCIAS SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.pericias_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_pericia()
RETURNS BIGINT AS $gerar_id_pericia$
BEGIN
    RETURN 80000000 + nextval('public.pericias_id_seq');
END;
    $gerar_id_pericia$ LANGUAGE plpgsql;

-- GERA O ID DO INVENTÁRIO JOGAVEL SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.inventario_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_inventario()
RETURNS BIGINT AS $gerar_id_inventario$
BEGIN
    RETURN 90000000 + nextval('public.inventario_id_seq');
END;
    $gerar_id_inventario$ LANGUAGE plpgsql;

-- GERA O ID DE PERSONAGENS POSSUEM PERÍCIAS SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.personagens_possuem_pericias_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_personagens_possuem_pericias()
RETURNS BIGINT AS $gerar_id_personagens_possuem_pericias$
BEGIN
    RETURN 13000000 + nextval('public.personagens_possuem_pericias_id_seq');
END;
    $gerar_id_personagens_possuem_pericias$ LANGUAGE plpgsql;

-- GERA O ID DE INSTÂNCIAS DE ITEM SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.instancia_de_item_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_instancia_de_item()
RETURNS BIGINT AS $gerar_id_instancia_de_item$
BEGIN
    RETURN 88000000 + nextval('public.instancia_de_item_id_seq');
END;
    $gerar_id_instancia_de_item$ LANGUAGE plpgsql;

-- GERA O ID DE INSTÂNCIAS DE MONSTRO SEGUINDO O PADRÃO DE IDS
CREATE SEQUENCE public.instancia_de_monstro_id_seq START WITH 1;

CREATE FUNCTION public.gerar_id_instancia_de_monstro()
RETURNS BIGINT AS $gerar_id_instancia_de_monstro$
BEGIN
    RETURN 99000000 + nextval('public.instancia_de_monstro_id_seq');
END;
    $gerar_id_instancia_de_monstro$ LANGUAGE plpgsql;

-- ===============================================

--             TABELAS DO RPG

-- ===============================================

CREATE TABLE public.personagens_jogaveis(
    -- id INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id public.id_personagem_jogavel NOT NULL PRIMARY KEY DEFAULT public.gerar_id_personagem_jogavel(),
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
    id_local public.id_local,  
    id_inventario public.id_inventario NOT NULL, 
    id_armadura public.id_item_de_armadura, 
    id_arma public.id_item_arma
    -- id_tipo_personagem public.id NOT NULL

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
    id public.id_personagem_npc NOT NULL PRIMARY KEY DEFAULT public.gerar_id_personagem_npc(),
    nome public.nome NOT NULL,
    ocupacao public.ocupacao NOT NULL,

    idade public.idade DEFAULT 18 NOT NULL,
    sexo public.sexo NOT NULL,

    residencia public.residencia NOT NULL,
    local_nascimento public.local_nascimento DEFAULT 'arkham' NOT NULL,

    -- FOREIGN KEYS
    id_local public.id_local
    -- id_tipo_personagem public.id NOT NULL
);

CREATE TABLE public.dialogos(
    id public.id_dialogo NOT NULL PRIMARY KEY DEFAULT public.gerar_id_dialogos(),
    script_dialogo public.script_dialogo NOT NULL,

    -- FOREIGN KEYS
    npc_id public.id_personagem_npc NOT NULL 

);

CREATE TABLE public.inventarios(
    -- id INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- Use INTEGER diretamente
    id public.id_inventario NOT NULL PRIMARY KEY DEFAULT public.gerar_id_inventario(),
    tamanho SMALLINT NOT NULL
);

CREATE TABLE public.templos(
    id public.id_templo NOT NULL PRIMARY KEY DEFAULT public.gerar_id_templo(),
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.andares(
    id public.id_andar NOT NULL PRIMARY KEY DEFAULT public.gerar_id_andar(),
    descricao public.descricao NOT NULL,

    -- FOREIGN KEYS
    id_templo public.id_templo NOT NULL DEFAULT public.gerar_id_templo(),
    sala_inicial public.id_local NOT NULL
);
    --TABELA LOCAL
CREATE TABLE public.local(
    id public.id_local NOT NULL PRIMARY KEY DEFAULT public.gerar_id_local(),
    descricao public.descricao NOT NULL,
    tipo_local int NOT NULL
    status BOOLEAN
    --FOREIGN KEY
    sul public.id_local 
    norte public.id_local
    leste public.id_local
    oeste public.id_local
    cima public.id_local
    baixo public.id_local
);


CREATE TABLE public.pericias(
    id public.id_pericia NOT NULL PRIMARY KEY DEFAULT public.gerar_id_pericia(),
    nome public.nome NOT NULL UNIQUE,
    valor SMALLINT,
    eh_de_ocupacao BOOLEAN
);

CREATE TABLE public.agressivos(
    id public.id_monstro_agressivo NOT NULL PRIMARY KEY DEFAULT public.gerar_id_monstro_agressivo(),
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
    dano public.dano NOT NULL,

    id_tipo_monstro INTEGER -- FK
);

CREATE TABLE public.pacificos(
    id public.id_monstro_pacifico NOT NULL PRIMARY KEY DEFAULT public.gerar_id_monstro_pacifico(),
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    defesa SMALLINT NOT NULL,
    vida SMALLINT NOT NULL,
    motivo_passividade public.comportamento_pacifico,
    tipo_pacifico public.tipo_monstro_pacifico NOT NULL,
    conhecimento_geografico CHARACTER(128),
    conhecimento_proibido CHARACTER(128),

    id_tipo_monstro INTEGER -- FK
);

CREATE TABLE public.instancias_monstros(
    id public.id_instancia_de_monstro NOT NULL PRIMARY KEY DEFAULT public.gerar_id_instancia_de_monstro(),

    -- FOREING KEYS
    id_instancia_de_item public.id_instancia_de_item NOT NULL,
    id_local public.id_local,  
    id_corredor public.id_corredor,
    id_monstro public.id_monstro NOT NULL
);

CREATE TABLE public.missoes(
    id public.id_missao NOT NULL PRIMARY KEY DEFAULT public.gerar_id_missao(),
    nome public.nome NOT NULL UNIQUE,
    descricao CHARACTER(512) NOT NULL,
    tipo public.tipo_missao NOT NULL,
    ordem CHARACTER(128) NOT NULL,

    -- FOREIGN KEYS
    id_npc public.id_personagem_npc NOT NULL 
);

CREATE TABLE public.magicos(
    id public.id_item_magico NOT NULL PRIMARY KEY DEFAULT public.gerar_id_item_magico(),
    funcao public.funcao_magica NOT NULL,
    qts_usos SMALLINT NOT NULL,
    custo_sanidade SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_feitico public.id_feitico NOT NULL
);

CREATE TABLE public.curas(
    id public.id_item_de_cura NOT NULL PRIMARY KEY DEFAULT public.gerar_id_item_de_cura(),
    funcao public.funcao_cura NOT NULL,
    qts_usos SMALLINT NOT NULL,
    qtd_pontos_sanidade_recupera SMALLINT NOT NULL,
    qtd_pontos_vida_recupera SMALLINT NOT NULL
);

CREATE TABLE public.armaduras(
    id public.id_item_de_armadura NOT NULL PRIMARY KEY DEFAULT public.gerar_id_item_de_armadura(),
    atributo_necessario public.tipo_atributo_personagem,
    durabilidade SMALLINT NOT NULL,
    funcao funcao_armadura NOT NULL,
    qtd_atributo_recebe SMALLINT NOT NULL,
    qtd_atributo_necessario SMALLINT NOT NULL,
    tipo_atributo_recebe public.tipo_atributo_personagem,
    qtd_dano_mitigado SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_pericia_necessaria public.id_pericia NOT NULL
);

CREATE TABLE public.armas(
    id public.id_item_arma NOT NULL PRIMARY KEY DEFAULT public.gerar_id_item_arma(),
    atributo_necessario public.tipo_atributo_personagem,
    qtd_atributo_necessario SMALLINT NOT NULL,
    durabilidade SMALLINT NOT NULL,
    funcao public.funcao_arma,
    alcance SMALLINT,
    tipo_municao public.tipo_municao DEFAULT NULL,
    tipo_dano public.tipo_dano NOT NULL,
    dano public.dano NOT NULL,
    
    -- FOREIGN KEYS
    id_pericia_necessaria public.id_pericia NOT NULL
);

CREATE TABLE public.feiticos_status(
    id public.id_feitico_de_status NOT NULL PRIMARY KEY DEFAULT public.gerar_id_feitico_de_status(),
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    qtd_pontos_de_magia SMALLINT NOT NULL,
    buff_debuff BOOLEAN NOT NULL,
    qtd_buff_debuff SMALLINT,
    status_afetado public.tipo_de_status NOT NULL
);

CREATE TABLE public.feiticos_dano(
    id public.id_feitico_de_dano NOT NULL PRIMARY KEY DEFAULT public.gerar_id_feitico_de_dano(),
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    qtd_pontos_de_magia SMALLINT NOT NULL,
    tipo_dano public.tipo_dano NOT NULL,
    qtd_dano public.dano NOT NULL
);


CREATE TABLE public.itens(
    id public.id_item NOT NULL PRIMARY KEY DEFAULT public.gerar_id_item(),
    tipo public.tipo_item NOT NULL,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    valor SMALLINT
);

CREATE TABLE public.instancias_de_itens(
    id public.id_instancia_de_item NOT NULL PRIMARY KEY DEFAULT public.gerar_id_instancia_de_item(),
    durabilidade SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_local public.id_local,
    id_missao_requer public.id_missao,
    id_missao_recompensa public.id_missao,
    id_item public.id_item NOT NULL
);

-- ===============================================

--             TABELAS DE TIPOS

-- =============================================== 

CREATE TABLE public.tipos_personagem(
    id SERIAL NOT NULL PRIMARY KEY,
    tipo public.tipo_personagem NOT NULL
);

CREATE TABLE public.tipos_feitico(
	id SERIAL NOT NULL PRIMARY KEY,
    tipo public.funcao_feitico NOT NULL
);

CREATE TABLE public.tipos_monstro(
    id SERIAL NOT NULL PRIMARY KEY,
    tipo public.tipo_monstro NOT null
);

-- ===============================================

--  TABELAS DE RELACIONAMENTOS MUITOS PARA MUITOS

-- =============================================== 

/*
Essa seção contém as tabelas derivadas de relacionamentos N para N
*/

CREATE TABLE public.batalhas(
    id_jogador public.id_personagem_jogavel NOT NULL,
    id_monstro public.id_instancia_de_monstro NOT NULL,
    PRIMARY KEY (id_jogador, id_monstro)
);

CREATE TABLE public.entregas_missoes(
    id_jogador public.id_personagem_jogavel NOT NULL,
    id_npc public.id_personagem_npc NOT NULL,
    PRIMARY KEY (id_jogador, id_npc)
);



CREATE TABLE public.inventarios_possuem_instancias_item(
    id_instancias_de_item public.id_instancia_de_item NOT NULL,
    id_inventario public.id_inventario NOT NULL,
    PRIMARY KEY (id_instancias_de_item, id_inventario)
);

CREATE TABLE public.personagens_possuem_pericias (
    valor_atual SMALLINT NOT NULL,
    PRIMARY KEY (id_personagem, id_pericia),

    -- FOREIGN KEYS
    id_personagem public.id_personagem_jogavel NOT NULL,
    id_pericia public.id_pericia NOT NULL
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
    FOREIGN KEY (id_local) 
    REFERENCES public.local (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario_instancia_arma
    FOREIGN KEY (id_arma) 
    REFERENCES public.instancias_de_itens (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario_instancia_armadura 
    FOREIGN KEY (id_armadura) 
    REFERENCES public.instancias_de_itens (id);

/*

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_tipos_personagem 
    FOREIGN KEY (id_tipo_personagem) 
    REFERENCES public.tipos_personagem (id);  

*/

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
    FOREIGN KEY (id_local) 
    REFERENCES public.local (id);

/*

ALTER TABLE public.npcs 
ADD CONSTRAINT fk_npcs_tipos_personagem 
    FOREIGN KEY (id_tipo_personagem) 
    REFERENCES public.tipos_personagem (id);    

*/

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
    REFERENCES public.local (id);


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
ADD CONSTRAINT fk_instancias_monstro_salas 
    FOREIGN KEY (id_local) 
    REFERENCES public.local (id);

ALTER TABLE public.instancias_monstros
ADD CONSTRAINT fk_instancias_monstro_instancia_de_item 
    FOREIGN KEY (id_instancia_de_item) 
    REFERENCES public.instancias_de_itens (id);

-- MONSTROS PACÍFICOS

ALTER TABLE public.pacificos 
ADD CONSTRAINT fk_pacificos_tipo_monstro 
    FOREIGN KEY (id_tipo_monstro) 
    REFERENCES public.tipos_monstro (id);

-- MONSTROS AGRESSIVOS

ALTER TABLE public.agressivos 
ADD CONSTRAINT fk_agressivos_tipo_monstro 
    FOREIGN KEY (id_tipo_monstro) 
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
    FOREIGN KEY (id_local) 
    REFERENCES public.local (id);  

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

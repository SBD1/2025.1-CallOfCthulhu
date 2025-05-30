-- ===============================================

--            DROP TABLES

-- ===============================================

-- PASSO 1: remover os triggers
DROP TRIGGER IF EXISTS trg_atualizar_atributos_do_personagem ON public.personagens_jogaveis;

-- PASSO 2: remover as restrições de chave estrangeira

-- da tabela de personagens jogaveis
ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_pt_de_magia;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_pericia;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_inventario;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_salas;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_corredores;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_inventario_arma;

ALTER TABLE public.personagens_jogaveis
DROP CONSTRAINT IF EXISTS fk_pj_inventarios;

-- da tabela de NPCS
ALTER TABLE public.npcs
DROP CONSTRAINT IF EXISTS fk_npcs_salas;

ALTER TABLE public.npcs
DROP CONSTRAINT IF EXISTS fk_corredores_salas_destino_corredores;

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

-- da tabela de itens
ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_cura;

ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_magicos;

ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_armaduras;

ALTER TABLE public.itens
DROP CONSTRAINT IF EXISTS fk_itens_armas;

-- da tabela instancias de item
ALTER TABLE public.instancias_de_item
DROP CONSTRAINT IF EXISTS fk_instancias_de_item_itens;

ALTER TABLE public.instancias_de_item
DROP CONSTRAINT IF EXISTS fk_instancias_de_item_salas;

-- da tabela invetario
ALTER TABLE public.inventarios
DROP CONSTRAINT IF EXISTS fk_inventarios_instancia_de_item;

-- da tabela magicos
ALTER TABLE public.magicos
DROP CONSTRAINT IF EXISTS fk_magicos_tipos_de_feitico;

-- da tabela agressivos
ALTER TABLE public.agressivos
DROP CONSTRAINT IF EXISTS fk_agressivos_tipos_de_feitico;

-- da tabela tipo_feitico
ALTER TABLE public.tipos_feitico
DROP CONSTRAINT IF EXISTS fk_tipos_feitico_feitico_status;

ALTER TABLE public.tipos_feitico
DROP CONSTRAINT IF EXISTS fk_tipos_feitico_feitico_dano;

-- da tabela instancias_monstro
ALTER TABLE public.instancias_monstro
DROP CONSTRAINT IF EXISTS fk_instancias_de_monstro_tipo_monstro;

ALTER TABLE public.instancias_monstro
DROP CONSTRAINT IF EXISTS fk_instancias_de_monstro_salas;

ALTER TABLE public.instancias_monstro
DROP CONSTRAINT IF EXISTS fk_instancias_de_monstro_corredores;

ALTER TABLE public.instancias_monstro
DROP CONSTRAINT IF EXISTS fk_instancias_de_monstro_instancia_de_item;

-- da tabela tipos_monstros
ALTER TABLE public.tipos_monstro
DROP CONSTRAINT IF EXISTS fk_tipos_monstro_pacificos;

ALTER TABLE public.tipos_monstro
DROP CONSTRAINT IF EXISTS fk_tipos_monstro_agressivo;

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

-- da tabela instancias_de_item
ALTER TABLE public.instancias_de_item
DROP CONSTRAINT IF EXISTS fk_instancias_de_itens_missoes_recompensa;

ALTER TABLE public.instancias_de_item
DROP CONSTRAINT IF EXISTS fk_instancias_de_itens_missoes_requer;

-- da tabela tipos_personagem
ALTER TABLE public.tipos_personagem
DROP CONSTRAINT IF EXISTS fk_tipos_personagem_personagens_jogaveis;

ALTER TABLE public.tipos_personagem
DROP CONSTRAINT IF EXISTS fk_tipos_personagem_npc;

-- da tabela armaduras
ALTER TABLE public.armaduras
DROP CONSTRAINT IF EXISTS fk_armaduras_pericia_necessaria;

-- da tabela armas
ALTER TABLE public.armas
DROP CONSTRAINT IF EXISTS fk_armas_pericia_necessaria;

-- PASSO 3: remover as tabelas

-- tabelas de juncao primeiro

DROP TABLE IF EXISTS public.inventarios_possuem_instancias_item;
DROP TABLE IF EXISTS public.corredores_salas_destino;
DROP TABLE IF EXISTS public.entregas_missoes;
DROP TABLE IF EXISTS public.batalhas;
DROP TABLE IF EXISTS public.instancias_de_item;

-- tabelas com muitas referencias por ultimo

DROP TABLE IF EXISTS public.tipos_personagem;
DROP TABLE IF EXISTS public.itens;
DROP TABLE IF EXISTS public.tipos_monstro;
DROP TABLE IF EXISTS public.pacificos;
DROP TABLE IF EXISTS public.agressivos;
DROP TABLE IF EXISTS public.feiticos_dano;
DROP TABLE IF EXISTS public.feiticos_status;
DROP TABLE IF EXISTS public.armas;
DROP TABLE IF EXISTS public.armaduras;
DROP TABLE IF EXISTS public.curas;
DROP TABLE IF EXISTS public.magicos;
DROP TABLE IF EXISTS public.missoes;
DROP TABLE IF EXISTS public.instancias_monstro;
DROP TABLE IF EXISTS public.pericias;
DROP TABLE IF EXISTS public.pts_de_magia;
DROP TABLE IF EXISTS public.corredores;
DROP TABLE IF EXISTS public.salas;
DROP TABLE IF EXISTS public.andares;
DROP TABLE IF EXISTS public.templos;
DROP TABLE IF EXISTS public.inventarios;
DROP TABLE IF EXISTS public.dialogos;
DROP TABLE IF EXISTS public.npcs;
DROP TABLE IF EXISTS public.tipos_feitico;
DROP TABLE IF EXISTS public.personagens_jogaveis;

-- PASSO 4: remover as funções

DROP FUNCTION IF EXISTS public.atualizar_atributos_do_personagem();
DROP FUNCTION IF EXISTS public.calcular_sanidade(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_ideia(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_conhecimento(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_sorte(INTEGER);
DROP FUNCTION IF EXISTS public.calcular_pts_de_vida(INTEGER, INTEGER);

-- PASSO 5: remover os domínios
DROP DOMAIN IF EXISTS public.sexo;
DROP DOMAIN IF EXISTS public.atributo_personagem;
DROP DOMAIN IF EXISTS public.idade;
DROP DOMAIN IF EXISTS public.tipo_monstro_pacifico;
DROP DOMAIN IF EXISTS public.tipo_monstro;
DROP DOMAIN IF EXISTS public.tipo_de_feitico;
DROP DOMAIN IF EXISTS public.tipo_monstro_agressivo;
DROP DOMAIN IF EXISTS public.tipo_personagem;
DROP DOMAIN IF EXISTS public.nome;
DROP DOMAIN IF EXISTS public.descricao;
DROP DOMAIN IF EXISTS public.id;
DROP DOMAIN IF EXISTS public.residencia;
DROP DOMAIN IF EXISTS public.local_nascimento;
DROP DOMAIN IF EXISTS public.script_dialogo;

-- ===============================================

--            DOMÍNIOS CRIADOS

-- ===============================================

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
        (VALUE)::text = ANY (ARRAY[
            ('masculino'::character)::text, 
            ('feminino'::character)::text
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

CREATE DOMAIN public.tipo_monstro_agressivo AS CHARACTER(8)
    CONSTRAINT tipo_monstro_agressivo_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('psiquico'::character)::text, 
            ('magico'::character)::text,
            ('fisico'::character)::text
        ])
    );

CREATE DOMAIN public.tipo_monstro_pacifico AS CHARACTER(12)
    CONSTRAINT tipo_monstro_pacifico_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('humóide'::character)::text, 
            ('sobrenatural'::character)::text
        ])
    );

CREATE DOMAIN public.tipo_monstro AS CHARACTER(9)
    CONSTRAINT tipo_monstro_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('agressivo'::character)::text, 
            ('pacífico'::character)::text
        ])
    );

CREATE DOMAIN public.tipo_personagem AS CHARACTER(18)
    CONSTRAINT tipo_personagem_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('personagem jogavel'::character)::text, 
            ('NPC'::character)::text
        ])
    );

 CREATE DOMAIN public.tipo_item AS CHARACTER(8)
    CONSTRAINT tipo_item_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('armadura'::character)::text, 
            ('arma'::character)::text,
            ('cura'::character)::text
        ])
    );   

 CREATE DOMAIN public.tipo_muniçao AS character(13)
    CONSTRAINT tipo_municao_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('baixo-calibre'::character)::text, 
            ('medio-calibre'::character)::text,
            ('alto-calibre'::character)::text
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
    CONSTRAINT tipo_de_status CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('vida'::character)::text, 
            ('sanidade'::character)::text
        ])
    );          

CREATE DOMAIN public.nome AS CHARACTER(128);

CREATE DOMAIN public.descricao AS CHARACTER(256);

CREATE DOMAIN public.ocupacao AS CHARACTER(64);

CREATE DOMAIN public.residencia AS CHARACTER(96);

CREATE DOMAIN public.local_nascimento AS CHARACTER(96);

CREATE DOMAIN public.script_dialogo AS CHARACTER(512);

-- ===============================================

--      FUNÇÕES PARA CALCULAR ATRIBUTOS

-- ===============================================

CREATE OR REPLACE FUNCTION calcular_sanidade(valor_poder INTEGER)
RETURNS smallint AS $$
BEGIN
    RETURN valor_poder * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_ideia(valor_inteligencia INTEGER)
RETURNS smallint AS $$
BEGIN
    RETURN valor_inteligencia * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_conhecimento(valor_educacao INTEGER)
RETURNS smallint AS $$
BEGIN
    RETURN valor_educacao * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_sorte(valor_poder INTEGER)
RETURNS smallint AS $$
BEGIN
    RETURN valor_poder * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_pts_de_vida(valor_constituicao INTEGER, valor_tamanho INTEGER)
RETURNS integer AS $$
BEGIN
    RETURN (valor_constituicao + valor_tamanho) / 2;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION atualizar_atributos_do_personagem()
RETURNS TRIGGER AS $$
BEGIN
    NEW.ideia = calcular_ideia(NEW.inteligencia);
    NEW.conhecimento = calcular_conhecimento(NEW.educacao);
    NEW.sorte = calcular_sorte(NEW.poder);
    NEW.pts_de_vida = calcular_pts_de_vida(NEW.constituicao, NEW.tamanho);
    NEW.sanidade_maxima = calcular_sanidade(NEW.poder);

    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_atributos_do_personagem
BEFORE INSERT OR UPDATE ON public.personagens_jogaveis
FOR EACH ROW
EXECUTE FUNCTION atualizar_atributos_do_personagem();

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
    tamanho public.atributo NOT NULL, -- 3d6 + 3
    inteligencia public.atributo NOT NULL, -- 3d6
    educacao public.atributo NOT NULL, -- 3d6 + 3

    ideia SMALLINT, -- inteligencia x 5
    conhecimento SMALLINT, -- educacao x 5
    sorte SMALLINT,  -- poder x 5
    pts_de_vida integer, -- (constituicao + tamanho) / 2
    sanidade_maxima SMALLINT, -- poder x 5
    movimento SMALLINT NOT NULL,
    localBoolean boolean NOT NULL,

    sanidade_atual SMALLINT,
    insanidade_temporaria boolean, 
    insanidade_indefinida boolean, -- quando sanidade é 0

    -- FOREIGN KEYS
    id_local public.id NOT NULL, 
    id_pt_de_magia public.id NOT NULL, 
    id_pericia public.id NOT NULL, 
    id_sanidade public.id NOT NULL, 
    id_inventario public.id NOT NULL, 
    id_armadura public.id NOT NULL, 
    id_arma public.id NOT NULL
);

CREATE TABLE public.npcs(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL,
    ocupacao public.ocupacao NOT NULL,

    idade public.idade DEFAULT 18 NOT NULL,
    sexo public.sexo NOT NULL,

    residencia public.residencia NOT NULL,
    local_nascimento public.local_nascimento DEFAULT 'arkham' NOT NULL,
    localBoolean boolean NOT NULL,

    -- FOREIGN KEYS
    id_local public.id NOT NULL 
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
    sala_inicial SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_templo public.id NOT NULL
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

CREATE TABLE public.pts_de_magia(
    id public.id NOT NULL PRIMARY KEY,
    valor_base SMALLINT, 
    PM_max SMALLINT
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
    catalisador_agressividade CHARACTER(32),
    poder SMALLINT,
    tipo_agressivo public.tipo_monstro_agressivo NOT NULL,
    velocidade_ataque SMALLINT,
    loucura_induzida SMALLINT,
    ponto_magia SMALLINT,
    dano public.dano NOT NULL,

    -- FOREING KEYS
    id_feitico public.id NOT NULL 
);

CREATE TABLE public.pacificos(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    defesa SMALLINT NOT NULL,
    vida SMALLINT NOT NULL,
    motivo_passividade CHARACTER(64),
    tipo_pacifico public.tipo_monstro_pacifico NOT NULL,
    conhecimento_geografico CHARACTER(128),
    conhecimento_proibido CHARACTER(128)
);

CREATE TABLE public.instancias_monstro(
    id public.id NOT NULL PRIMARY KEY,
    localBoolean BOOLEAN,

    -- FOREING KEYS
    id_instancia_de_item public.id NOT NULL,
    id_local public.id NOT NULL,  
    id_monstro public.id NOT NULL
);

CREATE TABLE public.missoes(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao CHARACTER(512) NOT NULL,
    tipo SMALLINT NOT NULL,
    ordem CHARACTER(128) NOT NULL,

    -- FOREIGN KEYS
    id_npc public.id NOT NULL 
);

CREATE TABLE public.magicos(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    funcao CHARACTER(128) NOT NULL,
    qts_usos SMALLINT NOT NULL,
    custo_sanidade SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_feitico public.id NOT NULL
);

CREATE TABLE public.curas(
    id public.id NOT NULL PRIMARY KEY,
    funcao CHARACTER(128) NOT NULL,
    nome public.nome NOT NULL UNIQUE,
    qts_usos SMALLINT NOT NULL,
    qtd_pontos_sanidade_recupera SMALLINT NOT NULL,
    qtd_pontos_vida_recupera SMALLINT NOT NULL
);

CREATE TABLE public.armaduras(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    atributo_necessario CHARACTER(128),
    durabilidade SMALLINT NOT NULL,
    funcao CHARACTER(128),
    qtd_atributo_recebe SMALLINT NOT NULL,
    tipo_atributo_recebe character(128) NOT NULL,
    qtd_dano_mitigado SMALLINT NOT NULL,

    -- FOREIGN KEYS
    id_pericia_necessaria public.id
);

CREATE TABLE public.armas(
    id public.id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    atributo_necessario character(128),
    durabilidade SMALLINT,
    funcao CHARACTER(128),
    alcance SMALLINT,
    tipo_municao public.tipo_municao DEFAULT NULL,
    tipo_dano character(64),
    dano public.dano NOT NULL,

    -- FOREIGN KEYS
    id_pericia_necessaria public.id,
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
    tipo_dano CHARACTER(64),
    qtd_dano public.dano NOT NULL
);


CREATE TABLE public.itens(
    id public.formato_id NOT NULL PRIMARY KEY,
    tipo public.tipo_item NOT NULL,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    valor SMALLINT
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
    tipo public.tipos_de_feitico NOT NULL
);

CREATE TABLE public.tipos_monstro(
    id public.id NOT NULL PRIMARY KEY,
    tipo public.tipo_monstro NOT NULL
);

-- ===============================================

--  TABELAS DE RELACIONAMENTOS MUITOS PARA MUITOS

-- =============================================== 

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

CREATE TABLE public.instancias_de_item(
  id public.id NOT NULL,
  id_item public.id NOT NULL,
  nome CHARACTER(64) NOT NULL,
  durabilidade SMALLINT NOT NULL,
  id_sala public.id NOT NULL,  -- FOREIGN KEY
  id_missao_requer public.id NOT NULL,  -- FOREIGN KEY
  id_missao_recompensa public.id NOT NULL,  -- FOREIGN KEY
  PRIMARY KEY (id, id_item)
);

-- ===============================================

--              CHAVES ESTRAGEIRAS 

-- ===============================================


--  PERSONAGENS JOGÁVEIS

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_pt_de_magia 
    FOREIGN KEY (id_pt_de_magia) 
    REFERENCES public.pts_de_magia (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_pericia 
    FOREIGN KEY (id_pericia) 
    REFERENCES public.pericias (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario 
    FOREIGN KEY (id_inventario) 
    REFERENCES public.inventarios (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_salas 
    FOREIGN KEY (id_local) 
    REFERENCES public.salas (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_corredores 
    FOREIGN KEY (id_local) 
    REFERENCES public.corredores (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventario_arma
    FOREIGN KEY (id_arma) 
    REFERENCES public.inventarios (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_pj_inventarios 
    FOREIGN KEY (id_armadura) 
    REFERENCES public.inventarios (id);

-- NPCS

ALTER TABLE public.npcs 
ADD CONSTRAINT fk_npcs_salas 
    FOREIGN KEY (id_local) 
    REFERENCES public.salas (id);

ALTER TABLE public.npcs 
ADD CONSTRAINT fk_npcs_corredores 
    FOREIGN KEY (id_local) 
    REFERENCES public.corredores (id);

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

-- ITENS
ALTER TABLE public.itens 
ADD CONSTRAINT fk_itens_curas 
    FOREIGN KEY (id) 
    REFERENCES public.curas (id);

ALTER TABLE public.itens 
ADD CONSTRAINT fk_itens_magicos 
    FOREIGN KEY (id) 
    REFERENCES public.magicos (id);

ALTER TABLE public.itens 
ADD CONSTRAINT fk_itens_armaduras 
    FOREIGN KEY (id) 
    REFERENCES public.armaduras (id);

ALTER TABLE public.itens 
ADD CONSTRAINT fk_itens_armas 
    FOREIGN KEY (id) 
    REFERENCES public.armas (id);

-- INSTANCIAS DE ITEM

ALTER TABLE public.instancias_de_item 
ADD CONSTRAINT fk_instancias_de_item_itens 
    FOREIGN KEY (id_item) 
    REFERENCES public.itens (id);

ALTER TABLE public.instancias_de_item 
ADD CONSTRAINT fk_instancias_de_item_salas 
    FOREIGN KEY (id_sala) 
    REFERENCES public.salas (id);

-- INVENTÁRIO

ALTER TABLE public.inventarios 
ADD CONSTRAINT fk_inventarios_instancia_de_item 
    FOREIGN KEY (id) 
    REFERENCES public.instancias_de_item (id);

-- MÁGICOS E FEITIÇOS

ALTER TABLE public.magicos 
ADD CONSTRAINT fk_magicos_tipos_de_feitico 
    FOREIGN KEY (id_feitico) 
    REFERENCES public.tipos_feitico (id);

ALTER TABLE public.tipos_feitico 
ADD CONSTRAINT fk_tipos_feitico_feitico_status 
    FOREIGN KEY (id) 
    REFERENCES public.feiticos_status (id);

ALTER TABLE public.tipos_feitico 
ADD CONSTRAINT fk_tipos_feitico_feitico_dano 
    FOREIGN KEY (id) 
    REFERENCES public.feiticos_dano (id);

-- INSTÂNCIAS DE MONSTRO

ALTER TABLE public.instancias_monstro 
ADD CONSTRAINT fk_instancias_de_monstro_tipo_monstro 
    FOREIGN KEY (id_monstro) 
    REFERENCES public.tipos_monstro (id);

ALTER TABLE public.instancias_monstro 
ADD CONSTRAINT fk_instancias_monstro_salas 
    FOREIGN KEY (id_local) 
    REFERENCES public.salas (id);

ALTER TABLE public.instancias_monstro 
ADD CONSTRAINT fk_instancias_monstro_corredores 
    FOREIGN KEY (id_local) 
    REFERENCES public.corredores (id);

ALTER TABLE public.instancias_monstro 
ADD CONSTRAINT fk_instancias_de_monstro_instancia_de_item 
    FOREIGN KEY (id_instancia_de_item) 
    REFERENCES public.instancias_de_item (id);

-- ESPECILIZAÇÃO DE MONSTROS

ALTER TABLE public.tipos_monstro 
ADD CONSTRAINT fk_tipos_monstro_pacificos 
    FOREIGN KEY (id) 
    REFERENCES public.pacificos (id);

ALTER TABLE public.tipos_monstro 
ADD CONSTRAINT fk_tipos_monstro_agressivos 
    FOREIGN KEY (id) 
    REFERENCES public.agressivos (id);

-- BATALHAS

ALTER TABLE public.batalhas 
ADD CONSTRAINT fk_batalhas_personagens_jogaveis 
    FOREIGN KEY (id_jogador) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.batalhas 
ADD CONSTRAINT fk_batalhas_monstro 
    FOREIGN KEY (id_monstro) 
    REFERENCES public.instancias_monstro (id);

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
    FOREIGN KEY (id_npcs) 
    REFERENCES public.npcs (id);

-- INSTÂNCIAS DE ITENS

ALTER TABLE public.instancias_de_item 
ADD CONSTRAINT fk_instancias_de_itens_missoes_recompensa
    FOREIGN KEY (id_missao_recompensa) 
    REFERENCES public.missoes (id);

ALTER TABLE public.instancias_de_item 
ADD CONSTRAINT fk_instancias_de_itens_missoes_requer
    FOREIGN KEY (id_missao_requer) 
    REFERENCES public.missoes (id);

--  ESPECIALIZAÇÃO DE PERSONAGEM

ALTER TABLE public.tipos_personagem 
ADD CONSTRAINT fk_tipos_personagem_personagens_jogaveis 
    FOREIGN KEY (id) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.tipos_personagem 
ADD CONSTRAINT fk_tipos_personagem_npc 
    FOREIGN KEY (id) 
    REFERENCES public.npcs (id);

--

ALTER TABLE public.agressivos 
ADD CONSTRAINT fk_agressivos_tipos_de_feitico 
    FOREIGN KEY (id_feitico) 
    REFERENCES public.tipos_feitico (id);

-- ARMADURAS

ALTER TABLE public.armaduras 
ADD CONSTRAINT fk_armaduras_pericia_necessaria
    FOREIGN KEY (id_pericia_necessaria) 
    REFERENCES public.pericias (id);

 -- ARMAS

ALTER TABLE public.armas 
ADD CONSTRAINT fk_armas_pericia_necessaria
    FOREIGN KEY (id_pericia_necessaria) 
    REFERENCES public.pericias (id);   

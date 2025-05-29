-- ===============================================

--            DOMÍNIOS CRIADOS

-- ===============================================

CREATE DOMAIN public.formato_id As integer
    CONSTRAINT formato_id_check CHECK (
        VALUE >= 1 AND VALUE <= 999999999
    );

CREATE DOMAIN public.dano As integer
    CONSTRAINT dano_check CHECK (
        VALUE >= 1 AND VALUE <= 500
    );  

CREATE DOMAIN public.sexo AS character(10)
    CONSTRAINT sexo_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('masculino'::character varying)::text, 
            ('feminino'::character varying)::text
        ])
    );

CREATE DOMAIN public.atributo_personagem As integer
    CONSTRAINT atributo_personagem_check CHECK (
        VALUE >= 3 AND VALUE <= 18
    );

CREATE DOMAIN public.idade_valida As integer
    CONSTRAINT idade_check CHECK (
        VALUE >= 1 AND VALUE <= 120
    );

CREATE DOMAIN public.tipo_monstro_agressivo AS character(12)
    CONSTRAINT tipo_monstro_agressivo_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('psíquico'::character varying)::text, 
            ('mágico'::character varying)::text,
            ('físico'::character varying)::text
        ])
    );

CREATE DOMAIN public.tipo_monstro_pacifico AS character(16)
    CONSTRAINT tipo_monstro_pacifico_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('humóide'::character varying)::text, 
            ('sobrenatural'::character varying)::text
        ])
    );

CREATE DOMAIN public.tipo_monstro AS character(16)
    CONSTRAINT tipo_monstro_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('agressivo'::character varying)::text, 
            ('pacífico'::character varying)::text
        ])
    );

CREATE DOMAIN public.tipo_personagem AS character(20)
    CONSTRAINT tipo_personagem_check CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('personagem jogável'::character varying)::text, 
            ('NPC'::character varying)::text
        ])
    );

CREATE DOMAIN public.tipo_feitico AS character(16)
    CONSTRAINT tipo_feitico CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('status'::character varying)::text, 
            ('dano'::character varying)::text
        ])
    );

 CREATE DOMAIN public.tipo_item AS character(16)
    CONSTRAINT tipo_item CHECK (
        (VALUE)::text = ANY (ARRAY[
            ('armadura'::character varying)::text, 
            ('arma'::character varying)::text
            ('cura'::character varying)::text
        ])
    );   

CREATE DOMAIN public.nome AS character(128);

CREATE DOMAIN public.descricao AS character(256);

CREATE DOMAIN public.ocupcao AS character(64);

CREATE DOMAIN public.residencia AS character(96);

CREATE DOMAIN public.local_nascimento AS character(96);

CREATE DOMAIN public.script_dialogo AS character(512);

-- ===============================================

--      FUNÇÕES PARA CALCULAR ATRIBUTOS

-- ===============================================

CREATE OR REPLACE FUNCTION calcular_sanidade(valor_poder integer)
RETURNS smallint AS $$
BEGIN
    RETURN valor_poder * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_ideia(valor_inteligencia integer)
RETURNS smallint AS $$
BEGIN
    RETURN valor_inteligencia * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_conhecimento(valor_educacao integer)
RETURNS smallint AS $$
BEGIN
    RETURN valor_educacao * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_sorte(valor_poder integer)
RETURNS smallint AS $$
BEGIN
    RETURN valor_poder * 5;
END
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION calcular_pts_de_vida(valor_constituicao integer, valor_tamanho integer)
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
    NEW.pts_de_vida = calcular_pts_de_vida(NEW.constituicao, NEW.tamanho)
    NEW.sanidade_maxima = calcular_sanidade(NEW.poder)

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
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL,
    ocupacao public.ocupacao NOT NULL,
    residencia public.residencia NOT NULL,
    local_nascimento public.local_nascimento NOT NULL,

    idade public.idade_valida DEFAULT 18 NOT NULL,
    sexo public.sexo NOT NULL,

    forca public.atributo_personagem NOT NULL, -- 3d6
    constituicao public.atributo_personagem NOT NULL, -- 3d6
    poder public.atributo_personagem NOT NULL, -- 3d6
    destreza public.atributo_personagem NOT NULL, -- 3d6
    aparencia public.atributo_personagem NOT NULL, -- 3d6
    tamanho public.atributo_personagem NOT NULL, -- 3d6 + 3
    inteligencia public.atributo_personagem NOT NULL, -- 3d6
    educacao public.atributo_personagem NOT NULL, -- 3d6 + 3

    ideia SMALLINT, -- inteligencia x 5
    conhecimento SMALLINT, -- educacao x 5
    sorte SMALLINT,  -- poder x 5
    pts_de_vida integer, -- (constituicao + tamanho) / 2
    sanidade_maxima SMALLINT, -- poder x 5
    movimento SMALLINT NOT NULL,
    localBoolean boolean NOT NULL,

    sanidade_atual SMALLINT,
    insanidade_temporaria boolean, 
    insanidade_indefinida boolean -- quando sanidade é 0

    -- FOREIGN KEYS
    id_local public.formato_id NOT NULL, -- FOREIGN KEY
    id_pt_de_magia public.formato_id NOT NULL, -- FOREIGN KEY
    id_pericia public.formato_id NOT NULL, -- FOREIGN KEY
    id_sanidade public.formato_id NOT NULL, -- FOREIGN KEY
    id_inventario public.formato_id NOT NULL, -- FOREIGN KEY
    id_armadura public.formato_id NOT NULL, -- FOREIGN KEY
    id_arma public.formato_id NOT NULL, -- FOREIGN KEY
);

CREATE TABLE public.npcs(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL,
    ocupacao public.ocupacao NOT NULL,

    idade public.idade_valida DEFAULT 18 NOT NULL,
    sexo public.sexo NOT NULL,

    residencia public.residencia NOT NULL,
    local_nascimento public.local_nascimento DEFAULT 'arkham' NOT NULL,
    localBoolean boolean NOT NULL,

    -- FOREIGN KEYS
    id_local public.formato_id NOT NULL -- FOREIGN KEY
);

CREATE TABLE public.dialogos(
    id public.formato_id NOT NULL PRIMARY KEY,
    script_dialogo public.script_dialogo NOT NULL,

    -- FOREIGN KEYS
    npc_id public.formato_id NOT NULL -- FOREIGN KEY

);

CREATE TABLE public.inventarios(
    id public.formato_id NOT NULL PRIMARY KEY,
    tamanho integer NOT NULL
);

CREATE TABLE public.templos(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.andares(
    id public.formato_id NOT NULL PRIMARY KEY,
    descricao public.descricao NOT NULL,
    sala_inicial integer NOT NULL,
    id_templo public.formato_id NOT NULL
);

CREATE TABLE public.salas(
    id public.formato_id NOT NULL PRIMARY KEY,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.corredores(
    id public.formato_id NOT NULL PRIMARY KEY,
    status boolean NOT NULL,
    descricao public.descricao NOT NULL
);

CREATE TABLE public.pts_de_magia(
    id public.formato_id NOT NULL PRIMARY KEY,
    valor_base integer, 
    PM_max integer
);

CREATE TABLE public.pericias(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    valor integer,
    eh_de_ocupacao boolean
);

CREATE TABLE public.agressivos(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao descricao public.descricao NOT NULL,
    defesa integer,
    vida integer,
    catalisador_agressividade character(32),
    poder integer,
    tipo_agressivo public.tipo_monstro_agressivo NOT NULL,
    velocidade_ataque integer,
    loucura_induzida integer,
    ponto_magia integer,
    dano public.dano NOT NULL,

    -- FOREING KEYS
    id_feitiço public.formato_id NOT NULL  -- FOREIGN KEY
);

CREATE TABLE public.pacificos(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    defesa integer NOT NULL,
    vida integer NOT NULL,
    motivo_passividade character(64),
    tipo_pacifico public.tipo_monstro_pacifico NOT NULL,
    conhecimento_geografico character(128),
    conhecimento_proibido character(128)
);

CREATE TABLE public.instancias_monstro(
    id public.formato_id NOT NULL PRIMARY KEY,
    localBoolean boolean,

    -- FOREING KEYS
    id_instancia_de_item public.formato_id NOT NULL  -- FOREIGN KEY
    id_local inpublic.formato_idteger NOT NULL,  -- FOREIGN KEY
    id_monstro public.formato_id NOT NULL,  -- FOREIGN KEY
);

CREATE TABLE public.missoes(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao character(512) NOT NULL,
    tipo integer NOT NULL,
    ordem character(128) NOT NULL,
    id_npc public.formato_id NOT NULL  -- FOREIGN KEY
);

CREATE TABLE public.magicos(
    id public.formato_id NOT NULL PRIMARY KEY,
    id_feitiço public.formato_id NOT NULL,  -- FOREIGN KEY
    nome public.nome NOT NULL UNIQUE,
    funcao character(128) NOT NULL,
    qts_usos integer NOT NULL,
    custo_sanidade integer NOT NULL
);

CREATE TABLE public.curas(
    id public.formato_id NOT NULL PRIMARY KEY,
    funcao character(128) NOT NULL,
    nome public.nome NOT NULL UNIQUE,
    qts_usos integer NOT NULL,
    qtd_pontos_sanidade_recupera integer NOT NULL,
    qtd_pontos_vida_recupera integer NOT NULL
);

CREATE TABLE public.armaduras(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    atributo_necessario character(128),
    durabilidade integer NOT NULL,
    pericia_necessaria character(128),
    funcao character(128),
    qtd_atributo_recebe integer NOT NULL,
    tipo_atributo_recebe character(128) NOT NULL,
    qtd_dano_mitigado integer NOT NULL
);

CREATE TABLE public.armas(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    atributo_necessario character(128),
    durabilidade integer,
    pericia_necessaria character(128),
    funcao character(128),
    alcance integer,
    tipo_municao character(64),
    tipo_dano character(64),
    dano public.dano NOT NULL
);

CREATE TABLE public.feiticos_status(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    qtd_pontos_de_magia integer NOT NULL,
    buff_debuff boolean NOT NULL,
    qtd_buff_debuff integer,
    status_afetado character(64) NOT NULL
);

CREATE TABLE public.feiticos_dano(
    id public.formato_id NOT NULL PRIMARY KEY,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    qtd_pontos_de_magia integer NOT NULL,
    tipo_dano character(64),
    qtd_dano dano public.dano NOT NULL
);


CREATE TABLE public.tipos_monstro(
    id public.formato_id NOT NULL PRIMARY KEY,
    tipo public.tipo_monstro NOT NULL
);

CREATE TABLE public.tipos_feitiço(
    id public.formato_id NOT NULL PRIMARY KEY,
    tipo public.tipo_feitico NOT NULL
);

CREATE TABLE public.itens(
    id public.formato_id NOT NULL PRIMARY KEY,
    tipo public.tipo_item NOT NULL,
    nome public.nome NOT NULL UNIQUE,
    descricao public.descricao NOT NULL,
    valor integer
);

CREATE TABLE public.tipos_personagem(
    id public.formato_id NOT NULL PRIMARY KEY,
    tipo public.tipos_personagem NOT NULL
);

-- ===============================================

--  TABELAS DE RELACIONAMENTOS MUITOS PARA MUITOS

-- =============================================== 

CREATE TABLE public.batalhas(
  id_jogador public.formato_id NOT NULL,
  id_monstro public.formato_id NOT NULL,
  PRIMARY KEY (id_jogador, id_monstro)
);

CREATE TABLE public.entregas_missoes(
  id_jogador public.formato_id NOT NULL,
  id_npc public.formato_id NOT NULL,
  PRIMARY KEY (id_jogador, id_npc)
);

CREATE TABLE public.corredores_salas_destino(
  id_sala public.formato_id NOT NULL,
  id_corredor public.formato_id NOT NULL, 
  PRIMARY KEY (id_sala, id_corredor)
);

CREATE TABLE public.inventarios_possuem_instancias_item(
  id_instancias_de_item public.formato_id NOT NULL,
  id_inventario public.formato_id NOT NULL,
  PRIMARY KEY (id_instancias_de_item, id_inventario)
);

CREATE TABLE public.instancias_de_item(
  id public.formato_id NOT NULL,
  id_item public.formato_id NOT NULL,
  nome character(64) NOT NULL UNIQUE,
  durabilidade integer NOT NULL,
  id_sala public.formato_id NOT NULL,  -- FOREIGN KEY
  id_missao_requer public.formato_id NOT NULL,  -- FOREIGN KEY
  id_missao_recompensa public.formato_id NOT NULL,  -- FOREIGN KEY
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
ADD CONSTRAINT fk_personagens_jogaveis_salas 
    FOREIGN KEY (id_local) 
    REFERENCES public.salas (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_persongens_jogaveis_corredores 
    FOREIGN KEY (id_local) 
    REFERENCES public.corredores (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_personagens_jogaveis_invetario_arma
    FOREIGN KEY (id_arma) 
    REFERENCES public.inventarios (id);

ALTER TABLE public.personagens_jogaveis 
ADD CONSTRAINT fk_personagens_jogaveis_inventarios 
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
ADD CONSTRAINT fk_corredores_saldas_destino_corredores 
    FOREIGN KEY (id_corredor) 
    REFERENCES public.corredores (id);

ALTER TABLE public.corredores_salas_destino 
ADD CONSTRAINT fk_corredores_saldas_destino_salas 
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
    FOREIGN KEY (id_feitiço) 
    REFERENCES public.tipos_feitiço (id);

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
    REFERENCES public.tipos_monstro (id_monstro);

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
    FOREIGN KEY (id_monstro) 
    REFERENCES public.pacificos (id);

ALTER TABLE public.tipos_monstro 
ADD CONSTRAINT fk_tipos_monstro_agressivos 
    FOREIGN KEY (id_monstro) 
    REFERENCES public.agressivos (id);

-- BATALHAS

ALTER TABLE public.batalhas 
ADD CONSTRAINT fk_batalhas_personagens_jogaveis 
    FOREIGN KEY (id_jogador) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.batalhas 
ADD CONSTRAINT fk_batalhas_mosntro 
    FOREIGN KEY (id_monstro) 
    REFERENCES public.instancias_monstro (id);

-- MISSÕES

ALTER TABLE public.missoes 
ADD CONSTRAINT fk_missoes_npcs 
    FOREIGN KEY (id_npc) 
    REFERENCES public.npc (id);

-- ENTREGAS DE MISSÕES

ALTER TABLE public.entregas_missoes 
ADD CONSTRAINT fk_entregas_missoes_personagens_jogaveis 
    FOREIGN KEY (id_jogador) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.entregas_missoes 
ADD CONSTRAINT fk_entregas_missoes_npc 
    FOREIGN KEY (id_npc) 
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
    FOREIGN KEY (id_personagem) 
    REFERENCES public.personagens_jogaveis (id);

ALTER TABLE public.tipos_personagem 
ADD CONSTRAINT fk_tipos_personagem_npc 
    FOREIGN KEY (id_personagem) 
    REFERENCES public.npcs (id);

ALTER TABLE public.agressivos 
ADD CONSTRAINT fk_agressivos_tipos_de_feitico 
    FOREIGN KEY (id_feitico) 
    REFERENCES public.tipos_feitico (id);

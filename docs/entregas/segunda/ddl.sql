CREATE TABLE public.personagens_jogaveis(
  id integer NOT NULL, -- chave primária
  nome character(64) NOT NULL,
  id_pt_de_magia integer NOT NULL,
  id_pericia integer NOT NULL,
  id_sanidade integer NOT NULL,
  ocupacao character(32) NOT NULL,
  idade integer NOT NULL,
  sexo integer NOT NULL,
  residencia integer NOT NULL,
  local_nascimento character(32) NOT NULL,
  id_armadura integer NOT NULL,
  id_arma integer NOT NULL,
  forca integer NOT NULL,
  destreza integer NOT NULL,
  constituicao integer NOT NULL,
  tamanho integer NOT NULL,
  aparencia integer NOT NULL,
  inteligencia integer NOT NULL,
  poder integer NOT NULL,
  educacao integer NOT NULL,
  ideia integer NOT NULL,
  conhecimento integer NOT NULL,
  movimento integer NOT NULL,
  sorte integer NOT NULL,
  id_inventario integer NOT NULL,
  localBoolean boolean NOT NULL,
  id_local integer NOT NULL,
);

CREATE TABLE public.npcs(
  id integer NOT NULL, -- [primary key]
  nome character(64) NOT NULL,
  ocupacao character(32) NOT NULL,
  idade integer NOT NULL,
  sexo character(10) NOT NULL,
  residencia character 
  local_nascimento character(32) NOT NULL
  localBoolean boolean NOT NULL
  id_local integer NOT NULL
);

CREATE TABLE public.dialogos(
  id integer NOT NULL,  --[primary key]
  npc_id integer NOT NULL, 
  script_dialogo character(256) NOT NULL,
);

CREATE TABLE public.inventarios(
  id integer NOT NULL, -- [primary key]
  tamanho integer NOT NULL,
);

CREATE TABLE public.templos(
  id integer NOT NULL, -- [primary key]
  nome character(32) NOT NULL,
  descricao character(128) NOT NULL,
);

CREATE TABLE public.andares(
  id integer NOT NULL, -- [primary key]
  descricao character(128) NOT NULL,
  sala_inicial integer NOT NULL,
  id_templo integer NOT NULL,
);

CREATE TABLE public.salas(
  id integer NOT NULL, -- [primary key]
  descricao character(128) NOT NULL,
);

CREATE TABLE public.corredores(
  id integer NOT NULL, -- [primary key]
  status boolean NOT NULL,
  descricao character(128) NOT NULL,
);

CREATE TABLE public.pts_de_magia(
  id integer NOT NULL, [primary key]
  valor_base integer, 
  PM_max integer,
);

CREATE TABLE public.sanidades(
  id integer NOT NULL, -- [primary key]
  sanidade_maxima integer NOT NULL,
  sanidade_atual integer,
  insanidade_temporaria boolean,
  insanidade_indefinida boolean,
)

CREATE TABLE public.pericias(
  id integer NOT NULL, -- [primary key]
  valor integer,
  eh_de_ocupacao boolean,
);

CREATE TABLE public.agressivos(
  id integer NOT NULL, -- [primary key]
  nome character(64) NOT NULL,
  descricao character(128) NOT NULL,
  defesa integer,
  vida integer,
  catalisador_agressividade character(32),
  poder integer,
  fisico boolean,
  psiquico boolean,
  magico boolean,
  velocidade_ataque integer,
  loucura_induzida integer,
  ponto_magia integer,
  id_feitiço integer,
);

CREATE TABLE public.pacificos(
  id integer NOT NULL, -- [primary key]
  nome character(64) NOT NULL,
  descricao character(128) NOT NULL,
  defesa integer,
  vida integer,
  motivo_passividade character(64),
  humanidade boolean,
  sobrenatural boolean,
  conhecimento_geografico character(128),
  conhecimento_proibido character(128),
);

CREATE TABLE public.instancias_monstro(
  id integer NOT NULL, -- [primary key]
  id_monstro integer NOT NULL,
  localBoolean boolean,
  id_local integer NOT NULL,
  id_instancia_de_item integer NOT NULL,
);

CREATE TABLE public.missoes(
  id integer NOT NULL, -- [primary key]
  nome character(128) NOT NULL,
  descricao character(512) NOT NULL,
  tipo integer NOT NULL,
  ordem character(128) NOT NULL,
  id_npc integer NOT NULL,
);

CREATE TABLE public.magicos(
    id integer NOT NULL, -- [primary key]
    id_feitiço integer NOT NULL,
    funcao character(128) NOT NULL,
    qts_usos integer NOT NULL,
    custo_sanidade integer NOT NULL,
);

CREATE TABLE public.curas(
    id integer NOT NULL, -- [primary key]
    funcao character(128) NOT NULL,
    qts_usos integer NOT NULL,
    qtd_pontos_sanidade_recupera integer NOT NULL,
    qtd_pontos_vida_recupera integer NOT NULL,
);

CREATE TABLE public.armaduras(
    id integer NOT NULL, -- [primary key]
    atributo_necessario character(128),
    durabilidade integer NOT NULL,
    pericia_necessaria character(128),
    funcao character(128),
    qtd_atributo_recebe integer NOT NULL,
    tipo_atributo_recebe character(128) NOT NULL,
    qtd_dano_mitigado integer NOT NULL,
);

CREATE TABLE public.armas(
    id integer NOT NULL, -- [primary key]
    atributo_necessario character(128),
    durabilidade integer,
    pericia_necessaria character(128),
    funcao character(128),
    alcance integer,
    tipo_municao character(64),
    tipo_dano character(64),
    dano integer NOT NULL,
);

CREATE TABLE public.feiticos_status(
    id integer NOT NULL, -- [primary key]
    nome character(64) NOT NULL,
    descricao character(128) NOT NULL,
    qtd_pontos_de_magia integer NOT NULL,
    buff_debuff boolean NOT NULL,
    qtd_buff_debuff integer,
    status_afetado character(64) NOT NULL,
);

CREATE TABLE public.feiticos_dano(
    id integer NOT NULL, -- [primary key]
    nome character(64) NOT NULL,
    descricao character(128) NOT NULL,
    qtd_pontos_de_magia integer NOT NULL,
    tipo_dano character(64),
    qtd_dano integer,
);

CREATE TABLE public.instancias_de_item(
  id integer NOT NULL, -- [primary key]
  id_item integer NOT NULL, -- [primary key]
  durabilidade integer NOT NULL,
  id_sala integer NOT NULL,
  id_missao_requer integer NOT NULL,
  id_missao_recompensa integer NOT NULL,
);


CREATE TABLE public.tipos_monstro(
  id_monstro integer NOT NULL, -- [primary key]
  tipo character(64) NOT NULL,
);

CREATE TABLE public.tipos_feitiço(
  id integer NOT NULL, -- [primary key]
  tipo character(64) NOT NULL,
);

CREATE TABLE public.batalhas(
  id_jogador integer NOT NULL, -- [primary key]
  id_monstro integer NOT NULL, -- [primary key]
);

CREATE TABLE public.entregas_missoes(
  id_jogador integer NOT NULL, -- [primary key]
  id_npc integer NOT NULL, -- [primary key]
);

CREATE TABLE public.corredores_salas_destino(
  id_sala integer NOT NULL, -- [primary key]
  id_corredor integer NOT NULL, -- [primary key]
);

CREATE TABLE public.tipos_personagem(
  id_personagem integer NOT NULL, -- [primary key]
  tipo character(32),
);

CREATE TABLE public.itens(
  id integer NOT NULL, -- [primary key]
  tipo character(32) NOT NULL,
  nome character(64) NOT NULL,
  descricao character(128) NOT NULL,
  valor integer,
);

CREATE TABLE public.inventarios_possuem_instancias_item(
  id_instancias_de_item integer NOT NULL, -- [primary key]
  id_inventario integer NOT NULL, -- [primary key]
);

ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_pj_sanidade FOREIGN KEY (id_sanidade) REFERENCES public.sanidades (id);
ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_pj_pt_de_magia FOREIGN KEY (id_pt_de_magia) REFERENCES public.pts_de_magia (id);
ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_pj_pericia FOREIGN KEY (id_pericia) REFERENCES public.pericias (id);
ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_pj_inventario FOREIGN KEY (id_inventario) REFERENCES public.inventarios (id);

ALTER TABLE public.andares ADD CONSTRAINT fk_andares_templo FOREIGN KEY (id_templo) REFERENCES public.templos (id);

ALTER TABLE public.andares ADD CONSTRAINT fk_andares_salas FOREIGN KEY (sala_inicial) REFERENCES public.salas (id);

ALTER TABLE public.corredores_salas_destino ADD CONSTRAINT fk_corredores_saldas_destino_corredores FOREIGN KEY (id_corredor) REFERENCES public.corredores (id);
ALTER TABLE public.corredores_salas_destino ADD CONSTRAINT fk_corredores_saldas_destino_salas FOREIGN KEY (id_sala) REFERENCES public.salas (id);

ALTER TABLE public.itens ADD CONSTRAINT fk_itens_curas FOREIGN KEY (id) REFERENCES public.curas (id);
ALTER TABLE public.itens ADD CONSTRAINT fk_itens_magicos FOREIGN KEY (id) REFERENCES public.magicos (id);
ALTER TABLE public.itens ADD CONSTRAINT fk_itens_armaduras FOREIGN KEY (id) REFERENCES public.armaduras (id);
ALTER TABLE public.itens ADD CONSTRAINT fk_itens_armas FOREIGN KEY (id) REFERENCES public.armas (id);

ALTER TABLE public.instancias_de_item ADD CONSTRAINT fk_instancias_de_item_itens FOREIGN KEY (id_item) REFERENCES public.itens (id);
ALTER TABLE public.instancias_de_item ADD CONSTRAINT fk_instancias_de_item_salas FOREIGN KEY (id_item) REFERENCES public.salas (id);

ALTER TABLE public.inventarios ADD CONSTRAINT fk_inventarios_instancia_de_item FOREIGN KEY (id_inventario) REFERENCES public.instancias_de_item (id);

ALTER TABLE public.magicos ADD CONSTRAINT fk_magicos_tipos_de_feitico FOREIGN KEY (id_feitiço) REFERENCES public.tipos_feitiço (id);

ALTER TABLE public.tipos_feitico ADD CONSTRAINT fk_tipos_feitico_feitico_status FOREIGN KEY (id) REFERENCES public.feiticos_status (id);
ALTER TABLE public.tipos_feitico ADD CONSTRAINT fk_tipos_feitico_feitico_dano FOREIGN KEY (id) REFERENCES public.feiticos_dano (id);

ALTER TABLE public.instancias_monstro ADD CONSTRAINT fk_instancias_de_monstro_tipo_monstro FOREIGN KEY (id_monstro) REFERENCES public.tipos_monstro (id_monstro);

ALTER TABLE public.tipos_monstro ADD CONSTRAINT fk_tipos_monstro_pacificos FOREIGN KEY (id_mosntro) REFERENCES public.pacificos (id);
ALTER TABLE public.tipos_monstro ADD CONSTRAINT fk_tipos_monstro_agressivos FOREIGN KEY (id_mosntro) REFERENCES public.agressivos (id);

ALTER TABLE public.batalhas ADD CONSTRAINT fk_batalhas_personagens_jogaveis FOREIGN KEY (id_jogador) REFERENCES public.personagens_jogaveis (id);
ALTER TABLE public.batalhas ADD CONSTRAINT fk_batalhas_mosntro FOREIGN KEY (id_monstro) REFERENCES public.instancias_monstro (id);

ALTER TABLE public.missoes ADD CONSTRAINT fk_missoes_npc FOREIGN KEY (id_npc) REFERENCES public.npc (id);

ALTER TABLE public.entregas_missoes ADD CONSTRAINT fk_entregas_missoes_personagens_jogaveis FOREIGN KEY (id_jogador) REFERENCES public.personagens_jogaveis (id);
ALTER TABLE public.entregas_missoes ADD CONSTRAINT fk_entregas_missoes_npc FOREIGN KEY (id_npc) REFERENCES public.npcs (id);

ALTER TABLE public.instancias_de_item ADD CONSTRAINT fk_instancias_de_itens_missoes FOREIGN KEY (id_missao_recompensa) REFERENCES public.missoes (id);
ALTER TABLE public.instancias_de_item ADD CONSTRAINT fk_instancias_de_itens_missoes FOREIGN KEY (id_missao_requer) REFERENCES public.missoes (id);

ALTER TABLE public.tipos_personagem ADD CONSTRAINT fk_tipos_personagem_personagens_jogaveis FOREIGN KEY (id_personagem) REFERENCES public.personagens_jogaveis (id);
ALTER TABLE public.tipos_personagem ADD CONSTRAINT fk_tipos_personagem_npc FOREIGN KEY (id_personagem) REFERENCES public.npcs (id);

ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_persongens_jogaveis_salas FOREIGN KEY (id_local) REFERENCES public.salas (id);
ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_persongens_jogaveis_corredores FOREIGN KEY (id_local) REFERENCES public.corredores (id);

ALTER TABLE public.npcs ADD CONSTRAINT fk_npcs_salas FOREIGN KEY (id_local) REFERENCES public.salas (id);
ALTER TABLE public.npcs ADD CONSTRAINT fk_npcs_corredores FOREIGN KEY (id_local) REFERENCES public.corredores (id);
ALTER TABLE public.npcs ADD CONSTRAINT fk_npcs_dialogos FOREIGN KEY (id) REFERENCES public.dialogos (npc_id);


ALTER TABLE public.instancias_monstro ADD CONSTRAINT fk_instancias_monstro_salas FOREIGN KEY (id_local) REFERENCES public.salas (id);
ALTER TABLE public.instancias_monstro ADD CONSTRAINT fk_instancias_monstro_corredores FOREIGN KEY (id_local) REFERENCES public.corredores (id);

ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_personagens_jogaveis_invetarios FOREIGN KEY (id_arma) REFERENCES public.inventarios (id_instancia_de_item);
ALTER TABLE public.personagens_jogaveis ADD CONSTRAINT fk_personagens_jogaveis_inventarios FOREIGN KEY (id_armadura) REFERENCES public.inventarios (id_instancia_de_item);

ALTER TABLE public.instancias_monstro ADD CONSTRAINT fk_instancias_de_monstro_instancia_de_item FOREIGN KEY (id_instancia_de_item) REFERENCES public.instancias_de_item (id);

ALTER TABLE public.agressivos ADD CONSTRAINT fk_agressivos_tipos_de_feitico FOREIGN KEY (id_feitico) REFERENCES public.tipos_feitico (id);


























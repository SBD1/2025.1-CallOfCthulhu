-- ROLLBACK;
/*
ARQUIVO: triggers-stored_procedures.sql
=====================================
        HISTÓRICO DE VERSÕES
=====================================
VERSÃO: 0.1
DATA: 28/06/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Criação dos triggers e stored procedures para a generalização e especialização de personagens jogáveis e NPCs.

VERSÃO: 0.2
DATA: 28/06/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Criação dos triggers e stored procedures para criação de personagens jogáveis e validação de atributos.

VERSÃO: 0.3
DATA: 28/06/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Reorganização do arquivo e do nome das funções e triggers.

VERSÃO: 0.4
DATA: 28/06/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Criação de stored procedure para criação de monstros, com validações de regras de negócio e exclusividade.

VERSÃO: 0.5
DATA: 28/06/2025
AUTOR: João Marcos
DESCRIÇÃO: Adição das funções e triggers para validação e criação de NPCs, e correção no DROP FUNCTION.

VERSÃO: 0.6
DATA: 28/06/2025
AUTOR: João Marcos
DESCRIÇÃO: Criação de triggers e stored procedures para missões, incluindo validações de regras de negócio e exclusividade.

VERSÃO: 0.7 
DATA: 05/07/2025
AUTOR: Luiz Guilherme
DESCRIÇÃO: Correção de bugs no arquivo

VERSÃO: 0.8
DATA: 05/07/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Cria triggers e stored procedures para armas e armaduras, incluindo validações de regras de negócio e exclusividade.

VERSÃO: 0.9
DATA: 05/07/2025
AUTOR: Luiz Guilherme
DESCRIÇÃO: Criação do procedure para permitir o respawn de monstros e itens no jogo

VERSÃO: 0.10
DATA: 05/07/2025
AUTOR: Luiz Guilherme
DESCRIÇÃO: Criação dos procedures: vasculhar sala, olhar inventario, pegar item da sala

VERSÃO: 0.11
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Organiza so triggers de npc e personagem jogável.

VERSÃO: 0.12
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Criando o ROLE usuario_padrao e concedendo permissões de acesso ao banco de dados.

VERSÃO: 0.13
DATA: 05/07/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Cria triggers, stored procedures e functions para itens consumíveis (cura e mágicos) e feitiços.

VERSÃO: 0.14
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria triggers, stored procedures e functions para Batalha e conclusão de missões.

VERSÃO: 0.15
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria triggers, stored procedures e functions para movimentação de jogadores, equipar itens e gerenciar durabilidade de itens.

VERSÃO: 0.16
DATA: 05/07/2025
AUTOR: Wanjo Chritopher
DESCRIÇÃO: Adiciona as procedures sp_desequipar_item e atualiza sp_equipar_item para gerenciar os atributos do personagem ao equipar e desequipar itens.

VERSÃO: 0.17
DATA: 05/07/2025
AUTOR: Wanjo Chritopher
DESCRIÇÃO: Corrige sp_executar_batalha para buscar vida da instância. Melhora sp_ver_inventario para retornar os bônus dos itens.

VERSÃO: 0.18
DATA: 05/07/2025
AUTOR: Wanjo Chritopher
DESCRIÇÃO: Cria procedure de insperior monstro e melhora a de checar inventário
*/


-- -- ===============================================================================
-- --          0.1. DROP, CREATE, GRANK E REVOKE DE USUÁRIO PADRÃO DO BANCO 
-- -- ===============================================================================
-- DROP ROLE IF EXISTS usuario_padrao;

-- CREATE ROLE usuario_padrao
--     WITH LOGIN
--     NOSUPERUSER
--     NOCREATEDB
--     NOCREATEROLE
--     INHERIT
--     NOREPLICATION
--     CONNECTION LIMIT -1
--     PASSWORD 'usuario_padrao';
-- COMMENT ON ROLE usuario_padrao IS 'Usuário padrão para acesso ao banco de dados';

-- -- ===============================================================================
-- -- Permissões para o usuário padrão
-- -- ===============================================================================

-- GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO usuario_padrao;

-- REVOKE INSERT, UPDATE, DELETE ON public.personagens_jogaveis FROM usuario_padrao;


-- =================================================================================
--         0.2. DROP TRIGGER E DROP FUNCTIONS
-- Para que a criação de triggers e funções não gere erros, é necessário remover as existentes
-- =================================================================================

-- ======== DROP DE TRIGGERS ========
-- Triggers de personagens e NPCs
DROP TRIGGER IF EXISTS trigger_valida_unicidade_personagem_jogavel ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_unicidade_npc ON public.npcs CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_ajustar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_npc ON public.npcs CASCADE;

-- Triggers de monstros agressivos e pacíficos
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_agressivo ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_pacifico ON public.pacificos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_atributos_agressivo ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_atributos_pacifico ON public.pacificos CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_monstros ON public.tipos_monstro CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_agressivos ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_pacificos ON public.pacificos CASCADE;

-- Triggers de missões
DROP TRIGGER IF EXISTS trigger_validar_dados_missao ON public.missoes CASCADE;

-- Triggers de itens
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens ON public.itens CASCADE;

-- Triggers de feitiços
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_feiticos ON public.tipos_feitico CASCADE;

-- ======== DROP DE FUNÇÕES ========
-- Funções de Generalização/Especialização
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pj() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_npc() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_agressivo() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pacifico() CASCADE;

-- Funções de Personagem Jogável
DROP FUNCTION IF EXISTS public.sp_criar_personagem_jogavel(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.func_ajustar_atributos_personagem() CASCADE;

-- Funções de NPC
DROP FUNCTION IF EXISTS public.sp_criar_npc(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_atributos_npc() CASCADE;

-- Funções de monstros agressivos e pacíficos
DROP FUNCTION IF EXISTS public.sp_criar_monstro(public.nome, public.descricao, public.tipo_monstro, SMALLINT, SMALLINT, public.gatilho_agressividade, SMALLINT, public.tipo_monstro_agressivo, SMALLINT, SMALLINT, SMALLINT, public.dano, SMALLINT, SMALLINT, public.comportamento_pacifico, public.tipo_monstro_pacifico, CHARACTER(128), CHARACTER(128)) CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_atributos_monstro_agressivo() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_atributos_monstro_pacifico() CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_monstro() CASCADE;

-- Funções de missões
DROP FUNCTION IF EXISTS public.sp_criar_missao(public.nome, CHARACTER(512), public.tipo_missao, CHARACTER(128), public.id_personagem_npc) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_dados_missao() CASCADE;
DROP FUNCTION IF EXISTS public.sp_entregar_missao(public.id_personagem_jogavel, public.id_missao) CASCADE;

-- Funções de itens
DROP FUNCTION IF EXISTS public.sp_criar_item(public.nome, public.descricao, public.tipo_item, SMALLINT, public.id_inventario) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_arma(public.nome, public.descricao, SMALLINT, public.tipo_atributo_personagem, SMALLINT, SMALLINT, public.funcao_arma, SMALLINT, public.tipo_municao, public.tipo_dano, public.dano) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_armadura(public.nome, public.descricao, SMALLINT, public.tipo_atributo_personagem, SMALLINT, funcao_armadura, SMALLINT, SMALLINT, public.tipo_atributo_personagem, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_item_cura(public.nome, public.descricao, SMALLINT, public.funcao_cura, SMALLINT, SMALLINT, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_item_magico(public.nome, public.descricao, SMALLINT, public.funcao_magica, SMALLINT, SMALLINT, public.id_feitico) CASCADE;
DROP FUNCTION IF EXISTS func_valida_atributos_item() CASCADE;
DROP FUNCTION IF EXISTS func_bloquear_insert_direto_itens() CASCADE;
DROP FUNCTION IF EXISTS func_valida_exclusividade_id_item() CASCADE;
DROP FUNCTION IF EXISTS func_valida_exclusividade_id_arma() CASCADE;
DROP FUNCTION IF EXISTS func_valida_exclusividade_id_armadura() CASCADE;

-- Funções de respawn
DROP FUNCTION IF EXISTS public.lua_de_sangue() CASCADE;
DROP FUNCTION IF EXISTS public.sp_vasculhar_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_adicionar_item_ao_inventario(public.id_personagem, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_ver_inventario(public.id_personagem) CASCADE;
DROP FUNCTION IF EXISTS public.sp_encontrar_monstros_no_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_matar_monstros_no_local(public.id_local) CASCADE;

-- Função de Batalha
DROP FUNCTION IF EXISTS public.sp_executar_batalha(public.id_personagem_jogavel, public.id_instancia_de_monstro) CASCADE;

-- Mover o jogador para um novo local
DROP FUNCTION IF EXISTS public.sp_mover_jogador(public.id_personagem_jogavel, public.id_local) CASCADE;

-- Equipar uma arma ou armadura
DROP FUNCTION IF EXISTS public.sp_equipar_item(public.id_personagem_jogavel, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_desequipar_item(public.id_personagem_jogavel, public.tipo_item) CASCADE;


-- Função Usar um item de cura
DROP FUNCTION IF EXISTS public.sp_usar_item_cura(public.id_personagem_jogavel, public.id_instancia_de_item) CASCADE;

-- Função para gerenciar durabilidade de itens
DROP FUNCTION IF EXISTS public.func_gerenciar_durabilidade_item() CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_durabilidade_arma ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_durabilidade_armadura ON public.armaduras CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_usos_cura ON public.curas CASCADE;

-- =================================================================================
--         1. REGRAS GERAIS DE PERSONAGENS
--         Lógica para garantir a exclusividade entre PJ e NPC (Regra T,E)
-- =================================================================================
-------------------------------------------------------------
-- Função/Trigger: Garante que um PJ não possa ser um NPC
-------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_pj()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o ID que está sendo inserido/atualizado em PJ já existe na tabela de NPCs.
    IF EXISTS (SELECT 1 FROM public.npcs WHERE id = NEW.id) THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O ID % já existe na tabela de NPCs. Um personagem não pode ser Jogável e NPC ao mesmo tempo.', NEW.id;
    END IF;

    -- Se a verificação passar, permite que a operação continue.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_valida_unicidade_personagem_jogavel
    BEFORE INSERT OR UPDATE ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_valida_exclusividade_id_pj();

-------------------------------------------------------------
-- Função/Trigger: Garante que um NPC não possa ser um PJ
-------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_npc()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o ID que está sendo inserido/atualizado em NPC já existe na tabela de PJs.
    IF EXISTS (SELECT 1 FROM public.personagens_jogaveis WHERE id = NEW.id) THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O ID % já existe na tabela de Personagens Jogáveis. Um NPC não pode ser NPC e Jogável ao mesmo tempo.', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_valida_unicidade_npc
    BEFORE INSERT OR UPDATE ON public.npcs
    FOR EACH ROW EXECUTE FUNCTION public.func_valida_exclusividade_id_npc();


-- =================================================================================
--         1.2. REGRAS E PROCEDIMENTOS DE PERSONAGENS JOGÁVEIS (PJ)
-- =================================================================================

-------------------------------------------------------------
-- Função/Trigger: Valida os dados de entrada de um novo PJ
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_validar_atributos_personagem()
RETURNS TRIGGER AS $$
BEGIN
    -- Validação do nome
    IF NEW.nome IS NULL OR TRIM(NEW.nome) = '' OR NEW.nome ~ '[0-9]' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O nome do personagem não pode ser nulo, vazio ou conter números.';
    END IF;

    -- Validação de outros campos de texto obrigatórios
    IF TRIM(NEW.ocupacao) = '' OR TRIM(NEW.residencia) = '' OR TRIM(NEW.local_nascimento) = '' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Os campos "ocupacao", "residencia" e "local_nascimento" não podem ser nulos ou vazios.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_atributos_personagem
    BEFORE INSERT ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_atributos_personagem();

-------------------------------------------------------------
-- Função/Trigger: Ajusta atributos calculados de um novo PJ
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_ajustar_atributos_personagem()
RETURNS TRIGGER AS $$
BEGIN
    -- Cálculo do MOVIMENTO
    IF NEW.destreza < NEW.tamanho AND NEW.forca < NEW.tamanho THEN
        NEW.movimento := 7;
    ELSIF NEW.destreza > NEW.tamanho AND NEW.forca > NEW.tamanho THEN
        NEW.movimento := 9;
    ELSE
        NEW.movimento := 8;
    END IF;
    
    -- Cálculo de Sanidade, Vida e PM iniciais, usando as funções auxiliares do DDL.
    NEW.sanidade_atual := public.calcular_sanidade(NEW.poder);
    NEW.pontos_de_vida_atual := public.calcular_pts_de_vida(NEW.constituicao, NEW.tamanho);
    NEW.pm_base := NEW.poder;
    NEW.pm_max := NEW.poder;

    -- Definindo valores iniciais padrão para colunas booleanas.
    NEW.insanidade_temporaria := FALSE;
    NEW.insanidade_indefinida := FALSE;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_ajustar_atributos_personagem
    BEFORE INSERT ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_ajustar_atributos_personagem();

-------------------------------------------------------------
--  STORED PROCEDURE: Criação de PJs
-------------------------------------------------------------
/*
    Este procedimento encapsula a lógica de criação de um novo Personagem Jogável.
    'p_' indica um parâmetro de entrada.
    'v_' indica uma variável local.
*/
CREATE FUNCTION public.sp_criar_personagem_jogavel(
    p_nome public.nome,
    p_ocupacao public.ocupacao,
    p_residencia public.residencia,
    p_local_nascimento public.local_nascimento,
    p_idade public.idade,
    p_sexo public.sexo
)
RETURNS public.id_personagem_jogavel AS $$
DECLARE
    v_novo_inventario_id public.id_inventario;
    v_novo_personagem_id public.id_personagem_jogavel;
BEGIN
    -- 1. Cria o inventário para o novo personagem.
    INSERT INTO public.inventarios (tamanho) VALUES (32) RETURNING id INTO v_novo_inventario_id;

    -- 2. Insere os dados básicos na tabela. Os atributos calculados e as validações
    --    serão processados automaticamente pelas triggers 'trigger_ajustar_atributos_personagem'
    --    e 'trigger_validar_atributos_personagem'.
    INSERT INTO public.personagens_jogaveis (
        nome, ocupacao, residencia, local_nascimento, idade, sexo,
        id_inventario, id_local
    ) VALUES (
        p_nome, p_ocupacao, p_residencia, p_local_nascimento, p_idade, p_sexo,
        v_novo_inventario_id, (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala' LIMIT 1) -- Define uma sala inicial padrão
    ) RETURNING id INTO v_novo_personagem_id;

    -- 3. Retorna o ID do personagem recém-criado.
    RETURN v_novo_personagem_id;
END;
$$ LANGUAGE plpgsql;


-- =================================================================================
--         1.3. REGRAS E PROCEDIMENTOS DE NPCs
-- =================================================================================

-------------------------------------------------------------
-- Função/Trigger: Valida os dados de entrada de um novo NPC
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_validar_atributos_npc()
RETURNS TRIGGER AS $$
BEGIN
    -- Validação do nome (similar ao PJ)
    IF NEW.nome IS NULL OR TRIM(NEW.nome) = '' OR NEW.nome ~ '[0-9]' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O nome do NPC não pode ser nulo, vazio ou conter números.';
    END IF;

    -- Validação de outros campos de texto obrigatórios
    IF TRIM(NEW.ocupacao) = '' OR TRIM(NEW.residencia) = '' OR TRIM(NEW.local_nascimento) = '' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Os campos "ocupacao", "residencia" e "local_nascimento" do NPC não podem ser nulos ou vazios.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_atributos_npc
    BEFORE INSERT ON public.npcs
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_atributos_npc();

-------------------------------------------------------------
-- STORED PROCEDURE: Criação de NPCs
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_criar_npc(
    p_nome public.nome,
    p_ocupacao public.ocupacao,
    p_residencia public.residencia,
    p_local_nascimento public.local_nascimento,
    p_idade public.idade,
    p_sexo public.sexo
)
RETURNS public.id_personagem_npc AS $$
DECLARE
    v_novo_npc_id public.id_personagem_npc;
BEGIN
    -- Insere os dados do NPC. A validação será feita pela trigger 'trigger_validar_atributos_npc'.
    INSERT INTO public.npcs (
        nome, ocupacao, residencia, local_nascimento, idade, sexo,
        id_local -- Localização inicial
    ) VALUES (
        p_nome, p_ocupacao, p_residencia, p_local_nascimento, p_idade, p_sexo,
        40300003 -- Sala inicial padrão para NPCs (exemplo, pode ser alterado ou passado como parâmetro)
    ) RETURNING id INTO v_novo_npc_id;

    RETURN v_novo_npc_id;
END;
$$ LANGUAGE plpgsql;

/*
=================================================================================
        2. LÓGICA PARA MONSTROS
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--         2.1. STORED PROCEDURE PARA CRIAÇÃO DE MONSTROS
--         Este SP é o único ponto de entrada e garante as regras Total, Exclusiva e de Atributos.
-- ---------------------------------------------------------------------------------

CREATE FUNCTION public.sp_criar_monstro(
    -- Parâmetros padrão para ambas tabelas
    p_nome public.nome,
    p_descricao public.descricao,
    -- Parâmetro para public.tipos_monstro
    p_tipo public.tipo_monstro,

    -- Parâmetros para monstro agressivo
    p_agressivo_defesa SMALLINT DEFAULT NULL,
    p_agressivo_vida SMALLINT DEFAULT NULL,
    p_agressivo_vida_total SMALLINT DEFAULT NULL,
    p_agressivo_catalisador public.gatilho_agressividade DEFAULT NULL,
    p_agressivo_poder SMALLINT DEFAULT NULL,
    p_agressivo_tipo public.tipo_monstro_agressivo DEFAULT NULL,
    p_agressivo_velocidade SMALLINT DEFAULT NULL,
    p_agressivo_loucura SMALLINT DEFAULT NULL,
    p_agressivo_pm SMALLINT DEFAULT NULL,
    p_agressivo_dano public.dano DEFAULT NULL,

    -- Parâmetros para monstro pacífico
    p_pacifico_defesa SMALLINT DEFAULT NULL,
    p_pacifico_vida SMALLINT DEFAULT NULL,
    p_pacifico_vida_total SMALLINT DEFAULT NULL,
    p_pacifico_motivo public.comportamento_pacifico DEFAULT NULL,
    p_pacifico_tipo public.tipo_monstro_pacifico DEFAULT NULL,
    p_pacifico_conhecimento_geo CHARACTER(128) DEFAULT NULL,
    p_pacifico_conhecimento_proibido CHARACTER(128) DEFAULT NULL
) 
RETURNS public.id_monstro 
LANGUAGE plpgsql AS $$
DECLARE
    v_novo_monstro_id public.id_monstro;
BEGIN
    -- == Funcionamento de current_setting('nome_da_config', 'missing_ok') ==
    -- Caso 'missing_ok' seja 'true', não gera erro caso a configuração não exista
    -- Caso seja 'false', gera Exception, o que daria problema pois testamos se o valor é inexistente (NULL)
    SET LOCAL bd_cthulhu.inserir = 'true';

    -- =================== VALIDAÇÃO E INSERÇÃO ===================
    IF p_tipo = 'agressivo' THEN
        IF p_agressivo_vida IS NULL OR p_agressivo_dano IS NULL OR p_agressivo_tipo IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Para monstros agressivos, os campos vida, dano e tipo_agressivo são obrigatórios.';
        END IF;
        IF p_agressivo_tipo = 'psiquico' AND p_agressivo_loucura IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "psiquico" devem ter valor para "loucura_induzida".';
        ELSIF p_agressivo_tipo = 'magico' AND p_agressivo_pm IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "magico" devem ter valor para "ponto_magia".';
        ELSIF p_agressivo_tipo = 'fisico' AND p_agressivo_velocidade IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "fisico" devem ter valor para "velocidade_ataque".';
        END IF;

        v_novo_monstro_id := public.gerar_id_monstro_agressivo();

        -- Insere na tabela de tipos_monstro
        INSERT INTO public.tipos_monstro (id, tipo)
            VALUES (v_novo_monstro_id, p_tipo);

        -- Insere na tabela de monstros agressivos
        INSERT INTO public.agressivos (id, nome, descricao, defesa, vida, vida_total, catalisador_agressividade, poder, tipo_agressivo, velocidade_ataque, loucura_induzida, ponto_magia, dano)
            VALUES (v_novo_monstro_id, p_nome, p_descricao, p_agressivo_defesa, p_agressivo_vida, p_agressivo_vida_total, p_agressivo_catalisador, p_agressivo_poder, p_agressivo_tipo, p_agressivo_velocidade, p_agressivo_loucura, p_agressivo_pm, p_agressivo_dano);
    ELSIF p_tipo = 'pacífico' THEN
        IF p_pacifico_vida IS NULL OR p_pacifico_defesa IS NULL OR p_pacifico_motivo IS NULL OR p_pacifico_tipo IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Para monstros pacíficos, os campos vida, defesa, motivo_passividade e tipo_pacifico são obrigatórios.';
        END IF;
        IF p_pacifico_tipo = 'sobrenatural' AND p_pacifico_conhecimento_proibido IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "sobrenatural" devem ter valor para "conhecimento_proibido".';
        ELSIF p_pacifico_tipo = 'humanoide' AND p_pacifico_conhecimento_geo IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "humanoide" devem ter valor para "conhecimento_geografico".';
        END IF;

        v_novo_monstro_id := public.gerar_id_monstro_pacifico();
        -- Insere na tabela de tipos_monstro
        INSERT INTO public.tipos_monstro (id, tipo)
            VALUES (v_novo_monstro_id, p_tipo);

        -- Insere na tabela de monstros pacíficos
        INSERT INTO public.pacificos (id, nome, descricao, defesa, vida, vida_total, motivo_passividade, tipo_pacifico, conhecimento_geografico, conhecimento_proibido)
            VALUES (v_novo_monstro_id, p_nome, p_descricao, p_pacifico_defesa, p_pacifico_vida, p_pacifico_vida_total, p_pacifico_motivo, p_pacifico_tipo, p_pacifico_conhecimento_geo, p_pacifico_conhecimento_proibido);
    ELSE
        RAISE EXCEPTION 'Tipo de monstro inválido: %. Use "agressivo" ou "pacífico".', p_tipo;
    END IF;

    RETURN v_novo_monstro_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação do monstro: %', SQLERRM;
        RAISE;
END;
$$;
-- --------------------------------------------------------------------
--        2.2 Inspecionar detalhes de um monstro
-- --------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_inspecionar_monstro(
    p_id_instancia_monstro public.id_instancia_de_monstro
)
RETURNS TABLE (
    nome public.nome,
    descricao public.descricao,
    tipo_monstro public.tipo_monstro,
    vida_atual SMALLINT,
    vida_total SMALLINT,
    defesa SMALLINT,
    -- Atributos de Monstro Agressivo
    dano public.dano,
    tipo_agressivo public.tipo_monstro_agressivo,
    catalisador_agressividade public.gatilho_agressividade,
    loucura_induzida SMALLINT,
    ponto_magia SMALLINT,
    velocidade_ataque SMALLINT,
    -- Atributos de Monstro Pacífico
    motivo_passividade public.comportamento_pacifico,
    tipo_pacifico public.tipo_monstro_pacifico,
    conhecimento_geografico CHARACTER(128),
    conhecimento_proibido CHARACTER(128)
)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(a.nome, p.nome),
        COALESCE(a.descricao, p.descricao),
        tm.tipo,
        im.vida,
        COALESCE(a.vida_total, p.vida_total),
        COALESCE(a.defesa, p.defesa),
        a.dano,
        a.tipo_agressivo,
        a.catalisador_agressividade,
        a.loucura_induzida,
        a.ponto_magia,
        a.velocidade_ataque,
        p.motivo_passividade,
        p.tipo_pacifico,
        p.conhecimento_geografico,
        p.conhecimento_proibido
    FROM public.instancias_monstros im
    JOIN public.tipos_monstro tm ON im.id_monstro = tm.id
    LEFT JOIN public.agressivos a ON tm.id = a.id AND tm.tipo = 'agressivo'
    LEFT JOIN public.pacificos p ON tm.id = p.id AND tm.tipo = 'pacífico'
    WHERE im.id = p_id_instancia_monstro;
END;
$$;
------------------------------------------------------------------------------------
--         2.2. FUNÇÕES E TRIGGERS PARA MONSTROS
-------------------------------------------------------------------------------------
CREATE FUNCTION public.func_bloquear_insert_direto_monstro()
RETURNS TRIGGER AS $$
BEGIN
    IF current_setting('bd_cthulhu.inserir', true) IS DISTINCT FROM 'true' THEN
        RAISE EXCEPTION 'Inserção direta não é permitida. Utilize o Stored Procedure "sp_criar_monstro" para criar monstros.';
    END IF;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

-- Trigger para bloquear inserção direta na tabela 'monstros'
CREATE TRIGGER trigger_bloqueia_insert_monstros
    BEFORE INSERT ON public.tipos_monstro
    FOR EACH ROW EXECUTE FUNCTION public.func_bloquear_insert_direto_monstro();

-- Trigger para bloquear inserção direta na tabela 'agressivos'
CREATE TRIGGER trigger_bloqueia_insert_agressivos
    BEFORE INSERT ON public.agressivos
    FOR EACH ROW EXECUTE FUNCTION public.func_bloquear_insert_direto_monstro();

-- Trigger para bloquear inserção direta na tabela 'pacificos'
CREATE TRIGGER trigger_bloqueia_insert_pacificos
    BEFORE INSERT ON public.pacificos
    FOR EACH ROW EXECUTE FUNCTION public.func_bloquear_insert_direto_monstro();

/*
=================================================================================
        3. LÓGICA PARA MISSÕES
=================================================================================
*/
-- =================================================================================
--         3.1. FUNÇÕES, TRIGGERS E STORED PROCEDURES PARA MISSÕES
-- =================================================================================
-------------------------------------------------------------
-- STORED PROCEDURE: Facilita a criação de novas missões
-------------------------------------------------------------
CREATE FUNCTION public.sp_criar_missao(
    p_nome public.nome,
    p_descricao CHARACTER(512),
    p_tipo public.tipo_missao,
    p_ordem CHARACTER(128),
    p_id_npc public.id_personagem_npc
)
RETURNS public.id_missao 
LANGUAGE plpgsql AS $$
DECLARE
    v_nova_missao_id public.id_missao;
BEGIN
    -- A inserção irá automaticamente disparar a trigger 'trigger_validar_dados_missao'
    -- para garantir a integridade dos dados antes de confirmar a operação.
    INSERT INTO public.missoes (
        nome,
        descricao,
        tipo,
        ordem,
        id_npc
    ) VALUES (
        p_nome,
        p_descricao,
        p_tipo,
        p_ordem,
        p_id_npc
    ) RETURNING id INTO v_nova_missao_id;

    RETURN v_nova_missao_id;
END;
$$;

-------------------------------------------------------------
-- Função/Trigger: Valida os dados de uma nova Missão
-------------------------------------------------------------
CREATE FUNCTION public.func_validar_dados_missao()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Validação dos campos de texto obrigatórios
    IF NEW.nome IS NULL OR TRIM(NEW.nome) = '' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O nome da missão não pode ser nulo ou vazio.';
    END IF;

    IF NEW.descricao IS NULL OR TRIM(NEW.descricao) = '' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A descrição da missão não pode ser nula ou vazia.';
    END IF;

    -- 2. Validação da existência do NPC
    -- Garante que o NPC que entrega a missão realmente existe.
    IF NOT EXISTS (SELECT 1 FROM public.npcs WHERE id = NEW.id_npc) THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA DE FK: O NPC com ID % não existe. Não é possível criar uma missão para um NPC inexistente.', NEW.id_npc;
    END IF;
    
    -- 3. Validação do tipo de missão (embora o DOMAIN já faça isso, é uma boa prática reforçar)
    IF NEW.tipo IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O tipo da missão não pode ser nulo.';
    END IF;

    -- Se todas as validações passarem, permite a operação.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER trigger_validar_dados_missao
    BEFORE INSERT OR UPDATE ON public.missoes
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_dados_missao();

/*
=================================================================================
        4. FUNÇÕES DE ITENS (GERAL)
=================================================================================
*/
-- ---------------------------------------------------------------------------------
-- Função/Trigger: Valida os atributos de um item antes de inseri-lo ou atualizá-lo
-- ---------------------------------------------------------------------------------
CREATE FUNCTION public.func_valida_atributos_item()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id IS NULL THEN
        RAISE EXCEPTION '[VIOLAÇÃO DE REGRA] O ID do item não pode ser nulo.';
    ELSIF NEW.nome IS NULL OR TRIM(NEW.nome) = '' THEN
        RAISE EXCEPTION '[VIOLAÇÃO DE REGRA] O nome do item não pode ser nulo ou vazio.';
    ELSIF NEW.descricao IS NULL OR TRIM(NEW.descricao) = '' THEN
        RAISE EXCEPTION '[VIOLAÇÃO DE REGRA] A descrição do item não pode ser nula ou vazia.';
    ELSIF NEW.valor IS NULL OR NOT (NEW.valor BETWEEN 0 AND 999) THEN
        RAISE EXCEPTION '[VIOLAÇÃO DE REGRA] O valor do item não pode ser nulo ou negativo ou maior que 999.';
    ELSIF NEW.tipo IS NULL THEN
        RAISE EXCEPTION '[VIOLAÇÃO DE REGRA] O tipo do item não pode ser nulo.';
    END IF;
    RETURN NEW;
END;  
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_valida_atributos_item
    BEFORE INSERT OR UPDATE ON public.itens
    FOR EACH ROW
    EXECUTE FUNCTION public.func_valida_atributos_item();

-- ---------------------------------------------------------------------------------
-- Função/Trigger: Bloqueia inserções diretas na tabela 'itens', 'armas', 'armaduras', 'curas' e 'magicos'
-- ---------------------------------------------------------------------------------
CREATE FUNCTION public.func_bloquear_insert_direto_itens()
RETURNS TRIGGER AS $$
BEGIN
    IF current_setting('bd_cthulhu.inserir', true) IS DISTINCT FROM 'true' THEN
        RAISE EXCEPTION 'Inserção direta na tabela "itens" não é permitida. Utilize a função apropriada.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_bloqueia_insert_itens
    BEFORE INSERT ON public.itens 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

CREATE TRIGGER trigger_bloqueia_insert_armas
    BEFORE INSERT ON public.armas 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

CREATE TRIGGER trigger_bloqueia_insert_armaduras
    BEFORE INSERT ON public.armaduras 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

CREATE TRIGGER trigger_bloqueia_insert_itens_curas
    BEFORE INSERT ON public.curas 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

CREATE TRIGGER trigger_bloqueia_insert_itens_magicos
    BEFORE INSERT ON public.magicos 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

-- =================================================================================
--         4.1.  FUNÇÕES, TRIGGERS E STORED PROCEDURES PARA ARMAS
-- =================================================================================
CREATE FUNCTION public.sp_criar_arma(
    p_nome public.nome,
    p_descricao public.descricao,
    p_valor SMALLINT,

    -- Parâmetros específicos de arma
    p_atributo_necessario public.tipo_atributo_personagem,
    p_qtd_atributo_necessario SMALLINT DEFAULT NULL,
    p_durabilidade SMALLINT DEFAULT NULL,
    p_funcao public.funcao_arma DEFAULT NULL,
    p_alcance SMALLINT DEFAULT NULL,
    p_tipo_municao public.tipo_municao DEFAULT NULL,
    p_tipo_dano public.tipo_dano DEFAULT NULL,
    p_dano public.dano DEFAULT NULL
)
RETURNS public.id_item 
LANGUAGE plpgsql AS $$
DECLARE
    v_novo_item_id public.id_item;
    v_pericia_id public.id_pericia;
BEGIN
    -- Passe livre para inserção de itens, sem bloqueio de triggers.
    -- Esse set volta a ter valor 'NULL' ao final da transação, garantindo que nenhuma tupla seja inserida sem passsar pelo sp_criar_arma.
    SET LOCAL bd_cthulhu.inserir = 'true';

    -- =================== VALIDAÇÃO ===================
    SELECT id INTO v_pericia_id FROM public.pericias WHERE nome = 'Briga';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'A perícia obrigatória "Briga" não foi encontrada na tabela public.pericias.';
    END IF;
    -- =================== INSERÇÃO ===================
    v_novo_item_id := public.gerar_id_item_arma();

    -- Insere na tabela pai 'itens'
    INSERT INTO public.itens(id, tipo, nome, descricao, valor)
    VALUES(v_novo_item_id, 'arma', p_nome, p_descricao, p_valor);

    -- Insere na tabela filha correta
    INSERT INTO public.armas (id, atributo_necessario, qtd_atributo_necessario, durabilidade, funcao, alcance, tipo_municao, tipo_dano, dano, id_pericia_necessaria)
    VALUES (v_novo_item_id, p_atributo_necessario, p_qtd_atributo_necessario, p_durabilidade, p_funcao, p_alcance, p_tipo_municao, p_tipo_dano, p_dano, v_pericia_id);

    RETURN v_novo_item_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação da arma: %', SQLERRM;
        RAISE; -- Re-lança a exceção para que a transação seja desfeita.
END;
$$;

-- ---------------------------------------------------------------------------------
-- Função/Trigger: Garante que uma armadura não possa ser uma arma
-- ---------------------------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_arma()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.armaduras WHERE id = NEW.id) THEN
        RAISE EXCEPTION 'O ID % já existe na tabela de armaduras. Um item do tipo arma não pode ser do tipo armadura.', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_valida_exclusividade_id_arma
    BEFORE INSERT OR UPDATE ON public.armas
    FOR EACH ROW EXECUTE FUNCTION public.func_valida_exclusividade_id_arma();

-- =================================================================================
--         4.2.  FUNÇÕES, TRIGGERS E STORED PROCEDURE PARA ARMADURAS
-- =================================================================================

CREATE OR REPLACE FUNCTION public.sp_criar_armadura(
    p_nome public.nome,
    p_descricao public.descricao,
    p_valor SMALLINT,
    p_atributo_necessario public.tipo_atributo_personagem,
    p_durabilidade SMALLINT,
    p_funcao funcao_armadura,
    p_qtd_atributo_recebe SMALLINT,
    p_qtd_atributo_necessario SMALLINT,
    p_tipo_atributo_recebe public.tipo_atributo_personagem,
    p_qtd_dano_mitigado SMALLINT
)
RETURNS public.id_item 
LANGUAGE plpgsql AS $$
DECLARE
    v_novo_item_id public.id_item;
    v_pericia_id public.id_pericia;
BEGIN
    SET LOCAL bd_cthulhu.inserir = 'true';

    -- =================== VALIDAÇÃO ===================
    SELECT id INTO v_pericia_id FROM public.pericias WHERE nome = 'Uso de Armadura';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'A perícia obrigatória "Uso de Armadura" não foi encontrada na tabela public.pericias.';
    END IF;
    
    -- =================== INSERÇÃO ===================
    v_novo_item_id := public.gerar_id_item_de_armadura();

    -- Insere na tabela pai 'itens'
    INSERT INTO public.itens(id, tipo, nome, descricao, valor)
        VALUES(v_novo_item_id, 'armadura', p_nome, p_descricao, p_valor);

    -- Insere na tabela filha correta
    INSERT INTO public.armaduras (id, atributo_necessario, durabilidade, funcao, qtd_atributo_recebe, qtd_atributo_necessario, tipo_atributo_recebe, qtd_dano_mitigado, id_pericia_necessaria)
        VALUES (v_novo_item_id, p_atributo_necessario, p_durabilidade, p_funcao , p_qtd_atributo_recebe, p_qtd_atributo_necessario, p_tipo_atributo_recebe, p_qtd_dano_mitigado, v_pericia_id);

    RETURN v_novo_item_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação da armadura: %', SQLERRM;
        RAISE; -- Re-lança a exceção para que a transação seja desfeita.
END;
$$;

-- ---------------------------------------------------------------------------------
-- Função/Trigger: Garante que uma arma não possa ser uma armadura
-- ---------------------------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_armadura()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.armas WHERE id = NEW.id) THEN
        RAISE EXCEPTION 'O ID % já existe na tabela de armas. Um item do tipo armadura não pode ser do tipo arma.', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_valida_exclusividade_id_armadura
    BEFORE INSERT OR UPDATE ON public.armaduras
    FOR EACH ROW EXECUTE FUNCTION public.func_valida_exclusividade_id_armadura();

-- =================================================================================
--         4.3.  STORED PROCEDURE PARA ITENS CONSUMÍVEIS DE CURA 
-- =================================================================================
--  Atributos levados em consideração para min e max dos efeitos de cura e magia:
--  ==== Sanidade Máxima (poder * 5) ====
--      Mínima: 3 de poder = 15 de Sanidade
--      Média: 10 de poder = 50 de Sanidade
--      Máxima: 18 de poder = 90 de Sanidade

-- ==== Pontos de Vida Máximos ((constituicao + tamanho) / 2) ====
--      Mínimo: (3+3)/2 = 3 PV
--      Médio: (10+10)/2 = 10 PV
--      Máximo: (18+18)/2 = 18 PV
-- =================================================================================
CREATE FUNCTION public.sp_criar_item_cura(
    p_nome public.nome,
    p_descricao public.descricao,
    p_valor SMALLINT,

    -- Parâmetros específicos de cura
    p_funcao public.funcao_cura,
    p_qts_usos SMALLINT,
    p_qtd_pontos_sanidade_recupera SMALLINT,
    p_qtd_pontos_vida_recupera SMALLINT
)
RETURNS public.id_item_de_cura
LANGUAGE plpgsql AS $$
DECLARE
    v_novo_item_id public.id_item_de_cura;
BEGIN
    SET LOCAL bd_cthulhu.inserir = 'true';
    -- =================== VALIDAÇÃO ===================
    IF p_funcao IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A função de cura não pode ser nula.';
    END IF;
    IF p_qts_usos <= 0 THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A quantidade de usos deve ser maior que zero.';
    END IF;
    IF NOT(p_qtd_pontos_sanidade_recupera BETWEEN 1 AND 8) THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A quantidade de pontos de sanidade recuperados deve estar entre 1 e 8.';
    END IF;
    IF NOT (p_qtd_pontos_vida_recupera BETWEEN 1 AND 10) THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A quantidade de pontos de vida recuperados deve estar entre 1 e 10.';
    END IF;

    -- =================== INSERÇÃO ===================
    v_novo_item_id := public.gerar_id_item_de_cura();
    -- Insere na tabela pai 'itens'
    INSERT INTO public.itens(id, tipo, nome, descricao, valor)
        VALUES(v_novo_item_id, 'cura', p_nome, p_descricao, p_valor);
    -- Insere na tabela filha correta
    INSERT INTO public.curas (id, funcao, qts_usos, qtd_pontos_sanidade_recupera, qtd_pontos_vida_recupera)
        VALUES (v_novo_item_id, p_funcao, p_qts_usos, p_qtd_pontos_sanidade_recupera, p_qtd_pontos_vida_recupera);
    
    RETURN v_novo_item_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação do item de cura: %', SQLERRM;      
        RAISE; -- Re-lança a exceção para que a transação seja desfeita.
END $$;

-- =================================================================================
--         4.4.  STORED PROCEDURE PARA ITENS CONSUMÍVEIS MÁGICOS
-- =================================================================================
CREATE FUNCTION public.sp_criar_item_magico(
    p_nome public.nome,
    p_descricao public.descricao,
    p_valor SMALLINT,

    -- Parâmetros específicos de item mágico
    p_funcao public.funcao_magica,
    p_qts_usos SMALLINT,
    p_custo_sanidade SMALLINT,
    p_id_feitico public.id_feitico
)
RETURNS public.id_item_magico
LANGUAGE plpgsql AS $$
DECLARE
    v_novo_item_id public.id_item_magico;
BEGIN
    SET LOCAL bd_cthulhu.inserir = 'true';
    -- =================== VALIDAÇÃO ===================
    IF p_funcao IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A função mágica não pode ser nula.';
    ELSIF p_qts_usos <= 0 THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: A quantidade de usos deve ser maior que zero.';
    ELSIF NOT (p_custo_sanidade BETWEEN 0 AND 15) THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O custo de sanidade deve estar entre 1 e 10.';
    ELSIF p_id_feitico IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: O ID do feitiço não pode ser nulo.';
    END IF;

    -- =================== INSERÇÃO ===================
    v_novo_item_id := public.gerar_id_item_magico();
    -- Insere na tabela pai 'itens'
    INSERT INTO public.itens(id, tipo, nome, descricao, valor)
        VALUES(v_novo_item_id, 'magico', p_nome, p_descricao, p_valor);
    -- Insere na tabela filha correta
    INSERT INTO public.magicos (id, funcao, qts_usos, custo_sanidade, id_feitico)
        VALUES (v_novo_item_id, p_funcao, p_qts_usos, p_custo_sanidade, p_id_feitico); 
    
    RETURN v_novo_item_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação do item mágico: %', SQLERRM;      
        RAISE; -- Re-lança a exceção para que a transação seja desfeita.
END $$;


/*
=================================================================================
        5. FUNÇÕES DE FEITIÇO (GERAL)
=================================================================================
*/
-- =========================================================================
--        5.1. FUNÇÕES, TRIGGERS E STORED PROCEDURES PARA FEITIÇOS
-- =========================================================================
CREATE OR REPLACE FUNCTION public.sp_criar_feitico(
    -- Parâmetros comuns
    p_nome public.nome,
    p_descricao public.descricao,
    p_qtd_pontos_de_magia SMALLINT,
    -- Parâmetros para o tipo de feitiço da tabela pai 'tipos_feitico'
    p_tipo_feitico public.funcao_feitico, -- status ou dano

    -- Parâmetros para feitiços de status
    p_status_buff_debuff BOOLEAN DEFAULT NULL,
    p_status_qtd_buff_debuff SMALLINT DEFAULT NULL,
    p_status_afetado public.tipo_de_status DEFAULT NULL,

    -- Parâmetros para feitiços de dano
    p_dano_tipo public.tipo_dano DEFAULT NULL,
    p_dano_qtd public.dano DEFAULT NULL
)
RETURNS public.id_feitico 
LANGUAGE plpgsql
AS $$
DECLARE
    v_novo_feitico_id INTEGER; 
BEGIN
    SET LOCAL bd_cthulhu.inserir_feitico = 'true';

    -- =================== VALIDAÇÃO e INSERT  ===================
    IF p_tipo_feitico = 'status' THEN
        IF p_status_buff_debuff IS NULL OR p_status_afetado IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Para feitiços de status, os campos "buff_debuff" e "status_afetado" são obrigatórios.';
        ELSIF p_status_buff_debuff = TRUE AND p_status_qtd_buff_debuff IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Feitiços que são buff/debuff devem ter um valor para "qtd_buff_debuff".';
        END IF;
        INSERT INTO public.feiticos_status (nome, descricao, qtd_pontos_de_magia, buff_debuff, qtd_buff_debuff, status_afetado) 
            VALUES (p_nome, p_descricao, p_qtd_pontos_de_magia, p_status_buff_debuff, p_status_qtd_buff_debuff, p_status_afetado)
        RETURNING id INTO v_novo_feitico_id; 
    ELSIF p_tipo_feitico = 'dano' THEN
        IF p_dano_tipo IS NULL OR p_dano_qtd IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Para feitiços de dano, os campos "tipo_dano" e "qtd_dano" são obrigatórios.';
        END IF;
        INSERT INTO public.feiticos_dano (nome, descricao, qtd_pontos_de_magia, tipo_dano, qtd_dano) 
            VALUES (p_nome, p_descricao, p_qtd_pontos_de_magia, p_dano_tipo, p_dano_qtd)
        RETURNING id INTO v_novo_feitico_id; 
    ELSE
        RAISE EXCEPTION 'Tipo de feitiço inválido: %. Use "status" ou "dano".', p_tipo_feitico;
    END IF;

    INSERT INTO public.tipos_feitico (id, tipo)
        VALUES (v_novo_feitico_id, p_tipo_feitico);

    RETURN v_novo_feitico_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação do feitiço: %', SQLERRM;
        RAISE; 
END;
$$;

-- ----------------------------------------------------------------
-- Função/Trigger: Bloqueia inserções diretas nas tabelas de feitiços
-- ----------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_bloquear_insert_direto_feitico()
RETURNS TRIGGER AS $$
BEGIN
    IF current_setting('bd_cthulhu.inserir_feitico', true) IS DISTINCT FROM 'true' THEN
        RAISE EXCEPTION '[PERMISSION DENIED] Utilize a Stored Procedure "sp_criar_feitico" para criar feitiços.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para bloquear inserção direta na tabela 'tipos_feitico'
CREATE TRIGGER trigger_bloqueia_insert_tipos_feitico
    BEFORE INSERT ON public.tipos_feitico
    FOR EACH ROW EXECUTE FUNCTION public.func_bloquear_insert_direto_feitico();

CREATE TRIGGER trigger_bloqueia_insert_magicos
    BEFORE INSERT ON public.magicos 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();
/*
=================================================================================
        6. FUNÇÕES DE TRANSAÇÃO (COMPRA/TRANSFERÊNCIA)
=================================================================================
*/

-- =================================================================================
--         6.1.  STORED PROCEDURE PARA TRANSFERIR ITEM DO NPC PARA O PJ
-- =================================================================================

CREATE OR REPLACE FUNCTION public.sp_comprar_item_do_npc(
    p_id_personagem_jogavel public.id_personagem_jogavel,
    p_id_npc public.id_personagem_npc,
    p_id_instancia_item public.id_instancia_de_item
    -- O parâmetro p_valor_pago foi removido
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario_npc public.id_inventario;
    v_id_inventario_pj public.id_inventario;
    v_valor_item SMALLINT;
    v_ouro_jogador INTEGER;
BEGIN
    -- ... (as validações iniciais de existência de PJ, NPC e item continuam as mesmas) ...
    
    -- Valida se o PJ e o NPC existem
    IF NOT EXISTS (SELECT 1 FROM public.personagens_jogaveis WHERE id = p_id_personagem_jogavel) THEN
        RAISE EXCEPTION 'COMPRA FALHOU: Personagem com ID % não encontrado.', p_id_personagem_jogavel;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM public.npcs WHERE id = p_id_npc) THEN
        RAISE EXCEPTION 'COMPRA FALHOU: NPC com ID % não encontrado.', p_id_npc;
    END IF;

    -- Obtém o valor do item
    SELECT i.valor INTO v_valor_item
    FROM public.itens i
    JOIN public.instancias_de_itens ii ON i.id = ii.id_item
    WHERE ii.id = p_id_instancia_item;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'COMPRA FALHOU: Item com instância ID % não encontrado.', p_id_instancia_item;
    END IF;

    -- =================== NOVA LÓGICA DE PAGAMENTO ===================
    -- Verifica se o jogador tem ouro suficiente
    SELECT ouro INTO v_ouro_jogador FROM public.personagens_jogaveis WHERE id = p_id_personagem_jogavel;
    
    IF v_ouro_jogador < v_valor_item THEN
        RAISE EXCEPTION 'COMPRA FALHOU: Ouro insuficiente. Você tem %, mas o item custa %.', v_ouro_jogador, v_valor_item;
    END IF;

    -- ... (a validação de espaço no inventário continua a mesma) ...

    -- =================== EXECUÇÃO DA TRANSFERÊNCIA ===================

    -- 1. Remove o item do inventário do NPC
    DELETE FROM public.inventarios_possuem_instancias_item
    WHERE id_inventario = (SELECT inventario FROM public.npcs WHERE id = p_id_npc)
      AND id_instancias_de_item = p_id_instancia_item;

    -- 2. Adiciona o item ao inventário do PJ
    INSERT INTO public.inventarios_possuem_instancias_item (id_inventario, id_instancias_de_item)
    VALUES ((SELECT id_inventario FROM public.personagens_jogaveis WHERE id = p_id_personagem_jogavel), p_id_instancia_item);

    -- 3. Transfere o ouro
    -- Tira ouro do jogador
    UPDATE public.personagens_jogaveis SET ouro = ouro - v_valor_item WHERE id = p_id_personagem_jogavel;
    -- Dá ouro para o NPC
    UPDATE public.npcs SET ouro = ouro + v_valor_item WHERE id = p_id_npc;

    RETURN 'Compra realizada com sucesso! ' || v_valor_item || ' de ouro foram pagos.';

EXCEPTION
    WHEN OTHERS THEN
        RAISE; -- Re-lança a exceção para que a transação seja desfeita e a mensagem de erro apareça
END;
$$;-- =================================================================================
--    6. STORED PROCEDURE PARA RESPAWN DE MONSTROS E ITENS (LUA DE SANGUE)
--=================================================================================

CREATE FUNCTION public.lua_de_sangue()
RETURNS VOID 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Primeiro passo: Respawn de Monstros
    -- Atualiza os monstros que não estão em um local (monstros mortos tem id_local = NULL)
    UPDATE public.instancias_monstros im
    SET
        id_local = im.id_local_de_spawn,
        vida = COALESCE(
            (SELECT a.vida_total FROM public.agressivos a WHERE a.id = im.id_monstro),
            (SELECT p.vida_total FROM public.pacificos p WHERE p.id = im.id_monstro)
        )
    WHERE im.id_local IS NULL;

    -- Segundo passo: Respawn de itens
    -- Adiciona os itens para os seus locais de origem
    UPDATE public.instancias_de_itens ii
    SET
        id_local = ii.id_local_de_spawn,
        durabilidade = ii.durabilidade_total
    WHERE ii.id_local IS NULL
    AND NOT EXISTS ( -- Para não duplicar itens que estão no inventário do jogador
        SELECT 1
        FROM public.inventarios_possuem_instancias_item ipii 
        WHERE ipii.id_instancias_de_item = ii.id
    );
    

    RAISE NOTICE 'Uma lua de sangue está ocorrendo. Monstros que foram derrotados voltam para vingar sua morte. Itens que já foram coletados podem ser encontrados novamente';

END;
$$;

--===============================================================================
--        7. STORED PROCEDURE PARA VASCULHAR A SALA EM BUSCA DE ITENS 
--===============================================================================

CREATE FUNCTION public.sp_vasculhar_local(
    p_local_id public.id_local
)
RETURNS TABLE (
    instancia_item_id public.id_instancia_de_item,
    durabilidade SMALLINT,
    durabilidade_total SMALLINT,
    item_base_id public.id_item,
    item_nome public.nome,
    item_descricao public.descricao,
    item_tipo public.tipo_item,
    item_valor SMALLINT
)
LANGUAGE plpgsql AS $$
BEGIN

    /*
    Pesquisa os itens presentes em uma sala fazendo uma junção das informações do item: informações
    básicas, presentes na tabela item, e informações da instância presente na tabela da instância,
    para garantir que somente os itens que estejam naquela sala apareçam é feito um 
    WHERE que pega o local que o jogador está, com esse id ele faz a seleção dos itens que estão
    neste id
    */

    RETURN QUERY
    SELECT
        iii.id AS instancia_item_id,
        iii.durabilidade,
        iii.durabilidade_total,
        it.id AS item_base_id,
        it.nome AS item_nome,
        it.descricao AS item_descricao,
        it.tipo AS item_tipo,
        it.valor AS item_valor
    FROM 
        public.instancias_de_itens iii
    JOIN
        public.itens it ON iii.id_item = it.id
    WHERE 
        iii.id_local = p_local_id;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ocorreu um erro ao vasculhar o local %: %', p_local_id, SQLERRM;
            RETURN;
END;
$$;

--===============================================================================
--        8. STORED PROCEDURE PARA ADICIONAR ITEM EM INVENTÁRIO
--===============================================================================

CREATE OR REPLACE FUNCTION public.sp_adicionar_item_ao_inventario(
    p_jogador_id public.id_personagem,
    p_instancia_item_id public.id_instancia_de_item
)
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario public.id_inventario;
    v_local_atual_item public.id_local;
BEGIN
    -- Verifica se o jogador existe e obtém o ID do inventário dele
    SELECT id_inventario INTO v_id_inventario
    FROM public.personagens_jogaveis
    WHERE id = p_jogador_id;

    IF v_id_inventario IS NULL THEN
        RAISE EXCEPTION 'Jogador com ID % nao encontrado ou nao possui inventario.', p_jogador_id;
    END IF;

    -- Verifica o local atual da instancia do item
    SELECT id_local INTO v_local_atual_item
    FROM public.instancias_de_itens
    WHERE id = p_instancia_item_id;

    IF v_local_atual_item IS NULL THEN
        -- O item ja foi pego ou nao esta em nenhum local
        RAISE NOTICE 'Item % ja foi pego ou nao esta em nenhum local.', p_instancia_item_id;
        RETURN FALSE;
    END IF;

    -- Inicia uma transação para garantir que ambas as operações sejam atômicas
    BEGIN
        -- 1. Remove o item do local (coloca o id_local do item como NULL)
        UPDATE public.instancias_de_itens
        SET id_local = NULL
        WHERE id = p_instancia_item_id;

        -- 2. Adiciona o item à tabela de junção inventarios_possuem_instancias_item
        INSERT INTO public.inventarios_possuem_instancias_item (id_instancias_de_item, id_inventario)
        VALUES (p_instancia_item_id, v_id_inventario);

        RETURN TRUE; -- Sucesso, o item foi adicionado ao inventário do jogador
    END;

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Item % ja esta no inventario do jogador %.', p_instancia_item_id, p_jogador_id;
        RETURN TRUE; -- Consideramos sucesso se já está no inventário
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao adicionar o item % ao inventario do jogador %: %', p_instancia_item_id, p_jogador_id, SQLERRM;
        RETURN FALSE; -- Falha
END;
$$;

--===============================================================================
--        9. STORED PROCEDURE PARA VER O INVENTÁRIO
--===============================================================================

CREATE OR REPLACE FUNCTION public.sp_ver_inventario(
    p_jogador_id public.id_personagem
)
RETURNS TABLE (
    instancia_item_id public.id_instancia_de_item,
    item_nome public.nome,
    item_descricao public.descricao,
    durabilidade SMALLINT,
    durabilidade_total SMALLINT,
    item_tipo public.tipo_item,
    item_valor SMALLINT,
    dano public.dano,
    qtd_dano_mitigado SMALLINT,
    qtd_atributo_recebe SMALLINT,
    tipo_atributo_recebe public.tipo_atributo_personagem,
    esta_equipado BOOLEAN 
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario public.id_inventario;
BEGIN
    SELECT id_inventario INTO v_id_inventario
    FROM public.personagens_jogaveis
    WHERE id = p_jogador_id;

    IF v_id_inventario IS NULL THEN
        RAISE NOTICE 'Jogador com ID % nao encontrado ou nao possui um inventario associado.', p_jogador_id;
        RETURN;
    END IF;

    RETURN QUERY
    SELECT
        ipii.id_instancias_de_item,
        it.nome,
        it.descricao,
        iii.durabilidade,
        iii.durabilidade_total,
        it.tipo,
        it.valor,
        a.dano,
        ar.qtd_dano_mitigado, 
        ar.qtd_atributo_recebe,
        ar.tipo_atributo_recebe,
        -- Lógica para verificar se o item está equipado
        CASE
            WHEN ipii.id_instancias_de_item = (SELECT pj.id_arma FROM public.personagens_jogaveis pj WHERE pj.id = p_jogador_id)
              OR ipii.id_instancias_de_item = (SELECT pj.id_armadura FROM public.personagens_jogaveis pj WHERE pj.id = p_jogador_id)
            THEN TRUE
            ELSE FALSE
        END AS esta_equipado
    FROM
        public.inventarios_possuem_instancias_item ipii
    JOIN
        public.instancias_de_itens iii ON ipii.id_instancias_de_item = iii.id
    JOIN
        public.itens it ON iii.id_item = it.id
    LEFT JOIN
        public.armas a ON it.id = a.id
    LEFT JOIN
        public.armaduras ar ON it.id = ar.id
    WHERE
        ipii.id_inventario = v_id_inventario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao verificar o inventario do jogador %: %', p_jogador_id, SQLERRM;
        RETURN;
END;
$$;

--===============================================================================
--        10. STORED PROCEDURE PARA ENCONTRAR MONSTROS NO LOCAL
--===============================================================================

CREATE OR REPLACE FUNCTION public.sp_encontrar_monstros_no_local(
    p_local_id public.id_local
)
RETURNS TABLE (
    instancia_monstro_id public.id_instancia_de_monstro,
    monstro_base_id public.id_monstro,
    monstro_nome public.nome,
    monstro_descricao public.descricao,
    monstro_tipo public.tipo_monstro,
    vida_atual SMALLINT,
    vida_total SMALLINT,
    defesa SMALLINT
    -- Mais atributos do monstro podem ser adicionados caso necessario
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Retorna todas as instâncias de monstros que estão atualmente no local especificado com uma consulta
    RETURN QUERY
    SELECT
        im.id AS instancia_monstro_id,
        im.id_monstro AS monstro_base_id,
        COALESCE(a.nome, p.nome) AS monstro_nome,
        COALESCE(a.descricao, p.descricao) AS monstro_descricao,
        tm.tipo AS monstro_tipo,
        im.vida AS vida_atual,
        COALESCE(a.vida_total, p.vida_total) AS vida_total,
        COALESCE(a.defesa, p.defesa) AS defesa
    FROM
        public.instancias_monstros im
    JOIN
        public.tipos_monstro tm ON im.id_monstro = tm.id
    LEFT JOIN
        public.agressivos a ON im.id_monstro = a.id AND tm.tipo = 'agressivo'
    LEFT JOIN
        public.pacificos p ON im.id_monstro = p.id AND tm.tipo = 'pacífico'
    WHERE
        im.id_local = p_local_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao encontrar monstros no local %: %', p_local_id, SQLERRM;
        RETURN; -- Retorna um conjunto vazio em caso de erro
END;
$$;

--===============================================================================
--        11. STORED PROCEDURE PARA MATAR TODOS OS MONSTROS DO LOCAL
--===============================================================================

-- Somente para testes do banco

CREATE OR REPLACE FUNCTION public.sp_matar_monstros_no_local(
    p_local_id public.id_local
)
RETURNS INTEGER -- Retorna o número de monstros "mortos"
LANGUAGE plpgsql AS $$
DECLARE
    v_monstros_mortos INTEGER := 0;
BEGIN
    -- Atualiza o id_local dos monstros para NULL e coloca a vida deles como 0
    UPDATE public.instancias_monstros im
    SET
        id_local = NULL, -- Remove da sala para que possam ser "respawnados" pela Lua de Sangue
        vida = 0
    WHERE im.id_local = p_local_id
    RETURNING 1 INTO v_monstros_mortos; -- Conta as linhas afetadas (monstros mortos)

    -- Se nenhum monstro foi encontrado, v_monstros_mortos sera 0, pois RETURNING 1 INTO
    -- incrementa a variavel para cada linha afetada.

    RAISE NOTICE 'Monstros no local % foram derrotados. Total: %', p_local_id, v_monstros_mortos;

    RETURN v_monstros_mortos;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao tentar matar monstros no local %: %', p_local_id, SQLERRM;
        RETURN -1; -- Retorna -1 para indicar um erro
END;
$$;

/*
=================================================================================
        12. LÓGICA PARA BATALHAS
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--  STORED PROCEDURE: Executa uma batalha completa entre um jogador e um monstro.
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_executar_batalha(
    p_id_jogador public.id_personagem_jogavel,
    p_id_instancia_monstro public.id_instancia_de_monstro
)
RETURNS TEXT -- Retorna uma mensagem com o resultado da batalha
LANGUAGE plpgsql AS $$
DECLARE
    -- Variáveis para os status do Jogador
    v_vida_jogador SMALLINT;
    v_dano_jogador SMALLINT;
    v_defesa_jogador SMALLINT;
    v_id_inventario public.id_inventario;

    -- Variáveis para os status do Monstro
    v_id_monstro_base public.id_monstro;
    v_vida_monstro SMALLINT;
    v_dano_monstro SMALLINT;
    v_defesa_monstro SMALLINT;
    v_nome_monstro public.nome;
    v_item_drop_id public.id_instancia_de_item;

    -- Variável de resultado
    v_resultado TEXT;
BEGIN
    -- 1. BUSCAR DADOS DO JOGADOR
    SELECT
        pj.pontos_de_vida_atual,
        COALESCE(a.dano, 1), 
        COALESCE(ar.qtd_dano_mitigado, 0),
        pj.id_inventario
    INTO
        v_vida_jogador, v_dano_jogador, v_defesa_jogador, v_id_inventario
    FROM public.personagens_jogaveis pj
    LEFT JOIN public.instancias_de_itens ii_arma ON pj.id_arma = ii_arma.id
    LEFT JOIN public.armas a ON ii_arma.id_item = a.id
    LEFT JOIN public.instancias_de_itens ii_armadura ON pj.id_armadura = ii_armadura.id
    LEFT JOIN public.armaduras ar ON ii_armadura.id_item = ar.id
    WHERE pj.id = p_id_jogador;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Jogador com ID % não encontrado.', p_id_jogador;
    END IF;

    -- 2. BUSCAR DADOS DO MONSTRO
    -- CORREÇÃO: A query agora busca im.vida para obter a vida atual da instância.
    SELECT
        im.id_monstro,
        im.id_instancia_de_item,
        COALESCE(ag.nome, pa.nome),
        im.vida, 
        ag.dano,
        COALESCE(ag.defesa, pa.defesa, 0)
    INTO
        v_id_monstro_base, v_item_drop_id, v_nome_monstro, v_vida_monstro, v_dano_monstro, v_defesa_monstro
    FROM public.instancias_monstros im
    JOIN public.tipos_monstro tm ON im.id_monstro = tm.id
    LEFT JOIN public.agressivos ag ON im.id_monstro = ag.id AND tm.tipo = 'agressivo'
    LEFT JOIN public.pacificos pa ON im.id_monstro = pa.id AND tm.tipo = 'pacífico'
    WHERE im.id = p_id_instancia_monstro AND tm.tipo = 'agressivo';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Instância de monstro agressivo com ID % não encontrada.', p_id_instancia_monstro;
    END IF;

    RAISE NOTICE 'Batalha iniciada! Jogador (Vida: %) vs % (Vida: %)', v_vida_jogador, v_nome_monstro, v_vida_monstro;

    -- 3. LOOP DE COMBATE
    WHILE v_vida_jogador > 0 AND v_vida_monstro > 0 LOOP
        v_vida_monstro := v_vida_monstro - GREATEST(1, v_dano_jogador - v_defesa_monstro);
        RAISE NOTICE 'Jogador ataca! Vida do monstro: %', v_vida_monstro;
        IF v_vida_monstro <= 0 THEN EXIT; END IF;

        v_vida_jogador := v_vida_jogador - GREATEST(1, v_dano_monstro - v_defesa_jogador);
        RAISE NOTICE 'Monstro ataca! Vida do jogador: %', v_vida_jogador;
    END LOOP;

    -- 4. DETERMINAR RESULTADO
    IF v_vida_monstro <= 0 THEN
        v_resultado := 'VITÓRIA! O monstro ' || v_nome_monstro || ' foi derrotado.';
        RAISE NOTICE '%', v_resultado;
        UPDATE public.instancias_monstros SET id_local = NULL, vida = 0 WHERE id = p_id_instancia_monstro;

        IF v_item_drop_id IS NOT NULL THEN
            INSERT INTO public.inventarios_possuem_instancias_item (id_instancias_de_item, id_inventario) VALUES (v_item_drop_id, v_id_inventario) ON CONFLICT DO NOTHING;
            UPDATE public.instancias_de_itens SET id_local = NULL WHERE id = v_item_drop_id;
            v_resultado := v_resultado || ' Você recebeu um item como recompensa!';
            RAISE NOTICE 'O jogador recebeu o item de ID %.', v_item_drop_id;
        END IF;

    ELSE
        v_resultado := 'DERROTA! Você foi vencido pelo ' || v_nome_monstro || '.';
        RAISE NOTICE '%', v_resultado;
        UPDATE public.personagens_jogaveis SET pontos_de_vida_atual = 0 WHERE id = p_id_jogador;
    END IF;

    RETURN v_resultado;
END;
$$;


/*
=================================================================================
        13. LÓGICA PARA CONCLUSÃO DE MISSÕES
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--  STORED PROCEDURE: Finaliza uma missão e entrega a recompensa ao jogador.
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_entregar_missao(
    p_id_jogador public.id_personagem_jogavel,
    p_id_missao public.id_missao
)
RETURNS TEXT -- Retorna uma mensagem de sucesso
LANGUAGE plpgsql AS $$
DECLARE
    v_id_recompensa public.id_instancia_de_item;
    v_nome_recompensa public.nome;
    v_id_inventario public.id_inventario;
    v_id_npc_missao public.id_personagem_npc;
BEGIN
    -- 1. VERIFICAR SE A MISSÃO EXISTE E OBTER O NPC ASSOCIADO
    SELECT id_npc INTO v_id_npc_missao FROM public.missoes WHERE id = p_id_missao;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Missão com ID % não encontrada.', p_id_missao;
    END IF;

    -- 2. ENCONTRAR O ITEM DE RECOMPENSA PARA A MISSÃO
    SELECT ii.id, i.nome
    INTO v_id_recompensa, v_nome_recompensa
    FROM public.instancias_de_itens ii
    JOIN public.itens i ON ii.id_item = i.id
    WHERE ii.id_missao_recompensa = p_id_missao;

    -- 3. SE HOUVER RECOMPENSA, ADICIONAR AO INVENTÁRIO DO JOGADOR
    IF FOUND THEN
        -- Obter o inventário do jogador
        SELECT id_inventario INTO v_id_inventario FROM public.personagens_jogaveis WHERE id = p_id_jogador;

        -- Adicionar o item de recompensa à tabela de junção do inventário
        INSERT INTO public.inventarios_possuem_instancias_item (id_instancias_de_item, id_inventario)
        VALUES (v_id_recompensa, v_id_inventario);

        -- Remover o item do mapa e desassociar da missão (para não ser pego de novo)
        UPDATE public.instancias_de_itens
        SET id_local = NULL, id_missao_recompensa = NULL
        WHERE id = v_id_recompensa;

        RAISE NOTICE 'O jogador % completou a missão % e recebeu a recompensa: %.', p_id_jogador, p_id_missao, v_nome_recompensa;
    ELSE
        RAISE NOTICE 'O jogador % completou a missão %, mas não havia recompensa em item associada.', p_id_jogador, p_id_missao;
    END IF;

    -- 4. REGISTRAR A CONCLUSÃO DA MISSÃO NA TABELA 'entregas_missoes'
    -- Isso previne que a mesma missão seja entregue novamente.
    INSERT INTO public.entregas_missoes (id_jogador, id_npc)
    VALUES (p_id_jogador, v_id_npc_missao)
    ON CONFLICT (id_jogador, id_npc) DO NOTHING; -- Não faz nada se o jogador já entregou uma missão para este NPC

    RETURN 'Missão concluída com sucesso!';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao entregar a missão: %', SQLERRM;
        RAISE;
END;
$$;

/*
=================================================================================
        14. LÓGICA PARA AÇÕES DO JOGADOR E MANUTENÇÃO DO JOGO
=================================================================================
*/
-- ---------------------------------------------------------------------------------
--  14.1 STORED PROCEDURE: Mover o jogador para um novo local
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_mover_jogador(
    p_id_jogador public.id_personagem_jogavel,
    p_id_novo_local public.id_local
)
RETURNS TEXT -- Retorna uma mensagem de confirmação
LANGUAGE plpgsql AS $$
DECLARE
    v_local_atual public.id_local;
    v_pode_mover BOOLEAN := FALSE;
BEGIN
    -- 1. Verifica a localização atual do jogador
    SELECT id_local INTO v_local_atual FROM public.personagens_jogaveis WHERE id = p_id_jogador;

    IF v_local_atual IS NULL THEN
        RAISE EXCEPTION 'Jogador % não está em um local válido.', p_id_jogador;
    END IF;

    -- 2. Verifica se o novo local é adjacente ao local atual
    SELECT TRUE INTO v_pode_mover
    FROM public.local
    WHERE id = v_local_atual AND p_id_novo_local IN (
        local_norte, local_sul, local_leste, local_oeste,
        local_nordeste, local_noroeste, local_sudeste, local_sudoeste,
        local_cima, local_baixo
    );

    IF v_pode_mover IS NOT TRUE THEN
        RAISE EXCEPTION 'Movimento inválido. O local % não é adjacente ao local atual %.', p_id_novo_local, v_local_atual;
    END IF;

    -- 3. Atualiza a localização do jogador
    UPDATE public.personagens_jogaveis
    SET id_local = p_id_novo_local
    WHERE id = p_id_jogador;

    RETURN 'Jogador movido para o local ' || p_id_novo_local || '.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao mover o jogador: %', SQLERRM;
        RAISE;
END;
$$;

-- ---------------------------------------------------------------------------------
--  14.2 STORED PROCEDURE: Desequipar uma arma ou armadura
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_desequipar_item(
    p_id_jogador public.id_personagem_jogavel,
    p_tipo_slot public.tipo_item -- 'arma' ou 'armadura'
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_id_instancia_item public.id_instancia_de_item;
    v_armadura_info RECORD;
    v_update_query TEXT;
BEGIN
    -- 1. Identifica qual item está no slot especificado
    IF p_tipo_slot = 'armadura' THEN
        SELECT id_armadura INTO v_id_instancia_item FROM public.personagens_jogaveis WHERE id = p_id_jogador;
    ELSIF p_tipo_slot = 'arma' THEN
        SELECT id_arma INTO v_id_instancia_item FROM public.personagens_jogaveis WHERE id = p_id_jogador;
    ELSE
        RAISE EXCEPTION 'Tipo de slot inválido: %. Use ''arma'' ou ''armadura''.', p_tipo_slot;
    END IF;

    -- 2. Se não houver item no slot, não faz nada
    IF v_id_instancia_item IS NULL THEN
        RETURN 'Nenhum item do tipo ' || p_tipo_slot || ' para desequipar.';
    END IF;

    -- 3. Se for uma armadura, reverte o bônus de atributo
    IF p_tipo_slot = 'armadura' THEN
        -- Busca as informações da armadura para saber qual atributo reverter
        SELECT ar.qtd_atributo_recebe, ar.tipo_atributo_recebe
        INTO v_armadura_info
        FROM public.armaduras ar
        JOIN public.instancias_de_itens ii ON ar.id = ii.id_item
        WHERE ii.id = v_id_instancia_item;

        -- Se a armadura concede um bônus, constrói e executa o UPDATE para removê-lo
        IF v_armadura_info.qtd_atributo_recebe IS NOT NULL AND v_armadura_info.tipo_atributo_recebe IS NOT NULL THEN
            v_update_query := format(
                'UPDATE public.personagens_jogaveis SET %I = %I - %s WHERE id = %s',
                v_armadura_info.tipo_atributo_recebe, -- Nome da coluna do atributo
                v_armadura_info.tipo_atributo_recebe, -- Nome da coluna novamente
                v_armadura_info.qtd_atributo_recebe,  -- Valor a subtrair
                p_id_jogador                          -- ID do jogador
            );
            EXECUTE v_update_query;
        END IF;
    END IF;

    -- 4. Limpa o slot do item na tabela do jogador
    IF p_tipo_slot = 'armadura' THEN
        UPDATE public.personagens_jogaveis SET id_armadura = NULL WHERE id = p_id_jogador;
    ELSIF p_tipo_slot = 'arma' THEN
        UPDATE public.personagens_jogaveis SET id_arma = NULL WHERE id = p_id_jogador;
    END IF;

    RETURN 'Item ' || p_tipo_slot || ' desequipado com sucesso.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao desequipar o item: %', SQLERRM;
        RAISE;
END;
$$;


-- ---------------------------------------------------------------------------------
--  14.3 STORED PROCEDURE: Equipar uma arma ou armadura
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_equipar_item(
    p_id_jogador public.id_personagem_jogavel,
    p_id_instancia_item public.id_instancia_de_item
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_item_info RECORD;
    v_id_inventario public.id_inventario;
    v_update_query TEXT;
BEGIN
    -- 1. Verifica se o item está no inventário do jogador
    SELECT pj.id_inventario INTO v_id_inventario FROM public.personagens_jogaveis pj WHERE pj.id = p_id_jogador;
    IF NOT EXISTS (
        SELECT 1 FROM public.inventarios_possuem_instancias_item
        WHERE id_inventario = v_id_inventario AND id_instancias_de_item = p_id_instancia_item
    ) THEN
        RAISE EXCEPTION 'O item % não está no inventário do jogador.', p_id_instancia_item;
    END IF;

    -- 2. Descobre o tipo do item e suas propriedades
    SELECT i.id, i.tipo, ar.qtd_atributo_recebe, ar.tipo_atributo_recebe
    INTO v_item_info
    FROM public.instancias_de_itens ii
    JOIN public.itens i ON ii.id_item = i.id
    LEFT JOIN public.armaduras ar ON i.id = ar.id 
    WHERE ii.id = p_id_instancia_item;

    -- 3. Desequipa qualquer item que já esteja no slot correspondente
    IF v_item_info.tipo = 'arma' THEN
        PERFORM public.sp_desequipar_item(p_id_jogador, 'arma');
    ELSIF v_item_info.tipo = 'armadura' THEN
        PERFORM public.sp_desequipar_item(p_id_jogador, 'armadura');
    ELSE
        RAISE EXCEPTION 'O item % não é um equipamento (arma ou armadura).', p_id_instancia_item;
    END IF;

    -- 4. Aplica os bônus do novo item (se for uma armadura com bônus)
    IF v_item_info.tipo = 'armadura' AND v_item_info.qtd_atributo_recebe IS NOT NULL AND v_item_info.tipo_atributo_recebe IS NOT NULL THEN
        v_update_query := format(
            'UPDATE public.personagens_jogaveis SET %I = %I + %s WHERE id = %s',
            v_item_info.tipo_atributo_recebe, -- Nome da coluna
            v_item_info.tipo_atributo_recebe, -- Nome da coluna novamente
            v_item_info.qtd_atributo_recebe,  -- Valor a adicionar
            p_id_jogador                      -- ID do jogador
        );
        EXECUTE v_update_query;
    END IF;

    -- 5. Equipa o novo item no slot correspondente
    IF v_item_info.tipo = 'arma' THEN
        UPDATE public.personagens_jogaveis SET id_arma = p_id_instancia_item WHERE id = p_id_jogador;
        RETURN 'Arma equipada com sucesso.';
    ELSIF v_item_info.tipo = 'armadura' THEN
        UPDATE public.personagens_jogaveis SET id_armadura = p_id_instancia_item WHERE id = p_id_jogador;
        RETURN 'Armadura equipada com sucesso.';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao equipar o item: %', SQLERRM;
        RAISE;
END;
$$;


-- ---------------------------------------------------------------------------------
--  14.4 STORED PROCEDURE: Usar um item de cura
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_usar_item_cura(
    p_id_jogador public.id_personagem_jogavel,
    p_id_instancia_item public.id_instancia_de_item
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_item_cura RECORD;
    v_jogador RECORD;
    v_vida_max SMALLINT;
    v_sanidade_max SMALLINT;
BEGIN
    -- 1. Verifica se o item é de cura e está no inventário do jogador
    SELECT c.* INTO v_item_cura
    FROM public.curas c
    JOIN public.instancias_de_itens ii ON c.id = ii.id_item
    JOIN public.inventarios_possuem_instancias_item ipi ON ii.id = ipi.id_instancias_de_item
    JOIN public.personagens_jogaveis pj ON ipi.id_inventario = pj.id_inventario
    WHERE pj.id = p_id_jogador AND ii.id = p_id_instancia_item;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'O item de cura % não foi encontrado no inventário do jogador %.', p_id_instancia_item, p_id_jogador;
    END IF;

    -- 2. Aplica os efeitos de cura
    SELECT *, public.calcular_pts_de_vida(constituicao, tamanho) as vida_max, public.calcular_sanidade(poder) as sanidade_max
    INTO v_jogador
    FROM public.personagens_jogaveis WHERE id = p_id_jogador;

    UPDATE public.personagens_jogaveis
    SET
        pontos_de_vida_atual = LEAST(v_jogador.vida_max, pontos_de_vida_atual + v_item_cura.qtd_pontos_vida_recupera),
        sanidade_atual = LEAST(v_jogador.sanidade_max, sanidade_atual + v_item_cura.qtd_pontos_sanidade_recupera)
    WHERE id = p_id_jogador;

    -- 3. Consome um uso do item
    UPDATE public.curas SET qts_usos = qts_usos - 1 WHERE id = v_item_cura.id;

    RETURN 'Você usou ' || (SELECT nome FROM public.itens WHERE id = v_item_cura.id) || ' e se sente melhor.';
END;
$$;

-- ---------------------------------------------------------------------------------
--  14.5 TRIGGER: Gerencia a durabilidade e quebra de itens
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_gerenciar_durabilidade_item()
RETURNS TRIGGER AS $$
BEGIN
    -- Se a durabilidade de um item chegar a 0 ou menos, ele "quebra".
    IF NEW.durabilidade <= 0 THEN
        RAISE NOTICE 'ATENÇÃO: O item de ID % quebrou!', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para armas
CREATE TRIGGER trigger_checar_durabilidade_arma
    BEFORE UPDATE ON public.armas
    FOR EACH ROW
    WHEN (OLD.durabilidade IS DISTINCT FROM NEW.durabilidade)
    EXECUTE FUNCTION public.func_gerenciar_durabilidade_item();

-- Trigger para armaduras
CREATE TRIGGER trigger_checar_durabilidade_armadura
    BEFORE UPDATE ON public.armaduras
    FOR EACH ROW
    WHEN (OLD.durabilidade IS DISTINCT FROM NEW.durabilidade)
    EXECUTE FUNCTION public.func_gerenciar_durabilidade_item();

-- Trigger para itens de cura (usos)
CREATE TRIGGER trigger_checar_usos_cura
    BEFORE UPDATE ON public.curas
    FOR EACH ROW
    WHEN (OLD.qts_usos IS DISTINCT FROM NEW.qts_usos)
    EXECUTE FUNCTION public.func_gerenciar_durabilidade_item(); -- Reutilizando a lógica para usos

-- ROLLBACK;
/*
ARQUIVO: triggers-stored_procedures.sql

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
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_monstros ON public.monstros CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_agressivos ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_pacificos ON public.pacificos CASCADE;

-- Triggers de missões
DROP TRIGGER IF EXISTS trigger_validar_dados_missao ON public.missoes CASCADE;

-- Triggers de itens
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens ON public.itens CASCADE;

-- Triggers de feitiços
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_feiticos ON public.feiticos CASCADE;

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

CREATE FUNCTION public.sp_criar_armadura(
    p_nome public.nome,
    p_descricao public.descricao,
    p_valor SMALLINT,

    -- Parâmetros específicos de armadura
    p_atributo_necessario public.tipo_atributo_personagem,
    p_durabilidade SMALLINT DEFAULT NULL,
    p_funcao funcao_armadura DEFAULT NULL,
    p_qtd_atributo_recebe SMALLINT DEFAULT NULL,
    p_qtd_atributo_necessario SMALLINT DEFAULT NULL,
    p_tipo_atributo_recebe public.tipo_atributo_personagem DEFAULT NULL,
    p_qtd_dano_mitigado SMALLINT DEFAULT NULL
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
    INSERT INTO public.armaduras (id, atributo_necessario, qtd_atributo_necessario, durabilidade, funcao, alcance, tipo_municao, tipo_dano, dano, id_pericia_necessaria)
        VALUES (v_novo_item_id, p_atributo_necessario, p_durabilidade, p_funcao , p_qtd_atributo_recebe, p_qtd_atributo_necessario, p_tipo_atributo_recebe, p_qtd_dano_mitigado, v_pericia_id);

    RETURN v_novo_item_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação da arma: %', SQLERRM;
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

-- =================================================================================
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
    item_valor SMALLINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario public.id_inventario;
BEGIN
    -- Primeiro, é obtido o ID do inventário do jogador
    SELECT id_inventario INTO v_id_inventario
    FROM public.personagens_jogaveis
    WHERE id = p_jogador_id;

    -- Se o jogador não tiver um inventário (o que não deve acontecer se a criação for bem feita),
    -- ou se o ID do jogador for inválido, podemos levantar uma exceção ou retornar vazio.
    IF v_id_inventario IS NULL THEN
        RAISE NOTICE 'Jogador com ID % nao encontrado ou nao possui um inventario associado.', p_jogador_id;
        RETURN; -- Retorna um conjunto vazio
    END IF;

    -- Retorna os detalhes de todos os itens associados a este inventário a partir de uma consulta
    RETURN QUERY
    SELECT
        ipii.id_instancias_de_item AS instancia_item_id,
        it.nome AS item_nome,
        it.descricao AS item_descricao,
        iii.durabilidade,
        iii.durabilidade_total,
        it.tipo AS item_tipo,
        it.valor AS item_valor
    FROM
        public.inventarios_possuem_instancias_item ipii
    JOIN
        public.instancias_de_itens iii ON ipii.id_instancias_de_item = iii.id
    JOIN
        public.itens it ON iii.id_item = it.id
    WHERE
        ipii.id_inventario = v_id_inventario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao verificar o inventario do jogador %: %', p_jogador_id, SQLERRM;
        RETURN; -- Retorna um conjunto vazio em caso de erro
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
        m.id AS monstro_base_id,
        m.nome AS monstro_nome,
        m.descricao AS monstro_descricao,
        m.tipo AS monstro_tipo,
        im.vida AS vida_atual, -- <--- Coluna 'vida' da instância do monstro
        COALESCE(a.vida_total, p.vida_total) AS vida_total, -- Vida total base do tipo de monstro
        COALESCE(a.defesa, p.defesa) AS defesa
    FROM
        public.instancias_monstros im
    JOIN
        public.monstros m ON im.id_monstro = m.id
    LEFT JOIN
        public.agressivos a ON m.id = a.id AND m.tipo = 'agressivo'
    LEFT JOIN
        public.pacificos p ON m.id = p.id AND m.tipo = 'pacifico'
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
        vida = COALESCE(
            (SELECT a.vida_total FROM public.agressivos a WHERE a.id = im.id_monstro),
            (SELECT p.vida_total FROM public.pacificos p WHERE p.id = im.id_monstro)
        )
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

--===============================================================================
--        12. STORED PROCEDURE PARA COMBATE (PERSONAGEM ATACA MONSTRO)
--===============================================================================

CREATE OR REPLACE FUNCTION public.sp_personagem_ataca_monstro(
    p_id_jogador public.id_personagem_jogavel,
    p_id_instancia_monstro public.id_instancia_de_monstro
)
RETURNS TABLE (
    dano_causado SMALLINT,
    vida_restante_monstro SMALLINT,
    monstro_derrotado BOOLEAN,
    mensagem TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_dano_arma SMALLINT;
    v_vida_atual_monstro SMALLINT;
    v_nova_vida_monstro SMALLINT;
    v_monstro_local_id public.id_local;
BEGIN
    -- PASSO 1: Verificar se o monstro e o jogador existem e se o monstro está vivo.
    SELECT im.vida, im.id_local INTO v_vida_atual_monstro, v_monstro_local_id
    FROM public.instancias_monstros im
    WHERE im.id = p_id_instancia_monstro;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 0::SMALLINT, 0::SMALLINT, FALSE, 'Monstro não encontrado.'::TEXT;
        RETURN;
    END IF;

    IF v_monstro_local_id IS NULL THEN
        RETURN QUERY SELECT 0::SMALLINT, v_vida_atual_monstro, TRUE, 'Este monstro já foi derrotado.'::TEXT;
        RETURN;
    END IF;

    -- PASSO 2: Calcular o dano do jogador.
    -- Tenta pegar o dano da arma equipada. Se não houver, usa um dano base de soco (ex: 1).
    SELECT a.dano INTO v_dano_arma
    FROM public.personagens_jogaveis pj
    JOIN public.instancias_de_itens ii ON pj.id_arma = ii.id
    JOIN public.armas a ON ii.id_item = a.id
    WHERE pj.id = p_id_jogador;

    v_dano_arma := COALESCE(v_dano_arma, 1); -- Se não tiver arma, o dano é 1.

    -- PASSO 3: Aplicar o dano e atualizar a vida do monstro.
    v_nova_vida_monstro := v_vida_atual_monstro - v_dano_arma;

    IF v_nova_vida_monstro <= 0 THEN
        -- Monstro foi derrotado.
        UPDATE public.instancias_monstros
        SET vida = 0, id_local = NULL -- Remove o monstro do local, marcando-o como "morto".
        WHERE id = p_id_instancia_monstro;

        RETURN QUERY SELECT v_dano_arma, 0::SMALLINT, TRUE, 'Golpe final! O monstro foi derrotado!'::TEXT;
    ELSE
        -- Monstro sobreviveu.
        UPDATE public.instancias_monstros
        SET vida = v_nova_vida_monstro
        WHERE id = p_id_instancia_monstro;

        RETURN QUERY SELECT v_dano_arma, v_nova_vida_monstro, FALSE, 'Você ataca a criatura!'::TEXT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro durante o combate: %', SQLERRM;
        RETURN QUERY SELECT 0::SMALLINT, 0::SMALLINT, FALSE, 'Erro inesperado no combate.'::TEXT;
END;
$$;

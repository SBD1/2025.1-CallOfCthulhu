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

*/

-- =================================================================================
--         1. DROP TRIGGER E DROP FUNCTIONS
-- Para que a criação de triggers e funções não gere erros, é necessário remover as existentes
-- =================================================================================

-- ======== DROP DE TRIGGERS ========
-- Triggers de personagens e NPCs
DROP TRIGGER IF EXISTS trigger_valida_unicidade_personagem_jogavel ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_unicidade_npc ON public.npcs CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_ajustar_atributos_personagem ON public.personagens_jogaveis CASCADE;

-- Triggers de monstros agressivos e pacíficos
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_agressivo ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_pacifico ON public.pacificos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_atributos_agressivo ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_atributos_pacifico ON public.pacificos CASCADE;

-- ======== DROP DE FUNÇÕES ========
-- Funções de Generalização/Especialização
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pj() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_npc() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_agressivo() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pacifico() CASCADE;

-- Funções de Personagem Jogável
DROP FUNCTION IF EXISTS public.func_validar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.func_ajustar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_personagem(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;

-- Funções de monstros agressivos e pacíficos
DROP FUNCTION IF EXISTS public.func_valida_atributos_monstro_agressivo() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_atributos_monstro_pacifico() CASCADE;


-- =================================================================================
--         2. REGRAS DE PERSONAGENS (GERAL)
-- Lógica de Generalização e Especialização para garantir a exclusividade
-- =================================================================================

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Garante que um PJ não possa ser um NPC
-------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_pj()
RETURNS TRIGGER AS $func_valida_exclusividade_id_pj$
BEGIN
    -- Verifica se o ID que está sendo inserido/atualizado em 'personagens_jogaveis' já existe na tabela 'npcs'. 
    PERFORM 1 FROM public.npcs WHERE id = NEW.id;

    IF FOUND THEN
        -- Caso id já exista, gera um erro.
        RAISE EXCEPTION 'O ID % já existe na tabela de NPCs. Um personagem não pode ser Jogável e NPC.', NEW.id;
    END IF;

    -- Se a verificação passar, retorna a tupla para continuar a operação de INSERT ou UPDATE.
    RETURN NEW;
END;
$func_valida_exclusividade_id_pj$ LANGUAGE plpgsql;

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Garante que um NPC não possa ser um PJ
-------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_npc()
RETURNS TRIGGER AS $func_valida_exclusividade_id_npc$
BEGIN
    -- Verifica se o ID que está sendo inserido/atualizado em 'npcs' já existe na tabela 'personagens_jogaveis'. 
    PERFORM 1 FROM public.personagens_jogaveis WHERE id = NEW.id;

    IF FOUND THEN
        -- Caso id já exista, gera um erro.
        RAISE EXCEPTION 'O ID % já existe na tabela de Personagens Jogáveis. Um NPC não pode ser NPC e Jogável.', NEW.id;
    END IF;

    -- Se a verificação passar, retorna a tupla para continuar a operação de INSERT ou UPDATE.
    RETURN NEW;
END;
$func_valida_exclusividade_id_npc$ LANGUAGE plpgsql;


-- =================================================================================
--         2.1. REGRAS E PROCEDIMENTOS DE PERSONAGENS JOGÁVEIS (PJ)
-- =================================================================================

-- ---------------------------------------------------------------------------------
--         2.1.1 FUNÇÕES DE TRIGGER PARA M.A.
-- ---------------------------------------------------------------------------------

-------------------------------------------------------------
-- Valida os dados de entrada de um novo PJ
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

-------------------------------------------------------------
-- Ajusta atributos calculados de um novo PJ
-- Calcula e define os valores derivados
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
    
    -- Cálculo de Sanidade, Vida e PM iniciais, usa funções do DDL auxiliares.
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


-- ---------------------------------------------------------------------------------
--         2.1.2 STORED PROCEDURE PARA CRIAÇÃO DE PJs
-- ---------------------------------------------------------------------------------

/*
    Aqui utilizamos 'p' como parametro advindos da interface, e 'v' como variável utilizada somente no escopo da função.
*/
CREATE OR REPLACE FUNCTION public.sp_criar_personagem(
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
    -- Cria o inventário.
    INSERT INTO public.inventarios (tamanho) VALUES (32) RETURNING id INTO v_novo_inventario_id;

    -- Insere dados básicos. O resto é feito pelo DEFAULT e pelo TRIGGER.
    INSERT INTO public.personagens_jogaveis (
        nome, ocupacao, residencia, local_nascimento, idade, sexo,
        id_inventario, id_sala -- Valores iniciais de localização
    ) VALUES (
        p_nome, p_ocupacao, p_residencia, p_local_nascimento, p_idade, p_sexo,
        v_novo_inventario_id, 40300002 -- Sala inicial padrão
    ) RETURNING id INTO v_novo_personagem_id;

    RETURN v_novo_personagem_id;

END;
$$ LANGUAGE plpgsql;


-- =================================================================================
--         2.2. REGRAS E PROCEDIMENTOS DE NPCs
-- =================================================================================

-- EM CONSTRUÇÃO 


-- =================================================================================
--         2.3. CRIAÇÃO DOS TRIGGERS
-- =================================================================================

-- ======== TRIGGERS DE PERSONAGENS (GERAL) ========

-- Executa a função de verificação de exclusividade em 'personagens_jogaveis'
CREATE TRIGGER trigger_valida_unicidade_personagem_jogavel
    BEFORE INSERT OR UPDATE ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_valida_exclusividade_id_pj();

-- Executa a função de verificação de exclusividade em 'npcs'
CREATE TRIGGER trigger_valida_unicidade_npc
    BEFORE INSERT OR UPDATE ON public.npcs
    FOR EACH ROW EXECUTE FUNCTION public.func_valida_exclusividade_id_npc();


-- ======== TRIGGERS DE PERSONAGENS JOGÁVEIS ========

-- Valida os dados de entrada de um novo personagem jogável
CREATE TRIGGER trigger_validar_atributos_personagem
    BEFORE INSERT ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_atributos_personagem();

-- Ajusta os atributos de um novo personagem jogável
CREATE TRIGGER trigger_ajustar_atributos_personagem
    BEFORE INSERT ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_ajustar_atributos_personagem();

/*
=================================================================================
        3. LÓGICA PARA MONSTROS
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--         3.1. REGRAS DE EXCLUSIVIDADE (AGRESSIVO vs. PACÍFICO) (T,E)
--         Garante que um monstro não possa ser dos dois tipos ao mesmo tempo
-- ---------------------------------------------------------------------------------

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Garante que um Monstro Agressivo não possa ser um Monstro Pacífico
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_valida_exclusividade_id_agressivo()
RETURNS TRIGGER AS $func_valida_exclusividade_id_agressivo$
BEGIN
    -- Verifica se o ID que está sendo inserido/atualizado em 'agressivos' já existe na tabela 'pacificos'.
    PERFORM 1 FROM public.pacificos WHERE id = NEW.id;
    IF FOUND THEN
        -- Caso id já exista, gera um erro.
        RAISE EXCEPTION 'O ID % já existe na tabela de Monstros Pacíficos. Um monstro não pode ser Agressivo e Pacífico ao mesmo tempo.', NEW.id;
    END IF;

    RETURN NEW;
END;
$func_valida_exclusividade_id_agressivo$ LANGUAGE plpgsql;

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Garante que um Monstro Pacífico não possa ser um Monstro Agressivo
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_valida_exclusividade_id_pacifico()
RETURNS TRIGGER AS $func_valida_exclusividade_id_pacifico$
BEGIN
    -- Verifica se o ID que está sendo inserido/atualizado em 'pacificos' já existe na tabela 'agressivos'.
    PERFORM 1 FROM public.agressivos WHERE id = NEW.id;
    IF FOUND THEN
        -- Caso id já exista, gera um erro.
        RAISE EXCEPTION 'O ID % já existe na tabela de Monstros Agressivos. Um monstro não pode ser Pacífico e Agressivo ao mesmo tempo.', NEW.id;
    END IF;
    RETURN NEW;
END;
$func_valida_exclusividade_id_pacifico$ LANGUAGE plpgsql;


-- ---------------------------------------------------------------------------------
--         3.2. REGRAS DE ATRIBUTOS PARA MONSTROS AGRESSIVOS
--         Valida se os atributos específicos correspondem ao subtipo do monstro
-- ---------------------------------------------------------------------------------

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Valida os atributos de um Monstro Agressivo com base no seu tipo.
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_valida_atributos_monstro_agressivo()
RETURNS TRIGGER AS $func_valida_atributos_monstro_agressivo$
BEGIN
    -- Validações gerais
    IF TRIM(NEW.nome) = '' OR TRIM(NEW.descricao) = '' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Nome e Descrição de um monstro agressivo não podem ser vazios.';
    END IF;
    IF NEW.defesa IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Defesa não pode ser nula para um monstro agressivo.';
    END IF;

    IF NEW.vida IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Vida não pode ser nula para um monstro agressivo.';
    END IF;

    IF NEW.catalisador_agressividade NOT IN ('proximidade', 'ataque_direto', 'barulho_alto', 'alvo_especifico', 'horario_noturno', 'ver_item_sagrado') THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: catalisador_agressividade inválido para monstro do tipo agressivo".';
    END IF;

    IF NEW.poder IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Poder não pode ser nulo para um monstro agressivo.';
    END IF;
    
    -- Validações específicas baseadas no subtipo
    IF NEW.tipo_agressivo = 'psiquico' THEN
        -- Monstros psíquicos DEVEM ter poder e causar loucura.
        IF NEW.loucura_induzida IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "psiquico" devem ter valor "loucura_induzida".';
        END IF;
    ELSIF NEW.tipo_agressivo = 'magico' THEN
        -- Monstros mágicos DEVEM ter poder e pontos de magia.
        IF NEW.ponto_magia IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "magico" devem ter valor "ponto_magia".';
        END IF;
    ELSIF NEW.tipo_agressivo = 'fisico' THEN
        -- Monstros físicos DEVEM ter atributos de força e velocidade de ataque.
        IF NEW.velocidade_ataque IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "fisico" devem ter valor "velocidade_ataque".';
        END IF;
    END IF;
    
    IF NEW.dano IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Dano não pode ser nulo para um monstro agressivo.';
    END IF;

    RETURN NEW;
END;
$func_valida_atributos_monstro_agressivo$ LANGUAGE plpgsql;


-- ---------------------------------------------------------------------------------
--         3.3. REGRAS DE ATRIBUTOS PARA MONSTROS PACÍFICOS
-- ---------------------------------------------------------------------------------

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Valida os atributos de um Monstro Pacífico.
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.func_valida_atributos_monstro_pacifico()
RETURNS TRIGGER AS $func_valida_atributos_monstro_pacifico$
BEGIN
    -- Validações gerais (não podem ser nulos ou vazios)
    IF TRIM(NEW.nome) = '' OR TRIM(NEW.descricao) = '' THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Nome e Descrição de um monstro pacífico não podem ser vazios.';
    END IF;

    IF NEW.defesa IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Defesa não pode ser nula para um monstro pacífico.';
    END IF;

    IF NEW.vida IS NULL THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Vida não pode ser nula para um monstro pacífico.';
    END IF;

    IF NEW.motivo_passividade NOT IN ('indiferente', 'medroso', 'amigavel', 'sob_controle_mental', 'adormecido', 'curioso') THEN
        RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: motivo_passividade inválido para monstro pacífico".';
    END IF;
    
    -- Validações específicas baseadas no subtipo
    IF NEW.tipo_pacifico = 'sobrenatural' THEN
        -- Monstros psíquicos DEVEM ter poder e causar loucura.
        IF NEW.conhecimento_proibido IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "psiquico" devem ter valor "conhecimento_proibido".';
        END IF;
    ELSIF NEW.tipo_pacifico = 'humanoide' THEN
        -- Monstros mágicos DEVEM ter poder e pontos de magia.
        IF NEW.conhecimento_geografico IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "humanoide" devem ter valor "conhecimento_geografico".';
        END IF;
    END IF;

    RETURN NEW;
END;
$func_valida_atributos_monstro_pacifico$ LANGUAGE plpgsql;



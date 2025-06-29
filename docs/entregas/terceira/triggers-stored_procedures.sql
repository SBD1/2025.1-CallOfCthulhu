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


*/
/*
-- =================================================================================
Comentário:
-- =================================================================================
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

-- ======== DROP DE FUNÇÕES ========
-- Funções de Generalização/Especialização
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pj() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_npc() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_agressivo() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pacifico() CASCADE;

-- Funções de Personagem Jogável
DROP FUNCTION IF EXISTS public.func_validar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.func_ajustar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_personagem(public.nome, public.ocupacao, public.residencia,
 public.local_nascimento, public.idade, public.sexo) CASCADE;

-- Funções de NPC
DROP FUNCTION IF EXISTS public.func_validar_atributos_npc() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_npc(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;


-- Funções de monstros agressivos e pacíficos
DROP FUNCTION IF EXISTS public.func_valida_atributos_monstro_agressivo() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_atributos_monstro_pacifico() CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_monstro() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_monstro(    
    public.nome,
    public.descricao,
    public.tipo_monstro,
    SMALLINT,
    SMALLINT,
    public.gatilho_agressividade,
    SMALLINT,
    public.tipo_monstro_agressivo,
    SMALLINT,
    SMALLINT,
    SMALLINT,
    public.dano,
    SMALLINT,
    SMALLINT,
    public.comportamento_pacifico,
    public.tipo_monstro_pacifico,
    CHARACTER(128),
    CHARACTER(128)
) CASCADE;

-- Funções de missões
DROP FUNCTION IF EXISTS public.func_validar_dados_missao() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_missao(public.nome, CHARACTER(512), public.tipo_missao, CHARACTER(128), public.id_personagem_npc) CASCADE;


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
CREATE FUNCTION public.func_validar_atributos_personagem()
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
CREATE FUNCTION public.func_ajustar_atributos_personagem()
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
CREATE FUNCTION public.sp_criar_personagem(
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

-------------------------------------------------------------
-- 2.2.1 FUNÇÃO DE TRIGGER: Valida os dados de entrada de um novo NPC
-------------------------------------------------------------

CREATE FUNCTION public.func_validar_atributos_npc() RETURNS TRIGGER AS $$
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

-------------------------------------------------------------
-- 2.2.2 STORED PROCEDURE: Criação de NPCs
-------------------------------------------------------------

CREATE FUNCTION public.sp_criar_npc(
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
    -- Insere os dados do NPC. NPCs não têm atributos calculados complexos nem inventário inicial.
    INSERT INTO public.npcs (
        nome, ocupacao, residencia, local_nascimento, idade, sexo,
        id_sala -- Localização inicial
    ) VALUES (
        p_nome, p_ocupacao, p_residencia, p_local_nascimento, p_idade, p_sexo,
        40300003 -- Sala inicial padrão para NPCs (exemplo)
    ) RETURNING id INTO v_novo_npc_id;

    RETURN v_novo_npc_id;
END;
$$ LANGUAGE plpgsql;

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

-- ======== TRIGGER DE NPCS (NOVO) ========
CREATE TRIGGER trigger_validar_atributos_npc
    BEFORE INSERT ON public.npcs
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_atributos_npc();

/*
=================================================================================
        3. LÓGICA PARA MONSTROS
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--         3.1. STORED PROCEDURE PARA CRIAÇÃO DE MONSTROS
--         Este SP é o único ponto de entrada e garante as regras Total, Exclusiva e de Atributos.
-- ---------------------------------------------------------------------------------

CREATE FUNCTION public.sp_criar_monstro(
    -- Parâmetros da tabela pai 'monstros'
    p_nome public.nome,
    p_descricao public.descricao,
    p_tipo public.tipo_monstro,

    -- Parâmetros para monstro agressivo (podem ser NULL)
    p_agressivo_defesa SMALLINT DEFAULT NULL,
    p_agressivo_vida SMALLINT DEFAULT NULL,
    p_agressivo_catalisador public.gatilho_agressividade DEFAULT NULL,
    p_agressivo_poder SMALLINT DEFAULT NULL,
    p_agressivo_tipo public.tipo_monstro_agressivo DEFAULT NULL,
    p_agressivo_velocidade SMALLINT DEFAULT NULL,
    p_agressivo_loucura SMALLINT DEFAULT NULL,
    p_agressivo_pm SMALLINT DEFAULT NULL,
    p_agressivo_dano public.dano DEFAULT NULL,

    -- Parâmetros para monstro pacífico (podem ser NULL)
    p_pacifico_defesa SMALLINT DEFAULT NULL,
    p_pacifico_vida SMALLINT DEFAULT NULL,
    p_pacifico_motivo public.comportamento_pacifico DEFAULT NULL,
    p_pacifico_tipo public.tipo_monstro_pacifico DEFAULT NULL,
    p_pacifico_conhecimento_geo CHARACTER(128) DEFAULT NULL,
    p_pacifico_conhecimento_proibido CHARACTER(128) DEFAULT NULL
)
RETURNS public.id_monstro AS $$
DECLARE
    v_novo_monstro_id public.id_monstro;
BEGIN
    -- =================== DESABILITAR TRIGGERS ===================
    -- Desabilita temporariamente os gatilhos para permitir a inserção pelo procedimento.
    ALTER TABLE public.monstros DISABLE TRIGGER trigger_bloqueia_insert_monstros;
    ALTER TABLE public.agressivos DISABLE TRIGGER trigger_bloqueia_insert_agressivos;
    ALTER TABLE public.pacificos DISABLE TRIGGER trigger_bloqueia_insert_pacificos;

    -- =================== BLOCO DE VALIDAÇÃO ===================
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
    ELSIF p_tipo = 'pacífico' THEN
        IF p_pacifico_vida IS NULL OR p_pacifico_defesa IS NULL OR p_pacifico_motivo IS NULL OR p_pacifico_tipo IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Para monstros pacíficos, os campos vida, defesa, motivo_passividade e tipo_pacifico são obrigatórios.';
        END IF;
        IF p_pacifico_tipo = 'sobrenatural' AND p_pacifico_conhecimento_proibido IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "sobrenatural" devem ter valor para "conhecimento_proibido".';
        ELSIF p_pacifico_tipo = 'humanoide' AND p_pacifico_conhecimento_geo IS NULL THEN
            RAISE EXCEPTION 'VIOLAÇÃO DE REGRA: Monstros do tipo "humanoide" devem ter valor para "conhecimento_geografico".';
        END IF;
    ELSE
        RAISE EXCEPTION 'Tipo de monstro inválido: %. Use "agressivo" ou "pacífico".', p_tipo;
    END IF;

    -- =================== BLOCO DE INSERÇÃO ===================
    IF p_tipo = 'agressivo' THEN
        v_novo_monstro_id := public.gerar_id_monstro_agressivo();
    ELSE 
        v_novo_monstro_id := public.gerar_id_monstro_pacifico();
    END IF;

    -- Insere na tabela pai 'monstros'
    INSERT INTO public.monstros (id, nome, descricao, tipo)
    VALUES (v_novo_monstro_id, p_nome, p_descricao, p_tipo);

    -- Insere na tabela filha correta
    IF p_tipo = 'agressivo' THEN
        INSERT INTO public.agressivos (id, defesa, vida, catalisador_agressividade, poder, tipo_agressivo, velocidade_ataque, loucura_induzida, ponto_magia, dano)
        VALUES (v_novo_monstro_id, p_agressivo_defesa, p_agressivo_vida, p_agressivo_catalisador, p_agressivo_poder, p_agressivo_tipo, p_agressivo_velocidade, p_agressivo_loucura, p_agressivo_pm, p_agressivo_dano);
    ELSE
        INSERT INTO public.pacificos (id, defesa, vida, motivo_passividade, tipo_pacifico, conhecimento_geografico, conhecimento_proibido)
        VALUES (v_novo_monstro_id, p_pacifico_defesa, p_pacifico_vida, p_pacifico_motivo, p_pacifico_tipo, p_pacifico_conhecimento_geo, p_pacifico_conhecimento_proibido);
    END IF;

    -- =================== REABILITAR TRIGGERS ===================
    -- Reabilita os gatilhos após a conclusão da operação.
    ALTER TABLE public.monstros ENABLE TRIGGER trigger_bloqueia_insert_monstros;
    ALTER TABLE public.agressivos ENABLE TRIGGER trigger_bloqueia_insert_agressivos;
    ALTER TABLE public.pacificos ENABLE TRIGGER trigger_bloqueia_insert_pacificos;

    RETURN v_novo_monstro_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação do monstro: %', SQLERRM;

        -- =================== REABILITAR TRIGGERS (EM CASO DE ERRO) ===================
        -- Garante que os gatilhos sejam reabilitados mesmo que ocorra uma exceção.
        ALTER TABLE public.monstros ENABLE TRIGGER trigger_bloqueia_insert_monstros;
        ALTER TABLE public.agressivos ENABLE TRIGGER trigger_bloqueia_insert_agressivos;
        ALTER TABLE public.pacificos ENABLE TRIGGER trigger_bloqueia_insert_pacificos;
        
        RAISE; -- Re-lança a exceção para que a transação seja desfeita.
END;
$$ LANGUAGE plpgsql;


-- ---------------------------------------------------------------------------------
--         3.2. GATILHO PARA BLOQUEAR INSERÇÕES DIRETAS
--         Força o uso do Stored Procedure para garantir as regras
-- ---------------------------------------------------------------------------------

CREATE FUNCTION public.func_bloquear_insert_direto_monstro()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Inserção direta não é permitida. Utilize o Stored Procedure "sp_criar_monstro" para criar monstros.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para bloquear inserção direta na tabela 'monstros'
CREATE TRIGGER trigger_bloqueia_insert_monstros
    BEFORE INSERT ON public.monstros
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
        4. LÓGICA PARA MISSÕES
=================================================================================
*/

-- =================================================================================
--         4.1. FUNÇÕES DE TRIGGER PARA MISSÕES
-- =================================================================================

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Valida os dados de uma nova Missão
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
$$ LANGUAGE plpgsql;


-- =================================================================================
--         4.2. STORED PROCEDURE PARA CRIAÇÃO DE MISSÕES
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
RETURNS public.id_missao AS $$
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
$$ LANGUAGE plpgsql;


-- =================================================================================
--         4.3. CRIAÇÃO DO TRIGGER DE MISSÃO
-- =================================================================================

-- Trigger que executa a função de validação antes de inserir ou atualizar uma missão.
CREATE TRIGGER trigger_validar_dados_missao
    BEFORE INSERT OR UPDATE ON public.missoes
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_dados_missao();
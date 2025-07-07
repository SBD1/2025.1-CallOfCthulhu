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

-- Triggers de itens
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens ON public.itens CASCADE;

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
DROP FUNCTION IF EXISTS public.sp_criar_monstro(public.nome, public.descricao, public.tipo_monstro, SMALLINT, SMALLINT, public.gatilho_agressividade, SMALLINT, public.tipo_monstro_agressivo, SMALLINT, SMALLINT, SMALLINT, public.dano, SMALLINT, SMALLINT, public.comportamento_pacifico, public.tipo_monstro_pacifico, CHARACTER(128), CHARACTER(128)) CASCADE;

-- Funções de missões
DROP FUNCTION IF EXISTS public.func_validar_dados_missao() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_missao(public.nome, CHARACTER(512), public.tipo_missao, CHARACTER(128), public.id_personagem_npc) CASCADE;

-- Funções de itens
DROP FUNCTION IF EXISTS public.sp_criar_item(public.nome, public.descricao, public.tipo_item, SMALLINT, public.id_inventario) CASCADE;

-- Funções de Interação com o Mundo
DROP FUNCTION IF EXISTS public.sp_mover_item_chao_para_inventario(public.id_instancia_de_item, public.id_personagem_jogavel) CASCADE;
DROP FUNCTION IF EXISTS public.sp_mover_item_inventario_para_chao(public.id_instancia_de_item, public.id_personagem_jogavel) CASCADE;


-- =================================================================================
--         2. REGRAS DE PERSONAGENS (GERAL)
-- Lógica de Generalização e Especialização para garantir a exclusividade
-- =================================================================================

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Garante que um PJ não possa ser um NPC
-------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_pj()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.npcs WHERE id = NEW.id) THEN
        RAISE EXCEPTION 'O ID % já existe na tabela de NPCs. Um personagem não pode ser Jogável e NPC.', NEW.id;
    END IF;

    -- Se a verificação passar, retorna a tupla para continuar a operação de INSERT ou UPDATE.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------
-- FUNÇÃO DE TRIGGER: Garante que um NPC não possa ser um PJ
-------------------------------------------------------------
CREATE FUNCTION public.func_valida_exclusividade_id_npc()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.personagens_jogaveis WHERE id = NEW.id) THEN
        RAISE EXCEPTION 'O ID % já existe na tabela de Personagens Jogáveis. Um NPC não pode ser NPC e Jogável.', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


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
        id_inventario, id_local -- Valores iniciais de localização
    ) VALUES (
        p_nome, p_ocupacao, p_residencia, p_local_nascimento, p_idade, p_sexo,
        v_novo_inventario_id, (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala' LIMIT 1) -- Sala inicial padrão
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
RETURNS public.id_monstro 
LANGUAGE plpgsql AS $$
DECLARE
    v_novo_monstro_id public.id_monstro;
BEGIN
    -- == Funcionamento de current_setting('nome_da_config', 'missing_ok') ==
    -- Caso 'missing_ok' seja 'true', não gera erro caso a configuração não exista
    -- Caso seja 'false', gera Exception, o que daria problema pois testamos se o valor é inexistente (NULL)
    SET LOCAL bd_cthulhu.inserir = 'true';

    -- =================== VALIDAÇÃO ===================
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

    -- =================== INSERÇÃO ===================
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

    RETURN v_novo_monstro_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro na criação do monstro: %', SQLERRM;
        RAISE;
END;
$$;


-- ---------------------------------------------------------------------------------
--         3.2. GATILHO PARA BLOQUEAR INSERÇÕES DIRETAS
--         Força o uso do Stored Procedure para garantir as regras
-- ---------------------------------------------------------------------------------

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
$$ LANGUAGE plpgsql ;


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


-- =================================================================================
--         4.3. CRIAÇÃO DO TRIGGER DE MISSÃO
-- =================================================================================

-- Trigger que executa a função de validação antes de inserir ou atualizar uma missão.
CREATE TRIGGER trigger_validar_dados_missao
    BEFORE INSERT OR UPDATE ON public.missoes
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_dados_missao();


/*
=================================================================================
        5. FUNÇÕES DE ITENS (GERAL)
-- Lógica de Generalização e Especialização para garantir a exclusividade
=================================================================================
*/

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
-- Função/Trigger: Bloqueia inserções diretas na tabela 'itens', 'armas' e 'armaduras'
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

-- =================================================================================
--         5.1.  FUNÇÕES, TRIGGERS E STORED PROCEDURES PARA ARMAS
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

-- =================================================================================
--         5.2.  STORED PROCEDURE PARA ARMADURAS
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
-- =================================================================================
--         5.3.  STORED PROCEDURE PARA ITENS DE CURA E MÁGICOS

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
--         5.4.  STORED PROCEDURE PARA ITENS MÁGICOS
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

-- =================================================================================
--         5.4.  FUNÇÕES DE TRIGGER 
-- =================================================================================
-- =================================================================================
--         5.2. CRIAÇÃO DOS TRIGGERS
-- =================================================================================


    

CREATE TRIGGER trigger_bloqueia_insert_curas
    BEFORE INSERT ON public.curas 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

CREATE TRIGGER trigger_bloqueia_insert_magicos
    BEFORE INSERT ON public.magicos 
    FOR EACH ROW 
    EXECUTE FUNCTION public.func_bloquear_insert_direto_itens();

/*
=================================================================================
        6. LÓGICA DE INTERAÇÃO COM O MUNDO
=================================================================================
*/

-- =================================================================================
--         6.1.  STORED PROCEDURE PARA MOVER ITEM DO CHÃO PARA O INVENTÁRIO
-- =================================================================================

CREATE OR REPLACE FUNCTION public.sp_mover_item_chao_para_inventario(
    p_id_instancia_item public.id_instancia_de_item,
    p_id_personagem_jogavel public.id_personagem_jogavel
)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_inventario public.id_inventario;
    v_id_local_personagem public.id_local;
    v_id_local_item public.id_local;
    v_tamanho_inventario SMALLINT;
    v_itens_no_inventario INT;
    v_item_no_chao BOOLEAN;
    v_item_no_inventario BOOLEAN;
BEGIN
    -- PASSO 1: Obter dados do personagem e do item.
    SELECT pj.id_inventario, pj.id_local INTO v_id_inventario, v_id_local_personagem
    FROM public.personagens_jogaveis pj
    WHERE pj.id = p_id_personagem_jogavel;

    IF NOT FOUND THEN
        RAISE NOTICE 'Personagem com ID % não encontrado.', p_id_personagem_jogavel;
        RETURN FALSE;
    END IF;

    SELECT ii.id_local, ii.esta_no_local, ii.esta_no_inventario INTO v_id_local_item, v_item_no_chao, v_item_no_inventario
    FROM public.instancias_de_itens ii
    WHERE ii.id = p_id_instancia_item;

    IF NOT FOUND THEN
        RAISE NOTICE 'Instância de item com ID % não encontrada.', p_id_instancia_item;
        RETURN FALSE;
    END IF;

    -- PASSO 2: Validar as condições para mover o item.
    IF v_item_no_chao IS NOT TRUE OR v_item_no_inventario IS TRUE THEN
        RAISE NOTICE 'O item % não está no chão ou já está em um inventário.', p_id_instancia_item;
        RETURN FALSE;
    END IF;

    IF v_id_local_personagem IS DISTINCT FROM v_id_local_item THEN
        RAISE NOTICE 'O personagem e o item não estão no mesmo local.';
        RETURN FALSE;
    END IF;

    -- PASSO 3: Verificar se há espaço no inventário.
    SELECT inv.tamanho INTO v_tamanho_inventario FROM public.inventarios inv WHERE inv.id = v_id_inventario;
    SELECT count(*) INTO v_itens_no_inventario FROM public.inventarios_possuem_instancias_item WHERE id_inventario = v_id_inventario;

    IF v_itens_no_inventario >= v_tamanho_inventario THEN
        RAISE NOTICE 'Inventário do personagem está cheio.';
        RETURN FALSE;
    END IF;

    -- PASSO 4: Executar a movimentação do item.
    UPDATE public.instancias_de_itens SET id_local = NULL, esta_no_local = FALSE, esta_no_inventario = TRUE WHERE id = p_id_instancia_item;
    INSERT INTO public.inventarios_possuem_instancias_item (id_instancias_de_item, id_inventario) VALUES (p_id_instancia_item, v_id_inventario);

    RAISE NOTICE 'Item % movido para o inventário do personagem % com sucesso.', p_id_instancia_item, p_id_personagem_jogavel;
    RETURN TRUE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro inesperado ao mover o item: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- =================================================================================
--         6.2.  STORED PROCEDURE PARA MOVER ITEM DO INVENTÁRIO PARA O CHÃO
-- =================================================================================

CREATE OR REPLACE FUNCTION public.sp_mover_item_inventario_para_chao(
    p_id_instancia_item public.id_instancia_de_item,
    p_id_personagem_jogavel public.id_personagem_jogavel
)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_inventario public.id_inventario;
    v_id_local_personagem public.id_local;
    v_item_no_inventario BOOLEAN;
    v_possui_item_count INT;
BEGIN
    -- PASSO 1: Obter dados do personagem e verificar se ele possui o item.
    SELECT pj.id_inventario, pj.id_local INTO v_id_inventario, v_id_local_personagem
    FROM public.personagens_jogaveis pj
    WHERE pj.id = p_id_personagem_jogavel;

    IF NOT FOUND THEN
        RAISE NOTICE 'Personagem com ID % não encontrado.', p_id_personagem_jogavel;
        RETURN FALSE;
    END IF;

    SELECT ii.esta_no_inventario INTO v_item_no_inventario
    FROM public.instancias_de_itens ii
    WHERE ii.id = p_id_instancia_item;

    IF NOT FOUND THEN
        RAISE NOTICE 'Instância de item com ID % não encontrada.', p_id_instancia_item;
        RETURN FALSE;
    END IF;

    -- PASSO 2: Validar se o item está de fato no inventário do personagem.
    SELECT count(*) INTO v_possui_item_count
    FROM public.inventarios_possuem_instancias_item
    WHERE id_inventario = v_id_inventario AND id_instancias_de_item = p_id_instancia_item;

    IF v_item_no_inventario IS NOT TRUE OR v_possui_item_count = 0 THEN
        RAISE NOTICE 'O item % não está no inventário do personagem %.', p_id_instancia_item, p_id_personagem_jogavel;
        RETURN FALSE;
    END IF;
    
    -- PASSO 3: Executar a movimentação do item.
    -- Remove a associação do inventário
    DELETE FROM public.inventarios_possuem_instancias_item
    WHERE id_instancias_de_item = p_id_instancia_item AND id_inventario = v_id_inventario;

    -- Atualiza o status da instância do item para estar no chão, no local atual do personagem
    UPDATE public.instancias_de_itens
    SET id_local = v_id_local_personagem, esta_no_local = TRUE, esta_no_inventario = FALSE
    WHERE id = p_id_instancia_item;

    RAISE NOTICE 'Item % solto no chão pelo personagem % com sucesso.', p_id_instancia_item, p_id_personagem_jogavel;
    RETURN TRUE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro inesperado ao soltar o item: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

/*
=================================================================================
        6. LÓGICA DE INTERAÇÃO COM O MUNDO
=================================================================================
*/

-- =================================================================================
--         6.3.  STORED PROCEDURE PARA MOVER ITEM DO CHÃO PARA O INVENTÁRIO
-- =================================================================================

CREATE OR REPLACE FUNCTION public.sp_mover_item_chao_para_inventario(
    p_id_instancia_item public.id_instancia_de_item,
    p_id_personagem_jogavel public.id_personagem_jogavel
)
RETURNS BOOLEAN AS $$
DECLARE
    v_id_inventario public.id_inventario;
    v_id_local_personagem public.id_local;
    v_id_local_item public.id_local;
    v_tamanho_inventario SMALLINT;
    v_itens_no_inventario INT;
    v_item_no_chao BOOLEAN;
    v_item_no_inventario BOOLEAN;
BEGIN
    -- PASSO 1: Obter dados do personagem e do item.
    SELECT pj.id_inventario, pj.id_local INTO v_id_inventario, v_id_local_personagem
    FROM public.personagens_jogaveis pj
    WHERE pj.id = p_id_personagem_jogavel;

    IF NOT FOUND THEN
        RAISE NOTICE 'Personagem com ID % não encontrado.', p_id_personagem_jogavel;
        RETURN FALSE;
    END IF;

    SELECT ii.id_local, ii.esta_no_local, ii.esta_no_inventario INTO v_id_local_item, v_item_no_chao, v_item_no_inventario
    FROM public.instancias_de_itens ii
    WHERE ii.id = p_id_instancia_item;

    IF NOT FOUND THEN
        RAISE NOTICE 'Instância de item com ID % não encontrada.', p_id_instancia_item;
        RETURN FALSE;
    END IF;

    -- PASSO 2: Validar as condições para mover o item.
    IF v_item_no_chao IS NOT TRUE OR v_item_no_inventario IS TRUE THEN
        RAISE NOTICE 'O item % não está no chão ou já está em um inventário.', p_id_instancia_item;
        RETURN FALSE;
    END IF;

    IF v_id_local_personagem IS DISTINCT FROM v_id_local_item THEN
        RAISE NOTICE 'O personagem e o item não estão no mesmo local.';
        RETURN FALSE;
    END IF;

    -- PASSO 3: Verificar se há espaço no inventário.
    SELECT inv.tamanho INTO v_tamanho_inventario FROM public.inventarios inv WHERE inv.id = v_id_inventario;
    SELECT count(*) INTO v_itens_no_inventario FROM public.inventarios_possuem_instancias_item WHERE id_inventario = v_id_inventario;

    IF v_itens_no_inventario >= v_tamanho_inventario THEN
        RAISE NOTICE 'Inventário do personagem está cheio.';
        RETURN FALSE;
    END IF;

    -- PASSO 4: Executar a movimentação do item.
    UPDATE public.instancias_de_itens SET id_local = NULL, esta_no_local = FALSE, esta_no_inventario = TRUE WHERE id = p_id_instancia_item;
    INSERT INTO public.inventarios_possuem_instancias_item (id_instancias_de_item, id_inventario) VALUES (p_id_instancia_item, v_id_inventario);

    RAISE NOTICE 'Item % movido para o inventário do personagem % com sucesso.', p_id_instancia_item, p_id_personagem_jogavel;
    RETURN TRUE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro inesperado ao mover o item: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

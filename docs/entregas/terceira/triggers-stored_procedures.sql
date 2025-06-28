/*
ARQUIVO: triggers-stored_procedures.sql
VERSÃO: 1.0
DATA: 28/06/2025
AUTOR: Wanjo Christopher
DESCRIÇÃO: Criação dos triggers e stored procedures para a generalização e especialização de personagens jogáveis e NPCs
*/

DROP FUNCTION IF EXISTS public.verifica_personagem_npc_existente() CASCADE;
DROP TRIGGER IF EXISTS trgg_valida_personagem_jogavel ON public.personagens_jogaveis CASCADE;
DROP FUNCTION IF EXISTS public.verifica_personagem_jogavel_existente() CASCADE;
DROP TRIGGER IF EXISTS trgg_valida_npc ON public.npcs CASCADE;
DROP FUNCTION IF EXISTS public.verificar_atributos_personagem_jogavel() CASCADE;
DROP TRIGGER IF EXISTS trgg_valida_atributos_personagem_jogavel ON public.personagens_jogaveis CASCADE;


-- ==============================================

--          GENERALIZAÇÃO E ESPECIALIZAÇÃO (T,D)

-- ==============================================

-- ================== PERSONAGENS =================

-------------------------------------------------------------
-- TRIGGER PARA GARANTIR EXCLUSIVIDADE DO PERSONAGEM JOGÁVEL
-------------------------------------------------------------
CREATE FUNCTION public.verifica_personagem_npc_existente()
RETURNS TRIGGER AS $verifica_personagem_npc_existente$
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
$verifica_personagem_npc_existente$ LANGUAGE plpgsql;

-- Trigger que executa a função de verificação em 'personagens_jogaveis'
CREATE TRIGGER trgg_valida_personagem_jogavel
    BEFORE INSERT OR UPDATE ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.verifica_personagem_npc_existente();


-------------------------------------------------------------
-- TRIGGER PARA GARANTIR EXCLUSIVIDADE DO NPC
-------------------------------------------------------------
CREATE FUNCTION public.verifica_personagem_jogavel_existente()
RETURNS TRIGGER AS $verifica_personagem_jogavel_existente$
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
$verifica_personagem_jogavel_existente$ LANGUAGE plpgsql;

-- Trigger que executa a função de verificação em 'npcs'
CREATE TRIGGER trgg_valida_npc
    BEFORE INSERT OR UPDATE ON public.npcs
    FOR EACH ROW EXECUTE FUNCTION public.verifica_personagem_jogavel_existente();



-------------------------------------------------------------
-- TRIGGER PARA GARANTIR E VALIDAR ATRIBUTOS ESPECÍFICOS DE PERSONAGENS JOGÁVEIS
-------------------------------------------------------------
CREATE FUNCTION public.verificar_atributos_personagem_jogavel()
RETURNS TRIGGER AS $verificar_atributos_personagem_jogavel$
BEGIN
    -- ======== Validação de campos de texto ========
    IF NEW.nome IS NULL OR TRIM(NEW.nome) = '' OR NEW.nome ~ '[0-9]' THEN
        RAISE EXCEPTION 'O nome do personagem jogável não pode ser nulo, vazio ou conter números.';
    END IF;

    IF TRIM(NEW.nome) = '' THEN
        RAISE EXCEPTION 'O campo "nome" do NPC não pode ser nulo ou vazio.';
    END IF;

    IF TRIM(NEW.descricao) = '' THEN
        RAISE EXCEPTION 'O campo "descricao" do NPC não pode ser nulo ou vazio.';
    END IF;

    IF TRIM(NEW.residencia) = '' OR TRIM(NEW.local_nascimento) = '' THEN
        RAISE EXCEPTION 'Os campos "residencia" e "local_nascimento" do NPC não podem ser nulos ou vazios.';
    END IF;

    -- ======== Validação de campos de atributos derivados ========
    -- Calcular o MOVIMENTO com base na Força, Destreza e Tamanho.
    IF NEW.destreza < NEW.tamanho AND NEW.forca < NEW.tamanho THEN
        NEW.movimento := 7;
    ELSIF NEW.destreza > NEW.tamanho AND NEW.forca > NEW.tamanho THEN
        NEW.movimento := 9;
    ELSE
        NEW.movimento := 8;
    END IF;
    
    -- Calcular Sanidade, Vida e PM iniciais usando as funções do seu DDL.
    NEW.sanidade_atual := public.calcular_sanidade(NEW.poder);
    NEW.pontos_de_vida_atual := public.calcular_pts_de_vida(NEW.constituicao, NEW.tamanho);
    NEW.pm_base := NEW.poder;
    NEW.pm_max := NEW.poder;

    RETURN NEW;
END;
$verificar_atributos_personagem_jogavel$ LANGUAGE plpgsql;

-- Trigger que executa a função de verificação em 'personagens_jogaveis'
CREATE TRIGGER trgg_valida_atributos_personagem_jogavel
    BEFORE INSERT OR UPDATE ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.verificar_atributos_personagem_jogavel();


-- 

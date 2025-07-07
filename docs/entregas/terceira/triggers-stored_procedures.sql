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
DATA: 06/07/2025
AUTOR: Luiz Guilherme
DESCRIÇÃO: Cria o stored procedure para movimentar os monstros de local.

VERSÃO: 0.15
DATA: 06/07/2025
AUTOR: Luiz Guilherme
DESCRIÇÃO: Corrige bugs da função encontrar monstros.

VERSÃO: 0.16
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria triggers, stored procedures e functions para Batalha e conclusão de missões.

VERSÃO: 0.17
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria triggers, stored procedures e functions para movimentação de jogadores, equipar itens e gerenciar durabilidade de itens.

VERSÃO: 0.18
DATA: 05/07/2025
AUTOR: Wanjo Chritopher
DESCRIÇÃO: Adiciona as procedures sp_desequipar_item e atualiza sp_equipar_item para gerenciar os atributos do personagem ao equipar e desequipar itens.

VERSÃO: 0.19
DATA: 05/07/2025
AUTOR: Wanjo Chritopher
DESCRIÇÃO: Corrige sp_executar_batalha para buscar vida da instância. Melhora sp_ver_inventario para retornar os bônus dos itens.

VERSÃO: 0.20
DATA: 05/07/2025
AUTOR: Wanjo Chritopher
DESCRIÇÃO: Cria procedure de insperior monstro e melhora a de checar inventário

VERSÃO: 0.21
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria procedure de Sanidade e pericias.

VERSÃO: 0.22
DATA: 05/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria procedure para executar turno batalha, que calcula dano e atualiza vida de personagens e monstros.

VERSÃO: 0.23
DATA: 06/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria procedure para LÓGICA DE BATALHA (NOVO - POR TURNO) E UTILITÁRIOS e STORED PROCEDURE: Realizar um teste de perícia

VERSÃO: 0.24
DATA: 06/07/2025
AUTOR: João Marcos
DESCRIÇÃO: Cria procedure para distribuição de pontos de perícia iniciais ao criar personagem jogável.

VERSÃO: 0.25
DATA: 07/07/2025
AUTOR: João Marcos e Luiz Guilherme
DESCRIÇÃO: Documentação do arquivo, organização e limpeza de código.

*/


-- -- ===============================================================================
-- --          0.1. DROP, CREATE, GRANK E REVOKE DE USUÁRIO PADRÃO DO BANCO 
-- -- ===============================================================================
/*
Este bloco cria o role `usuario_padrao` e define permissões básicas para acesso ao banco de dados.

*Atualmente este trecho está comentado e não está sendo utilizado pelo sistema.*

Responsabilidades:
- Criação de um usuário padrão com acesso restrito (sem superpoderes de banco);
- Permite `SELECT`, `INSERT`, `UPDATE` e `DELETE` em todas as tabelas do schema `public`;
- Revoga permissões de `INSERT`, `UPDATE` e `DELETE` na tabela `personagens_jogaveis`,
  garantindo que somente funções e triggers controladas possam alterar seus dados.

Este role é útil para limitar o que o jogador/usuário final pode modificar diretamente no banco.

*/
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
/*
Este bloco executa o **DROP** de todas as triggers e stored functions previamente criadas no banco de dados.

Ele é utilizado no início da execução do script para garantir que as versões antigas das funções e triggers
não causem conflitos ou erros de duplicidade durante o processo de desenvolvimento e reexecução.

O bloco está organizado em duas partes:
1. **DROP DE TRIGGERS:** remove todas as triggers vinculadas a tabelas como `personagens_jogaveis`, `npcs`, `missões`, `itens`, `armas`, `feitiços` e outras.
   Essas triggers geralmente controlam validações, bloqueios ou ajustes automáticos.
2. **DROP DE FUNÇÕES:** remove funções auxiliares e stored procedures relacionadas à criação e manipulação de dados
   do jogo — como criação de personagens, monstros, itens, feitiços, execução de batalhas, entre outras.
*/
-- ======== DROP DE TRIGGERS ========
/*
DROP TRIGGER IF EXISTS trigger_valida_unicidade_personagem_jogavel ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_unicidade_npc ON public.npcs CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_ajustar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_npc ON public.npcs CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_monstros ON public.tipos_monstro CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_agressivos ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_pacificos ON public.pacificos CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_dados_missao ON public.missoes CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_atributos_item ON public.itens CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens ON public.itens CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_armas ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_armaduras ON public.armaduras CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens_curas ON public.curas CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens_magicos ON public.magicos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_id_arma ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_id_armadura ON public.armaduras CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_tipos_feitico ON public.tipos_feitico CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_feiticos_status ON public.feiticos_status CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_feiticos_dano ON public.feiticos_dano CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_insanidade_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_durabilidade_arma ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_durabilidade_armadura ON public.armaduras CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_usos_cura ON public.curas CASCADE;

-- ======== DROP DE FUNÇÕES ========
-- Personagens e NPCs
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pj() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_npc() CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.func_ajustar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_personagem_jogavel(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_atributos_npc() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_npc(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;
DROP FUNCTION IF EXISTS public.sp_atribuir_pericias_iniciais(public.id_personagem_jogavel, public.ocupacao) CASCADE;

-- Monstros
DROP FUNCTION IF EXISTS public.sp_criar_monstro(public.nome, public.descricao, public.tipo_monstro, SMALLINT, SMALLINT, SMALLINT, public.gatilho_agressividade, SMALLINT, public.tipo_monstro_agressivo, SMALLINT, SMALLINT, SMALLINT, public.dano, SMALLINT, SMALLINT, SMALLINT, public.comportamento_pacifico, public.tipo_monstro_pacifico, CHARACTER, CHARACTER) CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_monstro() CASCADE;

-- Missões
DROP FUNCTION IF EXISTS public.sp_criar_missao(public.nome, CHARACTER, public.tipo_missao, CHARACTER, public.id_personagem_npc) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_dados_missao() CASCADE;
DROP FUNCTION IF EXISTS public.sp_entregar_missao(public.id_personagem_jogavel, public.id_missao) CASCADE;
DROP FUNCTION IF EXISTS public.sp_verificar_e_entregar_missao(public.id_personagem_jogavel, public.id_missao) CASCADE;

-- Itens
DROP FUNCTION IF EXISTS public.func_valida_atributos_item() CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_itens() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_arma(public.nome, public.descricao, SMALLINT, public.tipo_atributo_personagem, SMALLINT, SMALLINT, public.funcao_arma, SMALLINT, public.tipo_municao, public.tipo_dano, public.dano) CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_arma() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_armadura(public.nome, public.descricao, SMALLINT, public.tipo_atributo_personagem, SMALLINT, public.funcao_armadura, SMALLINT, public.tipo_atributo_personagem, SMALLINT, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_armadura(p_nome public.nome, p_descricao public.descricao, p_valor smallint, p_atributo_necessario public.tipo_atributo_personagem, p_durabilidade smallint, p_funcao public.funcao_armadura, p_qtd_atributo_recebe smallint, p_qtd_atributo_necessario smallint, p_tipo_atributo_recebe public.tipo_atributo_personagem, p_qtd_dano_mitigado smallint) CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_armadura() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_item_cura(public.nome, public.descricao, SMALLINT, public.funcao_cura, SMALLINT, SMALLINT, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_item_magico(public.nome, public.descricao, SMALLINT, public.funcao_magica, SMALLINT, SMALLINT, public.id_feitico) CASCADE;

-- Feitiços
DROP FUNCTION IF EXISTS public.sp_criar_feitico(public.nome, public.descricao, SMALLINT, public.funcao_feitico, BOOLEAN, SMALLINT, public.tipo_de_status, public.tipo_dano, public.dano) CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_feitico() CASCADE;

-- Interação e Jogo
DROP FUNCTION IF EXISTS public.lua_de_sangue() CASCADE;
DROP FUNCTION IF EXISTS public.sp_vasculhar_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_adicionar_item_ao_inventario(public.id_personagem, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_ver_inventario(public.id_personagem) CASCADE;
DROP FUNCTION IF EXISTS public.sp_encontrar_monstros_no_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_matar_monstros_no_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_executar_batalha(public.id_personagem_jogavel, public.id_instancia_de_monstro) CASCADE;
DROP FUNCTION IF EXISTS public.sp_mover_jogador(public.id_personagem_jogavel, public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_equipar_item(public.id_personagem_jogavel, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_desequipar_item(public.id_personagem_jogavel, TEXT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_desequipar_item(public.id_personagem_jogavel, public.tipo_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_usar_item_cura(public.id_personagem_jogavel, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.func_gerenciar_durabilidade_item() CASCADE;

-- Mecânicas Avançadas
DROP FUNCTION IF EXISTS public.func_verificar_insanidade() CASCADE;
DROP FUNCTION IF EXISTS public.sp_aplicar_dano_sanidade(public.id_personagem_jogavel, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_realizar_teste_pericia(public.id_personagem_jogavel, public.nome) CASCADE;
DROP FUNCTION IF EXISTS public.sp_inspecionar_monstro(public.id_instancia_de_monstro) CASCADE;
DROP FUNCTION IF EXISTS public.sp_dialogar_com_npc(public.id_personagem_npc) CASCADE;
DROP FUNCTION IF EXISTS public.sp_executar_turno_batalha(public.id_personagem_jogavel, public.id_instancia_de_monstro) CASCADE;
*/

-- =================================================================================
--         DROP DE TRIGGERS
-- =================================================================================

-- Personagens e NPCs
DROP TRIGGER IF EXISTS trigger_valida_unicidade_personagem_jogavel ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_unicidade_npc ON public.npcs CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_ajustar_atributos_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_atributos_npc ON public.npcs CASCADE;

-- Monstros
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_monstros ON public.tipos_monstro CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_agressivos ON public.agressivos CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_pacificos ON public.pacificos CASCADE;

-- Missões
DROP TRIGGER IF EXISTS trigger_validar_dados_missao ON public.missoes CASCADE;

-- Itens
DROP TRIGGER IF EXISTS trigger_valida_atributos_item ON public.itens CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens ON public.itens CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_armas ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_armaduras ON public.armaduras CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens_curas ON public.curas CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_itens_magicos ON public.magicos CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_id_arma ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_valida_exclusividade_id_armadura ON public.armaduras CASCADE;

-- Feitiços
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_tipos_feitico ON public.tipos_feitico CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_feiticos_status ON public.feiticos_status CASCADE;
DROP TRIGGER IF EXISTS trigger_bloqueia_insert_feiticos_dano ON public.feiticos_dano CASCADE;

-- Mecânicas Avançadas
DROP TRIGGER IF EXISTS trigger_checar_insanidade_personagem ON public.personagens_jogaveis CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_durabilidade_arma ON public.armas CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_durabilidade_armadura ON public.armaduras CASCADE;
DROP TRIGGER IF EXISTS trigger_checar_usos_cura ON public.curas CASCADE;

-- =================================================================================
--         DROP DE FUNÇÕES
-- =================================================================================

-- Personagens e NPCs
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_pj() CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_npc() CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.func_ajustar_atributos_personagem() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_personagem_jogavel(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_atributos_npc() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_npc(public.nome, public.ocupacao, public.residencia, public.local_nascimento, public.idade, public.sexo) CASCADE;
DROP FUNCTION IF EXISTS public.sp_atribuir_pericias_iniciais(public.id_personagem_jogavel, public.ocupacao) CASCADE;

-- Monstros
DROP FUNCTION IF EXISTS public.sp_criar_monstro(public.nome, public.descricao, public.tipo_monstro, SMALLINT, SMALLINT, SMALLINT, public.gatilho_agressividade, SMALLINT, public.tipo_monstro_agressivo, SMALLINT, SMALLINT, SMALLINT, public.dano, SMALLINT, SMALLINT, SMALLINT, public.comportamento_pacifico, public.tipo_monstro_pacifico, CHARACTER, CHARACTER) CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_monstro() CASCADE;

-- Missões
DROP FUNCTION IF EXISTS public.sp_criar_missao(public.nome, CHARACTER, public.tipo_missao, CHARACTER, public.id_personagem_npc) CASCADE;
DROP FUNCTION IF EXISTS public.func_validar_dados_missao() CASCADE;
DROP FUNCTION IF EXISTS public.sp_entregar_missao(public.id_personagem_jogavel, public.id_missao) CASCADE;
DROP FUNCTION IF EXISTS public.sp_verificar_e_entregar_missao(public.id_personagem_jogavel, public.id_missao) CASCADE;

-- Itens
DROP FUNCTION IF EXISTS public.func_valida_atributos_item() CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_itens() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_arma(public.nome, public.descricao, SMALLINT, public.tipo_atributo_personagem, SMALLINT, SMALLINT, public.funcao_arma, SMALLINT, public.tipo_municao, public.tipo_dano, public.dano) CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_arma() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_armadura(public.nome, public.descricao, SMALLINT, public.tipo_atributo_personagem, SMALLINT, public.funcao_armadura, SMALLINT, public.tipo_atributo_personagem, SMALLINT, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_armadura(p_nome public.nome, p_descricao public.descricao, p_valor smallint, p_atributo_necessario public.tipo_atributo_personagem, p_durabilidade smallint, p_funcao public.funcao_armadura, p_qtd_atributo_recebe smallint, p_qtd_atributo_necessario smallint, p_tipo_atributo_recebe public.tipo_atributo_personagem, p_qtd_dano_mitigado smallint) CASCADE;
DROP FUNCTION IF EXISTS public.func_valida_exclusividade_id_armadura() CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_item_cura(public.nome, public.descricao, SMALLINT, public.funcao_cura, SMALLINT, SMALLINT, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_criar_item_magico(public.nome, public.descricao, SMALLINT, public.funcao_magica, SMALLINT, SMALLINT, public.id_feitico) CASCADE;

-- Feitiços
DROP FUNCTION IF EXISTS public.sp_criar_feitico(public.nome, public.descricao, SMALLINT, public.funcao_feitico, BOOLEAN, SMALLINT, public.tipo_de_status, public.tipo_dano, public.dano) CASCADE;
DROP FUNCTION IF EXISTS public.func_bloquear_insert_direto_feitico() CASCADE;

-- Interação e Jogo
DROP FUNCTION IF EXISTS public.lua_de_sangue() CASCADE;
DROP FUNCTION IF EXISTS public.sp_vasculhar_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_adicionar_item_ao_inventario(public.id_personagem, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_ver_inventario(public.id_personagem) CASCADE;
DROP FUNCTION IF EXISTS public.sp_encontrar_monstros_no_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_matar_monstros_no_local(public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_executar_batalha(public.id_personagem_jogavel, public.id_instancia_de_monstro) CASCADE;
DROP FUNCTION IF EXISTS public.sp_mover_jogador(public.id_personagem_jogavel, public.id_local) CASCADE;
DROP FUNCTION IF EXISTS public.sp_equipar_item(public.id_personagem_jogavel, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_desequipar_item(public.id_personagem_jogavel, TEXT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_desequipar_item(public.id_personagem_jogavel, public.tipo_item) CASCADE;
DROP FUNCTION IF EXISTS public.sp_usar_item_cura(public.id_personagem_jogavel, public.id_instancia_de_item) CASCADE;
DROP FUNCTION IF EXISTS public.func_gerenciar_durabilidade_item() CASCADE;

-- Mecânicas Avançadas
DROP FUNCTION IF EXISTS public.func_verificar_insanidade() CASCADE;
DROP FUNCTION IF EXISTS public.sp_aplicar_dano_sanidade(public.id_personagem_jogavel, SMALLINT) CASCADE;
DROP FUNCTION IF EXISTS public.sp_realizar_teste_pericia(public.id_personagem_jogavel, public.nome) CASCADE;
DROP FUNCTION IF EXISTS public.sp_inspecionar_monstro(public.id_instancia_de_monstro) CASCADE;
DROP FUNCTION IF EXISTS public.sp_dialogar_com_npc(public.id_personagem_npc) CASCADE;
DROP FUNCTION IF EXISTS public.sp_executar_turno_batalha(public.id_personagem_jogavel, public.id_instancia_de_monstro) CASCADE;

-- =================================================================================
--         1. REGRAS GERAIS DE PERSONAGENS
--         Lógica para garantir a exclusividade entre PJ e NPC (Regra T,E)
-- =================================================================================
/*
Este trecho implementa a **regra de exclusividade entre NPC e PJ**, também conhecida como **Regra T,E** (Totalidade e Exclusividade).

O que ele faz:
- Garante que um mesmo ID **não possa existir simultaneamente** nas tabelas `personagens_jogaveis` e `npcs`.
- Se um PJ tentar ser criado com o mesmo ID de um NPC, a trigger dispara e bloqueia a inserção (e vice-versa).

Esse controle é feito por meio de duas funções com triggers associadas:
1. `func_valida_exclusividade_id_pj`: impede que um PJ use um ID já existente na tabela de NPCs.
2. `func_valida_exclusividade_id_npc`: impede que um NPC use um ID já existente na tabela de PJs.

Essas triggers são essenciais para manter a integridade da hierarquia e garantir que a especialização seja consistente com o modelo lógico do banco.
*/
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
-- =================================================================================
--    FUNÇÃO: Valida atributos obrigatórios de um novo PJ
-- =================================================================================
/*
A função `func_validar_atributos_personagem` garante que os dados obrigatórios de um
Personagem Jogável estejam preenchidos corretamente no momento da inserção.

Ela verifica:
- Se o nome não é nulo, vazio ou contém números;
- Se os campos "ocupação", "residência" e "local de nascimento" estão preenchidos.
*/
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

-- =================================================================================
--    TRIGGER: Executa validação de atributos do PJ no INSERT
-- =================================================================================
CREATE TRIGGER trigger_validar_atributos_personagem
    BEFORE INSERT ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_atributos_personagem();

-- =================================================================================
--    FUNÇÃO: Ajusta atributos calculados de um novo PJ
-- =================================================================================
/*
A função `func_ajustar_atributos_personagem` define automaticamente valores derivados
com base nos atributos principais do personagem.

Ajustes feitos:
- Cálculo do `movimento` baseado em força, destreza e tamanho;
- Cálculo inicial de `sanidade_atual`, `pontos_de_vida_atual`, `pm_base`, `pm_max`;
- Define estados iniciais booleanos de insanidade como FALSE.
*/
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


-- =================================================================================
--    TRIGGER: Executa o ajuste de atributos no INSERT do PJ
-- =================================================================================
CREATE TRIGGER trigger_ajustar_atributos_personagem
    BEFORE INSERT ON public.personagens_jogaveis
    FOR EACH ROW EXECUTE FUNCTION public.func_ajustar_atributos_personagem();

-- =================================================================================
--    STORED PROCEDURE: Criação completa de um Personagem Jogável
-- =================================================================================
/*
A stored procedure `sp_criar_personagem_jogavel` encapsula todo o processo de criação
de um novo personagem no jogo.

Etapas realizadas:
1. Cria um inventário com tamanho padrão.
2. Insere os dados na tabela `personagens_jogaveis` (triggers cuidarão dos ajustes).
3. Atribui automaticamente as perícias iniciais com base na ocupação.
4. Retorna o ID do personagem criado.
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

    -- 3. ADICIONE ESTA LINHA PARA ATRIBUIR AS PERÍCIAS
    PERFORM public.sp_atribuir_pericias_iniciais(v_novo_personagem_id, p_ocupacao);

    -- 4. Retorna o ID do personagem recém-criado.
    RETURN v_novo_personagem_id;
END;
$$ LANGUAGE plpgsql;


-- =================================================================================
--         1.3. REGRAS E PROCEDIMENTOS DE NPCs
-- =================================================================================
-- =================================================================================
--    FUNÇÃO: Valida atributos obrigatórios de um novo NPC
-- =================================================================================
/*
A função `func_validar_atributos_npc` é responsável por verificar os dados essenciais
de um NPC no momento da inserção.

Validações aplicadas:
- O nome não pode ser nulo, vazio ou conter números;
- Os campos `ocupacao`, `residencia` e `local_nascimento` devem estar preenchidos.

Essas validações garantem que todo NPC inserido esteja com informações mínimas completas.
*/
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

-- =================================================================================
--    TRIGGER: Executa a validação de atributos de NPCs no INSERT
-- =================================================================================
CREATE TRIGGER trigger_validar_atributos_npc
    BEFORE INSERT ON public.npcs
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_atributos_npc();

-- =================================================================================
--    STORED PROCEDURE: Criação completa de um NPC
-- =================================================================================
/*
A stored procedure `sp_criar_npc` encapsula o processo de criação de um personagem NPC.

Etapas realizadas:
1. Cria um inventário para o NPC com tamanho padrão de 32 espaços;
2. Insere os dados na tabela `npcs`;
3. Define a sala inicial padrão (caso o parâmetro `p_id_local` não seja informado, utiliza o ID 40300003);
4. A trigger `trigger_validar_atributos_npc` será automaticamente chamada no momento do INSERT;
5. Retorna o ID do NPC recém-criado.

Essa procedure garante que todo NPC do sistema seja criado com os dados completos e consistentes.
*/
CREATE OR REPLACE FUNCTION public.sp_criar_npc(
    p_nome public.nome,
    p_ocupacao public.ocupacao,
    p_residencia public.residencia,
    p_local_nascimento public.local_nascimento,
    p_idade public.idade,
    p_sexo public.sexo,
    p_id_local public.id_local DEFAULT 40300003
)
RETURNS public.id_personagem_npc AS $$
DECLARE
    v_novo_inventario_id public.id_inventario;
    v_novo_npc_id public.id_personagem_npc;
BEGIN
    INSERT INTO public.inventarios (tamanho) VALUES (32) RETURNING id INTO v_novo_inventario_id;
    -- Insere os dados do NPC. A validação será feita pela trigger 'trigger_validar_atributos_npc'.
    INSERT INTO public.npcs (
        nome, ocupacao, residencia, local_nascimento, idade, sexo, id_inventario,
        id_local -- Localização inicial
    ) VALUES (
        p_nome, p_ocupacao, p_residencia, p_local_nascimento, p_idade, p_sexo, v_novo_inventario_id,
        p_id_local -- Sala inicial padrão para NPCs (exemplo, pode ser alterado ou passado como parâmetro)
    ) RETURNING id INTO v_novo_npc_id;

    RETURN v_novo_npc_id;
END;
$$ LANGUAGE plpgsql;

-- =================================================================================
--         1.4. STORED PROCEDURE PARA ATRIBUIR PERÍCIAS INICIAIS
--         Esta procedure é chamada pela sp_criar_personagem_jogavel
-- =================================================================================
-- =================================================================================
--    STORED PROCEDURE: Atribuição de perícias iniciais ao PJ
-- =================================================================================
/*
A stored procedure `sp_atribuir_pericias_iniciais` é utilizada no momento da criação
de um Personagem Jogável para atribuir automaticamente as perícias básicas relacionadas
à ocupação escolhida pelo jogador.

Funcionamento:
- Consulta a tabela `ocupacoes_possuem_pericias`, que define as perícias associadas a cada ocupação;
- Insere na tabela `personagens_possuem_pericias` os pares (id_personagem, id_pericia) que representam
  o domínio inicial do personagem nas perícias correspondentes.

Regras:
- A procedure assume que a ocupação passada como parâmetro já está registrada no banco;
- Pode ser chamada automaticamente após a criação do personagem para garantir consistência.

Essa lógica evita que personagens iniciem sem ao menos as perícias mínimas esperadas de sua ocupação.
*/
CREATE OR REPLACE FUNCTION public.sp_atribuir_pericias_iniciais(p_id_jogador public.id_personagem_jogavel, p_ocupacao public.ocupacao) RETURNS VOID AS $$
DECLARE
    -- Variáveis para os pontos de perícia
    v_pontos_ocupacao INT;
    v_pontos_pessoais INT;
    v_educacao INT;
    v_inteligencia INT;

    -- Variáveis para a lógica de distribuição
    v_pericias_ocupacao_ids INT[];
    v_pericia_escolhida_id INT;
    v_pontos_a_gastar INT;
    v_pericia_rec RECORD;
    v_base_valor INT;
BEGIN
    -- 1. Obter os atributos do jogador para calcular os pontos de perícia
    SELECT educacao, inteligencia INTO v_educacao, v_inteligencia
    FROM public.personagens_jogaveis WHERE id = p_id_jogador;

    -- 2. Calcular os pontos de perícia baseados nas regras do Call of Cthulhu (EDU*4 para ocupação, INT*2 para pessoais)
    v_pontos_ocupacao := v_educacao * 4;
    v_pontos_pessoais := v_inteligencia * 2;

    -- 3. Mapear a Ocupação para uma lista de IDs de perícias
    CASE p_ocupacao
        WHEN 'Medico' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Primeiros Socorros', 'Medicina', 'Biologia', 'Farmácia', 'Ciência', 'Psicanálise', 'Língua, Outra', 'Lábia'));
        WHEN 'Doutor' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Medicina', 'Ciência', 'Usar Bibliotecas', 'Língua, Outra', 'Psicologia', 'Farmácia', 'Persuasão', 'Direito'));
        WHEN 'Arqueologo' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Arqueologia', 'História', 'Encontrar', 'Usar Bibliotecas', 'Língua, Outra', 'Arte e Ofício', 'Avaliação', 'Mundo Natural'));
        WHEN 'Detetive' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Psicologia', 'Encontrar', 'Fotografia', 'Usar Bibliotecas', 'Lábia', 'Intimidação', 'Disfarce', 'Briga'));
        WHEN 'Jornalista' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Psicologia', 'Lábia', 'Fotografia', 'Usar Bibliotecas', 'História', 'Charme', 'Furtividade', 'Língua (Nativa)'));
        WHEN 'Professor' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Psicologia', 'Usar Bibliotecas', 'Nível de Crédito', 'Língua, Outra', 'História', 'Ciência', 'Persuasão', 'Charme'));
        WHEN 'Engenheiro' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Engenharia', 'Ciência', 'Consertos Elétricos', 'Consertos Mecânicos', 'Usar Bibliotecas', 'Geologia', 'Física', 'Matemática'));
        WHEN 'Artista' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Arte e Ofício', 'Belas Artes', 'Fotografia', 'Psicologia', 'Charme', 'Persuasão', 'Encontrar', 'Furtividade'));
        WHEN 'Soldado' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Esquivar', 'Briga', 'Furtividade', 'Primeiros Socorros', 'Sobrevivencia', 'Rifles', 'Metralhadoras', 'Intimidação'));
        WHEN 'Explorador' THEN
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE nome IN ('Antropologia', 'Arqueologia', 'Mundo Natural', 'Escalar', 'Navegação', 'Sobrevivencia', 'Rastrear', 'Armas de Fogo'));
        ELSE
            v_pericias_ocupacao_ids := ARRAY(SELECT id FROM public.pericias WHERE eh_de_ocupacao = TRUE ORDER BY random() LIMIT 8);
    END CASE;

    -- 4. Distribuir os pontos de Ocupação
    WHILE v_pontos_ocupacao > 0 LOOP
        v_pericia_escolhida_id := v_pericias_ocupacao_ids[1 + floor(random() * array_length(v_pericias_ocupacao_ids, 1))];
        v_pontos_a_gastar := LEAST(v_pontos_ocupacao, 5 + floor(random() * 11));

        INSERT INTO public.personagens_possuem_pericias (id_personagem, id_pericia, valor_atual)
        VALUES (p_id_jogador, v_pericia_escolhida_id, v_pontos_a_gastar)
        ON CONFLICT (id_personagem, id_pericia) DO UPDATE
        SET valor_atual = personagens_possuem_pericias.valor_atual + v_pontos_a_gastar;

        v_pontos_ocupacao := v_pontos_ocupacao - v_pontos_a_gastar;
    END LOOP;

    -- 5. Distribuir os pontos Pessoais
    WHILE v_pontos_pessoais > 0 LOOP
        SELECT id INTO v_pericia_escolhida_id FROM public.pericias
        WHERE id <> ALL(v_pericias_ocupacao_ids) AND nome <> 'Mythos de Cthulhu'
        ORDER BY random() LIMIT 1;

        v_pontos_a_gastar := LEAST(v_pontos_pessoais, 5 + floor(random() * 11));

        INSERT INTO public.personagens_possuem_pericias (id_personagem, id_pericia, valor_atual)
        VALUES (p_id_jogador, v_pericia_escolhida_id, v_pontos_a_gastar)
        ON CONFLICT (id_personagem, id_pericia) DO UPDATE
        SET valor_atual = personagens_possuem_pericias.valor_atual + v_pontos_a_gastar;

        v_pontos_pessoais := v_pontos_pessoais - v_pontos_a_gastar;
    END LOOP;

    -- 6. Adicionar os valores base a todas as perícias atribuídas
    FOR v_pericia_rec IN SELECT id_pericia, valor_atual FROM public.personagens_possuem_pericias WHERE id_personagem = p_id_jogador LOOP
        SELECT valor INTO v_base_valor FROM public.pericias WHERE id = v_pericia_rec.id_pericia;
        UPDATE public.personagens_possuem_pericias
        SET valor_atual = v_pericia_rec.valor_atual + v_base_valor
        WHERE id_personagem = p_id_jogador AND id_pericia = v_pericia_rec.id_pericia;
    END LOOP;

    -- 7. Adicionar/Atualizar perícias essenciais que todos devem ter
    -- CORREÇÃO: Usando ON CONFLICT para evitar erro se 'Língua (Nativa)' já foi adicionada como perícia de ocupação.
    INSERT INTO public.personagens_possuem_pericias(id_personagem, id_pericia, valor_atual)
    VALUES (p_id_jogador, (SELECT id FROM pericias WHERE nome = 'Língua (Nativa)'), v_educacao)
    ON CONFLICT (id_personagem, id_pericia) DO UPDATE SET valor_atual = personagens_possuem_pericias.valor_atual + v_educacao;

    -- Mythos de Cthulhu sempre começa em 0
    INSERT INTO public.personagens_possuem_pericias(id_personagem, id_pericia, valor_atual)
    VALUES (p_id_jogador, (SELECT id FROM pericias WHERE nome = 'Mythos de Cthulhu'), 0)
    ON CONFLICT (id_personagem, id_pericia) DO NOTHING;

END;
$$ LANGUAGE plpgsql;

/*
=================================================================================
        2. LÓGICA PARA MONSTROS
=================================================================================
*/
-- =================================================================================
--    2.1 STORED PROCEDURE: Criação de Monstros (Agressivos e Pacíficos)
-- =================================================================================
/*
A stored procedure `sp_criar_monstro` é o único ponto de entrada autorizado para criação de monstros,
sendo responsável por garantir a integridade das regras de negócio do sistema, tais como:

- **Regra de Totalidade e Exclusividade (T, E):** um monstro deve ser obrigatoriamente agressivo ou pacífico, nunca ambos.
- **Validações obrigatórias por tipo:** atributos como "vida", "tipo", "dano", "poder", entre outros, variam conforme o subtipo.
- **Prevenção de inconsistências:** evita inserção manual incorreta usando validações condicionais por `IF`.

Funcionamento:
- Recebe todos os parâmetros possíveis para ambos os tipos (agressivo e pacífico).
- Verifica o tipo (`agressivo` ou `pacífico`) e aplica regras específicas.
- Chama funções `gerar_id_monstro_*` para gerar IDs únicos e consistentes.
- Realiza inserts nas tabelas `tipos_monstro` + `agressivos` ou `pacíficos`.

Em caso de erro, captura a exceção e retorna mensagem para diagnóstico.
*/
CREATE FUNCTION public.sp_criar_monstro(
    -- Parâmetros padrão para ambas tabelas
    p_nome public.nome,
    p_descricao public.descricao,
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

-- =================================================================================
--    2.2 STORED PROCEDURE: Inspecionar detalhes de um monstro
-- =================================================================================
/*
A stored procedure `sp_inspecionar_monstro` retorna os detalhes completos de uma instância de monstro,
incluindo atributos genéricos e específicos de acordo com seu tipo (agressivo ou pacífico).

Funcionamento:
- Recebe o ID da instância (`instancias_monstros.id`);
- Faz joins com `tipos_monstro`, `agressivos` e `pacificos`;
- Usa `COALESCE` para preencher os dados genéricos e `json_build_object` para retornar os detalhes específicos;
- Retorna os dados em formato de tabela com colunas nomeadas e um campo JSON com os atributos únicos.

A consulta é segura mesmo que o monstro tenha sido removido de alguma das tabelas especializadas.
*/
CREATE OR REPLACE FUNCTION public.sp_inspecionar_monstro(
    p_id_instancia_monstro public.id_instancia_de_monstro
)
RETURNS TABLE (
    monstro_nome public.nome,
    monstro_descricao public.descricao,
    tipo_monstro public.tipo_monstro,
    vida_atual SMALLINT,
    vida_total SMALLINT,
    defesa SMALLINT,
    dano public.dano,
    detalhes_especificos JSON
)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(a.nome, p.nome),
        COALESCE(a.descricao, p.descricao),
        tm.tipo,
        im.vida,
        COALESCE(a.vida_total, p.vida_total) AS vida_total,
        COALESCE(a.defesa, p.defesa) AS defesa,
        a.dano,
        CASE
            WHEN tm.tipo = 'agressivo' THEN json_build_object(
                'tipo_agressivo', a.tipo_agressivo,
                'catalisador', a.catalisador_agressividade,
                'poder', a.poder,
                'velocidade_ataque', a.velocidade_ataque,
                'loucura_induzida', a.loucura_induzida,
                'ponto_magia', a.ponto_magia
            )
            WHEN tm.tipo = 'pacífico' THEN json_build_object(
                'tipo_pacifico', p.tipo_pacifico,
                'motivo_passividade', p.motivo_passividade,
                'conhecimento_geografico', p.conhecimento_geografico,
                'conhecimento_proibido', p.conhecimento_proibido
            )
        END AS detalhes_especificos
    FROM public.instancias_monstros im
    JOIN public.tipos_monstro tm ON im.id_monstro = tm.id
    LEFT JOIN public.agressivos a ON tm.id = a.id
    LEFT JOIN public.pacificos p ON tm.id = p.id
    WHERE im.id = p_id_instancia_monstro;
END;
$$;

/*
=================================================================================
        3. LÓGICA PARA MISSÕES
=================================================================================
*/
-- =================================================================================
--    3.1 STORED PROCEDURE: Criação de Missões
-- =================================================================================

/*
A stored procedure `sp_criar_missao` encapsula a lógica de criação de uma nova missão no jogo.

Funcionalidades:
- Recebe os dados essenciais de uma missão, como nome, descrição, tipo, ordem e o NPC associado.
- Insere os dados na tabela `public.missoes`.
- Ao inserir, a trigger `trigger_validar_dados_missao` é automaticamente executada para validar
  as regras de negócio antes da confirmação da operação.

Essa abordagem centraliza e protege o processo de criação de missões contra inconsistências.
*/
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
--    3.2 TRIGGER + FUNÇÃO: Validação de Dados da Missão
-- =================================================================================

/*
A função `func_validar_dados_missao` garante que toda missão criada ou atualizada respeite
as regras básicas de integridade.

Validações realizadas:
1. Campos obrigatórios `nome` e `descricao` não podem estar nulos ou vazios.
2. O campo `tipo` da missão não pode ser nulo.
3. A chave estrangeira `id_npc` deve referenciar um NPC existente na tabela `npcs`.

Essa função é executada automaticamente por meio da trigger `trigger_validar_dados_missao`
antes de qualquer `INSERT` ou `UPDATE` na tabela `public.missoes`.
*/
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

-- Ja comentado acima, a trigger 'trigger_validar_dados_missao' é responsável por chamar a função
CREATE TRIGGER trigger_validar_dados_missao
    BEFORE INSERT OR UPDATE ON public.missoes
    FOR EACH ROW EXECUTE FUNCTION public.func_validar_dados_missao();

/*
=================================================================================
        4. FUNÇÕES DE ITENS (GERAL)
=================================================================================
*/
-- =================================================================================
--    4.1 TRIGGER + FUNÇÃO: Validação de Atributos de Itens
-- =================================================================================

/*
A função `func_valida_atributos_item` garante que os itens inseridos ou atualizados
na tabela `itens` possuam valores válidos para seus principais atributos.

Validações realizadas:
- ID, nome e descrição não podem ser nulos.
- O valor deve estar entre 0 e 999.
- O tipo do item deve ser informado.

Essa função é disparada pela trigger `trigger_valida_atributos_item`.
*/
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

-- =================================================================================
--    4.2 TRIGGERS DE BLOQUEIO: Inserções diretas em tabelas de itens
-- =================================================================================

/*
A função `func_bloquear_insert_direto_itens` impede que usuários insiram registros
diretamente nas tabelas `itens`, `armas`, `armaduras`, `curas` e `magicos`.

Ela obriga o uso das Stored Procedures oficiais do sistema para manter a integridade
dos dados. O controle é feito por meio da variável de sessão `bd_cthulhu.inserir`.

Essa função é usada por múltiplas triggers, uma para cada tabela sensível.
*/
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
--    4.3 STORED PROCEDURE: Criação de Armas
-- =================================================================================

/*
A procedure `sp_criar_arma` cria um novo item do tipo arma no sistema, incluindo:
- Inserção no domínio pai `itens`.
- Inserção na tabela específica `armas`, com todos os atributos especializados.
- Validação da existência da perícia obrigatória "Briga".

Ela depende da configuração de sessão `bd_cthulhu.inserir = 'true'` para habilitar a inserção.
*/
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
--    4.4 TRIGGER: Exclusividade entre Arma e Armadura
-- =================================================================================

/*
A função `func_valida_exclusividade_id_arma` garante que um mesmo ID não esteja presente
nas tabelas de `armas` e `armaduras` simultaneamente.

Evita que um item tenha comportamento de múltiplos tipos físicos incompatíveis.
*/
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
--    4.5 STORED PROCEDURE: Criação de Armaduras
-- =================================================================================

/*
A procedure `sp_criar_armadura` permite a criação completa de um item do tipo armadura,
realizando:

- Inserção na tabela base `itens` com o tipo 'armadura'.
- Inserção na tabela especializada `armaduras`, com atributos específicos.
- Validação da existência da perícia obrigatória "Uso de Armadura".

O bloqueio de inserção direta é evitado ao configurar `bd_cthulhu.inserir = 'true'`.
*/
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

-- =================================================================================
--    4.6 TRIGGER: Exclusividade entre Armadura e Arma
-- =================================================================================

/*
A função `func_valida_exclusividade_id_armadura` assegura que um mesmo item
não seja classificado simultaneamente como arma e armadura.

A trigger associada bloqueia inserções ou atualizações inválidas na tabela `armaduras`.
*/
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
--         4.7.  STORED PROCEDURE PARA ITENS CONSUMÍVEIS DE CURA 
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
/*
A procedure `sp_criar_item_cura` é responsável por inserir um novo item do tipo cura
nas tabelas `itens` (base) e `curas` (especializada). Ela realiza:

- Validação de atributos obrigatórios (função, usos, efeitos mínimos e máximos).
- Geração de ID com a função `gerar_id_item_de_cura`.
- Inserção protegida por `SET LOCAL bd_cthulhu.inserir = 'true'`.

Esse procedimento assegura que todos os consumíveis de cura respeitem as regras
mínimas de jogo em termos de equilíbrio e funcionalidade.
*/
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
--    4.8 STORED PROCEDURE: Criação de Itens Mágicos
-- =================================================================================

/*
A procedure `sp_criar_item_magico` realiza a criação de um item mágico, inserindo
dados nas tabelas `itens` (genérica) e `magicos` (especializada). 

Ela verifica os seguintes critérios:

- Função mágica não nula.
- Quantidade de usos positiva.
- Custo de sanidade entre 0 e 15.
- Referência obrigatória a um feitiço válido.

Além disso, garante a integridade ao usar o parâmetro `bd_cthulhu.inserir = 'true'`
para contornar os bloqueios de trigger padrão.
*/
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

/*
O stored procedure lua_de_sangue possibilita fazer o respawn de monstros e itens no jogo,
para isso ele atualiza as instancias de monstro que não estão em um local
(montros mortos possuem id_local = NULL), em seguida ele atualiza a vida das instâncias de monstro
para o valor da vida total do respectivo monstro. Depois, ele atualiza os itens, adiciona a durabilidade
dos itens para a durabilidade total daquele item, além de fazer uma verificação para não duplicar itens
que estão no inventário do jogador.

A periodicidade da lua de sangue é determinada através de funções em python que se baseiam na hora atual do jogador.
*/

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

/*
O stored procedure sp_vasculhar_local é utilizado para poder vasculhar a sala em busca de itens 
que estão presentes nela. Para isso, ele utiliza as tabelas de instâncias de itens e itens e utiliza a
condição WHERE para pegar os itens do mesmo local do jogador. Ele retorna uma tabela com as informações de
cada um dos itens.
*/

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

/*
O stored procedure sp_adicionar_item_ao_inventario é utilizado para pegar um item que está na sala
e adicioná-lo ao inventário do jogador. Primeiro, ele verifica se o jogador atual possui um inventário,
em seguida, verifica o id_local da instância de item. Logo, ele realiza uma transação que adiciona o item da sala na tabela de 
inventários_possuem_instancias_de_item.
*/

CREATE FUNCTION public.sp_adicionar_item_ao_inventario(
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

/*
O stored procedure sp_ver_inventario é utilizado para mostrar todos 
os itens que estão presentes no inventário do jogador. Para isso ele
seleciona todos tipos de itens (verificado se ele está equipado,
caso necessário) utilizando junções com as tabelas de itens, armas, armaduras, instâncias _de_itens. O procedure retorna uma tabela 
com as informações individuais de cada item.
*/

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

/*
O stored procedure sp_encontrar_monstros_no_local tem a mesma ideia
do procedure de encontrar itens no local do jogador,, só que neste
caso ele procura por monstros. Para isso, ele faz uma pesquisa, 
procurando todos os monstros agressivos e depois os pacíficos 
daquele local que o jogador está. Ele retorna uma tabela com as 
informações individuais de cada uma das instâncias de monstro.
*/

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
)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    -- Primeiro, busca todos os monstros AGRESSIVOS no local
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
        -- Este bloco ajuda a capturar erros inesperados durante a execução
        RAISE NOTICE 'Ocorreu um erro ao encontrar monstros no local %: %', p_local_id, SQLERRM;
        RETURN;
END;
$$;

--===============================================================================
--        11. STORED PROCEDURE PARA MATAR TODOS OS MONSTROS DO LOCAL
--===============================================================================

/*
O stored procedure sp_matar_monstros_no_local é utilizado para fins
de testes no jogo. Para isso, ele faz um UPDATE em todas as instancias
de monstros que estão no mesmo local do jogador, assim, ele diminui
a vida delas para zero, e configura o id_local para NULL.
O procedure retorna quantos monstros foram mortos automaticamente.
*/

-- Somente para testes do banco

CREATE FUNCTION public.sp_matar_monstros_no_local(
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

--===============================================================================
--        12. STORED PROCEDURE PARA MOVIMENTAR OS MONSTROS AUTOMATICAMENTE
--===============================================================================

/*
A stored procedure sp_movimentar_monstros seleciona um vetor com todos os locais do tipo sala
e itera sobre cada instância de monstro mudando o seu local para um dos locais do 
vetor de salas
*/

CREATE FUNCTION public.sp_movimentar_monstros()
RETURNS VOID AS $$
DECLARE
    r_monster RECORD;
    v_new_local_id public.id_local;
    v_sala_ids public.id_local[];
BEGIN
    -- Obter todos os IDs de locais que são 'Sala'
    SELECT ARRAY(SELECT id FROM public.local WHERE tipo_local = 'Sala') INTO v_sala_ids;

    IF v_sala_ids IS NULL OR array_length(v_sala_ids, 1) = 0 THEN
        RAISE NOTICE 'Nenhuma sala encontrada para movimentar monstros.';
        RETURN;
    END IF;

    -- Iterar sobre cada instância de monstro
    FOR r_monster IN SELECT id FROM public.instancias_monstros LOOP
        -- Selecionar um ID de sala aleatoriamente
        v_new_local_id := v_sala_ids[floor(random() * array_length(v_sala_ids, 1)) + 1];

        -- Atualizar a localização do monstro
        UPDATE public.instancias_monstros
        SET id_local = v_new_local_id
        WHERE id = r_monster.id;
    END LOOP;

    RAISE NOTICE 'Monstros movimentados para novas salas.';
END;
$$ LANGUAGE plpgsql;/*
=================================================================================
        12. LÓGICA PARA BATALHAS
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--  STORED PROCEDURE: Executa uma batalha completa entre um jogador e um monstro.
-- ---------------------------------------------------------------------------------

/*
O stored procedura sp_executar_batalha cria a lógica de batalha do
jogo. Ele seleciona atributos do jogador e seu inventário, além de 
atributos do monstro e quais itens ele carrega. Em seguida cria
um loop de combate, que só termina quando a vida do jogador ou a 
do monstro chega em zero.
*/

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

/*
O stored procedura sp_entregar_missao é utilizado para entregar 
missões de um NPC para o jogador. Para isso, ele verifica se a 
missão existe e obtem o NPC que a possui, depois, encontra o item
de recompensa. Quando o jogador completa a missão, o procedure
adiciona a instância de item de recompensa no inventário do 
jogador.
*/

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

/*
O stored procedure sp_mover_jogador é utilizado para realizar as 
movimentações do jogador pelo mapa. Primeiro, ele seleciona a 
localização atual do jogador, em seguida verifica se o novo local
é adjacente ao local atual, se for ele atualiza a posição atual
do jogador para o novo local.
*/

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

/*
O stored procedure sp_desequipar_item é utilizado para poder 
desequipar uma arma ou armadura do jogador. Para isso, ele primeiro
identica qual item está no slot especificado, se o item for uma
armadura ele reverte o bônus de atributo fazendo uma pesquisa
para descobrir qual atributo deve ser revertido, depois, ele limpa
o slot do item na tabela do jogador. Se for uma arma ele apenas 
desequipa ela. Contudo, se não tiver nenhum item no slot selecionado
ele não faz nada.
*/

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

/*
O stored procedure sp_equipar_item é utilizado para equipar uma
arma ou armadura no slot de arma/armadura do jogador. Para isso,
ele primeiro verifica se o item está no inventário do jogador,
em seguida ele faz uma consulta para descobrir o tipo do item e 
suas propriedades, depois ele desequipa qualquer item que estiver 
naquele slot, depois aplica o bônus do novo item e por último
equipa o novo item no slot correspondente do jogador.
*/

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

/*
O stored procedure sp_usar_item_de_cura é utilizado para aplicar
a função de cura de vida/sanidade no jogador. Para isso, ele 
primeiro verifica se aquele item selecionado é realmente de cura
e se está no inventário do jogador, depois ele aplica os efeitos
de cura e por último o procedure diminui 1 na quantidade de usos
daquele item de cura.
*/

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

/*
O procedure func_gerenciar_durabilidade_item é utilizado para 
garantir que os itens quebrem conforme vão sendo utilizados
pelo jogador. Para isso é usa um trigger que é ativado quando a 
durabilidade de um item muda, toda vez que ela muda, ele 
verifica se a durabilidade é igual a zero, se for ele indica que 
o item quebrou.
*/

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

/*
=================================================================================
        15. FUNÇÕES DE TRANSAÇÃO (COMPRA/TRANSFERÊNCIA)
=================================================================================
*/

-- =================================================================================
--         15.1.  STORED PROCEDURE PARA TRANSFERIR ITEM DO NPC PARA O PJ
-- =================================================================================

/*
O stored procedure sp_comprar_item_do_npc é utilizado quando o 
jogador faz compras de um NPC. Para isso ele primeiro verifica o 
id do jogador, depois o id no NPC, depois ele verifica se o NPC
possui o item que o jogador quer comprar. Em seguida, ele verifica
se a quantidade de ouro do jogador é suficiente para comprar aquele 
item. Feito tudo isso ele inicia uma transação: Remove o item do
inventario do npc, adiciona o item no inventario do jogador
e por último deduz o ouro do jogador.
*/

CREATE OR REPLACE FUNCTION public.sp_comprar_item_do_npc(
    p_id_personagem_jogavel public.id_personagem_jogavel,
    p_id_npc public.id_personagem_npc,
    p_id_instancia_item public.id_instancia_de_item,
    p_valor_pago SMALLINT
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario_npc public.id_inventario;
    v_id_inventario_pj public.id_inventario;
    v_valor_item SMALLINT;
    v_ouro_jogador INTEGER;
BEGIN
    -- Validações (Jogador, NPC, Inventários)
    SELECT id_inventario, ouro INTO v_id_inventario_pj, v_ouro_jogador FROM public.personagens_jogaveis WHERE id = p_id_personagem_jogavel;
    IF NOT FOUND THEN RAISE EXCEPTION 'COMPRA FALHOU: Personagem Jogável com ID % não encontrado.', p_id_personagem_jogavel; END IF;

    SELECT id_inventario INTO v_id_inventario_npc FROM public.npcs WHERE id = p_id_npc;
    IF NOT FOUND THEN RAISE EXCEPTION 'COMPRA FALHOU: NPC com ID % não encontrado.', p_id_npc; END IF;
    IF v_id_inventario_npc IS NULL THEN RAISE EXCEPTION 'COMPRA FALHOU: O NPC não possui um inventário.'; END IF;

    -- Validações do Item
    IF NOT EXISTS (SELECT 1 FROM public.inventarios_possuem_instancias_item WHERE id_inventario = v_id_inventario_npc AND id_instancias_de_item = p_id_instancia_item) THEN
        RAISE EXCEPTION 'COMPRA FALHOU: O NPC não possui o item especificado.';
    END IF;

    SELECT i.valor INTO v_valor_item FROM public.itens i JOIN public.instancias_de_itens ii ON i.id = ii.id_item WHERE ii.id = p_id_instancia_item;
    
    -- Validações de Negócio (Ouro e Espaço)
    IF v_ouro_jogador < v_valor_item THEN RAISE EXCEPTION 'COMPRA FALHOU: Ouro insuficiente. Você tem %, mas o item custa %.', v_ouro_jogador, v_valor_item; END IF;
    -- (Adicionar verificação de espaço no inventário se necessário)

    -- === Execução da Transação ===
    -- 1. Remove o item do inventário do NPC
    DELETE FROM public.inventarios_possuem_instancias_item WHERE id_inventario = v_id_inventario_npc AND id_instancias_de_item = p_id_instancia_item;

    -- 2. Adiciona o item ao inventário do PJ
    INSERT INTO public.inventarios_possuem_instancias_item (id_inventario, id_instancias_de_item) VALUES (v_id_inventario_pj, p_id_instancia_item);

    -- 3. Deduz o ouro do jogador
    UPDATE public.personagens_jogaveis SET ouro = ouro - v_valor_item WHERE id = p_id_personagem_jogavel;

    RETURN 'Item comprado com sucesso!';
EXCEPTION
    WHEN OTHERS THEN
        RETURN SQLERRM; -- Retorna a mensagem de erro do banco
END;
$$;
--===============================================================================
--        10. STORED PROCEDURE PARA ENCONTRAR VENDEDOR NO LOCAL
--===============================================================================

/*
O stored procedure sp_encontrar_vendedor_no_local é utilizado para encontrar os NPCs que estão no mesmo local do jogador. Em seguida,
ele mostra os itens do inventário do NPC para o jogador.
*/

CREATE OR REPLACE FUNCTION public.sp_encontrar_vendedor_no_local(p_id_local public.id_local)
RETURNS TABLE (
    id_personagem_npc public.id_personagem_npc,
    nome public.nome,
    ocupacao public.ocupacao,
    idade public.idade,
    sexo public.sexo,
    residencia public.residencia,
    local_nascimento public.local_nascimento,
    id_local public.id_local,
    id_inventario public.id_inventario,
    script_dialogo public.script_dialogo
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Retorna todos os Vendedores que estão atualmente no local especificado, incluindo um de seus diálogos.
    RETURN QUERY
    SELECT
        n.id,
        n.nome,
        n.ocupacao,
        n.idade,
        n.sexo,
        n.residencia,
        n.local_nascimento,
        n.id_local,
        n.id_inventario,
        (SELECT d.script_dialogo FROM public.dialogos d WHERE d.npc_id = n.id LIMIT 1)
    FROM
        public.npcs AS n
    WHERE
        -- Filtra para buscar apenas NPCs no local especificado que sejam vendedores.
        n.id_local = p_id_local AND n.ocupacao LIKE 'Vendedor%';
END;
$$;

CREATE OR REPLACE FUNCTION public.sp_ver_inventario_npc(
        p_npc_id public.id_personagem_npc
    )
    RETURNS TABLE (
        -- Colunas da Instância
        instancia_item_id public.id_instancia_de_item,
        durabilidade_atual SMALLINT,
        
        -- Colunas Gerais do Item Base (tabela itens)
        item_nome public.nome,
        item_descricao public.descricao,
        item_tipo public.tipo_item,
        item_valor SMALLINT,
        durabilidade_total SMALLINT,

        -- Colunas de Equipamentos (armas e armaduras)
        dano public.dano,
        alcance SMALLINT,
        tipo_municao public.tipo_municao,
        qtd_dano_mitigado SMALLINT,
        atributo_necessario public.tipo_atributo_personagem,
        qtd_atributo_necessario SMALLINT,
        
        -- Colunas de Itens Consumíveis (cura e magicos)
        qts_usos SMALLINT,
        qtd_pontos_vida_recupera SMALLINT,
        qtd_pontos_sanidade_recupera SMALLINT,
        custo_sanidade SMALLINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario public.id_inventario;
BEGIN
    -- Busca o ID do inventário do NPC especificado
    SELECT id_inventario INTO v_id_inventario
    FROM public.npcs
    WHERE id = p_npc_id;

    IF v_id_inventario IS NULL THEN
        RAISE NOTICE 'NPC com ID % nao encontrado ou nao possui um inventario associado.', p_npc_id;
        RETURN;
    END IF;

    -- Retorna a consulta com os dados do inventário do NPC
    RETURN QUERY
    SELECT
        -- Dados da Instância
        iii.id,
        iii.durabilidade,
        
        -- Dados Gerais do Item
        it.nome,
        it.descricao,
        it.tipo,
        it.valor,
        COALESCE(a.durabilidade, ar.durabilidade),
        
        -- Atributos Específicos (serão NULL se o item não for do tipo correspondente)
        a.dano,
        a.alcance,
        a.tipo_municao,
        ar.qtd_dano_mitigado,
        COALESCE(a.atributo_necessario, ar.atributo_necessario),
        COALESCE(a.qtd_atributo_necessario, ar.qtd_atributo_necessario),
        COALESCE(c.qts_usos, m.qts_usos),
        c.qtd_pontos_vida_recupera,
        c.qtd_pontos_sanidade_recupera,
        m.custo_sanidade
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
    LEFT JOIN
        public.curas c ON it.id = c.id
    LEFT JOIN
        public.magicos m ON it.id = m.id
    WHERE
        ipii.id_inventario = v_id_inventario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao verificar o inventario do NPC %: %', p_npc_id, SQLERRM;
        RETURN;
END;
$$;

CREATE OR REPLACE FUNCTION public.sp_jogador_vende_item(
    p_id_jogador public.id_personagem_jogavel,
    p_id_npc public.id_personagem_npc,
    p_id_instancia_item public.id_instancia_de_item
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario_pj public.id_inventario;
    v_id_inventario_npc public.id_inventario;
    v_valor_item SMALLINT;
BEGIN
    -- === VALIDAÇÕES ===
    -- 1. Verifica se o jogador existe e tem o item no inventário
    SELECT id_inventario INTO v_id_inventario_pj FROM public.personagens_jogaveis WHERE id = p_id_jogador;
    IF NOT FOUND THEN RAISE EXCEPTION 'VENDA FALHOU: Jogador com ID % não encontrado.', p_id_jogador; END IF;

    IF NOT EXISTS (SELECT 1 FROM public.inventarios_possuem_instancias_item WHERE id_inventario = v_id_inventario_pj AND id_instancias_de_item = p_id_instancia_item) THEN
        RAISE EXCEPTION 'VENDA FALHOU: Você não possui este item em seu inventário.';
    END IF;

    -- 2. Verifica se o NPC existe e tem um inventário para receber o item
    SELECT id_inventario INTO v_id_inventario_npc FROM public.npcs WHERE id = p_id_npc;
    IF NOT FOUND THEN RAISE EXCEPTION 'VENDA FALHOU: NPC com ID % não encontrado.', p_id_npc; END IF;
    IF v_id_inventario_npc IS NULL THEN RAISE EXCEPTION 'VENDA FALHOU: Este NPC não pode comprar itens (não tem inventário).'; END IF;

    -- 3. Impede a venda de itens equipados
    IF EXISTS (SELECT 1 FROM public.personagens_jogaveis WHERE id = p_id_jogador AND (id_arma = p_id_instancia_item OR id_armadura = p_id_instancia_item)) THEN
        RAISE EXCEPTION 'VENDA FALHOU: Você não pode vender um item que está equipado. Desequipe-o primeiro.';
    END IF;

    -- Pega o valor do item
    SELECT i.valor INTO v_valor_item FROM public.itens i JOIN public.instancias_de_itens ii ON i.id = ii.id_item WHERE ii.id = p_id_instancia_item;
    IF v_valor_item IS NULL THEN v_valor_item := 0; END IF;

    -- === TRANSAÇÃO ===
    -- 1. Remove o item do inventário do jogador
    DELETE FROM public.inventarios_possuem_instancias_item WHERE id_inventario = v_id_inventario_pj AND id_instancias_de_item = p_id_instancia_item;

    -- 2. Adiciona o item ao inventário do NPC
    INSERT INTO public.inventarios_possuem_instancias_item (id_inventario, id_instancias_de_item) VALUES (v_id_inventario_npc, p_id_instancia_item);

    -- 3. Adiciona o ouro ao jogador
    UPDATE public.personagens_jogaveis SET ouro = ouro + v_valor_item WHERE id = p_id_jogador;

    RETURN 'Item vendido com sucesso por ' || v_valor_item || ' de ouro!';
EXCEPTION
    WHEN OTHERS THEN
        RETURN SQLERRM; -- Retorna a mensagem de erro do banco
END;
$$;

/*
=================================================================================
        15. LÓGICA DE MECÂNICAS AVANÇADAS DE JOGO
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--  15.1 FUNÇÃO E TRIGGER: Gerenciamento de Sanidade e Loucura
-- ---------------------------------------------------------------------------------
-- Função que é chamada por uma trigger sempre que a sanidade do jogador é alterada.
CREATE OR REPLACE FUNCTION public.func_verificar_insanidade()
RETURNS TRIGGER AS $$
BEGIN
    -- Se a sanidade chegar a zero, o personagem enlouquece permanentemente.
    IF NEW.sanidade_atual <= 0 THEN
        NEW.sanidade_atual := 0;
        NEW.insanidade_indefinida := TRUE;
        RAISE NOTICE 'ALERTA: O personagem % (ID: %) sucumbiu à loucura permanente!', NEW.nome, NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que ativa a função acima sempre que a coluna 'sanidade_atual' é atualizada.
CREATE TRIGGER trigger_checar_insanidade_personagem
    BEFORE UPDATE ON public.personagens_jogaveis
    FOR EACH ROW
    WHEN (OLD.sanidade_atual IS DISTINCT FROM NEW.sanidade_atual)
    EXECUTE FUNCTION public.func_verificar_insanidade();

-- Procedure para aplicar dano à sanidade do jogador.
CREATE OR REPLACE FUNCTION public.sp_aplicar_dano_sanidade(
    p_id_jogador public.id_personagem_jogavel,
    p_quantidade_dano SMALLINT
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_sanidade_restante SMALLINT;
BEGIN
    UPDATE public.personagens_jogaveis
    SET sanidade_atual = sanidade_atual - p_quantidade_dano
    WHERE id = p_id_jogador
    RETURNING sanidade_atual INTO v_sanidade_restante;

    RETURN 'Você perdeu ' || p_quantidade_dano || ' pontos de sanidade. Sanidade restante: ' || v_sanidade_restante;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocorreu um erro ao aplicar dano de sanidade: %', SQLERRM;
        RAISE;
END;
$$;

-- ---------------------------------------------------------------------------------
--  15.2 STORED PROCEDURE: Realizar um teste de perícia
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_realizar_teste_pericia(
    p_id_jogador public.id_personagem_jogavel,
    p_nome_pericia public.nome
)
RETURNS BOOLEAN -- Retorna TRUE para sucesso, FALSE para falha.
LANGUAGE plpgsql AS $$
DECLARE
    v_valor_pericia SMALLINT;
    v_rolagem_d100 SMALLINT;
BEGIN
    -- 1. Busca o valor da perícia para o jogador.
    SELECT ppp.valor_atual INTO v_valor_pericia
    FROM public.personagens_possuem_pericias ppp
    JOIN public.pericias p ON ppp.id_pericia = p.id
    WHERE ppp.id_personagem = p_id_jogador AND p.nome = p_nome_pericia;

    -- Se o jogador não tiver a perícia, assume um valor base ou falha.
    IF NOT FOUND THEN
        SELECT valor INTO v_valor_pericia FROM public.pericias WHERE nome = p_nome_pericia;
        IF NOT FOUND THEN
             RAISE EXCEPTION 'Perícia % não existe no sistema.', p_nome_pericia;
        END IF;
    END IF;

    -- 2. Rola um dado de 100 lados (d100).
    v_rolagem_d100 := floor(random() * 100 + 1);

    RAISE NOTICE 'Teste de %: Valor da perícia: %, Rolagem (d100): %', p_nome_pericia, v_valor_pericia, v_rolagem_d100;

    -- 3. Compara a rolagem com o valor da perícia.
    IF v_rolagem_d100 <= v_valor_pericia THEN
        RAISE NOTICE 'Sucesso!';
        RETURN TRUE;
    ELSE
        RAISE NOTICE 'Falha.';
        RETURN FALSE;
    END IF;
END;
$$;

/*
=================================================================================
        18. LÓGICA DE BATALHA (NOVO - POR TURNO) E UTILITÁRIOS
=================================================================================
*/

-- ---------------------------------------------------------------------------------
--  18.1 STORED PROCEDURE: Executa UM turno de batalha.
--  Esta função calcula o dano do jogador no monstro e do monstro no jogador,
--  atualiza a vida de ambos e retorna o resultado do turno.
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_executar_turno_batalha(
    p_id_jogador public.id_personagem_jogavel,
    p_id_instancia_monstro public.id_instancia_de_monstro
)
RETURNS TABLE (
    log_turno TEXT,
    vida_jogador_nova SMALLINT,
    vida_monstro_nova SMALLINT
)
LANGUAGE plpgsql AS $$
DECLARE
    -- Variáveis do Jogador
    v_jogador RECORD;
    v_dano_jogador SMALLINT;

    -- Variáveis do Monstro
    v_monstro RECORD;
    v_dano_monstro SMALLINT;

    -- Lógica do Turno
    v_dano_final_no_monstro SMALLINT;
    v_dano_final_no_jogador SMALLINT;
    v_log TEXT := '';
BEGIN
    -- 1. BUSCAR DADOS DO JOGADOR (incluindo força para dano desarmado)
    SELECT
        pj.nome,
        pj.pontos_de_vida_atual,
        pj.forca,
        COALESCE(a.dano, 0) as dano_arma, -- Dano da arma, ou 0 se desarmado
        COALESCE(ar.qtd_dano_mitigado, 0) as defesa_armadura
    INTO v_jogador
    FROM public.personagens_jogaveis pj
    LEFT JOIN public.instancias_de_itens ii_arma ON pj.id_arma = ii_arma.id
    LEFT JOIN public.armas a ON ii_arma.id_item = a.id
    LEFT JOIN public.instancias_de_itens ii_armadura ON pj.id_armadura = ii_armadura.id
    LEFT JOIN public.armaduras ar ON ii_armadura.id_item = ar.id
    WHERE pj.id = p_id_jogador;

    -- MELHORIA: Dano desarmado agora é baseado na Força. Se tiver arma, usa o dano da arma.
    IF v_jogador.dano_arma > 0 THEN
        v_dano_jogador := v_jogador.dano_arma;
    ELSE
        v_dano_jogador := floor(v_jogador.forca / 5) + 1; -- Ex: 10 de Força = 3 de dano
    END IF;

    -- 2. BUSCAR DADOS DO MONSTRO
    SELECT im.vida, ag.nome, ag.dano, COALESCE(ag.defesa, 0) as defesa
    INTO v_monstro
    FROM public.instancias_monstros im
    JOIN public.agressivos ag ON im.id_monstro = ag.id
    WHERE im.id = p_id_instancia_monstro;

    -- 3. CALCULAR DANO E ATUALIZAR VIDAS
    v_dano_final_no_monstro := GREATEST(0, v_dano_jogador - v_monstro.defesa);
    UPDATE public.instancias_monstros SET vida = vida - v_dano_final_no_monstro WHERE id = p_id_instancia_monstro RETURNING vida INTO vida_monstro_nova;
    v_log := v_log || v_jogador.nome || ' ataca ' || v_monstro.nome || ' causando ' || v_dano_final_no_monstro || ' de dano.';

    IF vida_monstro_nova > 0 THEN
        v_dano_final_no_jogador := GREATEST(0, v_monstro.dano - v_jogador.defesa_armadura);
        UPDATE public.personagens_jogaveis SET pontos_de_vida_atual = pontos_de_vida_atual - v_dano_final_no_jogador WHERE id = p_id_jogador RETURNING pontos_de_vida_atual INTO vida_jogador_nova;
        v_log := v_log || ' ' || v_monstro.nome || ' revida, causando ' || v_dano_final_no_jogador || ' de dano.';
    ELSE
        vida_jogador_nova := v_jogador.pontos_de_vida_atual;
    END IF;

    -- 4. RETORNAR
    log_turno := v_log;
    RETURN NEXT;
END;
$$;

-- ---------------------------------------------------------------------------------
--  18.2 STORED PROCEDURE: Ataque somente do monstro (para quando o jogador falha em uma ação)
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_monstro_ataca_sozinho(
    p_id_jogador public.id_personagem_jogavel,
    p_id_instancia_monstro public.id_instancia_de_monstro
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_defesa_jogador SMALLINT;
    v_dano_monstro SMALLINT;
    v_nome_monstro public.nome;
    v_dano_final_no_jogador SMALLINT;
BEGIN
    -- Busca dados do jogador e do monstro
    SELECT COALESCE(ar.qtd_dano_mitigado, 0) INTO v_defesa_jogador FROM public.personagens_jogaveis pj LEFT JOIN public.instancias_de_itens ii_armadura ON pj.id_armadura = ii_armadura.id LEFT JOIN public.armaduras ar ON ii_armadura.id_item = ar.id WHERE pj.id = p_id_jogador;
    SELECT COALESCE(ag.nome, pa.nome), ag.dano INTO v_nome_monstro, v_dano_monstro FROM public.instancias_monstros im JOIN public.tipos_monstro tm ON im.id_monstro = tm.id LEFT JOIN public.agressivos ag ON im.id_monstro = ag.id LEFT JOIN public.pacificos pa ON im.id_monstro = pa.id WHERE im.id = p_id_instancia_monstro;

    -- Calcula e aplica o dano
    v_dano_final_no_jogador := GREATEST(0, v_dano_monstro - v_defesa_jogador);
    UPDATE public.personagens_jogaveis SET pontos_de_vida_atual = pontos_de_vida_atual - v_dano_final_no_jogador WHERE id = p_id_jogador;

    RETURN v_nome_monstro || ' aproveita sua hesitação e ataca, causando ' || v_dano_final_no_jogador || ' de dano!';
END;
$$;

-- ---------------------------------------------------------------------------------
--  18.3 STORED PROCEDURE: Resetar o status do jogador após a morte
-- ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sp_resetar_status_jogador(
    p_id_jogador public.id_personagem_jogavel
)
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
    v_vida_max SMALLINT;
    v_sanidade_max SMALLINT;
BEGIN
    -- Calcula a vida e sanidade máximas usando as funções existentes
    SELECT public.calcular_pts_de_vida(constituicao, tamanho), public.calcular_sanidade(poder)
    INTO v_vida_max, v_sanidade_max
    FROM public.personagens_jogaveis
    WHERE id = p_id_jogador;

    -- Atualiza a vida e sanidade atuais para seus valores máximos
    UPDATE public.personagens_jogaveis
    SET
        pontos_de_vida_atual = v_vida_max,
        sanidade_atual = v_sanidade_max -- Opcional: resetar sanidade também
    WHERE id = p_id_jogador;
END;
$$; 
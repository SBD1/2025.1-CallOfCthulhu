/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 10/06/2025
Descrição: Criando inserts iniciais nas tabelas templos, andares, salas, corredores e corredores_salas_destino.
Autor: Cayo, Igor

Versão: 0.2
Data: 10/06/2025
Descrição: Criando inserts iniciais nas tabelas templos, andares, salas, corredores e corredores_salas_destino.
Autor: Christopher, João Marcos

*/
-- ===============================================  

--            INSERT DE DADOS

-- ===============================================

-- TABELA INVENTÁRIOS
INSERT INTO public.inventarios (id, tamanho) VALUES (2, 32);

-- TABELA PERSONAGENS_JOGAVEIS
INSERT INTO public.personagens_jogaveis(
    id, nome, ocupacao, residencia, local_nascimento,
    idade, sexo,
    forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao,
    movimento,
    sanidade_atual, insanidade_temporaria, insanidade_indefinida,
    PM_base, PM_max,
    pontos_de_vida_atual,
    id_sala, id_corredor, id_inventario, id_armadura, id_arma, id_tipo_personagem
) VALUES (
    1, 'Samuel Carter', 'Doutor em Medicina', 'Arkham, MA', 'Boston, MA',
    42, 'masculino',
    10, 12, 12, 8, 15, 17, 13, 12,
    7,
    12, FALSE, FALSE,
    10, 10,
    100,
    1, NULL, 1, NULL, NULL, 1
);

INSERT INTO public.tipos_personagem (id, nome, descricao) VALUES
(1, 'Personagem Jogável', 'Personagens que os jogadores controlam durante a aventura.'),
(2, 'NPC', 'Personagens não jogáveis que interagem com os jogadores.'),
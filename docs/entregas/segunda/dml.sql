/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 10/06/2025
Descrição: Criando inserts iniciais nas tabelas templos, andares, salas, corredores e corredores_salas_destino.
Autor: Cayo, Igor

Versão: 0.2
Data: 10/06/2025
Descrição: Criando inserts iniciais nas tabelas inventários, salas, tipo_personagem, personagens_jogaveis, corredores, corredores_salas_destino, perícias e personagens_possuem_pericias.
Autor: Christopher, João Marcos

Versão: 0.3
Data: 11/06/2025
Descrição: Adicionando exemplos de NPCs e diálogos. Completando tabela de perícias.
Autor: Christopher, João Marcos

Versão: 0.4
Data: 11/06/2025
Descrição: Adicionando exemplos de monstros, tanto agressivos quanto pacíficos, e suas respectivas tabelas.
Autor: Christopher, João Marcos

Versão: 0.5
Data: 11/06/2025
Descrição: Adicionando exemplos de itens, e suas respectivas tabelas.
Autor: Christopher, João Marcos

Versão: 0.6
Data: 11/06/2025
Descrição: Adicionando exemplos de instancias de monstros e itens, e suas respectivas tabelas.
Autor: Christopher, João Marcos
*/
-- ===============================================

--            INSERT DE DADOS

-- ===============================================

-- TABELA INVENTÁRIOS

INSERT INTO public.inventarios 
            (id, tamanho)
    VALUES  (1, 32);

-- TABELA SALAS (EXEMPLOS)

INSERT INTO public.salas 
            (id, descricao)
    VALUES  (1, 'Salão Principal do Templo'),
            (2, 'Sala dos Murmúrios Antigos'),
            (3, 'Câmara Secreta do Templo'),
            (4, 'Tumba Esquecida'),
            (5, 'Arsenal Abandonado'),
            (6, 'Biblioteca Proibida');

-- TABELA TIPOS_PERSONAGEM

INSERT INTO public.tipos_personagem 
            (id, tipo)
    VALUES  (1, 'personagem jogavel'),
            (2, 'NPC');

-- TABELA PERSONAGENS_JOGAVEIS

INSERT INTO public.personagens_jogaveis
            (id, nome, ocupacao, residencia, local_nascimento, 
            idade, sexo, 
            forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, 
            sanidade_atual, insanidade_temporaria, insanidade_indefinida, 
            PM_base, PM_max, 
            pontos_de_vida_atual, 
            id_sala, id_corredor, 
            id_inventario, id_armadura, id_arma, id_tipo_personagem)
    VALUES (1, 'Samuel Carter', 'Doutor em Medicina', 'Arkham, MA', 'Boston, MA', 
            42, 'masculino', 
            10, 12, 12, 8, 15, 17, 13, 12, 7, 
            12, FALSE, FALSE, 
            10, 10, 
            100, 
            1, NULL, 
            1, NULL, NULL, 1),
            (2, 'Sarah Thompson', 'Arqueóloga', 'Boston, MA', 'Boston, MA',
            35, 'feminino',
            8, 10, 11, 14, 16, 15, 14, 13, 8,
            11, FALSE, FALSE,
            8, 8,
            80,
            2, NULL,
            1, NULL, NULL, 1);

-- TABELA NPCs

INSERT INTO public.npcs 
                (id, nome, ocupacao, idade, sexo, residencia, local_nascimento, id_tipo_personagem, id_sala)
        VALUES  (101, 'Velho Sábio', 'Guardião do Templo', 70, 'masculino', 'Templo das Sombras', 'Arkham', 2, 1 ),
                (102, 'Guarda do Templo', 'Protetor das Relíquias', 45, 'masculino', 'Templo das Sombras', 'Arkham', 2, 2),
                (103, 'Sacerdotisa Sombria', 'Mestre dos Rituais', 50, 'feminino', 'Templo das Sombras', 'Arkham', 2, 3);

-- TABELA DIALOGOS

INSERT INTO public.dialogos 
                (id, script_dialogo, npc_id)
        VALUES  (1, 'Viajante, cuidado com as sombras do templo! Elas consomem até a alma mais forte.', 101),
                (2, 'Eu já vi coisas que fariam um homem enlouquecer... *suspira* ' || 'As paredes deste lugar sussurram segredos antigos. Não confie nelas.', 101);

-- TABELA CORREDORES

INSERT INTO public.corredores 
            (id, status, descricao)
    VALUES  (1, TRUE, 'Corredor Principal do Templo'),
            (2, TRUE, 'Corredor Secundário do Templo'),
            (3, TRUE, 'Corredor de Emergência do Templo'),
            (4, FALSE, 'Corredor de Acesso Restrito do Templo'),
            (5, FALSE, 'Corredor de Manutenção do Templo'),
            (6, FALSE, 'Corredor de Descarte do Templo');

-- TABELA CORREDORES_SALA_DESTINO

INSERT INTO public.corredores_salas_destino 
            (id_sala, id_corredor)
    VALUES  (1, 1),
            (2, 1),
            (2, 2),
            (3, 2),
            (3, 3),
            (4, 3),
            (4, 4),
            (5, 4),
            (5, 5),
            (6, 5),
            (6, 6);

-- TABELA PERÍCIAS 

INSERT INTO public.pericias 
            (id, nome, valor, eh_de_ocupacao)
    VALUES  (1, 'Antropologia', 1, FALSE), -- 01%
            (2, 'Armas de Fogo', 0, FALSE), -- varia
            (3, 'Arqueologia', 1, FALSE), -- 01%
            (4, 'Arremessar', 20, FALSE), -- 20%
            (5, 'Arte e Ofício', 5, FALSE), -- 05%
            (6, 'Artilharia', 1, FALSE), -- 01%
            (7, 'Astronomia', 1, FALSE), -- 01%, ver Ciência
            (8, 'Atuação', 5, FALSE), -- 05%, ver Arte/Ofício
            (9, 'Avaliação', 5, FALSE), -- 05%
            (10, 'Belas Artes', 5, FALSE), -- 05%, ver Arte/Ofício
            (11, 'Biologia', 1, FALSE), -- 01%, ver Ciência
            (12, 'Botânica', 1, FALSE), -- 01%, ver Ciência
            (13, 'Briga', 25, FALSE), -- 25%, ver Lutar
            (14, 'Cavalgar', 5, FALSE), -- 05%
            (15, 'Charme', 15, FALSE), -- 15%
            (16, 'Chaveiro', 1, FALSE), -- 01%
            (17, 'Chicotes', 5, FALSE), -- 05%, ver Lutar
            (18, 'Ciência', 1, FALSE), -- 01%
            (19, 'Ciência Forense', 1, FALSE), -- 01%, ver Ciência
            (20, 'Conhecimento', 1, FALSE), -- 01%
            (21, 'Consertos Elétricos', 10, FALSE), -- 10%
            (22, 'Consertos Mecânicos', 10, FALSE), -- 10%
            (23, 'Contabilidade', 5, FALSE), -- 05%
            (24, 'Criptografia', 1, FALSE), -- 01%, ver Ciência
            (25, 'Demolições', 1, FALSE), -- 01%
            (26, 'Direito', 5, FALSE), -- 05%
            (27, 'Dirigir Automóveis', 20, FALSE), -- 20%
            (28, 'Disfarce', 5, FALSE), -- 05%
            (29, 'Eletrônica', 1, FALSE), -- 01%
            (30, 'Encontrar', 25, FALSE), -- 25%
            (31, 'Engenharia', 1, FALSE), -- 01%, ver Ciência
            (32, 'Escalar', 20, FALSE), -- 20%
            (33, 'Espingardas', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            (34, 'Escutar', 20, FALSE), -- 20%
            (35, 'Espadas', 20, FALSE), -- 20%, ver Lutar
            (36, 'Esquivar', 0, FALSE), -- == destreza / 2
            (37, 'Falsificação', 5, FALSE), -- 05%, ver Arte/Ofício
            (38, 'Farmácia', 1, FALSE), -- 01%, ver Ciência
            (39, 'Física', 1, FALSE), -- 01%, ver Ciência
            (40, 'Fotografia', 5, FALSE), -- 05%, ver Arte/Ofício
            (41, 'Furtividade', 20, FALSE), -- 20%
            (42, 'Garrote', 15, FALSE), -- 15%, ver Lutar
            (43, 'Geologia', 1, FALSE), -- 01%, ver Ciência
            (44, 'Hipnose', 1, FALSE), -- 01%
            (45, 'História', 5, FALSE), -- 05%
            (46, 'Intimidação', 15, FALSE), -- 15%
            (47, 'Lábia', 5, FALSE), -- 05%
            (48, 'Lança-Chamas', 10, FALSE), -- 10%, ver Armas de Fogo
            (49, 'Lanças', 20, FALSE), -- 20%, ver Lutar/Arremessar
            (50, 'Leitura Labial', 1, FALSE), -- 01%
            (51, 'Língua (Nativa)', 0, FALSE), -- == educacao
            (52, 'Língua, Outra', 1, FALSE), -- 01%
            (53, 'Lutar', 0, FALSE), -- varia
            (54, 'Machados', 15, FALSE), -- 15%, ver Lutar
            (55, 'Manguais', 10, FALSE), -- 10%, ver Lutar
            (56, 'Matemática', 1, FALSE), -- 01%, ver Ciência
            (57, 'Medicina', 1, TRUE), -- 01%
            (58, 'Mergulho', 1, FALSE), -- 01%
            (59, 'Meteorologia', 1, FALSE), -- 01%, ver Ciência
            (60, 'Metralhadoras', 10, FALSE), -- 10%, ver Armas de Fogo
            (61, 'Motosserras', 10, FALSE), -- 10%, ver Lutar
            (62, 'Mundo Natural', 10, FALSE), -- 10%
            (63, 'Mythos de Cthulhu', 0, FALSE), -- 00%
            (64, 'Natação', 20, FALSE), -- 20%
            (65, 'Navegação', 10, FALSE), -- 10%
            (66, 'Nível de Crédito', 0, FALSE), -- 00%
            (67, 'Ocultismo', 5, FALSE), -- 05%
            (68, 'Operar Maquinário Pesado', 1, FALSE), -- 01%
            (69, 'Persuasão', 10, FALSE), -- 10%
            (70, 'Pilotar', 1, FALSE), -- 01%
            (71, 'Pistolas', 20, FALSE), -- 20%, ver Armas de Fogo
            (72, 'Prestidigitação', 10, FALSE), -- 10%
            (73, 'Primeiros Socorros', 30, FALSE), -- 30%
            (74, 'Psicanálise', 1, FALSE), -- 01%
            (75, 'Psicologia', 10, FALSE), -- 10%
            (76, 'Química', 1, FALSE), -- 01%, ver Ciência
            (77, 'Rastrear', 10, FALSE), -- 10%
            (78, 'Rifles', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            (79, 'Saltar', 20, FALSE), -- 20%
            (80, 'Sobrevivência', 10, FALSE), -- 10%
            (81, 'Submetralhadoras', 15, FALSE), -- 15%, ver Armas de Fogo
            (82, 'Treinar Animais', 5, FALSE), -- 05%
            (83, 'Usar Bibliotecas', 20, FALSE), -- 20%
            (84, 'Usar Computadores', 5, FALSE), -- 05%
            (85, 'Zoologia', 1, FALSE); -- 01%, ver Ciência

-- TABELA PERSONAGENS_POSSUEM_PERICIAS

INSERT INTO public.personagens_possuem_pericias 
            (id_personagem, id_pericia, valor_atual)
    VALUES  (1, 57, 1), -- Medicina
            (1, 73, 1), -- Primeiros Socorros
            (1, 11, 1), -- Biologia
            (1, 12, 1), -- Botânica
            (1, 18, 1), -- Ciência
            (1, 19, 1), -- Ciência Forense
            (1, 32, 20), -- Escalar
            (1, 34, 20), -- Escutar
            (1, 41, 20), -- Furtividade
            (1, 53, 0), -- Lutar
            (1, 63, 0), -- Mythos de Cthulhu
            (1, 66, 0), -- Nível de Crédito
            (1, 62, 10), -- Mundo Natural
            (1, 71, 20), -- Pistolas
            (1, 78, 25), -- Rifles
            (1, 77, 1), -- Química
            (1, 83, 20), -- Usar Bibliotecas
            (1, 84, 5); -- Usar Computadores

-- MONSTROS 

INSERT INTO public.tipos_monstro 
            (id, tipo)
    VALUES  (1,'agressivo'), -- Para Abominável Horrores
            (2,'agressivo'), -- Para Carnífice Sombrio
            (3,'agressivo'), -- Para Mago da Corrupção
            (4,'pacífico'), -- Para Espírito Guardião
            (5,'pacífico'); -- Para Eremita do Templo

-- TABELA MONSTROS AGRESSIVOS

INSERT INTO public.agressivos 
        (id, nome, descricao, defesa, vida, catalisador_agressividade, poder, tipo_agressivo, velocidade_ataque, loucura_induzida, ponto_magia, dano)
VALUES  (1, 'Abominável Horrores', 'Criatura grotesca que se esconde nas sombras, devorando a sanidade.', 10, 50, 'proximidade', 15, 'psiquico', 5, 20, 10, 30),
        (2, 'Carnífice Sombrio', 'Um monstro com garras afiadas, rápido e implacável.', 12, 60, 'ataque_direto', 10, 'fisico', 8, 0, 0, 40),
        (3, 'Mago da Corrupção', 'Uma entidade mágica que distorce a realidade com seus feitiços.', 8, 40, 'barulho_alto', 20, 'magico', 4, 15, 25, 25);

-- TABELA MONSTROS PACÍFICOS

INSERT INTO public.pacificos 
        (id, nome, descricao, defesa, vida, motivo_passividade, tipo_pacifico, conhecimento_geografico, conhecimento_proibido)
VALUES  (4, 'Espírito Guardião', 'Um espírito antigo que protege certas áreas, mas não ataca a menos que provocado.', 5, 30, 'indiferente', 'sobrenatural', 'Conhece todos os caminhos do templo.', 'Nenhum.'),
        (5, 'Eremita do Templo', 'Um humanoide recluso que vive no templo, buscando conhecimento.', 7, 25, 'amigavel', 'humanoide', 'Mapas mentais detalhados do andar superior.', 'Histórias de rituais proibidos.');   

-- TABELA ITENS

INSERT INTO public.itens 
        (id, tipo, nome, descricao, valor)
VALUES  (1, 'arma', 'Adaga Simples', 'Uma adaga enferrujada.', 5);   

-- TABELA INSTÂNCIA DE ITENS

INSERT INTO public.instancias_de_itens 
        (id, durabilidade, id_sala, id_missao_requer, id_missao_recompensa, id_item)
VALUES  (1, 100, 1, NULL, NULL, 1); -- Uma adaga simples no Salão Principal

-- TABELA INSTÂNCIA DE MONSTROS

INSERT INTO public.instancias_monstros 
        (id, id_monstro, id_sala, id_corredor, id_instancia_de_item)
VALUES  (1, 1, 3, NULL, 1),-- Uma instância do Abominável Horrores na Câmara Secreta, com a Adaga Simples
        (2, 2, NULL, 1, 1), -- Uma instância do Carnífice Sombrio no Corredor Principal, com a Adaga Simples
        (3, 4, 4, NULL, 1), -- Uma instância do Espírito Guardião na Tumba Esquecida, com a Adaga Simples
        (4, 5, 6, NULL, 1); -- Uma instância do Eremita do Templo na Biblioteca Proibida, com a Adaga Simples
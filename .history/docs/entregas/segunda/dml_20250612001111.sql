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

Versão: 0.7
Data: 11/06/2025
Descrição: Adicionando exemplos de missões e batalhas, e suas respectivas tabelas.
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
            3, NULL, 
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

-- TABELA MISSÕES

INSERT INTO public.missoes 
        (id, nome, descricao, tipo, ordem, id_npc)
VALUES  (1, 'A Súplica do Ancião', 'O Velho Sábio precisa que você recupere um artefato roubado das profundezas do templo.', 'principal', 'Encontre o artefato na Tumba Esquecida (Sala 4).', 101),
        (2, 'Relíquias Perdidas', 'O Guarda do Templo precisa de ajuda para localizar relíquias dispersas pelo Corredor Principal.', 'coleta', 'Procure por 3 fragmentos de relíquias no Corredor Principal (Corredor 1).', 102),
        (3, 'Purificação do Santuário', 'A Sacerdotisa Sombria pede que você extermine uma criatura maligna na Câmara Secreta.', 'eliminacao', 'Derrote o Abominável Horrores na Câmara Secreta (Sala 3).', 103);


 -- TABELA ENTREGA DE MISSÕES

INSERT INTO public.entregas_missoes 
            (id_jogador, id_npc)
    VALUES  (1, 101),-- Samuel Carter entregou uma missão ao Velho Sábio
            (2, 102); -- Sarah Thompson entregou uma missão ao Guarda do Templo 

-- TABELA BATALHAS

INSERT INTO public.batalhas 
            (id_jogador, id_monstro)
    VALUES  (1, 1),-- Samuel Carter batalhou contra o Abominável Horrores (instância 1)
            (2, 2),-- Sarah Thompson batalhou contra o Carnífice Sombrio (instância 2)
            (1, 2); -- Samuel Carter também batalhou contra o Carnífice Sombrio (instância 2)
INSERT INTO public.salas 
            (id, descricao) 
    VALUES  (1, 'O ar pesa como um véu úmido, carregado do sal podre de eras esquecidas. As paredes de pedra verde-escura suam um líquido viscoso, suas superfícies entalhadas com runas que parecem se contorcer sob o olhar prolongado. Um arco negro, adornado com tentáculos de pedra, domina a parede ao fundo — seu vazio parece respirar, exalando um murmúrio que arranha a mente. No centro, um círculo de símbolos antigos está manchado de marrom-escuro, e os ossos quebrados ao redor sugerem que algo espera ali... seja para impedir intrusos... ou recebê-los como oferenda'),
            (2, 'Esta câmara é uma abóbada cavernosa, o teto adornado com estalactites que parecem garras de uma criatura abissal. No centro, um poço sem fundo exala um ar gelado e úmido, e ruídos de algo se movendo na escuridão chegam de suas profundezas. Os hieróglifos nas paredes retratam rituais de sacrifício, e uma leve névoa verde preenche o ambiente.'),
            (3, 'Um salão circular com paredes que pulsam com uma luz bioluminescente fraca, vinda de estranhas plantas marinhas que crescem em fendas. O chão é coberto por uma camada de areia úmida e conchas quebradas, e o ar tem o cheiro de sal e decomposição. No centro, uma estrutura de coral negro retorcido parece um trono macabro.'),
            (4, 'Esta sala é um labirinto de pilares retorcidos e esculpidos com formas grotescas. O chão é escorregadio, coberto por um limo viscoso e esverdeado. Em meio aos pilares, pequenos olhos brilhantes parecem observar de todas as direções, e o silêncio é quebrado apenas pelo gotejar constante de água de uma fonte invisível.'),
            (5, 'Uma câmara triangular com um altar de obsidiana no centro, cercado por incenso queimado que emite uma fumaça densa e doce. As paredes são adornadas com tapeçarias desbotadas que retratam entidades cósmicas e estrelas distantes. Uma energia estranha e pulsante emana do altar.'),
            (6, 'Esta é uma sala de observação, com uma grande janela arqueada que se abre para um abismo escuro, de onde emana um brilho fraco e azulado. Instrumentos metálicos enferrujados estão espalhados pelo chão, e uma sensação de vertigem toma conta de quem se aproxima da janela. Sons distantes de guinchos e rosnados ecoam do vazio.');

INSERT INTO public.andares 
            (id, descricao, id_templo, sala_inicial) 
    VALUES  (1, 'Primeiro andar do templo de Chutullu', 1, 1);

INSERT INTO public.corredores 
            (id, status, descricao) 
    VALUES  (1, FALSE, 'O corredor estreito serpenteia adiante, suas paredes de pedra negra exsudando uma umidade fria que escorre em veios brilhantes, como lágrimas de estrelas agonizantes. O chão irregular é entalhado com símbolos que latejam suavemente ao toque da luz, ecoando em sussurros distantes quando pisados. Colunas retorcidas sustentam um teto alto demais para ser visto claramente, onde coisas sem forma se agitam nas trevas, seguindo seu avanço com olhos invisíveis. Ao longe, uma névoa esverdeada dança, revelando e ocultando passagens laterais que certamente não estavam lá antes.'),
            (2, FALSE, 'Este corredor é estreito e serpenteia por uma série de arcos baixos, cada um adornado com símbolos que parecem mudar quando não se olha diretamente. O ar é pesado com o cheiro de ozônio e algo metálico. Sons de arranhões distantes vêm de dentro das paredes.'),
            (3, FALSE, 'Um corredor largo e cavernoso, com colunas naturais que se elevam até um teto invisível nas trevas. O chão é irregular e coberto por poças de água escura, e o eco dos passos se arrasta por muito tempo. Um vento frio e úmido sopra de uma direção desconhecida.'),
            (4, FALSE, 'Este corredor tem as paredes cobertas por uma substância pegajosa e translúcida, que brilha fracamente em tons de roxo e azul. O chão é inclinado, e o ar é preenchido com um zumbido baixo e constante. Pequenas aberturas nas paredes revelam vislumbres de espaços claustrofóbicos.'),
            (5, FALSE, 'Um corredor que se estende em linha reta, suas paredes de pedra lisa e escura refletem a pouca luz como um espelho distorcido. O ar é denso e quente, e um cheiro adocicado e enjoativo paira no ambiente. No final, uma porta de pedra maciça, sem maçaneta, aguarda.'),
            (6, FALSE, 'Este corredor é irregular e parece descer em espiral para as profundezas. As paredes são cobertas por musgo luminescente e estranhas formações rochosas que se assemelham a criaturas adormecidas. O som de água corrente é constante, e a sensação de estar sendo observado é intensa.');

INSERT INTO public.corredores_salas_destino 
            (id_sala, id_corredor) 
    VALUES  (1, 1),
            (2, 1),
            (3, 2),
            (4, 3),
            (5, 4),
            (6, 5);
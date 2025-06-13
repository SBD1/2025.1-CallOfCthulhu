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

Versão: 0.8
Data: 12/06/2025
Descrição: Removendo o id da tabela inventários, pois não é necessário. Adicionando o id do inventário na tabela personagens_jogaveis. E retirando o id na inserção do personagens_jogaveis.
Autor: João Marcos

Versão: 0.9
Data: 13/06/2025
Descrição: Atualizando os ids das tabelas para os novos domínios de id
Autor: Luiz Guilherme

*/
-- ===============================================

--            INSERT DE DADOS

-- ===============================================

-- TABELA INVENTÁRIOS
INSERT INTO public.inventarios 
            (tamanho)
    VALUES  (32);

-- TABELA SALAS

INSERT INTO public.templos      
                (id, nome, descricao)
        VALUES (40100001, 'Templo de Chutullu', 'O templo é colossal, suas paredes de pedra verde-escura brilham sob uma luz sobrenatural, entalhadas com runas alienígenas que sussurram segredos proibidos. O ar é salgado e pesado, e cada passo ecoa em corredores que se torcem como pesadelos. No altar central, um ídolo pulsante de Cthulhu aguarda, enquanto sombras insanas dançam à sua volta.');
            
INSERT INTO public.salas 
            (id, descricao) 
    VALUES  (40300001, 'O ar pesa como um véu úmido, carregado do sal podre de eras esquecidas. As paredes de pedra verde-escura suam um líquido viscoso, suas superfícies entalhadas com runas que parecem se contorcer sob o olhar prolongado. Um arco negro, adornado com tentáculos de pedra, domina a parede ao fundo — seu vazio parece respirar, exalando um murmúrio que arranha a mente. No centro, um círculo de símbolos antigos está manchado de marrom-escuro, e os ossos quebrados ao redor sugerem que algo espera ali... seja para impedir intrusos... ou recebê-los como oferenda'),
            (40300002, 'Esta câmara é uma abóbada cavernosa, o teto adornado com estalactites que parecem garras de uma criatura abissal. No centro, um poço sem fundo exala um ar gelado e úmido, e ruídos de algo se movendo na escuridão chegam de suas profundezas. Os hieróglifos nas paredes retratam rituais de sacrifício, e uma leve névoa verde preenche o ambiente.'),
            (40300003, 'Um salão circular com paredes que pulsam com uma luz bioluminescente fraca, vinda de estranhas plantas marinhas que crescem em fendas. O chão é coberto por uma camada de areia úmida e conchas quebradas, e o ar tem o cheiro de sal e decomposição. No centro, uma estrutura de coral negro retorcido parece um trono macabro.'),
            (40300004, 'Esta sala é um labirinto de pilares retorcidos e esculpidos com formas grotescas. O chão é escorregadio, coberto por um limo viscoso e esverdeado. Em meio aos pilares, pequenos olhos brilhantes parecem observar de todas as direções, e o silêncio é quebrado apenas pelo gotejar constante de água de uma fonte invisível.'),
            (40300005, 'Uma câmara triangular com um altar de obsidiana no centro, cercado por incenso queimado que emite uma fumaça densa e doce. As paredes são adornadas com tapeçarias desbotadas que retratam entidades cósmicas e estrelas distantes. Uma energia estranha e pulsante emana do altar.'),
            (40300006, 'Esta é uma sala de observação, com uma grande janela arqueada que se abre para um abismo escuro, de onde emana um brilho fraco e azulado. Instrumentos metálicos enferrujados estão espalhados pelo chão, e uma sensação de vertigem toma conta de quem se aproxima da janela. Sons distantes de guinchos e rosnados ecoam do vazio.');

-- TABELA ANDARES

INSERT INTO public.andares 
            (id, descricao, id_templo, sala_inicial) 
    VALUES  (40200001, 'Primeiro andar do templo de Chutullu', 40100001, 40300001);

-- TABELA CORREDORES

INSERT INTO public.corredores 
            (id, status, descricao) 
    VALUES  (40400001, FALSE, 'O corredor estreito serpenteia adiante, suas paredes de pedra negra exsudando uma umidade fria que escorre em veios brilhantes, como lágrimas de estrelas agonizantes. O chão irregular é entalhado com símbolos que latejam suavemente ao toque da luz, ecoando em sussurros distantes quando pisados. Colunas retorcidas sustentam um teto alto demais para ser visto claramente, onde coisas sem forma se agitam nas trevas, seguindo seu avanço com olhos invisíveis. Ao longe, uma névoa esverdeada dança, revelando e ocultando passagens laterais que certamente não estavam lá antes.'),
            (40400002, FALSE, 'Este corredor é estreito e serpenteia por uma série de arcos baixos, cada um adornado com símbolos que parecem mudar quando não se olha diretamente. O ar é pesado com o cheiro de ozônio e algo metálico. Sons de arranhões distantes vêm de dentro das paredes.'),
            (40400003, FALSE, 'Um corredor largo e cavernoso, com colunas naturais que se elevam até um teto invisível nas trevas. O chão é irregular e coberto por poças de água escura, e o eco dos passos se arrasta por muito tempo. Um vento frio e úmido sopra de uma direção desconhecida.'),
            (40400004, FALSE, 'Este corredor tem as paredes cobertas por uma substância pegajosa e translúcida, que brilha fracamente em tons de roxo e azul. O chão é inclinado, e o ar é preenchido com um zumbido baixo e constante. Pequenas aberturas nas paredes revelam vislumbres de espaços claustrofóbicos.'),
            (40400005, FALSE, 'Um corredor que se estende em linha reta, suas paredes de pedra lisa e escura refletem a pouca luz como um espelho distorcido. O ar é denso e quente, e um cheiro adocicado e enjoativo paira no ambiente. No final, uma porta de pedra maciça, sem maçaneta, aguarda.'),
            (40400006, FALSE, 'Este corredor é irregular e parece descer em espiral para as profundezas. As paredes são cobertas por musgo luminescente e estranhas formações rochosas que se assemelham a criaturas adormecidas. O som de água corrente é constante, e a sensação de estar sendo observado é intensa.');

-- TABELA CORREDORES SALAS DESTINO

INSERT INTO public.corredores_salas_destino 
            (id_sala, id_corredor) 
    VALUES  (40300001, 40400001),
            (40300002, 40400001),

            -- Conexão entre Sala 2 e Sala 3 (pelo Corredor 2)
            (40300002, 40400002),
            (40300003, 40400002),

            -- Conexão entre Sala 3 e Sala 4 (pelo Corredor 3)
            (40300003, 40400003),
            (40300004, 40400003),

            -- Conexão entre Sala 4 e Sala 5 (pelo Corredor 4)
            (40300004, 40400004),
            (40300005, 40400004),

            -- Conexão entre Sala 5 e Sala 6 (pelo Corredor 5)
            (40300005, 40400005),
            (40300006, 40400005);

-- TABELA TIPOS_PERSONAGEM

INSERT INTO public.tipos_personagem 
            (id, tipo)
    VALUES  (1, 'personagem jogavel'),
            (2, 'NPC');

-- TABELA PERSONAGENS_JOGAVEIS

-- TABELA PERSONAGENS_JOGAVEIS
INSERT INTO public.personagens_jogaveis
            (nome, ocupacao, residencia, local_nascimento,
            idade, sexo,
            forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao,
            movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida,
            PM_base, PM_max,
            pontos_de_vida_atual,
            id_sala, id_corredor,
            id_inventario, id_armadura, id_arma /*id_tipo_personagem*/)
    VALUES ('Samuel Carter', 'Doutor em Medicina', 'Arkham, MA', 'Boston, MA',
            42, 'masculino',
            10, 12, 12, 8, 15, 17, 13, 12,
            7, -- movimento
            12, FALSE, FALSE, -- sanidade_atual, insanidade_temporaria, insanidade_indefinida
            10, 10, -- PM_base, PM_max
            100, -- pontos_de_vida_atual
            40300001, NULL, -- id_sala, id_corredor
            90000001, NULL, NULL /*1*/), -- id_inventario, id_armadura, id_arma, id_tipo_personagem

           ('Sarah Thompson', 'Arqueóloga', 'Boston, MA', 'Boston, MA',
            35, 'feminino',
            8, 10, 11, 14, 16, 15, 14, 13,
            8, -- movimento
            11, FALSE, FALSE, -- sanidade_atual, insanidade_temporaria, insanidade_indefinida
            8, 8, -- PM_base, PM_max
            80, -- pontos_de_vida_atual
            40300002, NULL, -- id_sala, id_corredor
            90000001, NULL, NULL /*1*/); -- id_inventario, id_armadura, id_arma, id_tipo_personagem

-- TABELA NPCs

INSERT INTO public.npcs 
                (id, nome, ocupacao, idade, sexo, residencia, local_nascimento, /*id_tipo_personagem*/ id_sala)
        VALUES  (10200001, 'Velho Sábio', 'Guardião do Templo', 70, 'masculino', 'Templo das Sombras', 'Arkham', /*2*/  40300001 ),
                (10200102, 'Guarda do Templo', 'Protetor das Relíquias', 45, 'masculino', 'Templo das Sombras', 'Arkham', /*2*/ 40300002),
                (10200103, 'Sacerdotisa Sombria', 'Mestre dos Rituais', 50, 'feminino', 'Templo das Sombras', 'Arkham', /*2*/ 40300003);

-- TABELA DIALOGOS

INSERT INTO public.dialogos 
                (id, script_dialogo, npc_id)
        VALUES  (70000001, 'Viajante, cuidado com as sombras do templo! Elas consomem até a alma mais forte.', 10200001),
                (70000002, 'Eu já vi coisas que fariam um homem enlouquecer... *suspira* ' || 'As paredes deste lugar sussurram segredos antigos. Não confie nelas.', 10200001);

-- TABELA PERÍCIAS 

INSERT INTO public.pericias 
            (id, nome, valor, eh_de_ocupacao)
    VALUES  (80000001, 'Antropologia', 1, FALSE), -- 01%
            (80000002, 'Armas de Fogo', 0, FALSE), -- varia
            (80000003, 'Arqueologia', 1, FALSE), -- 01%
            (80000004, 'Arremessar', 20, FALSE), -- 20%
            (80000005, 'Arte e Ofício', 5, FALSE), -- 05%
            (80000006, 'Artilharia', 1, FALSE), -- 01%
            (80000007, 'Astronomia', 1, FALSE), -- 01%, ver Ciência
            (80000008, 'Atuação', 5, FALSE), -- 05%, ver Arte/Ofício
            (80000009, 'Avaliação', 5, FALSE), -- 05%
            (80000010, 'Belas Artes', 5, FALSE), -- 05%, ver Arte/Ofício
            (80000011, 'Biologia', 1, FALSE), -- 01%, ver Ciência
            (80000012, 'Botânica', 1, FALSE), -- 01%, ver Ciência
            (80000013, 'Briga', 25, FALSE), -- 25%, ver Lutar
            (80000014, 'Cavalgar', 5, FALSE), -- 05%
            (80000015, 'Charme', 15, FALSE), -- 15%
            (80000016, 'Chaveiro', 1, FALSE), -- 01%
            (80000017, 'Chicotes', 5, FALSE), -- 05%, ver Lutar
            (80000018, 'Ciência', 1, FALSE), -- 01%
            (80000019, 'Ciência Forense', 1, FALSE), -- 01%, ver Ciência
            (80000020, 'Conhecimento', 1, FALSE), -- 01%
            (80000021, 'Consertos Elétricos', 10, FALSE), -- 10%
            (80000022, 'Consertos Mecânicos', 10, FALSE), -- 10%
            (80000023, 'Contabilidade', 5, FALSE), -- 05%
            (80000024, 'Criptografia', 1, FALSE), -- 01%, ver Ciência
            (80000025, 'Demolições', 1, FALSE), -- 01%
            (80000026, 'Direito', 5, FALSE), -- 05%
            (80000027, 'Dirigir Automóveis', 20, FALSE), -- 20%
            (80000028, 'Disfarce', 5, FALSE), -- 05%
            (80000029, 'Eletrônica', 1, FALSE), -- 01%
            (80000030, 'Encontrar', 25, FALSE), -- 25%
            (80000031, 'Engenharia', 1, FALSE), -- 01%, ver Ciência
            (80000032, 'Escalar', 20, FALSE), -- 20%
            (80000033, 'Espingardas', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            (80000034, 'Escutar', 20, FALSE), -- 20%
            (80000035, 'Espadas', 20, FALSE), -- 20%, ver Lutar
            (80000036, 'Esquivar', 0, FALSE), -- == destreza / 2
            (80000037, 'Falsificação', 5, FALSE), -- 05%, ver Arte/Ofício
            (80000038, 'Farmácia', 1, FALSE), -- 01%, ver Ciência
            (80000039, 'Física', 1, FALSE), -- 01%, ver Ciência
            (80000040, 'Fotografia', 5, FALSE), -- 05%, ver Arte/Ofício
            (80000041, 'Furtividade', 20, FALSE), -- 20%
            (80000042, 'Garrote', 15, FALSE), -- 15%, ver Lutar
            (80000043, 'Geologia', 1, FALSE), -- 01%, ver Ciência
            (80000044, 'Hipnose', 1, FALSE), -- 01%
            (80000045, 'História', 5, FALSE), -- 05%
            (80000046, 'Intimidação', 15, FALSE), -- 15%
            (80000047, 'Lábia', 5, FALSE), -- 05%
            (80000048, 'Lança-Chamas', 10, FALSE), -- 10%, ver Armas de Fogo
            (80000049, 'Lanças', 20, FALSE), -- 20%, ver Lutar/Arremessar
            (80000050, 'Leitura Labial', 1, FALSE), -- 01%
            (80000051, 'Língua (Nativa)', 0, FALSE), -- == educacao
            (80000052, 'Língua, Outra', 1, FALSE), -- 01%
            (80000053, 'Lutar', 0, FALSE), -- varia
            (80000054, 'Machados', 15, FALSE), -- 15%, ver Lutar
            (80000055, 'Manguais', 10, FALSE), -- 10%, ver Lutar
            (80000056, 'Matemática', 1, FALSE), -- 01%, ver Ciência
            (80000057, 'Medicina', 1, TRUE), -- 01%
            (80000058, 'Mergulho', 1, FALSE), -- 01%
            (80000059, 'Meteorologia', 1, FALSE), -- 01%, ver Ciência
            (80000060, 'Metralhadoras', 10, FALSE), -- 10%, ver Armas de Fogo
            (80000061, 'Motosserras', 10, FALSE), -- 10%, ver Lutar
            (80000062, 'Mundo Natural', 10, FALSE), -- 10%
            (80000063, 'Mythos de Cthulhu', 0, FALSE), -- 00%
            (80000064, 'Natação', 20, FALSE), -- 20%
            (80000065, 'Navegação', 10, FALSE), -- 10%
            (80000066, 'Nível de Crédito', 0, FALSE), -- 00%
            (80000067, 'Ocultismo', 5, FALSE), -- 05%
            (80000068, 'Operar Maquinário Pesado', 1, FALSE), -- 01%
            (80000069, 'Persuasão', 10, FALSE), -- 10%
            (80000070, 'Pilotar', 1, FALSE), -- 01%
            (80000071, 'Pistolas', 20, FALSE), -- 20%, ver Armas de Fogo
            (80000072, 'Prestidigitação', 10, FALSE), -- 10%
            (80000073, 'Primeiros Socorros', 30, FALSE), -- 30%
            (80000074, 'Psicanálise', 1, FALSE), -- 01%
            (80000075, 'Psicologia', 10, FALSE), -- 10%
            (80000076, 'Química', 1, FALSE), -- 01%, ver Ciência
            (80000077, 'Rastrear', 10, FALSE), -- 10%
            (80000078, 'Rifles', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            (80000079, 'Saltar', 20, FALSE), -- 20%
            (80000080, 'Sobrevivência', 10, FALSE), -- 10%
            (80000081, 'Submetralhadoras', 15, FALSE), -- 15%, ver Armas de Fogo
            (80000082, 'Treinar Animais', 5, FALSE), -- 05%
            (80000083, 'Usar Bibliotecas', 20, FALSE), -- 20%
            (80000084, 'Usar Computadores', 5, FALSE), -- 05%
            (80000085, 'Zoologia', 1, FALSE); -- 01%, ver Ciência

-- TABELA PERSONAGENS_POSSUEM_PERICIAS

INSERT INTO public.personagens_possuem_pericias 
            (id_personagem, id_pericia, valor_atual)
    VALUES  (10100001, 80000057, 1), -- Medicina
            (10100001, 80000073, 1), -- Primeiros Socorros
            (10100001, 80000011, 1), -- Biologia
            (10100001, 80000012, 1), -- Botânica
            (10100001, 80000018, 1), -- Ciência
            (10100001, 80000019, 1), -- Ciência Forense
            (10100001, 80000032, 20), -- Escalar
            (10100001, 80000034, 20), -- Escutar
            (10100001, 80000041, 20), -- Furtividade
            (10100001, 80000053, 0), -- Lutar
            (10100001, 80000063, 0), -- Mythos de Cthulhu
            (10100001, 80000066, 0), -- Nível de Crédito
            (10100001, 80000062, 10), -- Mundo Natural
            (10100001, 80000071, 20), -- Pistolas
            (10100001, 80000078, 25), -- Rifles
            (10100001, 80000077, 1), -- Química
            (10100001, 80000083, 20), -- Usar Bibliotecas
            (10100001, 80000084, 5); -- Usar Computadores

-- MONSTROS 

INSERT INTO public.tipos_monstro 
            (id, tipo)
    VALUES  (20100001,'agressivo'), -- Para Abominável Horrores
            (20100002,'agressivo'), -- Para Carnífice Sombrio
            (20100003,'agressivo'), -- Para Mago da Corrupção
            (20200004,'pacífico'), -- Para Espírito Guardião
            (20200005,'pacífico'); -- Para Eremita do Templo

-- TABELA MONSTROS AGRESSIVOS

INSERT INTO public.agressivos 
            (id, nome, descricao, defesa, vida, catalisador_agressividade, poder, tipo_agressivo, velocidade_ataque, loucura_induzida, ponto_magia, dano)
    VALUES  (20100001, 'Abominável Horrores', 'Criatura grotesca que se esconde nas sombras, devorando a sanidade.', 10, 50, 'proximidade', 15, 'psiquico', 5, 20, 10, 30),
            (20100002, 'Carnífice Sombrio', 'Um monstro com garras afiadas, rápido e implacável.', 12, 60, 'ataque_direto', 10, 'fisico', 8, 0, 0, 40),
            (20100003, 'Mago da Corrupção', 'Uma entidade mágica que distorce a realidade com seus feitiços.', 8, 40, 'barulho_alto', 20, 'magico', 4, 15, 25, 25);

-- TABELA MONSTROS PACÍFICOS

INSERT INTO public.pacificos 
            (id, nome, descricao, defesa, vida, motivo_passividade, tipo_pacifico, conhecimento_geografico, conhecimento_proibido)
    VALUES  (20200004, 'Espírito Guardião', 'Um espírito antigo que protege certas áreas, mas não ataca a menos que provocado.', 5, 30, 'indiferente', 'sobrenatural', 'Conhece todos os caminhos do templo.', 'Nenhum.'),
            (20200005, 'Eremita do Templo', 'Um humanoide recluso que vive no templo, buscando conhecimento.', 7, 25, 'amigavel', 'humanoide', 'Mapas mentais detalhados do andar superior.', 'Histórias de rituais proibidos.');   

-- TABELA ITENS

INSERT INTO public.itens 
            (id, tipo, nome, descricao, valor)
    VALUES  (30400001, 'arma', 'Adaga Simples', 'Uma adaga enferrujada.', 5);   

-- TABELA INSTÂNCIA DE ITENS

INSERT INTO public.instancias_de_itens 
            (id, durabilidade, id_sala, id_missao_requer, id_missao_recompensa, id_item)
    VALUES  (88000001, 100, 40300001, NULL, NULL, 30400001); -- Uma adaga simples no Salão Principal

-- TABELA INSTÂNCIA DE MONSTROS

INSERT INTO public.instancias_monstros 
            (id, id_monstro, id_sala, id_corredor, id_instancia_de_item)
    VALUES  (99000001, 20100001, 40300003, NULL, 88000001),-- Uma instância do Abominável Horrores na Câmara Secreta, com a Adaga Simples
            (99000002, 20100002, NULL, 40400001, 88000001), -- Uma instância do Carnífice Sombrio no Corredor Principal, com a Adaga Simples
            (99000003, 20200004, 40300004, NULL, 88000001), -- Uma instância do Espírito Guardião na Tumba Esquecida, com a Adaga Simples
            (99000004, 20200005, 40300006, NULL, 88000001); -- Uma instância do Eremita do Templo na Biblioteca Proibida, com a Adaga Simples

-- TABELA MISSÕES

INSERT INTO public.missoes 
        (id, nome, descricao, tipo, ordem, id_npc)
VALUES  (50000001, 'A Súplica do Ancião', 'O Velho Sábio precisa que você recupere um artefato roubado das profundezas do templo.', 'principal', 'Encontre o artefato na Tumba Esquecida (Sala 4).', 10200001),
        (50000002, 'Relíquias Perdidas', 'O Guarda do Templo precisa de ajuda para localizar relíquias dispersas pelo Corredor Principal.', 'coleta', 'Procure por 3 fragmentos de relíquias no Corredor Principal (Corredor 1).', 10200102),
        (50000003, 'Purificação do Santuário', 'A Sacerdotisa Sombria pede que você extermine uma criatura maligna na Câmara Secreta.', 'eliminacao', 'Derrote o Abominável Horrores na Câmara Secreta (Sala 3).', 10200103);


 -- TABELA ENTREGA DE MISSÕES

INSERT INTO public.entregas_missoes 
            (id_jogador, id_npc)
    VALUES  (10100001, 10200001),-- Samuel Carter entregou uma missão ao Velho Sábio
            (10100002, 10200102); -- Sarah Thompson entregou uma missão ao Guarda do Templo 

-- TABELA BATALHAS

INSERT INTO public.batalhas 
            (id_jogador, id_monstro)
    VALUES  (10100001, 99000001),-- Samuel Carter batalhou contra o Abominável Horrores (instância 1)
            (10100002, 99000002),-- Sarah Thompson batalhou contra o Carnífice Sombrio (instância 2)
            (10100001, 99000002); -- Samuel Carter também batalhou contra o Carnífice Sombrio (instância 2)

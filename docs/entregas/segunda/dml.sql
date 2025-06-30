/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 10/06/2025
Descrição: Criando inserts iniciais nas tabelas templos, andares, salas, corredores e corredores_salas_destino.
Autor: Cayo, Igor

Versão: 0.2
Data: 10/06/2025
Descrição: Criando inserts iniciais nas tabelas inventarios, salas, tipo_personagem, personagens_jogaveis, corredores, corredores_salas_destino, pericias e personagens_possuem_pericias.
Autor: Christopher, João Marcos

Versão: 0.3
Data: 11/06/2025
Descrição: Adicionando exemplos de NPCs e dialogos. Completando tabela de pericias.
Autor: Christopher, João Marcos

Versão: 0.4
Data: 11/06/2025
Descrição: Adicionando exemplos de monstros, tanto agressivos quanto pacificos, e suas respectivas tabelas.
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
Descrição: Adicionando exemplos de missoes e batalhas, e suas respectivas tabelas.
Autor: Christopher, João Marcos

Versão: 0.8
Data: 12/06/2025
Descrição: Removendo o id da tabela inventarios, pois nao eh necessario. Adicionando o id do inventario na tabela personagens_jogaveis. E retirando o id na insercao do personagens_jogaveis.
Autor: João Marcos

Versão: 0.9
Data: 13/06/2025
Descrição: Atualizando os ids das tabelas para os novos dominios de id
Autor: Luiz Guilherme

Versão: 1.0
Data: 14/06/2025
Descrição: Atualizando o dml para suportar a criacao automatica de ids nas tabelas
Autor: Luiz Guilherme

Versão: 1.1
Data: 28/06/2025
Descrição: Ajustando DML para a nova estrutura unificada da tabela 'local' (sala e corredor).
            Uso de 'tipo_local' como string (CHARACTER VARYING) e ajuste de escopo de CTEs.
Autor: Cayo

Versão: 1.2
Data: 30/06/2025
Descrição: Refatorando a logica de insercao e conexao de locais. Populando os locais do banco
Autor: Luiz Guilherme

*/
-- ===============================================

--          INSERT DE DADOS

-- ===============================================

INSERT INTO public.tipos_personagem (tipo) VALUES ('personagem jogavel'), ('NPC');
INSERT INTO public.tipos_monstro (tipo) VALUES ('agressivo'), ('pacífico');

-- ===============================================

--       ADIÇÃO NA TABELA DE PERÍCIAS

-- ===============================================

INSERT INTO public.pericias
            (nome, valor, eh_de_ocupacao)
    VALUES  ('Antropologia', 1, FALSE),
            ('Armas de Fogo', 0, FALSE),
            ('Arqueologia', 1, FALSE),
            ('Arremessar', 20, FALSE),
            ('Arte e Ofício', 5, FALSE),
            ('Artilharia', 1, FALSE),
            ('Astronomia', 1, FALSE),
            ('Atuação', 5, FALSE),
            ('Avaliação', 5, FALSE),
            ('Belas Artes', 5, FALSE),
            ('Biologia', 1, FALSE),
            ('Botânica', 1, FALSE),
            ('Briga', 25, FALSE),
            ('Cavalgar', 5, FALSE),
            ('Charme', 15, FALSE),
            ('Chaveiro', 1, FALSE),
            ('Chicotes', 5, FALSE),
            ('Ciência', 1, FALSE),
            ('Ciência Forense', 1, FALSE),
            ('Conhecimento', 1, FALSE),
            ('Consertos Elétricos', 10, FALSE),
            ('Consertos Mecânicos', 10, FALSE),
            ('Contabilidade', 5, FALSE),
            ('Criptografia', 1, FALSE),
            ('Demolições', 1, FALSE),
            ('Direito', 5, FALSE),
            ('Dirigir Automóveis', 20, FALSE),
            ('Disfarce', 5, FALSE),
            ('Eletrônica', 1, FALSE),
            ('Encontrar', 25, FALSE),
            ('Engenharia', 1, FALSE),
            ('Escalar', 20, FALSE),
            ('Espingardas', 25, FALSE),
            ('Escutar', 20, FALSE),
            ('Espadas', 20, FALSE),
            ('Esquivar', 0, FALSE),
            ('Falsificação', 5, FALSE),
            ('Farmácia', 1, FALSE),
            ('Física', 1, FALSE),
            ('Fotografia', 5, FALSE),
            ('Furtividade', 20, FALSE),
            ('Garrote', 15, FALSE),
            ('Geologia', 1, FALSE),
            ('Hipnose', 1, FALSE),
            ('História', 5, FALSE),
            ('Intimidação', 15, FALSE),
            ('Lábia', 5, FALSE),
            ('Lança-Chamas', 10, FALSE),
            ('Lanças', 20, FALSE),
            ('Leitura Labial', 1, FALSE),
            ('Língua (Nativa)', 0, FALSE),
            ('Língua, Outra', 1, FALSE),
            ('Lutar', 0, FALSE),
            ('Machados', 15, FALSE),
            ('Manguais', 10, FALSE),
            ('Matemática', 1, FALSE),
            ('Medicina', 1, TRUE),
            ('Mergulho', 1, FALSE),
            ('Meteorologia', 1, FALSE),
            ('Metralhadoras', 10, FALSE),
            ('Motosserras', 10, FALSE),
            ('Mundo Natural', 10, FALSE),
            ('Mythos de Cthulhu', 0, FALSE),
            ('Natação', 20, FALSE),
            ('Navegação', 10, FALSE),
            ('Nível de Crédito', 0, FALSE),
            ('Ocultismo', 5, FALSE),
            ('Operar Maquinário Pesado', 1, FALSE),
            ('Persuasão', 10, FALSE),
            ('Pilotar', 1, FALSE),
            ('Pistolas', 20, FALSE),
            ('Prestidigitação', 10, FALSE),
            ('Primeiros Socorros', 30, FALSE),
            ('Psicanálise', 1, FALSE),
            ('Psicologia', 10, FALSE),
            ('Química', 1, FALSE),
            ('Rastrear', 10, FALSE),
            ('Rifles', 25, FALSE),
            ('Saltar', 20, FALSE),
            ('Sobrevivência', 10, FALSE),
            ('Submetralhadoras', 15, FALSE),
            ('Treinar Animais', 5, FALSE),
            ('Usar Bibliotecas', 20, FALSE),
            ('Usar Computadores', 5, FALSE),
            ('Zoologia', 1, FALSE);

-- ===============================================

--       ADIÇÃO NAS TABELAS DE LOCAIS (UNIFICADA)

-- ===============================================

WITH
    templo_criado_cte AS (
        INSERT INTO public.templos(nome, descricao)
        VALUES ('Templo de Cthulhu', 'O templo é colossal, suas paredes de pedra verde-escura brilham sob uma luz sobrenatural, entalhadas com runas alienígenas que sussurram segredos proibidos. O ar é salgado e pesado, e cada passo ecoa em corredores que se torcem como pesadelos. No altar central, um ídolo pulsante de Cthulhu aguarda, enquanto sombras insanas dançam à sua volta.')
        RETURNING id
    ),
    andar_criado_cte AS (
        INSERT INTO public.andares(descricao, id_templo)
        VALUES ('Primeiro andar do templo de Cthulhu', (SELECT id FROM templo_criado_cte))
        RETURNING id AS andar_id
    ),
    locais_criados_cte AS (
        INSERT INTO public.local (descricao, tipo_local, status, andar)
        VALUES
            -- Salas (tipo_local = 'Sala', status é NULL)
            ('O ar pesa como um véu úmido, carregado do sal podre de eras esquecidas. As paredes de pedra verde-escura suam um líquido viscoso, suas superfícies entalhadas com runas que parecem se contorcer sob o olhar prolongado. Um arco negro, adornado com tentáculos de pedra, domina a parede ao fundo — seu vazio parece respirar, exalando um murmúrio que arranha a mente. No centro, um círculo de símbolos antigos está manchado de marrom-escuro, e os ossos quebrados ao redor sugerem que algo espera ali... seja para impedir intrusos... ou recebê-los como oferenda', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Esta câmara é uma abóbada cavernosa, o teto adornado com estalactites que parecem garras de uma criatura abissal. No centro, um poço sem fundo exala um ar gelado e úmido, e ruídos de algo se movendo na escuridão chegam de suas profundezas. Os hieróglifos nas paredes retratam rituais de sacrifício, e uma leve névoa verde preenche o ambiente.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Um salão circular com paredes que pulsam com uma luz bioluminescente fraca, vinda de estranhas plantas marinhas que crescem em fendas. O chão é coberto por uma camada de areia úmida e conchas quebradas, e o ar tem o cheiro de sal e decomposição. No centro, uma estrutura de coral negro retorcido parece um trono macabro.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Esta sala é um labirinto de pilares retorcidos e esculpidos com formas grotescas. O chão é escorregadio, coberto por um limo viscoso e esverdeado. Em meio aos pilares, pequenos olhos brilhantes parecem observar de todas as direções, e o silêncio é quebrado apenas pelo gotejar constante de água de uma fonte invisível.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Uma câmara triangular com um altar de obsidiana no centro, cercado por incenso queimado que emite uma fumaça densa e doce. As paredes são adornadas com tapeçarias desbotadas que retratam entidades cósmicas e estrelas distantes. Uma energia estranha e pulsante emana do altar.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Esta é uma sala de observação, com uma grande janela arqueada que se abre para um abismo escuro, de onde emana um brilho fraco e azulado. Instrumentos metálicos enferrujados estão espalhados pelo chão, e uma sensação de vertigem toma conta de quem se aproxima da janela. Sons distantes de guinchos e rosnados ecoam do vazio.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Uma cripta úmida, revestida de musgo bioluminescente que emana um brilho esverdeado fraco. Estátuas grotescas de criaturas marinhas adornam as paredes, e um sarcófago de pedra negra repousa no centro, selado por correntes enferrujadas. O ar é pesado com o cheiro de mofo e algo indefinível.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Um laboratório abandonado, com bancadas de pedra cobertas por instrumentos corroídos e frascos quebrados. Pistas de experimentos estranhos e falhos podem ser encontradas, e o chão está manchado com substâncias desconhecidas. O local_oeste está selado com uma barreira de energia residual.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Uma biblioteca submersa, onde estantes de coral e algas abrigam tomos ancestrais feitos de pele escamosa e papiro resistente à água. A luz filtra-se de fendas no teto, iluminando inscrições esquecidas. Sons distantes de murmúrios parecem vir dos próprios livros.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Um anfiteatro circular com assentos em degraus esculpidos na rocha. No centro, um palco elevado com um pedestal vazio. As paredes reverberam com o eco de vozes antigas, e símbolos de culto estão gravados em cada assento. O local_leste leva a uma câmara secreta.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            ('Uma sala de tesouros com pilhas de moedas de ouro e joias estranhas incrustadas com gemas que parecem pulsos. No entanto, uma aura de maldição paira sobre a riqueza, e os tesouros parecem resistir a serem tocados.', 'Sala', NULL, (SELECT andar_id FROM andar_criado_cte)),
            -- Corredores (tipo_local = 'Corredor', status é definido)
            ('O corredor estreito serpenteia adiante, suas paredes de pedra negra exsudando uma umidade fria que escorre em veios brilhantes, como lágrimas de estrelas agonizantes. O chão irregular é entalhado com símbolos que latejam suavemente ao toque da luz, ecoando em sussurros distantes quando pisados. Colunas retorcidas sustentam um teto alto demais para ser visto claramente, onde coisas sem forma se agitam nas trevas, seguindo seu avanço com olhos invisíveis. Ao longe, uma névoa esverdeada dança, revelando e ocultando passagens laterais que certamente não estavam lá antes.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Este corredor é estreito e serpenteia por uma série de arcos baixos, cada um adornado com símbolos que parecem mudar quando não se olha diretamente. O ar é pesado com o cheiro de ozônio e algo metálico. Sons de arranhões distantes vêm de dentro das paredes.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Um corredor largo e cavernoso, com colunas naturais que se elevam até um teto invisível nas trevas. O chão é irregular e coberto por poças de água escura, e o eco dos passos se arrasta por muito tempo. Um vento frio e úmido sopra de uma direção desconhecida.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Este corredor tem as paredes cobertas por uma substância pegajosa e translúcida, que brilha fracamente em tons de roxo e azul. O chão é inclinado, e o ar é preenchido com um zumbido baixo e constante. Pequenas aberturas nas paredes revelam vislumbres de espaços claustrofóbicos.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Um corredor que se estende em linha reta, suas paredes de pedra lisa e escura refletem a pouca luz como um espelho distorcido. O ar é denso e quente, e um cheiro adocicado e enjoativo paira no ambiente. No final, uma porta de pedra maciça, sem maçaneta, aguarda.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Este corredor é irregular e parece descer em espiral para as profundezas. As paredes são cobertas por musgo luminescente e estranhas formações rochosas que se assemelham a criaturas adormecidas. O som de água corrente é constante, e a sensação de estar sendo observado é intensa.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Um corredor sinuoso que desce abruptamente para a escuridão, suas paredes cobertas por tentáculos fossilizados que parecem se estender para agarrá-lo. Um vento frio assobia através de rachaduras invisíveis.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Este corredor é uma passagem estreita e claustrofóbica, onde as paredes e o teto são de carne pulsante. O chão é pegajoso, e o ar denso com um odor metálico. Sounds de respiração profunda ecoam de todas as direções.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Um túnel inundado com água salgada até a altura do joelho. Peixes cegos e disformes nadam em torno de seus pés, e a iluminação é esporádica, vindo de fungos luminescentes nas paredes.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Um corredor espaçoso com colunas maciças que se assemelham a ossos gigantes. Fragmentos de murais antigos podem ser vistos nas paredes, retratando seres cósmicos e catástrofes inimagináveis.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte)),
            ('Este corredor leva a uma área de transição, com uma porta maciça feita de obsidiana no final. As paredes são lisas e frias, e uma sensação de pressa inexplicável domina o ambiente.', 'Corredor', FALSE, (SELECT andar_id FROM andar_criado_cte))
        RETURNING id, descricao, tipo_local
    )
  SELECT 1;


-- ===============================================

-- ATUALIZANDO AS CONEXÕES ENTRE LOCAIS (SUL, NORTE, LESTE, OESTE, CIMA, BAIXO)

-- ===============================================

-- Mapeamento das conexões originais para as novas direções
-- (Sala X, Corredor Y) = Sala X.local_sul -> Corredor Y, e Corredor Y.local_norte -> Sala X
-- Para conexões múltiplas de uma sala/corredor, usaremos outras direções (Leste/Oeste)

-- ==========
-- SALA 1 INICIAL
-- ==========

-- Conexão 1.S: Sala 1 <-> Corredor 1 SUL
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor';

-- Conexão 1.N: Sala 1 <-> Corredor 2 NORTE
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série%' AND tipo_local = 'Corredor';

-- Conexão 1.L: Sala 1 <-> Corredor 3 LESTE
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor';

-- Conexão 1.O: Sala 1 <-> Corredor 4 OESTE
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma%' AND tipo_local = 'Corredor';

-- ==========
-- SALA 2 
-- ==========

-- Conexão 2.N: Sala 1 <-> Corredor 1 NORTE
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor';

-- ==========
-- SALA 3
-- ==========

-- Conexão 3.S: Sala 1 <-> Corredor 1 SUL
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala';
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série%' AND tipo_local = 'Corredor';


-- ===============================================

-- ADIÇÃO NA TABELA DE PERSONAGENS JOGÁVEIS E SEUS INVENTÁRIOS

-- ===============================================

WITH
  inv_samuel AS ( INSERT INTO public.inventarios (tamanho) VALUES (32) RETURNING id ),
  samuel AS (
    INSERT INTO public.personagens_jogaveis (nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, PM_base, PM_max, pontos_de_vida_atual, id_local, id_inventario)
    VALUES ('Samuel Carter', 'Doutor em Medicina', 'Arkham, MA', 'Boston, MA', 42, 'masculino', 10, 12, 12, 8, 15, 17, 13, 12, 7, 60, 12, 12, 14, (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala'), (SELECT id FROM inv_samuel))
    RETURNING id
  ),
  inv_sarah AS ( INSERT INTO public.inventarios (tamanho) VALUES (28) RETURNING id ),
  sarah AS (
    INSERT INTO public.personagens_jogaveis (nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, PM_base, PM_max, pontos_de_vida_atual, id_local, id_inventario)
    VALUES ('Sarah Thompson', 'Arqueóloga', 'Boston, MA', 'Boston, MA', 35,
    'feminino', 8, 10, 11, 14, 16, 15, 14, 13, 8, 55, 11, 11, 12, (SELECT id FROM public.local WHERE descricao LIKE 'Esta câmara é uma abóbada%' AND tipo_local = 'Sala'), (SELECT id FROM inv_sarah))
    RETURNING id
  )
SELECT 1;


-- ===============================================

-- ADIÇÃO NA TABELA DE personagens_possuem_pericias

-- ===============================================

INSERT INTO public.personagens_possuem_pericias (id_personagem, id_pericia, valor_atual)
VALUES
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM public.pericias WHERE nome = 'Medicina'), 75),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM public.pericias WHERE nome = 'Ciência'), 50),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Sarah Thompson'), (SELECT id FROM public.pericias WHERE nome = 'Arqueologia'), 70),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Sarah Thompson'), (SELECT id FROM public.pericias WHERE nome = 'História'), 60);

-- ===============================================

-- ADIÇÃO NA TABELA DE NPCS, DIÁLOGOS E MISSÕES

-- ===============================================

WITH
  sabio AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_local)
    VALUES ('Velho Sábio', 'Guardião do Templo', 70, 'masculino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala')) RETURNING id
  ),
  guarda AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_local)
    VALUES ('Guarda do Templo', 'Protetor das Relíquias', 45, 'masculino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.local WHERE descricao LIKE 'Esta câmara é uma abóbada%' AND tipo_local = 'Sala')) RETURNING id
  ),
  sacerdotisa AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_local)
    VALUES ('Sacerdotisa Sombria', 'Mestre dos Rituais', 50, 'feminino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular%' AND tipo_local = 'Sala')) RETURNING id
  ),
  dialogos_inseridos AS (
    INSERT INTO public.dialogos (script_dialogo, npc_id)
    VALUES
      ('Viajante, cuidado com as sombras do templo!', (SELECT id FROM sabio)),
      ('As paredes deste lugar sussurram segredos antigos.', (SELECT id FROM sabio))
    RETURNING npc_id
  ),
  missoes_inseridas AS (
    INSERT INTO public.missoes (nome, descricao, tipo, ordem, id_npc)
    VALUES
        ('A Súplica do Ancião', 'Recupere um artefato roubado das profundezas do templo.', 'principal', 'Encontre o artefato na sala triangular.', (SELECT id FROM sabio)),
        ('Relíquias Perdidas', 'Ajude a localizar relíquias dispersas pelo corredor.', 'coleta', 'Procure por 3 fragmentos.', (SELECT id FROM guarda)),
        ('Purificação do Santuário', 'Extermine uma criatura maligna.', 'eliminacao', 'Derrote o Abominável Horror.', (SELECT id FROM sacerdotisa))
    RETURNING id_npc
  )
SELECT 1;


-- ===============================================

-- ADIÇÃO NA TABELA DE MONSTROS E ITENS

-- ===============================================

WITH
  monstro_agressivo AS (
    INSERT INTO public.agressivos (nome, descricao, defesa, vida, catalisador_agressividade, poder, tipo_agressivo, velocidade_ataque, loucura_induzida, ponto_magia, dano)
    VALUES ('Abominável Horror', 'Criatura grotesca que se esconde nas sombras...', 10, 50, 'proximidade', 15, 'psiquico', 5, 20, 10, 30) RETURNING id
  ),
  monstro_pacifico AS (
    INSERT INTO public.pacificos (nome, descricao, defesa, vida, motivo_passividade, tipo_pacifico)
    VALUES ('Espírito Guardião', 'Um espírito antigo que protege certas áreas...', 5, 30, 'indiferente', 'sobrenatural') RETURNING id
  ),
  item_adaga AS (
    INSERT INTO public.itens (tipo, nome, descricao, valor)
    VALUES ('arma', 'Adaga Simples', 'Uma adaga enferrujada.', 5) RETURNING id
  ),
  instancia_adaga AS (
    INSERT INTO public.instancias_de_itens (durabilidade, id_item, id_local)
    SELECT 100, id, (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular%' AND tipo_local = 'Sala') FROM item_adaga RETURNING id
  ),
  instancia_monstro AS (
    INSERT INTO public.instancias_monstros (id_monstro, id_local, id_instancia_de_item)
    SELECT (SELECT id FROM monstro_agressivo), (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular%' AND tipo_local = 'Sala'), id FROM instancia_adaga RETURNING id
  ),
  batalhas_inseridas AS (
    INSERT INTO public.batalhas (id_jogador, id_monstro)
    VALUES
        ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM instancia_monstro))
    RETURNING id_jogador
  )
SELECT 1;

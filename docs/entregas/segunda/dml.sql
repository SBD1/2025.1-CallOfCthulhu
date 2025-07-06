-- BEGIN; -- Inicia uma nova transação

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

Versão: 1.3
Data: 28/06/2025
Descrição: Refatorado para usar o Stored Procedure sp_criar_monstro
Autor: Wanjo Christopher

Versão: 1.4
Data: 01/07/2025
Descrição: Insere as conexões entre salas e corredores do mapa até a sala 8
Autor: Wanjo Christopher

Versão: 1.5
Data: 01/07/2025
Descrição: Adicionado tipo feitiço
Autores: João Marcos e Luiz Guilherme

Versão: 1.6
Data: 01/07/2025
Descrição: Refatoração completa dos INSERTs para se alinhar com as correções do DDL e garantir a integridade dos dados. As principais mudanças foram:
- Implementação de um novo padrão transacional com 'BEGIN/COMMIT' para a inserção de todos os tipos de itens, garantindo a lógica de herança correta (inserção em tabela filha e depois na pai).
- Correção nos 'INSERT's de 'feiticos_status' e 'feiticos_dano' para incluir a referência ao 'id_tipo_feitico'.
- Substituição do bloco de inserção de monstros e da 'Adaga Simples' para utilizar os novos padrões de DML.
- Ajuste na criação de itens mágicos para referenciar um feitiço específico em vez de um tipo de feitiço genérico.
Autor: João Marcos, Luiz Guilherme.

Versão 1.7 
Data 05/07/2025
Descrição: Adicionando itens com o procedure sp_criar_arma
Autor: Luiz Guilherme

Versão 1.8 
Data 05/07/2025
Descrição: Melhorias na inserção de instâncias de monstros e itens para permitir seu respawn
Autor: Luiz Guilherme

Versão 1.9
Data: 05/07/2025
Descrição: Adiciona novas armas e armaduras ao jogo usando as stored procedures correspondentes e as insere em locais específicos do mapa.
Autor: Gemini

Versão 2.0
Data: 05/07/2025
Descrição: Adiciona type casting explícito às chamadas de stored procedures de criação de itens para garantir a correta inferência de tipos.
Autor: Gemini

Versão 2.1
Data: 05/07/2025
Descrição: Substitui os itens por versões mais temáticas e sombrias, adequadas à estética de Cthulhu, e ajusta seus atributos e locais.
Autor: Gemini

Versão 2.2
Data: 05/07/2025
Descrição: Substitui as inserções diretas de personagens, NPCs e missões por chamadas aos seus respectivos stored procedures (sp_criar_personagem_jogavel, sp_criar_npc, sp_criar_missao).
Autor: Gemini
*/
-- ===============================================

--          INSERT DE DADOS

-- ===============================================

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
            ('Natacao', 20, FALSE),
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
            ('Sobrevivencia', 10, FALSE),
            ('Submetralhadoras', 15, FALSE),
            ('Treinar Animais', 5, FALSE),
            ('Usar Bibliotecas', 20, FALSE),
            ('Usar Computadores', 5, FALSE),
            ('Zoologia', 1, FALSE),
            ('Uso de Armadura', 1, TRUE);

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

-- ATUALIZANDO AS CONEXÕES ENTRE LOCAIS (SUL, NORTE, LESTE, OESTE, SUDESTE, SUDOESTE, NORDESTE, NOROESTE, CIMA, BAIXO)

-- ===============================================

-- Mapeamento das conexões originais para as novas direções
-- (Sala X, Corredor Y) = Sala X.local_sul -> Corredor Y, e Corredor Y.local_norte -> Sala X
-- Para conexões múltiplas de uma sala/corredor, usaremos outras direções (Leste/Oeste, Sudeste/Sudoeste, Nordeste/Noroeste)

-- ====================
-- SALA 0 INICIAL
-- ====================

-- Conexão 0.S: Sala 0 <-> Corredor 1 SUL
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor';

-- Conexão 0.L: Sala 0 <-> Corredor 2 LESTE
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor';

-- -- Conexão 0.N: Sala 0 <-> Corredor 3 NORTE
-- UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
-- UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série%' AND tipo_local = 'Corredor';


-- -- Conexão 0.O: Sala 0 <-> Corredor 4 OESTE
-- UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala';
-- UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 1
-- ====================

-- Conexão 1.O: Sala 1 <-> Corredor 2 OESTE
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série de arcos baixos%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série de arcos baixos%' AND tipo_local = 'Corredor';

-- Conexão 1.S: Sala 1 <-> Corredor 3 SUL
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor';

-- Conexão 1.SO: Sala 1 <-> Corredor 5 SUDOESTE
UPDATE public.local SET local_sudoeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor que se estende em linha reta%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala';
UPDATE public.local SET local_nordeste = (SELECT id FROM public.local WHERE descricao LIKE 'Esta câmara é uma abóbada cavernosa%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor que se estende em linha reta%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 2
-- ====================

-- Conexão 2.N: Sala 2 <-> Corredor 1 NORTE
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala') WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor';

-- Conexão 2.L: Sala 2 <-> Corredor 4 LESTE
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma substância pegajosa%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala';
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma substância pegajosa%' AND tipo_local = 'Corredor';

-- Conexão 2.NE: Sala 2 <-> Corredor 5 NORDESTE
UPDATE public.local SET local_nordeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor que se estende em linha reta%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sudoeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor que se estende em linha reta%' AND tipo_local = 'Corredor';

-- Conexão 2.S: Sala 2 <-> Corredor 10 SUL
-- TODO trigger e stored procedure para fazer o update somente quando o player chegar na sala 7
UPDATE public.local SET local_nordeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor espaçoso com colunas maciças%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sudoeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular com paredes que pulsam%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor espaçoso com colunas maciças%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 3
-- ====================

-- Conexão 3.N: Sala 3 <-> Corredor 3 NORTE
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta sala é um labirinto de pilares retorcidos%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Esta sala é um labirinto de pilares retorcidos%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor largo e cavernoso, com colunas naturais%' AND tipo_local = 'Corredor';

-- Conexão 3.N: Sala 3 <-> Corredor 4 OESTE
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma substância pegajosa%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta sala é um labirinto de pilares retorcidos%' AND tipo_local = 'Sala';
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Esta sala é um labirinto de pilares retorcidos%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma substância pegajosa%' AND tipo_local = 'Corredor';

-- Conexão 3.S: Sala 3 <-> Corredor 6 SUL
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é irregular e parece descer em espiral%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta sala é um labirinto de pilares retorcidos%' AND tipo_local = 'Sala';
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Esta sala é um labirinto de pilares retorcidos%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é irregular e parece descer em espiral%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 4
-- ====================

-- Conexão 4.N: Sala 4 <-> Corredor 6 NORTE
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é irregular e parece descer em espiral%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Uma câmara triangular com um altar de obsidiana%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Uma câmara triangular com um altar de obsidiana%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é irregular e parece descer em espiral%' AND tipo_local = 'Corredor';

-- Conexão 4.L: Sala 4 <-> Corredor 7 LESTE
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor sinuoso que desce abruptamente%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Uma câmara triangular com um altar de obsidiana%' AND tipo_local = 'Sala';
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Uma câmara triangular com um altar de obsidiana%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor sinuoso que desce abruptamente%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 5
-- ====================

-- Conexão 5.O: Sala 5 <-> Corredor 7 OESTE
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor sinuoso que desce abruptamente%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta é uma sala de observação, com uma grande janela arqueada%' AND tipo_local = 'Sala';
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Esta é uma sala de observação, com uma grande janela arqueada%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor sinuoso que desce abruptamente%' AND tipo_local = 'Corredor';

-- Conexão 5.SO: Sala 5 <-> Corredor 8 SUDOESTE
UPDATE public.local SET local_sudoeste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é uma passagem estreita e claustrofóbica%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Esta é uma sala de observação, com uma grande janela arqueada%' AND tipo_local = 'Sala';
UPDATE public.local SET local_nordeste = (SELECT id FROM public.local WHERE descricao LIKE 'Esta é uma sala de observação, com uma grande janela arqueada%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é uma passagem estreita e claustrofóbica%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 6
-- ====================

-- Conexão 6.NE: Sala 6 <-> Corredor 8 NORDESTE
UPDATE public.local SET local_nordeste = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor é uma passagem estreita e claustrofóbica%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Uma biblioteca submersa, onde estantes de coral e algas%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sudoeste = (SELECT id FROM public.local WHERE descricao LIKE 'Uma biblioteca submersa, onde estantes de coral e algas%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor é uma passagem estreita e claustrofóbica%' AND tipo_local = 'Corredor';

-- Conexão 6.O: Sala 6 <-> Corredor 9 OESTE
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um túnel inundado com água salgada%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Uma biblioteca submersa, onde estantes de coral e algas%' AND tipo_local = 'Sala';
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Uma biblioteca submersa, onde estantes de coral e algas%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um túnel inundado com água salgada%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 7
-- ====================

-- Conexão 7.L: Sala 7 <-> Corredor 9 LESTE
UPDATE public.local SET local_leste = (SELECT id FROM public.local WHERE descricao LIKE 'Um túnel inundado com água salgada%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um laboratório abandonado, com bancadas de pedra cobertas%' AND tipo_local = 'Sala';
UPDATE public.local SET local_oeste = (SELECT id FROM public.local WHERE descricao LIKE 'Um laboratório abandonado, com bancadas de pedra cobertas%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um túnel inundado com água salgada%' AND tipo_local = 'Corredor';

-- Conexão 7.S: Sala 7 <-> Corredor 11 SUL
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor leva a uma área de transição%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um laboratório abandonado, com bancadas de pedra cobertas%' AND tipo_local = 'Sala';
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Um laboratório abandonado, com bancadas de pedra cobertas%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor leva a uma área de transição%' AND tipo_local = 'Corredor';

-- Conexão 7.N: Sala 7 <-> Corredor 10 NORTE
-- TODO trigger e stored procedure para liberar SOMENTE quando o personagem chegar na sala 7
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Um corredor espaçoso com colunas maciças%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Um laboratório abandonado, com bancadas de pedra cobertas%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Um laboratório abandonado, com bancadas de pedra cobertas%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Um corredor espaçoso com colunas maciças%' AND tipo_local = 'Corredor';

-- ====================
-- SALA 8 FINAL
-- ====================

-- Conexão 8.N: Sala 8 <-> Corredor 11 NORTE
UPDATE public.local SET local_norte = (SELECT id FROM public.local WHERE descricao LIKE 'Este corredor leva a uma área de transição%' AND tipo_local = 'Corredor') WHERE descricao LIKE 'Uma cripta úmida, revestida de musgo bioluminescente%' AND tipo_local = 'Sala';
UPDATE public.local SET local_sul = (SELECT id FROM public.local WHERE descricao LIKE 'Uma cripta úmida, revestida de musgo bioluminescente%' AND tipo_local = 'Sala') WHERE descricao LIKE 'Este corredor leva a uma área de transição%' AND tipo_local = 'Corredor';

-- ===============================================

-- ADIÇÃO NA TABELA DE PERSONAGENS JOGÁVEIS E SEUS INVENTÁRIOS

-- ===============================================

-- Criação dos personagens jogáveis iniciais usando a Stored Procedure
-- NOTA: Atributos como força, constituição, etc., são gerados aleatoriamente pela trigger no banco de dados.
SELECT public.sp_criar_personagem_jogavel('Samuel Carter'::public.nome, 'Doutor em Medicina'::public.ocupacao, 'Arkham, MA'::public.residencia, 'Boston, MA'::public.local_nascimento, 42::public.idade, 'masculino'::public.sexo);
SELECT public.sp_criar_personagem_jogavel('Sarah Thompson'::public.nome, 'Arqueóloga'::public.ocupacao, 'Boston, MA'::public.residencia, 'Boston, MA'::public.local_nascimento, 35::public.idade, 'feminino'::public.sexo);

-- ===============================================

-- ADIÇÃO NA TABELA DE personagens_possuem_pericias

-- ===============================================

-- NOTA: Usando INSERT ... ON CONFLICT para garantir que as perícias chave tenham os valores definidos,
--       substituindo qualquer valor que tenha sido atribuído aleatoriamente na criação do personagem.

INSERT INTO public.personagens_possuem_pericias (id_personagem, id_pericia, valor_atual)
VALUES
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM public.pericias WHERE nome = 'Medicina'), 75),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM public.pericias WHERE nome = 'Ciência'), 50),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Sarah Thompson'), (SELECT id FROM public.pericias WHERE nome = 'Arqueologia'), 70),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Sarah Thompson'), (SELECT id FROM public.pericias WHERE nome = 'História'), 60)
ON CONFLICT (id_personagem, id_pericia) DO UPDATE
SET valor_atual = EXCLUDED.valor_atual;
-- ===============================================

-- ADIÇÃO NA TABELA DE NPCS, DIÁLOGOS E MISSÕES

-- ===============================================

-- Criação dos NPCs usando a Stored Procedure
SELECT public.sp_criar_npc('Velho Sábio'::public.nome, 'Guardião do Templo'::public.ocupacao, 'Templo das Sombras'::public.residencia, 'Arkham'::public.local_nascimento, 70::public.idade, 'masculino'::public.sexo);
SELECT public.sp_criar_npc('Guarda do Templo'::public.nome, 'Protetor das Relíquias'::public.ocupacao, 'Templo das Sombras'::public.residencia, 'Arkham'::public.local_nascimento, 45::public.idade, 'masculino'::public.sexo);
SELECT public.sp_criar_npc('Sacerdotisa Sombria'::public.nome, 'Mestre dos Rituais'::public.ocupacao, 'Templo das Sombras'::public.residencia, 'Arkham'::public.local_nascimento, 50::public.idade, 'feminino'::public.sexo);

-- Inserção de diálogos (depende do nome do NPC)
INSERT INTO public.dialogos (script_dialogo, npc_id)
VALUES
    ('Viajante, cuidado com as sombras do templo!', (SELECT id FROM public.npcs WHERE nome = 'Velho Sábio')),
    ('As paredes deste lugar sussurram segredos antigos.', (SELECT id FROM public.npcs WHERE nome = 'Velho Sábio'));

-- Criação de missões usando a Stored Procedure
SELECT public.sp_criar_missao('A Súplica do Ancião'::public.nome, 'Recupere um artefato roubado das profundezas do templo.'::CHARACTER(512), 'principal'::public.tipo_missao, 'Encontre o artefato na sala triangular.'::CHARACTER(128), (SELECT id FROM public.npcs WHERE nome = 'Velho Sábio'));
SELECT public.sp_criar_missao('Relíquias Perdidas'::public.nome, 'Ajude a localizar relíquias dispersas pelo corredor.'::CHARACTER(512), 'coleta'::public.tipo_missao, 'Procure por 3 fragmentos.'::CHARACTER(128), (SELECT id FROM public.npcs WHERE nome = 'Guarda do Templo'));
SELECT public.sp_criar_missao('Purificação do Santuário'::public.nome, 'Extermine uma criatura maligna.'::CHARACTER(512), 'eliminacao'::public.tipo_missao, 'Derrote o Abominável Horror.'::CHARACTER(128), (SELECT id FROM public.npcs WHERE nome = 'Sacerdotisa Sombria'));


-- ===============================================

--       ADIÇÃO NAS TABELAS DE FEITIÇOS

-- ===============================================
SELECT public.sp_criar_feitico(
    p_nome                   := 'Bênção da Coragem'::public.nome,
    p_descricao              := 'Inspira o alvo com bravura, aumentando sua força temporariamente.'::public.descricao,
    p_qtd_pontos_de_magia    := 10::SMALLINT,
    p_tipo_feitico           := 'status'::public.funcao_feitico,
    p_status_buff_debuff     := TRUE,
    p_status_qtd_buff_debuff := 5::SMALLINT,
    p_status_afetado         := 'sanidade'::public.tipo_de_status,
    p_dano_tipo              := NULL,
    p_dano_qtd               := NULL
);

SELECT public.sp_criar_feitico(
    p_nome                    := 'Toque da Agonia'::public.nome,
    p_descricao               := 'Causa dano psíquico direto na mente do alvo.'::public.descricao,
    p_qtd_pontos_de_magia     := 15::SMALLINT,
    p_tipo_feitico            := 'dano'::public.funcao_feitico,
    p_status_buff_debuff      := NULL,
    p_status_qtd_buff_debuff  := NULL,
    p_status_afetado          := NULL,
    p_dano_tipo               := 'unico'::public.tipo_dano,
    p_dano_qtd                := 8::public.dano
);

-- ===============================================

-- ADIÇÃO NA TABELA DE MONSTROS e ITENS

-- ===============================================
/*
Aqui adicionamos os monstros no dml do jogo, cada monstro retorna um id, que é usado na instancia de monstro e em batalhas
também criamos os itens, os quais retornam um id, que é usado nas instâncias de item e nas intâncias de monstro
também criamos as batalhas com base no nome do personagem
*/

SELECT public.sp_criar_monstro(
    p_nome                  := 'Abominável Horror'::public.nome,
    p_descricao             := 'Criatura grotesca que se esconde nas sombras...'::public.descricao,
    p_tipo                  := 'agressivo'::public.tipo_monstro,
    p_agressivo_defesa      := 3::SMALLINT,
    p_agressivo_vida        := 5::SMALLINT,
    p_agressivo_vida_total  := 5::SMALLINT,
    p_agressivo_catalisador := 'proximidade'::public.gatilho_agressividade,
    p_agressivo_poder       := 2::SMALLINT,
    p_agressivo_tipo        := 'psiquico'::public.tipo_monstro_agressivo,
    p_agressivo_velocidade  := 2::SMALLINT,
    p_agressivo_loucura     := 3::SMALLINT,
    p_agressivo_pm          := 4::SMALLINT,
    p_agressivo_dano        := 5::public.dano
);

SELECT public.sp_criar_monstro(
    p_nome                       := 'Espírito Guardião'::public.nome,
    p_descricao                  := 'Um espírito antigo que protege certas áreas...'::public.descricao,
    p_tipo                       := 'pacífico'::public.tipo_monstro,
    p_pacifico_defesa            := 5::SMALLINT,
    p_pacifico_vida              := 30::SMALLINT,
    p_pacifico_vida_total        := 30::SMALLINT,
    p_pacifico_motivo            := 'indiferente'::public.comportamento_pacifico,
    p_pacifico_tipo              := 'sobrenatural'::public.tipo_monstro_pacifico,
    p_pacifico_conhecimento_proibido := 'Sabe sobre a fraqueza de uma entidade maior.'::CHARACTER(128)
);

-- ===============================================
--       CRIAÇÃO DE NOVAS ARMAS E ARMADURAS TEMÁTICAS
-- ===============================================

-- Armas
SELECT public.sp_criar_arma(
    p_nome                    := 'Faca de Sacrifício'::public.nome,
    p_descricao               := 'Uma lâmina de obsidiana, fria ao toque e gravada com símbolos que parecem se mover.'::public.descricao,
    p_valor                   := 45::SMALLINT,
    p_atributo_necessario     := 'destreza'::public.tipo_atributo_personagem,
    p_qtd_atributo_necessario := 10::SMALLINT,
    p_durabilidade            := 70::SMALLINT,
    p_funcao                  := 'corpo_a_corpo_leve'::public.funcao_arma,
    p_alcance                 := 1::SMALLINT,
    p_tipo_municao            := NULL,
    p_tipo_dano               := 'unico'::public.tipo_dano,
    p_dano                    := 5::public.dano
);
SELECT public.sp_criar_arma(
    p_nome                    := 'Revólver Amaldiçoado'::public.nome,
    p_descricao               := 'Um revólver antigo que sussurra o nome de suas vítimas anteriores. Cada tiro custa um pouco de sanidade.'::public.descricao,
    p_valor                   := 70::SMALLINT,
    p_atributo_necessario     := 'destreza'::public.tipo_atributo_personagem,
    p_qtd_atributo_necessario := 12::SMALLINT,
    p_durabilidade            := 50::SMALLINT,
    p_funcao                  := 'disparo_unico'::public.funcao_arma,
    p_alcance                 := 12::SMALLINT,
    p_tipo_municao            := 'medio-calibre'::public.tipo_municao,
    p_tipo_dano               := 'unico'::public.tipo_dano,
    p_dano                    := 10::public.dano
);
SELECT public.sp_criar_arma(
    p_nome                    := 'Cajado de Ossos Retorcidos'::public.nome,
    p_descricao               := 'Feito de ossos de criaturas desconhecidas, este cajado pulsa com uma energia profana.'::public.descricao,
    p_valor                   := 60::SMALLINT,
    p_atributo_necessario     := 'poder'::public.tipo_atributo_personagem,
    p_qtd_atributo_necessario := 14::SMALLINT,
    p_durabilidade            := 90::SMALLINT,
    p_funcao                  := 'corpo_a_corpo_pesada'::public.funcao_arma,
    p_alcance                 := 2::SMALLINT,
    p_tipo_municao            := NULL,
    p_tipo_dano               := 'unico'::public.tipo_dano,
    p_dano                    := 7::public.dano
);

-- Armaduras
SELECT public.sp_criar_armadura(
    p_nome                    := 'Traje de Explorador Esfarrapado'::public.nome,
    p_descricao               := 'Roupas de couro e lona que viram horrores demais. Oferece proteção mínima, mas não atrapalha os movimentos.'::public.descricao,
    p_valor                   := 15::SMALLINT,
    p_atributo_necessario     := 'constituicao'::public.tipo_atributo_personagem,
    p_durabilidade            := 60::SMALLINT,
    p_funcao                  := 'peitoral'::funcao_armadura,
    p_qtd_atributo_recebe     := 1::SMALLINT,
    p_qtd_atributo_necessario := 8::SMALLINT,
    p_tipo_atributo_recebe    := 'constituicao'::public.tipo_atributo_personagem,
    p_qtd_dano_mitigado       := 1::SMALLINT
);
SELECT public.sp_criar_armadura(
    p_nome                    := 'Amuleto de Proteção Inquietante'::public.nome,
    p_descricao               := 'Um amuleto de prata com um olho que parece seguir você. Protege a mente, mas a um custo.'::public.descricao,
    p_valor                   := 55::SMALLINT,
    p_atributo_necessario     := 'poder'::public.tipo_atributo_personagem,
    p_durabilidade            := 40::SMALLINT,
    p_funcao                  := 'peitoral'::funcao_armadura, -- Usando peitoral como slot genérico para amuletos
    p_qtd_atributo_recebe     := 2::SMALLINT,
    p_qtd_atributo_necessario := 13::SMALLINT,
    p_tipo_atributo_recebe    := 'poder'::public.tipo_atributo_personagem,
    p_qtd_dano_mitigado       := 2::SMALLINT
);
SELECT public.sp_criar_armadura(
    p_nome                    := 'Máscara Ritualística Medonha'::public.nome,
    p_descricao               := 'Uma máscara de madeira e ossos que esconde o rosto e a identidade, causando medo nos inimigos.'::public.descricao,
    p_valor                   := 40::SMALLINT,
    p_atributo_necessario     := 'aparencia'::public.tipo_atributo_personagem,
    p_durabilidade            := 75::SMALLINT,
    p_funcao                  := 'cabeca'::funcao_armadura,
    p_qtd_atributo_recebe     := 2::SMALLINT,
    p_qtd_atributo_necessario := 10::SMALLINT,
    p_tipo_atributo_recebe    := 'aparencia'::public.tipo_atributo_personagem,
    p_qtd_dano_mitigado       := 2::SMALLINT
);


-- ===============================================
--       INSTÂNCIAS DE ITENS NO MUNDO
-- ===============================================

INSERT INTO public.instancias_de_itens (durabilidade, durabilidade_total, id_item, id_local, id_local_de_spawn) VALUES 
  -- Faca de Sacrifício na Câmara Triangular (Altar)
  (70, 70, (SELECT id FROM public.itens WHERE nome = 'Faca de Sacrifício'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM public.local WHERE descricao LIKE 'Uma câmara triangular%')),
  -- Revólver Amaldiçoado na Cripta Úmida (Sarcófago)
  (50, 50, (SELECT id FROM public.itens WHERE nome = 'Revólver Amaldiçoado'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM public.local WHERE descricao LIKE 'Uma cripta úmida%')),
  -- Cajado de Ossos no Salão Circular (Trono de Coral)
  (90, 90, (SELECT id FROM public.itens WHERE nome = 'Cajado de Ossos Retorcidos'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular%')),
  -- Traje de Explorador na Sala Inicial
  (60, 60, (SELECT id FROM public.itens WHERE nome = 'Traje de Explorador Esfarrapado'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%')),
  -- Amuleto na Biblioteca Submersa
  (40, 40, (SELECT id FROM public.itens WHERE nome = 'Amuleto de Proteção Inquietante'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM public.local WHERE descricao LIKE 'Uma biblioteca submersa%')),
  -- Máscara Ritualística no Anfiteatro
  (75, 75, (SELECT id FROM public.itens WHERE nome = 'Máscara Ritualística Medonha'), (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM public.local WHERE descricao LIKE 'Um anfiteatro circular%'));


-- Inserindo a instância do monstro com a instância do item
-- CORREÇÃO: Adicionando a coluna 'vida' para inicializar a vida atual do monstro.
INSERT INTO public.instancias_monstros (id_monstro, id_local, id_local_de_spawn, id_instancia_de_item, vida)
SELECT
    (SELECT id FROM public.agressivos WHERE nome = 'Abominável Horror'),
    (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular%'),
    (SELECT id FROM public.local WHERE descricao LIKE 'Um salão circular%'),
    (SELECT id FROM public.instancias_de_itens WHERE id_item = (SELECT id FROM public.itens WHERE nome = 'Faca de Sacrifício')),
    (SELECT vida_total FROM public.agressivos WHERE nome = 'Abominável Horror');

-- Inserindo a batalha
INSERT INTO public.batalhas (id_jogador, id_monstro)
SELECT
    (SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'),
    (SELECT id FROM public.instancias_monstros WHERE id_monstro = (SELECT id FROM public.agressivos WHERE nome = 'Abominável Horror'));

    -- COMMIT; -- Finaliza a transação
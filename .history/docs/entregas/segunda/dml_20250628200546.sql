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

Versão: 1.0
Data: 14/06/2025
Descrição: Atualizando o dml para suportar a criação automática de ids nas tabelas
Autor: Luiz Guilherme

*/
-- ===============================================

--            INSERT DE DADOS

-- ===============================================

INSERT INTO public.tipos_personagem (tipo) VALUES ('personagem jogavel'), ('NPC');
INSERT INTO public.tipos_monstro (tipo) VALUES ('agressivo'), ('pacífico');

-- ===============================================

--       ADIÇÃO NA TABELA DE PERÍCIAS

-- ===============================================

-- A tabela de perícias não depende de nenhuma outra, então a inserção de dados nela é feita primeiro
-- Ela não tem a necessidade de retornar nenhum id ou outro dado após a inserção

INSERT INTO public.pericias 
            (nome, valor, eh_de_ocupacao)
    VALUES  ('Antropologia', 1, FALSE), -- 01%
            ('Armas de Fogo', 0, FALSE), -- varia
            ('Arqueologia', 1, FALSE), -- 01%
            ('Arremessar', 20, FALSE), -- 20%
            ('Arte e Ofício', 5, FALSE), -- 05%
            ('Artilharia', 1, FALSE), -- 01%
            ('Astronomia', 1, FALSE), -- 01%, ver Ciência
            ('Atuação', 5, FALSE), -- 05%, ver Arte/Ofício
            ('Avaliação', 5, FALSE), -- 05%
            ('Belas Artes', 5, FALSE), -- 05%, ver Arte/Ofício
            ('Biologia', 1, FALSE), -- 01%, ver Ciência
            ('Botânica', 1, FALSE), -- 01%, ver Ciência
            ('Briga', 25, FALSE), -- 25%, ver Lutar
            ('Cavalgar', 5, FALSE), -- 05%
            ('Charme', 15, FALSE), -- 15%
            ('Chaveiro', 1, FALSE), -- 01%
            ('Chicotes', 5, FALSE), -- 05%, ver Lutar
            ('Ciência', 1, FALSE), -- 01%
            ('Ciência Forense', 1, FALSE), -- 01%, ver Ciência
            ('Conhecimento', 1, FALSE), -- 01%
            ('Consertos Elétricos', 10, FALSE), -- 10%
            ('Consertos Mecânicos', 10, FALSE), -- 10%
            ('Contabilidade', 5, FALSE), -- 05%
            ('Criptografia', 1, FALSE), -- 01%, ver Ciência
            ('Demolições', 1, FALSE), -- 01%
            ('Direito', 5, FALSE), -- 05%
            ('Dirigir Automóveis', 20, FALSE), -- 20%
            ('Disfarce', 5, FALSE), -- 05%
            ('Eletrônica', 1, FALSE), -- 01%
            ('Encontrar', 25, FALSE), -- 25%
            ('Engenharia', 1, FALSE), -- 01%, ver Ciência
            ('Escalar', 20, FALSE), -- 20%
            ('Espingardas', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            ('Escutar', 20, FALSE), -- 20%
            ('Espadas', 20, FALSE), -- 20%, ver Lutar
            ('Esquivar', 0, FALSE), -- == destreza / 2
            ('Falsificação', 5, FALSE), -- 05%, ver Arte/Ofício
            ('Farmácia', 1, FALSE), -- 01%, ver Ciência
            ('Física', 1, FALSE), -- 01%, ver Ciência
            ('Fotografia', 5, FALSE), -- 05%, ver Arte/Ofício
            ('Furtividade', 20, FALSE), -- 20%
            ('Garrote', 15, FALSE), -- 15%, ver Lutar
            ('Geologia', 1, FALSE), -- 01%, ver Ciência
            ('Hipnose', 1, FALSE), -- 01%
            ('História', 5, FALSE), -- 05%
            ('Intimidação', 15, FALSE), -- 15%
            ('Lábia', 5, FALSE), -- 05%
            ('Lança-Chamas', 10, FALSE), -- 10%, ver Armas de Fogo
            ('Lanças', 20, FALSE), -- 20%, ver Lutar/Arremessar
            ('Leitura Labial', 1, FALSE), -- 01%
            ('Língua (Nativa)', 0, FALSE), -- == educacao
            ('Língua, Outra', 1, FALSE), -- 01%
            ('Lutar', 0, FALSE), -- varia
            ('Machados', 15, FALSE), -- 15%, ver Lutar
            ('Manguais', 10, FALSE), -- 10%, ver Lutar
            ('Matemática', 1, FALSE), -- 01%, ver Ciência
            ('Medicina', 1, TRUE), -- 01%
            ('Mergulho', 1, FALSE), -- 01%
            ('Meteorologia', 1, FALSE), -- 01%, ver Ciência
            ('Metralhadoras', 10, FALSE), -- 10%, ver Armas de Fogo
            ('Motosserras', 10, FALSE), -- 10%, ver Lutar
            ('Mundo Natural', 10, FALSE), -- 10%
            ('Mythos de Cthulhu', 0, FALSE), -- 00%
            ('Natação', 20, FALSE), -- 20%
            ('Navegação', 10, FALSE), -- 10%
            ('Nível de Crédito', 0, FALSE), -- 00%
            ('Ocultismo', 5, FALSE), -- 05%
            ('Operar Maquinário Pesado', 1, FALSE), -- 01%
            ('Persuasão', 10, FALSE), -- 10%
            ('Pilotar', 1, FALSE), -- 01%
            ('Pistolas', 20, FALSE), -- 20%, ver Armas de Fogo
            ('Prestidigitação', 10, FALSE), -- 10%
            ('Primeiros Socorros', 30, FALSE), -- 30%
            ('Psicanálise', 1, FALSE), -- 01%
            ('Psicologia', 10, FALSE), -- 10%
            ('Química', 1, FALSE), -- 01%, ver Ciência
            ('Rastrear', 10, FALSE), -- 10%
            ('Rifles', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            ('Saltar', 20, FALSE), -- 20%
            ('Sobrevivência', 10, FALSE), -- 10%
            ('Submetralhadoras', 15, FALSE), -- 15%, ver Armas de Fogo
            ('Treinar Animais', 5, FALSE), -- 05%
            ('Usar Bibliotecas', 20, FALSE), -- 20%
            ('Usar Computadores', 5, FALSE), -- 05%
            ('Zoologia', 1, FALSE); -- 01%, ver Ciência

-- ===============================================

--       ADIÇÃO NAS TABELAS DE LOCAIS

-- ===============================================

/*
Primeiro criamos o templo que retorna o id
depois as salas, elas retornam os seus ids e descrição
depois os corredores, que também retornam os seus id e descrição
criamos também o andar, ele pega o id do templo criado e adiciona no id templo
ela também pega o id da sala inicial por meio da descrição da sala inicial
*/

WITH 
        templo_criado AS (
                INSERT INTO public.templos(nome, descricao)
                VALUES ('Templo de Chutullu', 'O templo é colossal, suas paredes de pedra verde-escura brilham sob uma luz sobrenatural, entalhadas com runas alienígenas que sussurram segredos proibidos. O ar é salgado e pesado, e cada passo ecoa em corredores que se torcem como pesadelos. No altar central, um ídolo pulsante de Cthulhu aguarda, enquanto sombras insanas dançam à sua volta.')
                RETURNING id
        ),
        salas_criadas AS (
                INSERT INTO public.salas (descricao)
                VALUES  ('O ar pesa como um véu úmido, carregado do sal podre de eras esquecidas. As paredes de pedra verde-escura suam um líquido viscoso, suas superfícies entalhadas com runas que parecem se contorcer sob o olhar prolongado. Um arco negro, adornado com tentáculos de pedra, domina a parede ao fundo — seu vazio parece respirar, exalando um murmúrio que arranha a mente. No centro, um círculo de símbolos antigos está manchado de marrom-escuro, e os ossos quebrados ao redor sugerem que algo espera ali... seja para impedir intrusos... ou recebê-los como oferenda'),
            ('Esta câmara é uma abóbada cavernosa, o teto adornado com estalactites que parecem garras de uma criatura abissal. No centro, um poço sem fundo exala um ar gelado e úmido, e ruídos de algo se movendo na escuridão chegam de suas profundezas. Os hieróglifos nas paredes retratam rituais de sacrifício, e uma leve névoa verde preenche o ambiente.'),
            ('Um salão circular com paredes que pulsam com uma luz bioluminescente fraca, vinda de estranhas plantas marinhas que crescem em fendas. O chão é coberto por uma camada de areia úmida e conchas quebradas, e o ar tem o cheiro de sal e decomposição. No centro, uma estrutura de coral negro retorcido parece um trono macabro.'),
            ('Esta sala é um labirinto de pilares retorcidos e esculpidos com formas grotescas. O chão é escorregadio, coberto por um limo viscoso e esverdeado. Em meio aos pilares, pequenos olhos brilhantes parecem observar de todas as direções, e o silêncio é quebrado apenas pelo gotejar constante de água de uma fonte invisível.'),
            ('Uma câmara triangular com um altar de obsidiana no centro, cercado por incenso queimado que emite uma fumaça densa e doce. As paredes são adornadas com tapeçarias desbotadas que retratam entidades cósmicas e estrelas distantes. Uma energia estranha e pulsante emana do altar.'),
            ('Esta é uma sala de observação, com uma grande janela arqueada que se abre para um abismo escuro, de onde emana um brilho fraco e azulado. Instrumentos metálicos enferrujados estão espalhados pelo chão, e uma sensação de vertigem toma conta de quem se aproxima da janela. Sons distantes de guinchos e rosnados ecoam do vazio.')
            RETURNING id, descricao
        ),
        corredores_criados AS (
                INSERT INTO public.corredores(status, descricao)
                VALUES   (FALSE, 'O corredor estreito serpenteia adiante, suas paredes de pedra negra exsudando uma umidade fria que escorre em veios brilhantes, como lágrimas de estrelas agonizantes. O chão irregular é entalhado com símbolos que latejam suavemente ao toque da luz, ecoando em sussurros distantes quando pisados. Colunas retorcidas sustentam um teto alto demais para ser visto claramente, onde coisas sem forma se agitam nas trevas, seguindo seu avanço com olhos invisíveis. Ao longe, uma névoa esverdeada dança, revelando e ocultando passagens laterais que certamente não estavam lá antes.'),
            (FALSE, 'Este corredor é estreito e serpenteia por uma série de arcos baixos, cada um adornado com símbolos que parecem mudar quando não se olha diretamente. O ar é pesado com o cheiro de ozônio e algo metálico. Sons de arranhões distantes vêm de dentro das paredes.'),
            (FALSE, 'Um corredor largo e cavernoso, com colunas naturais que se elevam até um teto invisível nas trevas. O chão é irregular e coberto por poças de água escura, e o eco dos passos se arrasta por muito tempo. Um vento frio e úmido sopra de uma direção desconhecida.'),
            (FALSE, 'Este corredor tem as paredes cobertas por uma substância pegajosa e translúcida, que brilha fracamente em tons de roxo e azul. O chão é inclinado, e o ar é preenchido com um zumbido baixo e constante. Pequenas aberturas nas paredes revelam vislumbres de espaços claustrofóbicos.'),
            (FALSE, 'Um corredor que se estende em linha reta, suas paredes de pedra lisa e escura refletem a pouca luz como um espelho distorcido. O ar é denso e quente, e um cheiro adocicado e enjoativo paira no ambiente. No final, uma porta de pedra maciça, sem maçaneta, aguarda.'),
            (FALSE, 'Este corredor é irregular e parece descer em espiral para as profundezas. As paredes são cobertas por musgo luminescente e estranhas formações rochosas que se assemelham a criaturas adormecidas. O som de água corrente é constante, e a sensação de estar sendo observado é intensa.')
            RETURNING id, descricao
        ),
        andar_criado AS (
                INSERT INTO public.andares(descricao, id_templo, sala_inicial)
                SELECT 'Primeiro andar do templo de Cthulhu', (SELECT id FROM templo_criado), (SELECT id FROM salas_criadas WHERE descricao LIKE 'O ar pesa%')
                RETURNING id
        )

/*
Aqui fazemos a união dos corredores com as salas, para isso fazemos as pesquisas com base nas descrições das salas e dos corredores
quando ele acha a descrição daquela sala/corredor, ele adiciona o seu id em id_sala/id_corredor
a união não depende mais de uma chave, sendo feita apenas com as descrições
*/

INSERT INTO public.corredores_salas_destino (id_local, id_corredor)
VALUES
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'O corredor estreito serpenteia adiante%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Esta câmara é uma abóbada%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'O corredor estreito serpenteia adiante%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Esta câmara é uma abóbada%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série de arcos baixos%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Um salão circular%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Este corredor é estreito e serpenteia por uma série de arcos baixos%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Um salão circular%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Um corredor largo%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Esta sala é um labirinto%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Um corredor largo%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Esta sala é um labirinto%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma substância pegajosa%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Uma câmara triangular%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Este corredor tem as paredes cobertas por uma substância pegajosa%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Uma câmara triangular%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Um corredor que se estende em linha reta%')),
    ((SELECT id FROM salas_criadas WHERE descricao LIKE 'Esta é uma sala de observação%'), (SELECT id FROM corredores_criados WHERE descricao LIKE 'Um corredor que se estende em linha reta%'));

-- ===============================================

-- ADIÇÃO NA TABELA DE PERSONAGENS JOGÁVEIS E SEUS INVENTÁRIOS

-- ===============================================

/*
Aqui preenchemos os dados nas tabelas dos personagens jogáveis, utilizamos uma pesquisa do id do inventário para 
adicionar o seu id no seu respectivo personagem, note que cada personagem também retorna um id, ele é utilizado 
para adicionar as perícias para os personagens na tabela personagens_possuem_pericias
*/

WITH
  inv_samuel AS ( INSERT INTO public.inventarios (tamanho) VALUES (32) RETURNING id ),
  samuel AS (
    INSERT INTO public.personagens_jogaveis (nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, PM_base, PM_max, pontos_de_vida_atual, id_sala, id_inventario)
    VALUES ('Samuel Carter', 'Doutor em Medicina', 'Arkham, MA', 'Boston, MA', 42, 'masculino', 10, 12, 12, 8, 15, 17, 13, 12, 7, 60, 12, 12, 14, (SELECT id FROM public.salas WHERE descricao LIKE 'O ar pesa%'), (SELECT id FROM inv_samuel))
    RETURNING id
  ),
  inv_sarah AS ( INSERT INTO public.inventarios (tamanho) VALUES (28) RETURNING id ),
  sarah AS (
    INSERT INTO public.personagens_jogaveis (nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, PM_base, PM_max, pontos_de_vida_atual, id_sala, id_inventario)
    VALUES ('Sarah Thompson', 'Arqueóloga', 'Boston, MA', 'Boston, MA', 35, 'feminino', 8, 10, 11, 14, 16, 15, 14, 13, 8, 55, 11, 11, 12, (SELECT id FROM public.salas WHERE descricao LIKE 'Esta câmara é uma abóbada%'), (SELECT id FROM inv_sarah))
    RETURNING id
  )

-- ===============================================

-- ADIÇÃO NA TABELA DE personagens_possuem_pericias

-- ===============================================

/*
Aqui, adicionamos as perícias de cada um dos personagens com base nos ids que é retornado ao pesquisar o seu nome, que foi definido anteriormente
como o nome das perícias é unico, podemos pegar o seu id fazendo uma pesquisa com base no seu nome
*/

INSERT INTO public.personagens_possuem_pericias (id_personagem, id_pericia, valor_atual)
VALUES
    ((SELECT id FROM samuel), (SELECT id FROM public.pericias WHERE nome = 'Medicina'), 75),
    ((SELECT id FROM samuel), (SELECT id FROM public.pericias WHERE nome = 'Ciência'), 50),
    ((SELECT id FROM sarah), (SELECT id FROM public.pericias WHERE nome = 'Arqueologia'), 70),
    ((SELECT id FROM sarah), (SELECT id FROM public.pericias WHERE nome = 'História'), 60);

-- ===============================================

-- ADIÇÃO NA TABELA DE NPCS, DIÁLOGOS E MISSÕES

-- ===============================================

/*
Aqui criamos cada um dos NPCs do jogo, os seus diálogos e as missões que eles carregam seguindo a mesma lógica das inserções anteriores
cada NPC criado retorna um id que é utilizado para se ligar a tabela de diálogos e na de missões
*/

WITH
  sabio AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_sala)
    VALUES ('Velho Sábio', 'Guardião do Templo', 70, 'masculino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.salas WHERE descricao LIKE 'O ar pesa%')) RETURNING id
  ),
  guarda AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_sala)
    VALUES ('Guarda do Templo', 'Protetor das Relíquias', 45, 'masculino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.salas WHERE descricao LIKE 'Esta câmara é uma abóbada%')) RETURNING id
  ),
  sacerdotisa AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_sala)
    VALUES ('Sacerdotisa Sombria', 'Mestre dos Rituais', 50, 'feminino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.salas WHERE descricao LIKE 'Um salão circular%')) RETURNING id
  ),
  dialogos_inseridos AS (
    INSERT INTO public.dialogos (script_dialogo, npc_id)
    VALUES
      ('Viajante, cuidado com as sombras do templo!', (SELECT id FROM sabio)),
      ('As paredes deste lugar sussurram segredos antigos.', (SELECT id FROM sabio))
  )

INSERT INTO public.missoes (nome, descricao, tipo, ordem, id_npc)
VALUES
    ('A Súplica do Ancião', 'Recupere um artefato roubado das profundezas do templo.', 'principal', 'Encontre o artefato na sala triangular.', (SELECT id FROM sabio)),
    ('Relíquias Perdidas', 'Ajude a localizar relíquias dispersas pelo corredor.', 'coleta', 'Procure por 3 fragmentos.', (SELECT id FROM guarda)),
    ('Purificação do Santuário', 'Extermine uma criatura maligna.', 'eliminacao', 'Derrote o Abominável Horror.', (SELECT id FROM sacerdotisa));

-- ===============================================

-- ADIÇÃO NA TABELA DE MONSTROS e ITENS

-- ===============================================

/*
Aqui adicionamos os monstros no dml do jogo, cada monstro retorna um id, que é usado na instancia de monstro e em batalhas
também criamos os itens, os quais retornam um id, que é usado nas instâncias de item e nas intâncias de monstro
também criamos as batalhas com base no nome do personagem 
*/

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
    INSERT INTO public.instancias_de_itens (durabilidade, id_item, id_sala)
    SELECT 100, id, (SELECT id FROM public.salas WHERE descricao LIKE 'Um salão circular%') FROM item_adaga RETURNING id
  ),
  instancia_monstro AS (
    INSERT INTO public.instancias_monstros (id_monstro, id_sala, id_instancia_de_item)
    SELECT (SELECT id FROM monstro_agressivo), (SELECT id FROM public.salas WHERE descricao LIKE 'Um salão circular%'), id FROM instancia_adaga RETURNING id
  )
INSERT INTO public.batalhas (id_jogador, id_monstro)
VALUES
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM instancia_monstro));

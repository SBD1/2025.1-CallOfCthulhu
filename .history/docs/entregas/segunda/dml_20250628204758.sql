/*

HISTORICO DE VERSOES

Versao: 0.1
Data: 10/06/2025
Descricao: Criando inserts iniciais nas tabelas templos, andares, salas, corredores e corredores_salas_destino.
Autor: Cayo, Igor

Versao: 0.2
Data: 10/06/2025
Descricao: Criando inserts iniciais nas tabelas inventarios, salas, tipo_personagem, personagens_jogaveis, corredores, corredores_salas_destino, pericias e personagens_possuem_pericias.
Autor: Christopher, Joao Marcos

Versao: 0.3
Data: 11/06/2025
Descricao: Adicionando exemplos de NPCs e dialogos. Completando tabela de pericias.
Autor: Christopher, Joao Marcos

Versao: 0.4
Data: 11/06/2025
Descricao: Adicionando exemplos de monstros, tanto agressivos quanto pacificos, e suas respectivas tabelas.
Autor: Christopher, Joao Marcos

Versao: 0.5
Data: 11/06/2025
Descricao: Adicionando exemplos de itens, e suas respectivas tabelas.
Autor: Christopher, Joao Marcos

Versao: 0.6
Data: 11/06/2025
Descricao: Adicionando exemplos de instancias de monstros e itens, e suas respectivas tabelas.
Autor: Christopher, Joao Marcos

Versao: 0.7
Data: 11/06/2025
Descricao: Adicionando exemplos de missoes e batalhas, e suas respectivas tabelas.
Autor: Christopher, Joao Marcos

Versao: 0.8
Data: 12/06/2025
Descricao: Removendo o id da tabela inventarios, pois nao eh necessario. Adicionando o id do inventario na tabela personagens_jogaveis. E retirando o id na insercao do personagens_jogaveis.
Autor: Joao Marcos

Versao: 0.9
Data: 13/06/2025
Descricao: Atualizando os ids das tabelas para os novos dominios de id
Autor: Luiz Guilherme

Versao: 1.0
Data: 14/06/2025
Descricao: Atualizando o dml para suportar a criacao automatica de ids nas tabelas
Autor: Luiz Guilherme

Versao: 1.2
Data: 28/06/2025
Descricao: Ajustando DML para a nova estrutura unificada da tabela 'local' (sala e corredor).
            Remocao da tabela de juncao 'conexoes_locais' e utilizacao de auto-referencias para navegacao.
Autor: Luiz Guilherme, Gemini

*/
-- ===============================================

--          INSERT DE DADOS

-- ===============================================

INSERT INTO public.tipos_personagem (tipo) VALUES ('personagem jogavel'), ('NPC');
-- Corrigindo 'pacifico' para o dominio 'tipo_monstro' (sem acento, conforme definido no DDL)
-- Assegurando que os valores inseridos estejam em conformidade com o CHECK CONSTRAINT do dominio tipo_monstro.
INSERT INTO public.tipos_monstro (tipo) VALUES ('agressivo'), ('pacífico'); 

-- ===============================================

--       ADICAO NA TABELA DE PERICIAS

-- ===============================================

-- A tabela de pericias nao depende de nenhuma outra, entao a insercao de dados nela eh feita primeiro
-- Ela nao tem a necessidade de retornar nenhum id ou outro dado apos a insercao

INSERT INTO public.pericias 
            (nome, valor, eh_de_ocupacao)
    VALUES  ('Antropologia', 1, FALSE), -- 01%
            ('Armas de Fogo', 0, FALSE), -- varia
            ('Arqueologia', 1, FALSE), -- 01%
            ('Arremessar', 20, FALSE), -- 20%
            ('Arte e Oficio', 5, FALSE), -- 05%
            ('Artilharia', 1, FALSE), -- 01%
            ('Astronomia', 1, FALSE), -- 01%, ver Ciencia
            ('Atuacao', 5, FALSE), -- 05%, ver Arte/Oficio
            ('Avaliacao', 5, FALSE), -- 05%
            ('Belas Artes', 5, FALSE), -- 05%, ver Arte/Oficio
            ('Biologia', 1, FALSE), -- 01%, ver Ciencia
            ('Botanica', 1, FALSE), -- 01%, ver Ciencia
            ('Briga', 25, FALSE), -- 25%, ver Lutar
            ('Cavalgar', 5, FALSE), -- 05%
            ('Charme', 15, FALSE), -- 15%
            ('Chaveiro', 1, FALSE), -- 01%
            ('Chicotes', 5, FALSE), -- 05%, ver Lutar
            ('Ciencia', 1, FALSE), -- 01%
            ('Ciencia Forense', 1, FALSE), -- 01%, ver Ciencia
            ('Conhecimento', 1, FALSE), -- 01%
            ('Consertos Eletricos', 10, FALSE), -- 10%
            ('Consertos Mecanicos', 10, FALSE), -- 10%
            ('Contabilidade', 5, FALSE), -- 05%
            ('Criptografia', 1, FALSE), -- 01%, ver Ciencia
            ('Demolicoes', 1, FALSE), -- 01%
            ('Direito', 5, FALSE), -- 05%
            ('Dirigir Automoveis', 20, FALSE), -- 20%
            ('Disfarce', 5, FALSE), -- 05%
            ('Eletronica', 1, FALSE), -- 01%
            ('Encontrar', 25, FALSE), -- 25%
            ('Engenharia', 1, FALSE), -- 01%, ver Ciencia
            ('Escalar', 20, FALSE), -- 20%
            ('Espingardas', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            ('Escutar', 20, FALSE), -- 20%
            ('Espadas', 20, FALSE), -- 20%, ver Lutar
            ('Esquivar', 0, FALSE), -- == destreza / 2
            ('Falsificacao', 5, FALSE), -- 05%, ver Arte/Oficio
            ('Farmacia', 1, FALSE), -- 01%, ver Ciencia
            ('Fisica', 1, FALSE), -- 01%, ver Ciencia
            ('Fotografia', 5, FALSE), -- 05%, ver Arte/Oficio
            ('Furtividade', 20, FALSE), -- 20%
            ('Garrote', 15, FALSE), -- 15%, ver Lutar
            ('Geologia', 1, FALSE), -- 01%, ver Ciencia
            ('Hipnose', 1, FALSE), -- 01%
            ('Historia', 5, FALSE), -- 05%
            ('Intimidacao', 15, FALSE), -- 15%
            ('Labia', 5, FALSE), -- 05%
            ('Lanca-Chamas', 10, FALSE), -- 10%, ver Armas de Fogo
            ('Lancas', 20, FALSE), -- 20%, ver Lutar/Arremessar
            ('Leitura Labial', 1, FALSE), -- 01%
            ('Lingua (Nativa)', 0, FALSE), -- == educacao
            ('Lingua, Outra', 1, FALSE), -- 01%
            ('Lutar', 0, FALSE), -- varia
            ('Machados', 15, FALSE), -- 15%, ver Lutar
            ('Manguais', 10, FALSE), -- 10%, ver Lutar
            ('Matematica', 1, FALSE), -- 01%, ver Ciencia
            ('Medicina', 1, TRUE), -- 01%
            ('Mergulho', 1, FALSE), -- 01%
            ('Meteorologia', 1, FALSE), -- 01%, ver Ciencia
            ('Metralhadoras', 10, FALSE), -- 10%, ver Armas de Fogo
            ('Motosserras', 10, FALSE), -- 10%, ver Lutar
            ('Mundo Natural', 10, FALSE), -- 10%
            ('Mythos de Cthulhu', 0, FALSE), -- 00%
            ('Natacao', 20, FALSE), -- 20%
            ('Navegacao', 10, FALSE), -- 10%
            ('Nivel de Credito', 0, FALSE), -- 00%
            ('Ocultismo', 5, FALSE), -- 05%
            ('Operar Maquinario Pesado', 1, FALSE), -- 01%
            ('Persuasao', 10, FALSE), -- 10%
            ('Pilotar', 1, FALSE), -- 01%
            ('Pistolas', 20, FALSE), -- 20%, ver Armas de Fogo
            ('Prestidigitacao', 10, FALSE), -- 10%
            ('Primeiros Socorros', 30, FALSE), -- 30%
            ('Psicanalise', 1, FALSE), -- 01%
            ('Psicologia', 10, FALSE), -- 10%
            ('Quimica', 1, FALSE), -- 01%, ver Ciencia
            ('Rastrear', 10, FALSE), -- 10%
            ('Rifles', 25, FALSE), -- 25%, ver Armas de Fogo (Rifles/Espingardas)
            ('Saltar', 20, FALSE), -- 20%
            ('Sobrevivencia', 10, FALSE), -- 10%
            ('Submetralhadoras', 15, FALSE), -- 15%, ver Armas de Fogo
            ('Treinar Animais', 5, FALSE), -- 05%
            ('Usar Bibliotecas', 20, FALSE), -- 20%
            ('Usar Computadores', 5, FALSE), -- 05%
            ('Zoologia', 1, FALSE); -- 01%, ver Ciencia

-- ===============================================

--       ADICAO NAS TABELAS DE LOCAIS

-- ===============================================

/*
Primeiro criamos o templo que retorna o id
depois os locais (salas e corredores combinados), eles retornam os seus ids e descricao
criamos tambem o andar, ele pega o id do templo criado e adiciona no id templo
ele tambem pega o id do local inicial por meio da descricao e tipo do local
*/

-- Criando a tabela para armazenar os IDs temporários dos locais para referências futuras
-- Isso é necessário porque o DML original usa a descrição para buscar os IDs dos locais
-- em um único WITH, mas agora também precisamos dos IDs para as colunas de direção.
CREATE TEMPORARY TABLE temp_locais_ids (
    descricao TEXT,
    tipo_local TEXT,
    id_local public.id_local
);

WITH 
        templo_criado AS (
                INSERT INTO public.templos(nome, descricao)
                VALUES ('Templo de Chutullu', 'O templo eh colossal, suas paredes de pedra verde-escura brilham sob uma luz sobrenatural, entalhadas com runas alienigenas que sussurram segredos proibidos. O ar eh salgado e pesado, e cada passo ecoa em corredores que se torcem como pesadelos. No altar central, um idolo pulsante de Cthulhu aguarda, enquanto sombras insanas dancam a sua volta.')
                RETURNING id
        )
-- CORRIGIDO: Inserindo os locais na tabela 'local' e capturando seus IDs na tabela temporaria
INSERT INTO temp_locais_ids (descricao, tipo_local, id_local)
SELECT descricao, tipo_local, id
FROM (
    INSERT INTO public.local (descricao, tipo_local, status)
    VALUES 
        -- Salas (status eh NULL para salas, a menos que voce defina o contrario)
        ('O ar pesa como um veu umido, carregado do sal podre de eras esquecidas. As paredes de pedra verde-escura suam um liquido viscoso, suas superficies entalhadas com runas que parecem se contorcer sob o olhar prolongado. Um arco negro, adornado com tentaculos de pedra, domina a parede ao fundo - seu vazio parece respirar, exalando um murmurio que arranha a mente. No centro, um circulo de simbolos antigos esta manchado de marrom-escuro, e os ossos quebrados ao redor sugerem que algo espera ali... seja para impedir intrusos... ou recebe-los como oferenda', 'Sala', NULL),
        ('Esta camara eh uma abobada cavernosa, o teto adornado com estalactites que parecem garras de uma criatura abissal. No centro, um poco sem fundo exala um ar gelado e umido, e ruidos de algo se movendo na escuridao chegam de suas profundezas. Os hieroglifos nas paredes retratam rituais de sacrificio, e uma leve nevoa verde preenche o ambiente.', 'Sala', NULL),
        ('Um salao circular com paredes que pulsam com uma luz bioluminescente fraca, vinda de estranhas plantas marinhas que crescem em fendas. O chao eh coberto por uma camada de areia umida e conchas quebradas, e o ar tem o cheiro de sal e decomposicao. No centro, uma estrutura de coral negro retorcido parece um trono macabro.', 'Sala', NULL),
        ('Esta sala eh um labirinto de pilares retorcidos e esculpidos com formas grotescas. O chao eh escorregadio, coberto por um limo viscoso e esverdeado. Em meio aos pilares, pequenos olhos brilhantes parecem observar de todas as direcoes, e o silencio eh quebrado apenas pelo gotejar constante de agua de uma fonte invisivel.', 'Sala', NULL),
        ('Uma camara triangular com um altar de obsidiana no centro, cercado por incenso queimado que emite uma fumaca densa e doce. As paredes sao adornadas com tapeçarias desbotadas que retratam entidades cosmicas e estrelas distantes. Uma energia estranha e pulsante emana do altar.', 'Sala', NULL),
        ('Esta eh uma sala de observacao, com uma grande janela arqueada que se abre para um abismo escuro, de onde emana um brilho fraco e azulado. Instrumentos metalicos enferrujados estao espalhados pelo chao, e uma sensacao de vertigem toma conta de quem se aproxima da janela. Sons distantes de guinchos e rosnados ecoam do vazio.', 'Sala', NULL),
        -- Corredores (status eh definido para corredores)
        ('O corredor estreito serpenteia adiante, suas paredes de pedra negra exsudando uma umidade fria que escorre em veios brilhantes, como lagrimas de estrelas agonizantes. O chao irregular eh entalhado com simbolos que latejam suavemente ao toque da luz, ecoando em sussurros distantes quando pisados. Colunas retorcidas sustentam um teto alto demais para ser visto claramente, onde coisas sem forma se agitam nas trevas, seguindo seu avanco com olhos invisiveis. Ao longe, uma nevoa esverdeada danca, revelando e ocultando passagens laterais que certamente nao estavam la antes.', 'Corredor', FALSE),
        ('Este corredor eh estreito e serpenteia por uma serie de arcos baixos, cada um adornado com simbolos que parecem mudar quando nao se olha diretamente. O ar eh pesado com o cheiro de ozonio e algo metalico. Sons de arranhoes distantes vem de dentro das paredes.', 'Corredor', FALSE),
        ('Um corredor largo e cavernoso, com colunas naturais que se elevam ate um teto invisivel nas trevas. O chao eh irregular e coberto por pocas de agua escura, e o eco dos passos se arrasta por muito tempo. Um vento frio e umido sopra de uma direcao desconhecida.', 'Corredor', FALSE),
        ('Este corredor tem as paredes cobertas por uma substancia pegajosa e translucida, que brilha fracamente em tons de roxo e azul. O chao eh inclinado, e o ar eh preenchido com um zumbido baixo e constante. Pequenas aberturas nas paredes revelam vislumbres de espacos claustrofobicos.', 'Corredor', FALSE),
        ('Um corredor que se estende em linha reta, suas paredes de pedra lisa e escura refletem a pouca luz como um espelho distorcido. O ar eh denso e quente, e um cheiro adocicado e enjoativo paira no ambiente. No final, uma porta de pedra macica, sem macaneta, aguarda.', 'Corredor', FALSE),
        ('Este corredor eh irregular e parece descer em espiral para as profundezas. As paredes sao cobertas por musgo luminescente e estranhas formacoes rochosas que se assemelham a criaturas adormecidas. O som de agua corrente eh constante, e a sensacao de estar sendo observado eh intensa.', 'Corredor', FALSE)
    RETURNING descricao, tipo_local, id -- 'id' eh o id gerado para 'public.local'
) AS inserted_locais; -- Alias para a subconsulta

-- Inserindo o andar, referenciando o ID do local inicial a partir da temp_locais_ids
INSERT INTO public.andares(descricao, id_templo, sala_inicial)
SELECT 'Primeiro andar do templo de Cthulhu', 
       (SELECT id FROM templo_criado), 
       (SELECT id_local FROM temp_locais_ids WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala');


-- Atualizando as conexões de saida dos locais
UPDATE public.local l
SET
    sul = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'O ar pesa%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'O corredor estreito serpenteia adiante%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    leste = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Esta camara eh uma abobada%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Este corredor eh estreito e serpenteia por uma serie de arcos baixos%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    -- Continue para todas as outras direções que você deseja conectar
    -- Exemplo:
    norte = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Um salao circular%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Um corredor largo%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    oeste = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Esta sala eh um labirinto%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Este corredor tem as paredes cobertas por uma substancia pegajosa%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    cima = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Uma camara triangular%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Um corredor que se estende em linha reta%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    baixo = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Esta eh uma sala de observacao%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Um corredor que se estende em linha reta%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local)
WHERE l.id IN (SELECT id_local FROM temp_locais_ids WHERE tipo_local = 'Sala'); -- Apenas atualiza salas, corredores nao tem saidas diretamente nessas colunas


-- Se os corredores também tiverem saídas diretas para outros locais (salas ou corredores)
-- você precisaria de mais UPDATES para a tabela 'local' para as entradas de 'Corredor'.
-- Exemplo para o primeiro corredor conectando à segunda sala:
UPDATE public.local l
SET
    norte = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'O corredor estreito serpenteia adiante%' AND t1.tipo_local = 'Corredor' AND t2.descricao LIKE 'Esta camara eh uma abobada%' AND t2.tipo_local = 'Sala' WHERE l.id = t1.id_local)
WHERE l.id IN (SELECT id_local FROM temp_locais_ids WHERE tipo_local = 'Corredor');
-- Você precisará replicar isso para todas as conexões de corredores também.

-- ===============================================

-- ADICAO NA TABELA DE PERSONAGENS JOGAVEIS E SEUS INVENTARIOS

-- ===============================================

/*
Aqui preenchemos os dados nas tabelas dos personagens jogaveis, utilizamos uma pesquisa do id do inventario para 
adicionar o seu id no seu respectivo personagem, note que cada personagem tambem retorna um id, ele eh utilizado 
para adicionar as pericias para os personagens na tabela personagens_possuem_pericias
*/

WITH
  inv_samuel AS ( INSERT INTO public.inventarios (tamanho) VALUES (32) RETURNING id ),
  samuel AS (
    INSERT INTO public.personagens_jogaveis (nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, PM_base, PM_max, pontos_de_vida_atual, id_local, id_inventario)
    VALUES ('Samuel Carter', 'Doutor em Medicina', 'Arkham, MA', 'Boston, MA', 42, 'masculino', 10, 12, 12, 8, 15, 17, 13, 12, 7, 60, 12, 12, 14, (SELECT id_local FROM temp_locais_ids WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala'), (SELECT id FROM inv_samuel))
    RETURNING id
  ),
  inv_sarah AS ( INSERT INTO public.inventarios (tamanho) VALUES (28) RETURNING id ),
  sarah AS (
    INSERT INTO public.personagens_jogaveis (nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao, movimento, sanidade_atual, PM_base, PM_max, pontos_de_vida_atual, id_local, id_inventario)
    VALUES ('Sarah Thompson', 'Arqueologa', 'Boston, MA', 'Boston, MA', 35, 
    'feminino', 8, 10, 11, 14, 16, 15, 14, 13, 8, 55, 11, 11, 12, (SELECT id_local FROM temp_locais_ids WHERE descricao LIKE 'Esta camara eh uma abobada%' AND tipo_local = 'Sala'), (SELECT id FROM inv_sarah))
    RETURNING id
  )
SELECT 1; -- Para finalizar o WITH no PostgreSQL, se nao houver outra instrucao

-- Removendo a tabela temporaria
DROP TABLE temp_locais_ids;

-- ===============================================

-- ADICAO NA TABELA DE personagens_possuem_pericias

-- ===============================================

/*
Aqui, adicionamos as pericias de cada um dos personagens com base nos ids que eh retornado ao pesquisar o seu nome, que foi definido anteriormente
como o nome das pericias eh unico, podemos pegar o seu id fazendo uma pesquisa com base no seu nome
*/

INSERT INTO public.personagens_possuem_pericias (id_personagem, id_pericia, valor_atual)
VALUES
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM public.pericias WHERE nome = 'Medicina'), 75),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM public.pericias WHERE nome = 'Ciencia'), 50),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Sarah Thompson'), (SELECT id FROM public.pericias WHERE nome = 'Arqueologia'), 70),
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Sarah Thompson'), (SELECT id FROM public.pericias WHERE nome = 'Historia'), 60);

-- ===============================================

-- ADICAO NA TABELA DE NPCS, DIALOGOS E MISSOES

-- ===============================================

/*
Aqui criamos cada um dos NPCs do jogo, os seus dialogos e as missoes que eles carregam seguindo a mesma logica das insercoes anteriores
cada NPC criado retorna um id que eh utilizado para se ligar a tabela de dialogos e na de missoes
*/

WITH
  sabio AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_local)
    VALUES ('Velho Sabio', 'Guardiao do Templo', 70, 'masculino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.local WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala')) RETURNING id
  ),
  guarda AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_local)
    VALUES ('Guarda do Templo', 'Protetor das Reliquias', 45, 'masculino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.local WHERE descricao LIKE 'Esta camara eh uma abobada%' AND tipo_local = 'Sala')) RETURNING id
  ),
  sacerdotisa AS (
    INSERT INTO public.npcs (nome, ocupacao, idade, sexo, residencia, local_nascimento, id_local)
    VALUES ('Sacerdotisa Sombria', 'Mestre dos Rituais', 50, 'feminino', 'Templo das Sombras', 'Arkham', (SELECT id FROM public.local WHERE descricao LIKE 'Um salao circular%' AND tipo_local = 'Sala')) RETURNING id
  ),
  dialogos_inseridos AS (
    INSERT INTO public.dialogos (script_dialogo, npc_id)
    VALUES
      ('Viajante, cuidado com as sombras do templo!', (SELECT id FROM sabio)),
      ('As paredes deste lugar sussurram segredos antigos.', (SELECT id FROM sabio))
  )
INSERT INTO public.missoes (nome, descricao, tipo, ordem, id_npc)
VALUES
    ('A Suplica do Ancião', 'Recupere um artefato roubado das profundezas do templo.', 'principal', 'Encontre o artefato na sala triangular.', (SELECT id FROM sabio)),
    ('Reliquias Perdidas', 'Ajude a localizar reliquias dispersas pelo corredor.', 'coleta', 'Procure por 3 fragmentos.', (SELECT id FROM guarda)),
    ('Purificacao do Santuario', 'Extermine uma criatura maligna.', 'eliminacao', 'Derrote o Abominavel Horror.', (SELECT id FROM sacerdotisa));

-- ===============================================

-- ADICAO NA TABELA DE MONSTROS e ITENS

-- ===============================================

/*
Aqui adicionamos os monstros no dml do jogo, cada monstro retorna um id, que eh usado na instancia de monstro e em batalhas
tambem criamos os itens, os quais retornam um id, que eh usado nas instancias de item e nas instancias de monstro
tambem criamos as batalhas com base no nome do personagem 
*/

WITH
  monstro_agressivo AS (
    INSERT INTO public.agressivos (nome, descricao, defesa, vida, catalisador_agressividade, poder, tipo_agressivo, velocidade_ataque, loucura_induzida, ponto_magia, dano)
    VALUES ('Abominavel Horror', 'Criatura grotesca que se esconde nas sombras...', 10, 50, 'proximidade', 15, 'psiquico', 5, 20, 10, 30) RETURNING id
  ),
  monstro_pacifico AS (
    INSERT INTO public.pacificos (nome, descricao, defesa, vida, motivo_passividade, tipo_pacifico)
    VALUES ('Espirito Guardiao', 'Um espirito antigo que protege certas areas...', 5, 30, 'indiferente', 'sobrenatural') RETURNING id
  ),
  item_adaga AS (
    INSERT INTO public.itens (tipo, nome, descricao, valor)
    VALUES ('arma', 'Adaga Simples', 'Uma adaga enferrujada.', 5) RETURNING id
  ),
  instancia_adaga AS (
    INSERT INTO public.instancias_de_itens (durabilidade, id_item, id_local) -- Alterado id_sala para id_local
    SELECT 100, id, (SELECT id FROM public.local WHERE descricao LIKE 'Um salao circular%' AND tipo_local = 'Sala') FROM item_adaga RETURNING id
  ),
  instancia_monstro AS (
    INSERT INTO public.instancias_monstros (id_monstro, id_local, id_instancia_de_item) -- Alterado id_sala para id_local
    SELECT (SELECT id FROM monstro_agressivo), (SELECT id FROM public.local WHERE descricao LIKE 'Um salao circular%' AND tipo_local = 'Sala'), id FROM instancia_adaga RETURNING id
  )
INSERT INTO public.batalhas (id_jogador, id_monstro)
VALUES
    ((SELECT id FROM public.personagens_jogaveis WHERE nome = 'Samuel Carter'), (SELECT id FROM instancia_monstro));
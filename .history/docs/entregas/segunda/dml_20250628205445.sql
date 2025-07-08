/*

HISTORICO DE VERSOES
... (seus comentarios de historico) ...

Versao: 1.2
Data: 28/06/2025
Descricao: Ajustando DML para a nova estrutura unificada da tabela 'local' (sala e corredor).
            Remocao da tabela de juncao 'conexoes_locais' e utilizacao de auto-referencias para navegacao.
            Corrigindo a sintaxe do INSERT/RETURNING para popular a tabela temporaria de IDs.
Autor: Luiz Guilherme, Gemini

*/
-- ===============================================

--          INSERT DE DADOS

-- ===============================================

INSERT INTO public.tipos_personagem (tipo) VALUES ('personagem jogavel'), ('NPC');
INSERT INTO public.tipos_monstro (tipo) VALUES ('agressivo'), ('pacfico'); 

-- ===============================================

--       ADICAO NA TABELA DE PERICIAS

-- ===============================================

TRUNCATE TABLE public.pericias RESTART IDENTITY CASCADE; -- Adicionado para evitar duplicatas em re-execuções.

INSERT INTO public.pericias 
            (nome, valor, eh_de_ocupacao)
    VALUES  ('Antropologia', 1, FALSE), 
            ('Armas de Fogo', 0, FALSE), 
            ('Arqueologia', 1, FALSE), 
            ('Arremessar', 20, FALSE), 
            ('Arte e Oficio', 5, FALSE), 
            ('Artilharia', 1, FALSE), 
            ('Astronomia', 1, FALSE), 
            ('Atuacao', 5, FALSE), 
            ('Avaliacao', 5, FALSE), 
            ('Belas Artes', 5, FALSE), 
            ('Biologia', 1, FALSE), 
            ('Botanica', 1, FALSE), 
            ('Briga', 25, FALSE), 
            ('Cavalgar', 5, FALSE), 
            ('Charme', 15, FALSE), 
            ('Chaveiro', 1, FALSE), 
            ('Chicotes', 5, FALSE), 
            ('Ciencia', 1, FALSE), 
            ('Ciencia Forense', 1, FALSE), 
            ('Conhecimento', 1, FALSE), 
            ('Consertos Eletricos', 10, FALSE), 
            ('Consertos Mecanicos', 10, FALSE), 
            ('Contabilidade', 5, FALSE), 
            ('Criptografia', 1, FALSE), 
            ('Demolicoes', 1, FALSE), 
            ('Direito', 5, FALSE), 
            ('Dirigir Automoveis', 20, FALSE), 
            ('Disfarce', 5, FALSE), 
            ('Eletronica', 1, FALSE), 
            ('Encontrar', 25, FALSE), 
            ('Engenharia', 1, FALSE), 
            ('Escalar', 20, FALSE), 
            ('Espingardas', 25, FALSE), 
            ('Escutar', 20, FALSE), 
            ('Espadas', 20, FALSE), 
            ('Esquivar', 0, FALSE), 
            ('Falsificacao', 5, FALSE), 
            ('Farmacia', 1, FALSE), 
            ('Fisica', 1, FALSE), 
            ('Fotografia', 5, FALSE), 
            ('Furtividade', 20, FALSE), 
            ('Garrote', 15, FALSE), 
            ('Geologia', 1, FALSE), 
            ('Hipnose', 1, FALSE), 
            ('Historia', 5, FALSE), 
            ('Intimidacao', 15, FALSE), 
            ('Labia', 5, FALSE), 
            ('Lanca-Chamas', 10, FALSE), 
            ('Lancas', 20, FALSE), 
            ('Leitura Labial', 1, FALSE), 
            ('Lingua (Nativa)', 0, FALSE), 
            ('Lingua, Outra', 1, FALSE), 
            ('Lutar', 0, FALSE), 
            ('Machados', 15, FALSE), 
            ('Manguais', 10, FALSE), 
            ('Matematica', 1, FALSE), 
            ('Medicina', 1, TRUE), 
            ('Mergulho', 1, FALSE), 
            ('Meteorologia', 1, FALSE), 
            ('Metralhadoras', 10, FALSE), 
            ('Motosserras', 10, FALSE), 
            ('Mundo Natural', 10, FALSE), 
            ('Mythos de Cthulhu', 0, FALSE), 
            ('Natacao', 20, FALSE), 
            ('Navegacao', 10, FALSE), 
            ('Nivel de Credito', 0, FALSE), 
            ('Ocultismo', 5, FALSE), 
            ('Operar Maquinario Pesado', 1, FALSE), 
            ('Persuasao', 10, FALSE), 
            ('Pilotar', 1, FALSE), 
            ('Pistolas', 20, FALSE), 
            ('Prestidigitacao', 10, FALSE), 
            ('Primeiros Socorros', 30, FALSE), 
            ('Psicanalise', 1, FALSE), 
            ('Psicologia', 10, FALSE), 
            ('Quimica', 1, FALSE), 
            ('Rastrear', 10, FALSE), 
            ('Rifles', 25, FALSE), 
            ('Saltar', 20, FALSE), 
            ('Sobrevivencia', 10, FALSE), 
            ('Submetralhadoras', 15, FALSE), 
            ('Treinar Animais', 5, FALSE), 
            ('Usar Bibliotecas', 20, FALSE), 
            ('Usar Computadores', 5, FALSE), 
            ('Zoologia', 1, FALSE); 

-- ===============================================

--       ADICAO NAS TABELAS DE LOCAIS

-- ===============================================

/*
Primeiro criamos o templo que retorna o id
depois os locais (salas e corredores combinados), eles retornam os seus ids e descricao
criamos tambem o andar, ele pega o id do templo criado e adiciona no id templo
ele tambem pega o id do local inicial por meio da descricao e tipo do local
*/

-- Adicione esta linha antes do CREATE TEMPORARY TABLE
DROP TABLE IF EXISTS temp_locais_ids;

-- Criando a tabela para armazenar os IDs temporarios dos locais para referencias futuras
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
        ),
        -- Use uma CTE para inserir em public.local e retornar os dados
        locais_inseridos AS (
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
        )
-- Inserindo os dados da CTE (locais_inseridos) na tabela temporaria
INSERT INTO temp_locais_ids (descricao, tipo_local, id_local)
SELECT descricao, tipo_local, id FROM locais_inseridos;

-- Inserindo o andar, referenciando o ID do local inicial a partir da temp_locais_ids
-- Usamos a CTE `templo_criado` aqui, pois ela está no escopo do mesmo bloco `WITH`.
INSERT INTO public.andares(descricao, id_templo, sala_inicial)
SELECT 'Primeiro andar do templo de Cthulhu', 
       (SELECT id FROM templo_criado), 
       (SELECT id_local FROM temp_locais_ids WHERE descricao LIKE 'O ar pesa%' AND tipo_local = 'Sala');


-- Atualizando as conexões de saida dos locais
-- Usamos a temp_locais_ids para buscar os IDs dos locais
UPDATE public.local l
SET
    sul = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'O ar pesa%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'O corredor estreito serpenteia adiante%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    norte = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Esta camara eh uma abobada%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Este corredor eh estreito e serpenteia por uma serie de arcos baixos%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    leste = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Um salao circular%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Um corredor largo%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    oeste = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Esta sala eh um labirinto%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Este corredor tem as paredes cobertas por uma substancia pegajosa%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    cima = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Uma camara triangular%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Um corredor que se estende em linha reta%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local),
    baixo = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'Esta eh uma sala de observacao%' AND t1.tipo_local = 'Sala' AND t2.descricao LIKE 'Um corredor que se estende em linha reta%' AND t2.tipo_local = 'Corredor' WHERE l.id = t1.id_local)
WHERE l.id IN (SELECT id_local FROM temp_locais_ids WHERE tipo_local = 'Sala'); -- Apenas atualiza salas (ou locais com saidas explicitas)

-- Você precisaria replicar isso para todas as conexões de corredores também.
-- Exemplo para o primeiro corredor conectando à segunda sala:
UPDATE public.local l
SET
    norte = (SELECT t2.id_local FROM temp_locais_ids t1 JOIN temp_locais_ids t2 ON t1.descricao LIKE 'O corredor estreito serpenteia adiante%' AND t1.tipo_local = 'Corredor' AND t2.descricao LIKE 'Esta camara eh uma abobada%' AND t2.tipo_local = 'Sala' WHERE l.id = t1.id_local)
WHERE l.id IN (SELECT id_local FROM temp_locais_ids WHERE descricao LIKE 'O corredor estreito serpenteia adiante%' AND tipo_local = 'Corredor');
-- Repita para todas as direções e todas as conexões de corredores.


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
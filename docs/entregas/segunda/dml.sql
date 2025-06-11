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

INSERT INTO public.inventarios (id, tamanho)
VALUES (1, 32);

-- TABELA SALAS (EXEMPLOS)

INSERT INTO public.salas (id, descricao)
VALUES (1, 'Salão Principal do Templo'),
       (2, 'Sala dos Murmúrios Antigos'),
       (3, 'Câmara Secreta do Templo'),
       (4, 'Tumba Esquecida'),
       (5, 'Arsenal Abandonado'),
       (6, 'Biblioteca Proibida');

-- TABELA TIPOS_PERSONAGEM

INSERT INTO public.tipos_personagem (id, tipo)
VALUES (2001, 'personagem jogavel');

-- TABELA PERSONAGENS_JOGAVEIS

INSERT INTO public.personagens_jogaveis(id, nome, ocupacao, residencia, local_nascimento, 
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
                                        1, NULL, NULL, 2001);

-- TABELA CORREDORES (EXEMPLOS)

INSERT INTO public.corredores (id, status, descricao)
VALUES (1, TRUE, 'Corredor Principal do Templo'),
       (2, TRUE, 'Corredor Secundário do Templo'),
       (3, TRUE, 'Corredor de Emergência do Templo'),
       (4, FALSE, 'Corredor de Acesso Restrito do Templo'),
       (5, FALSE, 'Corredor de Manutenção do Templo'),
       (6, FALSE, 'Corredor de Descarte do Templo');

-- TABELA CORREDORES_SALA_DESTINO (EXEMPLOS)

INSERT INTO public.corredores_salas_destino (id_sala, id_corredor)
VALUES (1, 1),
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
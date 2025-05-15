## Histórico de versões

| Versão |    Data    | Descrição               | Autor                                                                                                                 |
| :----: | :--------: | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `1.0`  | 01/05/25 | Criação do documento DD | [Christopher Paraizo](https://github.com/wChrstphr)                                                                  |
| `1.1`  | 02/05/25 | Populando o DD | [Christopher Paraizo](https://github.com/wChrstphr)   |
| `1.2`  | 02/05/25 | Populando o DD com as tabelas de entidades | [Christopher Paraizo](https://github.com/wChrstphr) e [João Marcos](https://github.com/JJOAOMARCOSS)   |
| `1.3`  | 02/05/25 | Populando o DD com as tabelas provindas de relacionamentos, generalizações e especializações | [Christopher Paraizo](https://github.com/wChrstphr)      |   
| `1.4`  | 15/05/25 | Adicionando a tabela Diálogos | [Luiz](https://github.com/luizfaria1989)      |                                                          |

# DD - Dicionário de Dados

> "Um dicionário de dados é uma coleção de nomes, atributos e definições sobre elementos de dados que estão sendo usados ​​em seu estudo" (ABCD-USP) 
>
>[...] "o dicionário de dados armazena outras informações, como
as decisões de projeto, os padrões de utilização, as descrições dos programas das aplicações e as informações dos usuários" (Navathe, 2005)
>
>Seu principal objetivo é esclarecer o significado dos nomes e valores das variáveis presentes em uma planilha ou base de dados. Em um dicionário de dados, é possível encontrar informações como:
> - Nomes das variáveis exatamente como aparecem na planilha;
> - Intervalo de valores ou categorias aceitas para cada variável;
> - Descrição detalhada da finalidade e conteúdo da variável;
> - Outras informações relevantes, como unidades de medida, formatos ou regras de coleta.

# Tabelas Provindas de Entidades
## Entidade: NPC
### Tabela: npcs
#### Descrição: A entidade NPC (Non-Player-Character) guarda as informações sobre seu identificador único, informações pessoais como nome, ocupação, idade, sexo, residência, local de nascimento e script de diálogo além do local em que está.

#### Observação: essa tabela possui chave estrangeira para as entidades ``Sala`` e ``Corredor``

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do NPC | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome completo do NPC | a-z, A,z | Não | |
| ocupacao | varchar[100] | Ocupação do NPC na história | a-z, A,z | Não | |
| idade | int | Idade do NPC | 1 - 200 | Não | |
| sexo | char[1] | Sexo do NPC | F, M | Não | |
| residencia | varchar[200] | Descrição de onde o NPC reside | a-z, A-z, !-/ | Não | |
| local_nascimento | varchar[100] | Local onde o NCP nasceu | a-z, A-z, !-/ | Não | | 
| script_dialogo | varchar [500] | Script de diálogo que o NPC vai ter com o jogador | a-z, A-z, !-/ | Não | |
| local_boolean | boolean | Verifica onde o NPC está, sendo 1 para sala e 0 para corredor | 1-0 | Não | | 
| id_local | int | Local onde o NPC está | 1 - 5000 | Não | FK |

## Entidade: Diálogos
### Tabela: dialogos
#### Descrição: A tabela diálogos contém os textos dos diálogos dos NPCs do RPG.

#### Observação: essa tabela possui chave estrangeira para as entidades ``Sala`` e ``Corredor``

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do Dialogo | 1 - 5000 | Não | PK | |
| id_npc | varchar[100] | id do NPC que possui aquele diálogo | a-z, A,z | Não | FK |
| script_dialogo | varchar[500] | Texto do diálogo do NPC que será lido pelo jogador| a-z, A,z, !?,. | Não | |


## Entidade: Personagem Jogável
### Tabela: personagens_jogaveis

#### Descrição: A entidade Personagem Jogável armazena informações sobre o identificador único, dados pessoais (nome, ocupação, idade, sexo, residência, local de nascimento), atributos de status (força, destreza, magia, inteligência, sorte, entre outros), equipamentos (arma, armadura), inventário e localização atual do personagem controlado pelo jogador. Inclui também características físicas e habilidades específicas, como tamanho, aparência, educação e conhecimento, essenciais para interações e mecânicas de jogo.

#### Observação: essa tabela possui chave estrangeira para as entidades `Sanidade`, `Pts_de_magia`, `Pericia`, `Instancia_de_item`, `Inventario`, `Sala` e `Corredor`

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do personagem | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome completo do personagem  | a-z, A,z | Não | |
| id_pt_de_magia | int | Identificador de magia que o personagem possui | 10 - 100 | Não | FK | Valor base = x |
| id_pericia | int | Identificador de perícia que o personagem possui | 1 - 5000 | Não | FK |
| id_sanidade | int | Identificador de sanidade mental que o personagem possui | 1 - 5000 | Não | FK |
| ocupacao | varchar[100] | Ocupação do personagem na história do jogo | a-z, A,z | Não | |
| idade | int | Idade do personagem | 1 - 200 | Não | |
| sexo | char[1] | Sexo do personagem | F, M | Não | |
| residencia | varchar[200] | Descrição de onde o personagem reside | a-z, A-z, !-/ | Não | |
| local_nascimento | varchar[100] | Local onde o personagem nasceu | a-z, A-z, !-/ | Não | | 
| id_armadura | int | Identificador de qual armadura o personagem equipa | 1 - 5000 | Não | FK |
| id_arma | int | Identificador de qual arma o personagem equipa | 1 - 5000 | Não | FK |
| forca | int | Pontos de força que o personagem possui | 1 - 100 | Não |  |
| destreza | int | Pontos de destreza que o personagem possui | 1 - 100 | Não |  |
| constituicao | int | Pontos de constituição que o personagem possui | 1 - 100 | Não |  |
| tamanho | int | Pontos de tamanho que o personagem possui | 1 - 100 | Não |  |
| aparencia | int | Pontos de aparência que o personagem possui | 1 - 100 | Não |  |
| inteligencia | int | Pontos de inteligencia que o personagem possui | 1 - 100 | Não |  |
| poder | int | Pontos de destreza poder o personagem possui | 1 - 100 | Não |  |
| educacao | int | Pontos de destreza que educação personagem possui | 1 - 100 | Não |  |
| ideia | int | Pontos de ideia que o personagem possui | 1 - 100 | Não |  |
| conhecimento | int | Pontos de conhecimento que o personagem possui | 1 - 100 | Não |  |
| movimento | int | Pontos de movimento que o personagem possui | 1 - 100 | Não |  |
| sorte | int | Pontos de sorte que o personagem possui | 1 - 100 | Não |  |
| inventario | int | Identificador de inventário do personagem | 1 - 5000 | Não | FK |
| localBoolean | boolean | Verifica onde o personagem está, sendo 1 para sala e 0 para corredor | 1-0 | Não | | 
| id_local | int | Local onde o personagem está | 1 - 5000 | Não | FK |

## Entidade: Sanidade
### Tabela: sanidades
#### Descrição: a entidade Sanidade armazena o estado mental de um personagem, registrando seu identificador único, valores máximos e atuais de sanidade, além de status temporários ou permanentes de insanidade.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da sanidade do personagem | 1 - 5000 | Não | PK | |
| sanidade_maxima | int | Sanidade máxima que o personagem pode ter | 10 - 100 | Não | | Valor padrão = 10 | 
| sanidade_atual | int | Sanidade atual do personagem | 10 - 100 | Não | | Valor padrão = 10 | 
| insanidade_temporaria | boolean | Insaidade temporária produzida por algum evento externo | 1-0 | Não | |
| insanidade_indefinida | boolean | Insanidade sem tempo determinado e que só terminará após uma ação específica | 1-0 | Não | | 

## Entidade: Perícia
### Tabela: pericias
#### Descrição: a entidade pontos de pericia possui identificar único, valor da perícia e se é de ocupação do personagem.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único dos pontos de perícia do personagem | 1 - 5000 | Não | PK | |
| valor | int | Valor da perícia do personagem | 10 - 100 | Não | | Valor padrão = 10 | 
| de_ocupacao | boolean | A perícia é de ocupação do personagem ou não?  | 1-0 | Não | 0 para sim e 1 para não | 

## Entidade: Pontos de Magia
### Tabela: pts_de_magia
#### Descrição: a entidade pontos de magia gerencia os recursos mágicos de um personagem, registrando seu identificador único, valor base de pontos de magia e o máximo possível de PM (Pontos de Magia). 

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único dos pontos de perícia do personagem | 1 - 5000 | Não | PK | |
| valor_base | int | Valor base dos pontos de magia do personagem | 10 - 100 | Não | | Valor padrão = 10 | 
| PM_max | int | Valor máximo de pontos de magia do personagem | 10 - 100 | Não | |  | 

## Entidade: Inventario
### Tabela: inventarios

#### Descrição: A entidade Inventário armazena informações sobre o identificador único e tamanho do inventário, que representa a capacidade disponível para armazenamento.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do inventário | 1 - 5000 | Não | PK | |
| tamanho | int | Tamanho do invetário do personagem | 10 - 100 | Não | | Valor padrão = 10 | 

## Entidade: Templo
### Tabela: templos

#### Descrição: A entidade Templo armazena informações sobre seu identificador único, nome e descrição detalhada do local.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do templo | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome do templo | a-z, A-z | Não | | | 
| descricao | varchar[200] | Descrição do templo |  a-z, A-z, !-/ | Não | | | 

## Entidade: Andar
### Tabela: andares
#### Descrição: A entidade Andar armazena informações sobre seu identificador único, descrição, sala inicial e a referência ao templo ao qual pertence. 

#### Observação: essa entidade possui chave estrangeira para as Entidades ``Templo`` e ``Sala``

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Número do andar | 1 - 50 | Não | PK | |
| descricao | varchar[200] | Descrição do andar |  a-z, A-z, !-/ | Não | | | 
| salaInicial | int | Sala inicial daquele andar | 1 - 5000 | Não | FK | |
| id_templo | int | Templo no qual aquele andar está contido | 1 - 5000 | Não | FK | |

## Entidade: Sala
### Tabela: salas
#### Descrição: A entidade Sala possui informações sobre seu identificador único e descrição

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da sala | 1 - 5000 | Não | PK | |
| descricao | varchar[200] | Descrição da sala |  a-z, A-z, !-/ | Não | | | 

## Entidade: Corredor
### Tabela: corredores
#### Descrição: a entidade Corredor armazena os dados essenciais para identificar e caracterizar um corredor, como seu identificador único, o status atual e uma descrição.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da sala | 1 - 5000 | Não | PK | |
| status | boolean | Verifica se o corredor pode ser acessado ou não: 0 para inativo e 1 para ativo | Não | | 
| descricao | varchar[200] | Descrição do corredor |  a-z, A-z, !-/ | Não | | | 


## Entidade: Instancia de Monstro
### intancias_monstros
#### Descrição: a entidade InstanciaMonstro registra as instâncias específicas de monstros presentes no sistema. Armazena o identificador único da instância, a referência ao monstro base, e informações sobre sua localização.

#### Observação: essa tabela possui chave estrangeira para as entidades ``Pacífico``, ``Agressivo``, ``Corredor`` e ``Sala``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da instância do monstro | 1 - 5000 | Não | PK | |
| id_monstro | int | Identificador do tipo daquele monstro | 1 - 5000 | Não | FK | |
| localBoolean | boolean | Verifica onde a instância do monstro está, sendo 1 para sala e 0 para corredor | Não | | 
| id_local | int | Identificador do local daquele monstro | 1 - 5000 | Não | FK | |
| id_instancia_de_item | int | Identificador do item daquele monstro | 1 - 5000 | Não | FK | |

## Entidade: Pacifico
### Tabela: pacificos
#### Descrição: a entidade Pacifico armazena informações sobre monstros de comportamento passivo, detalhando suas características físicas. como defesa, vitalidade, o motivo da sua não agressividade e seu nome.

#### Observação: .
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do monstro pacífico | 1 - 5000 | Não | PK e FK | |
| nome | varchar[100] | Nome do monstro pacífico | a-z, A,z | Não | |
| descricao | varchar[100] | Descrição do monstro pacífico | a-z, A,z | Não | |
| defesa | int | Defesa do monstro pacífico | 1 - 50 | Não | |
| vida | int | Vida do monstro pacífico | 1 - 100 | Não | Valor Base = 100|
| motivo_passividade | varchar[100] | Descrição da motivo para o monstro ser passivo | a-z, A,z | Não | |

## Entidade: Agressivo
### Tabela: agressivos
#### Descrição: 

#### Observação: .
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do monstro agressivo | 1 - 5000 | Não | PK e FK | |
| nome | varchar[100] | Nome do monstro agressivo | a-z, A,z | Não | |
| descricao | varchar[100] | Descrição do monstro agressivo | a-z, A,z | Não | |
| defesa | int | Defesa do monstro agressivo | 1 - 50 | Não | |
| vida | int | Vida do monstro agressivo | 1 - 100 | Não | Valor Base = 100|
| poder | int | Poder do monstro agressivo | 1 - 100 | Não | Valor Base = 100|
| catalisador_agressividade | varchar[100] | Motivo ou catalisador para o monstro ser agressivo e hostil | a-z, A,z | Não | |

## Entidade: Arma
### Tabela: armas
#### Descrição: a entidade Arma armazena as informações sobre itens do tipo arma, incluindo seu identificador único, atributos necessários para uso (atributo e perícia), características de combate (durabilidade, função, alcance, tipo de munição, tipo de dano e valor de dano).

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do item | 1 - 5000 | Não |  | |
| atributo_necessario | varchar[100] | Atributo necessário para que a arma seja utilizada | a-z, A,z | Não | |
| qtd_atributo_necessario | int | Quantidade de atributos necessário para que a arma seja utilizada pelo personagem | 1 - 50 | Não | |
| durabilidade | int | Durabilidade da arma | 1 - 100 | Não | |
| pericia_necessario | varchar[100] | Perícia necessária para que o personagem possa utilizar essa arma | a-z, A,z | Não | |
| alcance | int | Alcance da arma | 1 - 100 | Não | |
| tipo_municao | varchar[100] | Tipo da munição dessa arma | a-z, A,z | Não | |
| tipo_dano | varchar[100] | Tipo de dano dessa arma | a-z, A,z | Não | |
| dano | int | Dano da arma | 1 - 100 | Não | |

## Entidade: Armadura
### Tabela: armaduras
#### Descrição: a entidade Armadura armazena as informações sobre itens de proteção, incluindo seu identificador único, atributos necessários para uso, características como durabilidade, função, quantidade de atributo recebido, tipo de atributo beneficiado e quantidade de dano mitigado.

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da amardura | 1 - 5000 | Não |  | |
| atributo_necessario | varchar[100] | Atributo necessário para que a armadura seja utilizada | a-z, A,z | Não | |
| qtd_atributo_necessario | int | Quantidade de atributos necessário para que a armadura seja utilizada pelo personagem | 1 - 50 | Não | |
| durabilidade | int | Durabilidade da armadura | 1 - 100 | Não | |
| pericia_necessario | varchar[100] | Perícia necessária para que o personagem possa utilizar essa armadura | a-z, A,z | Não | |
| funcao | varchar[100] | Função da armadura | a-z, A,z | Não | |
| qtd_atributo_recebe | int | Quantidade de atributo que a armadura concede ao personagem | 1 - 100 | Não | |
| tipo_atributo_recebe | varchar[100] | Tipo da atributo recebido por essa armadura | a-z, A,z | Não | |
| qtd_dano_mitigado | int | Quantidade de dano mitigado pela armadura quando utilizada pelo personagem | 1 - 100 | Não | |

## Entidade: Item
### Tabela: itens
#### Descrição: a entidade Item armazena informações gerais sobre itens, incluindo seu identificador único, tipo, nome, descrição e valor.

#### Observação: essa entidade possui chave estrangeira para as entidades ``Arma``, ``Armadura`` e ``Cura``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do item | 1 - 5000 | Não | PK e FK | |
| tipo | varchar[100] | Tipo do item | a-z, A,z | Não | |
| nome | varchar[100] | Nome do item | a-z, A,z | Não | |
| descricao | varchar[100] | Descrição do item | a-z, A,z | Não | |
| valor | int | Valor de venda do item | 1 - 20000 | Não | |

## Entidade: Cura
### Tabela: curas
#### Descrição: a entidade Cura armazena informações sobre itens ou efeitos de recuperação, incluindo seu identificador único, função principal, quantidade de usos disponíveis e os valores de pontos de sanidade e/ou vida recuperados.

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do item de cura | 1 - 5000 | Não | PK e FK | |
| funcao | varchar[100] | Função do item de cura | a-z, A,z | Não | |
| qtd_usos | int | Quantidade de usos desse item de cura | 1 - 10 | Não | |
| qtd_pontos_sanidade_recupera | int | Quantidade de pontos de sanidade que esse item recupera | 1 - 100 | Não | |
| qtd_pontos_vida_recupera | int | Quantidade de pontos de vida que esse item recupera | 1 - 100 | Não | |

## Entidade: Instância de Item
### Tabela: instancias_de_itens
#### Descrição: a entidade Instância de item registra as ocorrências específicas de itens no jogo, contendo identificador único, referência ao item original, durabilidade, sala em que está, missões a qual está associado e batalhas .

#### Observação: essa entidade possui chave estrangeira para as entidades ``Item``, ``Sala``, ``Batalha`` e as tabelas ``inventario_possui_instancia_item``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da instância de item | 1 - 5000 | Não | PK | |
| id_item | int | Identificador único do item | 1 - 5000 | Não | FK | |
| durabilidade | int | Durabilidade da de item | 1 - 100 | Não | |
| id_sala | int | Sala no qual esse item está | 1 - 100 | Não |  |
| id_missao_requer | int | Item necessário para poder realizar uma missão | 1 - 100 | Não | FK |
| id_missao_recompensa | int | Recompensa que uma missão da para o personagem ao ser concluída | 1 - 100 | Não | FK |

## Entidade: Mágico
### Tabela: magicos
#### Descrição: a entidade mágico armazena informações sobre itens mágicos que podem ser utilizados por personagens, incluindo seu identificador único, função principal, quantidade de usos disponíveis e o custo em pontos de sanidade para cada utilização. 

#### Observação: essa entidade possui chave estrangeira para a tabela ``tipo_feitico``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do item de mágico | 1 - 5000 | Não | PK | |
| id_feitico | int | Identificador único do feitiço mágico | 1 - 5000 | Não | PK e FK | |
| funcao | varchar[100] | Função do item mágico | a-z, A,z | Não | |
| qtd_usos | int | Quantidade de usos desse item mágico | 1 - 10 | Não | |
| custo_sanidade | int | Quantidade de pontos de sanidade que esse item mágico custa ao personagem por utilizá-lo | 1 - 100 | Não | |


## Entidade: Feitiço Status
### Tabela: feiticos_status
#### Descrição:  a entidade Feitico_status armazena informações sobre feitiços que afetam o status de personagens, incluindo seu identificador único, nome, descrição, quantidade de pontos de magia consumidos, tipo e intensidade do efeito (buff ou debuff) e o status afetado. Além disso, está vinculada à entidade Tipo_feitiço por meio de chave estrangeira.

#### Observação: essa entidade é chave estrangeira para ``Tipo_feitiço``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do feitiço que afeta status | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome do feitiço status | a-z, A,z | Não | |
| descricao | varchar[100] | Descrição do feitiço status | a-z, A,z | Não | |
| qtd_pontos_de_magia | int | Quantidade de pontos de magia | 1 - 5000 | Não | |
| qtd_buff_debuff | int | Quantidade de Buff ou Debuff | 1 - 5000 | Não | |
| buff_ou_debuff | Boolean | Buff ou Debuff | 0 - 1 | Não | |
| status_afetado | varchar[100] | Status que sera afetado | a-z, A,z | Não | |


## Entidade: Feitiço Dano
### Tabela: feiticos_dano
#### Descrição:  a entidade Feitico_dano armazena informações sobre feitiços que causam dano direto, incluindo seu identificador único, nome, descrição, quantidade de pontos de magia consumidos, tipo de dano causado e a quantidade de dano gerado. Além disso, está vinculada à entidade Tipo_feitiço por meio de chave estrangeira.

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do feitiço que afeta status | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome do feitiço dano | a-z, A,z | Não | |
| descricao | varchar[100] | Descrição do feitiço dano | a-z, A,z | Não | |
| qtd_pontos_de_magia | int | Quantidade de pontos de magia do feitiço | 1 - 100 | Não | |
| tipo_dano | varchar[100] | Tipo de dano do feitiço | a-z, A,z | Não | |
| qtd_dano | int | Quantidade de Dano do feitiço | 1 - 25 | Não | |



## Entidade: Missao
### Tabela: missoes
#### Descrição:  a entidade missoes armazena as missoe disponíveis no jogo, com seu id, nome, descrição, tipo, ordem e npc que a disponibiliza.
#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único da missao| 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome da missao | a-z, A,z | Não | |
| descricao | varchar[500] | Descrição da missao | a-z, A,z | Não | |
| tipo | int | Codigo tipo da missao | 1 - 100 | Não | |
| ordem | varchar[100] | Ordem da missao | a-z, A,z | Não | |
| id_npc | int | Quantidade de Dano do feitiço | 1 - 5000 | Não | FK |




# Tabelas Provindas de Relacionamentos, Especializações e Generalizações
### Tabela: tipos_monstro
#### Descrição:  a tabela tipos_monstro possui o identificador único e o tipo do monstro
#### Observação: essa tabela possui chave estrangeira para as tabelas ``agressivos`` e ``pacificos``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_monstro | int | Identificador único do feitiço que afeta status | 1 - 5000 | Não | PK e FK | |
| tipo | varchar[100] | Tipo do monstro | a-z, A,z | Não | |

### Tabela: batalhas
#### Descrição:  a tabela batalhas possui identificadores do jogador e do monstro envolvidos na batalha.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``instancias_monstro`` e ``personagens_jogaveis``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_jogador | int | Identificador único do jogador envolvido na batalha | 1 - 5000 | Não | PK e FK | |
| id_monstro | int | Identificador único do monstro envolvido na batalha | 1 - 5000 | Não | PK e FK | |

### Tabela: corredores_sala_destino
#### Descrição:  a tabela corredores_sala_destino possui identificadores únicos de sala e corredor na transição entre salas.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``salas`` e ``corredores``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_sala | int | Identificador único da sala destino ou origem | 1 - 5000 | Não | PK e FK | |
| id_corredor | int | Identificador único do corredor destino ou origem | 1 - 5000 | Não | PK e FK | |

### Tabela: tipos_personagem
#### Descrição:  a tabela tipos_personagem armazena informações para identificação única do personagem, assim como seu tipo.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``personagens_jogaveis`` e ``npcs``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_personagem | int | Identificador único do personagem | 1 - 5000 | Não | PK e FK | |
| tipo | varchar[100] | Tipo do personagem | a-z, A-Z | Não | | |

### Tabela: inventarios_possuem_instancias_item
#### Descrição:  a tabela inventarios_possuem_instancias_item armazena os identificadores únicos de instância de item e de inventário.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``inventarios`` e ``instancias_de_item``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_instancias_de_item | int | Identificador único da instancia de item | 1 - 5000 | Não | PK e FK | |
| id_invetario | int | Identificador único do inventário | 1 - 5000  | Não | PK e FK | |

### Tabela: entrega_missoes
#### Descrição:  a tabela entrega_missoes armazena os identificadores únicos de jogador e de npc, na interação de entre de missões.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``personagens_jogaveis`` e ``npcs``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_jogador | int | Identificador único do jogador | 1 - 5000 | Não | PK e FK | |
| id_npc | int | Identificador único do NPC | 1 - 5000  | Não | PK e FK | |

### Tabela: tipos_feitico
#### Descrição:  a tabela tipos_feitico armazena o identificador único e o tipo do feitiço.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``feiticos_dano`` e ``feiticos_status``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do feitiço | 1 - 5000 | Não | PK e FK | |
| tipo | varchar[100] | Tipo do feitiço | a-z, A-Z | Não | | |









## Histórico de versões

| Versão |    Data    | Descrição               | Autor                                                                                                                 |
| :----: | :--------: | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `1.0`  | 01/05/25 | Criação do documento DD | [Christopher Paraizo](https://github.com/wChrstphr)                                                                  |
| `1.1`  | 02/05/25 | Populando o DD | [Christopher Paraizo](https://github.com/wChrstphr)   |
| `1.2`  | 02/05/25 | Populando o DD com as tabelas de entidades | [Christopher Paraizo](https://github.com/wChrstphr) e [João Marcos](https://github.com/JJOAOMARCOSS)   |
| `1.3`  | 02/05/25 | Populando o DD com as tabelas provindas de relacionamentos, generalizações e especializações | [Christopher Paraizo](https://github.com/wChrstphr)      |   
| `1.4`  | 15/05/25 | Adicionando a tabela Diálogos | [Luiz](https://github.com/luizfaria1989)      |  
| `2.0`  | 08/06/25 | Adicionando a seção que explica os domínios criados no DDL | [Luiz](https://github.com/luizfaria1989)      |                                                          
| `2.1`  | 09/06/25 | Atualizando os tipos dos atributos para condizer com os domínios criados no DDL | [Luiz](https://github.com/luizfaria1989)      | 

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
| id | id | Identificador único do NPC | 1 - 999999999 | Não | PK | |
| nome | nome | Nome completo do NPC | a-z, A,z | Não | |
| ocupacao | ocupacao | Ocupação do NPC na história | a-z, A,z | Não | |
| idade | idade | Idade do NPC | 1 - 120 | Não | O valor default é 18 |
| sexo | sexo | Sexo do NPC | 'masculino', <br> 'feminino' | Não | |
| residencia | residencia | Descrição de onde o NPC reside | a-z, A-z | Não | |
| local_nascimento | local_nascimento | Local onde o NCP nasceu | a-z, A-z | Não | O valor default é 'arkham' | 
| id_tipo_personagem | id | Indica o id do NPC na tabela de tipos de personagem | 1 - 999999999 | Sim | FK |
| id_sala | id | Indica o id da sala que o personagem está | 1 - 999999999 | Sim | FK | Quando id_sala for nulo, id_corredor deve ser diferente de nulo, e vice-versa. | | 
| id_corredor | id | Indica o id do corredor que o personagem está | 1 - 999999999 | Sim | FK  | Quando id_corredor for nulo, id_sala deve ser diferente de nulo, e vice-versa. | |

## Entidade: Diálogos
### Tabela: dialogos
#### Descrição: A tabela diálogos contém os textos dos diálogos dos NPCs do RPG.

#### Observação: essa tabela possui chave estrangeira para as entidades ``NPC``

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do Dialogo | 1 - 999999999 | Não | PK | |
| npc_id | id | Indica o id do NPC que possui aquele diálogo | 1 - 999999999 | Não | FK |
| script_dialogo | script_dialogo | Texto do diálogo do NPC que será lido pelo jogador| a-z, A,z | Não | |


## Entidade: Personagem Jogável
### Tabela: personagens_jogaveis

#### Descrição: A entidade Personagem Jogável armazena informações sobre o identificador único, dados pessoais (nome, ocupação, idade, sexo, residência, local de nascimento), atributos de status (força, destreza, magia, inteligência, sorte, entre outros), equipamentos (arma, armadura), inventário e localização atual do personagem controlado pelo jogador. Inclui também características físicas e habilidades específicas, como tamanho, aparência, educação e conhecimento, essenciais para interações e mecânicas de jogo.

#### Observação: essa tabela possui chave estrangeira para as entidades `Pericia`, `Instancia_de_item`, `Inventario`, `Sala` e `Corredor`

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do personagem | 1 - 999999999 | Não | PK | |
| nome | nome | Nome completo do personagem  | a-z, A,z | Não | |
| ocupacao | ocupacao | Ocupação do personagem na história do jogo | a-z, A,z | Não | |
| residencia | residencia | Descrição de onde o personagem reside | a-z, A-z | Não | |
| local_nascimento | local_nascimento | Local onde o personagem nasceu | a-z, A-z | Não | | 
| idade | idade | Idade do personagem | 1 - 120 | Não | O valor default é 18 |
| sexo | sexo | Sexo do personagem | 'masculino', <br> 'feminino' | Não | |
| movimento | smallint | Pontos de movimento que o personagem possui | 1 - 100 | Não |  |
| sanidade_atual | smallint | Sanidade atual do personagem | 0 - 100 | Não | | Valor padrão = 10 | 
| insanidade_temporaria | boolean | Insaidade temporária produzida por algum evento externo | 1-0 | Não | |
| insanidade_indefinida | boolean | Insanidade sem tempo determinado e que só terminará após uma ação específica | 1-0 | Não | | É verdadeira quando a sanidade_atual do personagem é 0 | 
| PM_base | smallint | Valor base dos pontos de magia do personagem | 10 - 100 | Não | | Valor padrão = 10 | 
| PM_max | smallint | Valor máximo de pontos de magia do personagem | 10 - 100 | Não | |  
| forca | atributo | Pontos de força que o personagem possui | 3 - 18 | Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados |
| constituicao | atributo | Pontos de constituição que o personagem possui | 3 - 18 | Não |  |  Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados |
| poder | atributo | Pontos de destreza poder o personagem possui | 3 - 18 | Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados |
| destreza | atributo | Pontos de destreza que o personagem possui | 3 - 18 | Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados | 
| aparencia | atributo | Pontos de aparência que o personagem possui | 3 - 18| Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados | 
| tamanho | atributo | Pontos de tamanho que o personagem possui | 3 - 18| Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados | 
| inteligencia | atributo | Pontos de inteligencia que o personagem possui | 3 - 18 | Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados | 
| educacao | atributo | Pontos de destreza que educação personagem possui | 3 - 18 | Não |  | Equivale aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados | 
| pontos_de_vida_atual | smallint | Equivale aos pontos de vida atuais do personagem | 0 - 100 | Não | |
| ideia | smallint | Pontos de ideia que o personagem possui | 1 - 100 | Não | |  inteligência x 5. Para corrigir a terceira forma normal, esse atributo está representado com uma VIEW no DLL |
| conhecimento | smallint | Pontos de conhecimento que o personagem possui | 1 - 100 | Não | |  educação x 5. Para corrigir a terceira forma normal, esse atributo está representado com uma VIEW no DLL |
| sorte | smallint | Pontos de sorte que o personagem possui | 1 - 100 | Não | | poder x 5. Para corrigir a terceira forma normal, esse atributo está representado com uma VIEW no DLL |
| sanidade_maxima | smallint | Equivale aos pontos máximos de sanidade do personagem | 1 - 100 | Não | | poder x 5. Para corrigir a terceira forma normal, esse atributo está representado com uma VIEW no DLL |
| pts_de_vida_maximo | Integer | Equivale ao valor máximo para os pontos de vida do personagem | 1 - 100 | Não | (constituição + tamanho ) / 2. Para corrigir a terceira forma normal, esse atributo está representado com uma VIEW no DLL |
| id_sala | id | Indica o id da sala que o personagem está | 1 - 999999999 | Sim | FK | Quando id_sala for nulo, id_corredor deve ser diferente de nulo, e vice-versa. | | 
| id_corredor | id | Indica o id do corredor que o personagem está | 1 - 999999999 | Sim | FK  | Quando id_corredor for nulo, id_sala deve ser diferente de nulo, e vice-versa. | |
| id_inventario | id | Identificador de inventário do personagem | 1 - 999999999 | Não | FK |
| id_armadura | id | Identificador de qual armadura o personagem equipa | 1 - 999999999 | Sim | FK |
| id_arma | id | Identificador de qual arma o personagem equipa | 1 - 999999999 | Sim | FK |

## Entidade: Perícia
### Tabela: pericias
#### Descrição: a entidade pontos de pericia possui identificar único, nome e valor da perícia e se é de ocupação do personagem.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único dos pontos de perícia do personagem | 1 - 999999999 | Não | PK | |
| nome | nome | Nome da perícia do personagem | a-z, A-Z | Não | | | 
| valor | int | Valor da perícia do personagem | 10 - 100 | Não | | Valor padrão = 10 | 
| de_ocupacao | boolean | A perícia é de ocupação do personagem ou não?  | 1-0 | Não | 0 para sim e 1 para não | 

## Entidade: Inventario
### Tabela: inventarios

#### Descrição: A entidade Inventário armazena informações sobre o identificador único e tamanho do inventário, que representa a capacidade disponível para armazenamento.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do inventário | 1 - 999999999 | Não | PK | |
| tamanho | smallint | Tamanho do invetário do personagem | 10 - 100 | Não | | Valor padrão = 10 | 

## Entidade: Templo
### Tabela: templos

#### Descrição: A entidade Templo armazena informações sobre seu identificador único, nome e descrição detalhada do local.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do templo | 1 - 999999999 | Não | PK | |
| nome | nome | Nome do templo | a-z, A-z | Não | | | 
| descricao | descricao | Descrição do templo |  a-z, A-z | Não | | | 

## Entidade: Andar
### Tabela: andares
#### Descrição: A entidade Andar armazena informações sobre seu identificador único, descrição, sala inicial e a referência ao templo ao qual pertence. 

#### Observação: essa entidade possui chave estrangeira para as Entidades ``Templo`` e ``Sala``

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Número do andar | 1 - 999999999 | Não | PK | |
| descricao | descricao | Descrição do andar |  a-z, A-z | Não | | | 
| salaInicial | int | Sala inicial daquele andar | 1 - 999999999 | Não | FK | |
| id_templo | int | Templo no qual aquele andar está contido | 1 - 999999999 | Não | FK | |

## Entidade: Sala
### Tabela: salas
#### Descrição: A entidade Sala possui informações sobre seu identificador único e descrição

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único da sala | 1 - 999999999 | Não | PK | |
| descricao | descricao | Descrição da sala |  a-z, A-z | Não | | | 

## Entidade: Corredor
### Tabela: corredores
#### Descrição: a entidade Corredor armazena os dados essenciais para identificar e caracterizar um corredor, como seu identificador único, o status atual e uma descrição.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único da sala | 1 - 999999999 | Não | PK | |
| status | boolean | Verifica se o corredor pode ser acessado ou não: 0 para inativo e 1 para ativo | Não | | 
| descricao | descricao | Descrição do corredor |  a-z, A-z | Não | | | 


## Entidade: Instancia de Monstro
### intancias_monstros
#### Descrição: a entidade InstanciaMonstro registra as instâncias específicas de monstros presentes no sistema. Armazena o identificador único da instância, a referência ao monstro base, e informações sobre sua localização.

#### Observação: essa tabela possui chave estrangeira para as entidades ``Pacífico``, ``Agressivo``, ``Corredor`` e ``Sala``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único da instância do monstro | 1 - 999999999 | Não | PK | |
| id_monstro | id | Identificador do tipo daquele monstro | 1 - 999999999 | Não | FK | |
| id_corredor | id | Identificador do corredor que aquele monstro está | 1 - 999999999 | Não | FK | |
| id_sala | id | Identificador da sala que aquele monstro está | 1 - 999999999 | Não | FK | Quando id_sala for nulo, id_corredor deve ser diferente de nulo, e vice-versa. |
| id_instancia_de_item | id | Identificador do item daquele monstro | 1 - 999999999 | Não | FK | Quando id_corredor for nulo, id_sala deve ser diferente de nulo, e vice-versa. |

## Entidade: Pacifico
### Tabela: pacificos
#### Descrição: a entidade Pacifico armazena informações sobre monstros de comportamento passivo, detalhando suas características físicas. como defesa, vitalidade, o motivo da sua não agressividade e seu nome.

#### Observação: .
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do monstro pacífico | 1 - 999999999 | Não | PK e FK | |
| nome | nome | Nome do monstro pacífico | a-z, A,z | Não | |
| descricao | varchar[100] | Descrição do monstro pacífico | a-z, A,z | Não | |
| defesa | smallint | Defesa do monstro pacífico | 1 - 50 | Não | |
| vida | int | Vida do monstro pacífico | 1 - 100 | Não | Valor Base = 100|
| motivo_passividade | comportamento_pacifico | Descrição da motivo para o monstro ser passivo | 'indiferente', <br> 'medroso', <br> 'amigavel', <br> 'sob_controle_mental', <br> 'adormecido', <br> 'curioso' | Não | |
| tipo_pacifico | tipo_monstro_pacifico | Tipo de monstro pacífico | 'humanoide', <br> 'sobrenatural' | Não | | |

## Entidade: Agressivo
### Tabela: agressivos
#### Descrição: 

#### Observação: .
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do monstro agressivo | 1 - 999999999 | Não | PK e FK | |
| nome | nome | Nome do monstro agressivo | a-z, A,z | Não | | É unico na tabela |
| descricao | descricao | Descrição do monstro agressivo | a-z, A,z | Não | |
| defesa | smallint | Defesa do monstro agressivo | 1 - 50 | Não | |
| vida | smallint | Vida do monstro agressivo | 1 - 100 | Não | Valor Base = 100|
| poder | smallint | Poder do monstro agressivo | 1 - 100 | Não | Valor Base = 100|
| tipo_agressivo | Indica qual o tipo de monstro agressivo aquele monstro é | 'psiquico', <br> 'magico', <br> 'fisico' | Não | | | 
| velocidade_ataque | smallint | Indica a velocidade de ataque do monstro agressivo | 1 - 100 |  | | |
| loucura_induzida | smallint | Indica a quantidade de sanidade que o personagem perde ao ver aquele monstro | 1 - 100 | |
| ponto_magia | smallint | Quantidade de pontos de magia o monstro agressivo tem | 1 - 100 | | |
| dano | dano | Quandidade de dano que o ataque do monstro agressivo causa | | Não |
| catalisador_agressividade | gatilho_agressividade | Motivo ou catalisador para o monstro ser agressivo e hostil | 'proximidade', <br> 'ataque_direto', <br> 'barulho_alto', <br> 'alvo_especifico', <br> 'horario_noturno', <br> 'ver_item_sagrado'| Não | |

## Entidade: Arma
### Tabela: armas
#### Descrição: a entidade Arma armazena as informações sobre itens do tipo arma, incluindo seu identificador único, atributos necessários para uso (atributo e perícia), características de combate (durabilidade, função, alcance, tipo de munição, tipo de dano e valor de dano).

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do item | 1 - 999999999 | Não | PK | |
| nome | nome | Nome da arma | a-z, A-Z | Não | | É unico |
| atributo_necessario | tipo_atributo_personagem | Atributo necessário para que a arma seja utilizada | 'forca', <br> 'constituicao', <br> 'poder',  <br> 'destreza', <br> 'aparencia', <br> 'tamanho', <br> 'inteligencia', <br> 'educacao'| Não | |
| qtd_atributo_necessario | int | Quantidade de atributos necessário para que a arma seja utilizada pelo personagem | 1 - 50 | Não | |
| durabilidade | smallint | Durabilidade da arma | 1 - 100 | Não | |
| id_pericia_necessaria | id | Perícia necessária para que o personagem possa utilizar essa arma | 1 - 999999999 | Não | FK |
| alcance | smallint | Alcance da arma | 1 - 100 | Não | |
| tipo_municao | tipo_municao | Tipo da munição dessa arma | 'baixo-calibre', <br> 'medio-calibre', <br> 'alto-calibre' | Não | |
| tipo_dano | vtipo_dano | Tipo de dano dessa arma | 'area', <br> 'unico' | Não | |
| dano | dano | Dano da arma | 1 - 100 | Não | |

## Entidade: Armadura
### Tabela: armaduras
#### Descrição: a entidade Armadura armazena as informações sobre itens de proteção, incluindo seu identificador único, atributos necessários para uso, características como durabilidade, função, quantidade de atributo recebido, tipo de atributo beneficiado e quantidade de dano mitigado.

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único da amardura | 1 - 999999999 | Não | PK | |
| nome | nome | Nome da peça de armadura | a-z, A-Z | Não | | É unico |
| atributo_necessario | tipo_atributo_personagem | Atributo necessário para que a armadura seja utilizada | 'forca', <br> 'constituicao', <br> 'poder',  <br> 'destreza', <br> 'aparencia', <br> 'tamanho', <br> 'inteligencia', <br> 'educacao' | Não | |
| qtd_atributo_necessario | int | Quantidade de atributos necessário para que a armadura seja utilizada pelo personagem | 1 - 50 | Não | |
| durabilidade | smallint | Durabilidade da armadura | 1 - 100 | Não | |
| id_pericia_necessaria | id_pericia_necessaria | Perícia necessária para que o personagem possa utilizar essa armadura | 1 - 999999999 | Não | FK | |
| funcao | varchar[100] | Função da armadura | 'cabeca', <br> 'peitoral', <br> 'bracos', <br> 'pernas', <br> 'pes', <br> 'mao'  | Não | |
| qtd_atributo_recebe | smallint | Quantidade de atributo que a armadura concede ao personagem | 1 - 100 | Não | |
| tipo_atributo_recebe | tipo_atributo_personagem | Tipo da atributo recebido por essa armadura | 'forca', <br> 'constituicao', <br> 'poder',  <br> 'destreza', <br> 'aparencia', <br> 'tamanho', <br> 'inteligencia', <br> 'educacao' | Não | |
| qtd_dano_mitigado | smallint | Quantidade de dano mitigado pela armadura quando utilizada pelo personagem | 1 - 100 | Não | |

## Entidade: Item
### Tabela: itens
#### Descrição: a entidade Item armazena informações gerais sobre itens, incluindo seu identificador único, tipo, nome, descrição e valor.

#### Observação: essa entidade possui chave estrangeira para as entidades ``Arma``, ``Armadura`` e ``Cura``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do item | 1 - 999999999 | Não | PK e FK | |
| tipo | tipo_item | Tipo do item | 'armadura', <br> 'arma', <br> 'cura' | Não | |
| nome | nome | Nome do item | a-z, A,z | Não | |
| descricao | descricao | Descrição do item | a-z, A,z | Não | |
| valor | smallint | Valor de venda do item | 1 - 20000 | Não | |

## Entidade: Cura
### Tabela: curas
#### Descrição: a entidade Cura armazena informações sobre itens ou efeitos de recuperação, incluindo seu identificador único, função principal, quantidade de usos disponíveis e os valores de pontos de sanidade e/ou vida recuperados.

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do item de cura | 1 - 999999999 | Não | PK e FK | |
| funcao | funcao_cura | Função do item de cura | 'restaurar_vida', <br> 'restaurar_sanidade', <br> 'remover_veneno', <br> 'remover_maldicao', <br> 'antidoto_insanidade' | Não | |
| qtd_usos | smallint | Quantidade de usos desse item de cura | 1 - 10 | Não | |
| qtd_pontos_sanidade_recupera | smallint | Quantidade de pontos de sanidade que esse item recupera | 1 - 100 | Não | |
| qtd_pontos_vida_recupera | smallint | Quantidade de pontos de vida que esse item recupera | 1 - 100 | Não | |

## Entidade: Instância de Item
### Tabela: instancias_de_itens
#### Descrição: a entidade Instância de item registra as ocorrências específicas de itens no jogo, contendo identificador único, referência ao item original, durabilidade, sala em que está, missões a qual está associado e batalhas .

#### Observação: essa entidade possui chave estrangeira para as entidades ``Item``, ``Sala``, ``Batalha`` e as tabelas ``inventario_possui_instancia_item``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único da instância de item | 1 - 999999999 | Não | PK | |
| id_item | id | Identificador único do item | 1 - 999999999 | Não | FK | |
| durabilidade | smallint | Durabilidade da de item | 1 - 100 | Não | |
| id_sala | id | Sala no qual esse item está | 1 - 999999999 | Não |  |
| id_missao_requer | id | Item necessário para poder realizar uma missão | 1 - 999999999 | Não | FK |
| id_missao_recompensa | id | Recompensa que uma missão da para o personagem ao ser concluída | 1 - 999999999 | Não | FK |

## Entidade: Mágico
### Tabela: magicos
#### Descrição: a entidade mágico armazena informações sobre itens mágicos que podem ser utilizados por personagens, incluindo seu identificador único, função principal, quantidade de usos disponíveis e o custo em pontos de sanidade para cada utilização. 

#### Observação: essa entidade possui chave estrangeira para a tabela ``tipo_feitico``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do item de mágico | 1 - 999999999 | Não | PK | |
| nome | nome | Nome daquele item mágico | a-z, A-Z, | Não | | É um valor unico |
| id_feitico | id | Identificador único do feitiço mágico | 1 - 999999999 | Não | PK e FK | |
| funcao | funcao_magica | Função do item mágico | 'revelar_invisivel', <br> 'abrir_fechadura', <br> 'encantar_arma', <br> 'invocar_criatura', <br> 'teleporte', <br> 'protecao_elemental' | Não | |
| qtd_usos | smallint | Quantidade de usos desse item mágico | 1 - 10 | Não | |
| custo_sanidade | smallint | Quantidade de pontos de sanidade que esse item mágico custa ao personagem por utilizá-lo | 1 - 100 | Não | |


## Entidade: Feitiço Status
### Tabela: feiticos_status
#### Descrição:  a entidade Feitico_status armazena informações sobre feitiços que afetam o status de personagens, incluindo seu identificador único, nome, descrição, quantidade de pontos de magia consumidos, tipo e intensidade do efeito (buff ou debuff) e o status afetado. Além disso, está vinculada à entidade Tipo_feitiço por meio de chave estrangeira.

#### Observação: essa entidade é chave estrangeira para ``Tipo_feitiço``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do feitiço que afeta status | 1 - 999999999 | Não | PK | |
| nome | nome | Nome do feitiço status | a-z, A,z | Não | | É unico |
| descricao | descricao | Descrição do feitiço status | a-z, A,z | Não | |
| qtd_pontos_de_magia | smallint | Quantidade de pontos de magia | 1 - 5000 | Não | |
| qtd_buff_debuff | smallint | Quantidade de Buff ou Debuff | 1 - 5000 | Não | |
| buff_ou_debuff | Boolean | Buff ou Debuff | 0 - 1 | Não | |
| status_afetado | tipo_status | Status que sera afetado | 'vida', <br> 'sanidade' | Não | |


## Entidade: Feitiço Dano
### Tabela: feiticos_dano
#### Descrição:  a entidade Feitico_dano armazena informações sobre feitiços que causam dano direto, incluindo seu identificador único, nome, descrição, quantidade de pontos de magia consumidos, tipo de dano causado e a quantidade de dano gerado. Além disso, está vinculada à entidade Tipo_feitiço por meio de chave estrangeira.

#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do feitiço que afeta status | 1 - 999999999 | Não | PK | |
| nome | nome | Nome do feitiço dano | a-z, A,z | Não | |
| descricao | descricao | Descrição do feitiço dano | a-z, A,z | Não | |
| qtd_pontos_de_magia | smallint | Quantidade de pontos de magia do feitiço | 1 - 100 | Não | |
| tipo_dano | tipo_dano | Tipo de dano do feitiço | 'area', <br> 'unico' | Não | |
| qtd_dano | dano | Quantidade de Dano do feitiço | 1 - 25 | Não | |



## Entidade: Missao
### Tabela: missoes
#### Descrição:  a entidade missoes armazena as missoe disponíveis no jogo, com seu id, nome, descrição, tipo, ordem e npc que a disponibiliza.
#### Observação: 
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único da missao| 1 - 999999999 | Não | PK | |
| nome | nome | Nome da missao | a-z, A,z | Não | |
| descricao | character(512) | Descrição da missao | a-z, A,z | Não | |
| tipo | tipo_missao | Tipo da missao | principal', <br> 'secundaria', <br> 'coleta', <br> 'eliminacao', <br> 'escolta'  | Não | |
| ordem | character[128] | Ordem da missao | a-z, A,z | Não | |
| id_npc | id | Quantidade de Dano do feitiço | 1 - 999999999 | Não | FK |




# Tabelas Provindas de Relacionamentos, Especializações e Generalizações
### Tabela: tipos_monstro
#### Descrição:  a tabela tipos_monstro possui o identificador único e o tipo do monstro
#### Observação: essa tabela possui chave estrangeira para as tabelas ``agressivos`` e ``pacificos``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_monstro | id | Identificador único do feitiço que afeta status | 1 - 999999999 | Não | PK e FK | |
| tipo | tipo_monstro | Tipo do monstro | 'agressivo', <br> 'pacifico'| Não | |

### Tabela: batalhas
#### Descrição:  a tabela batalhas possui identificadores do jogador e do monstro envolvidos na batalha.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``instancias_monstro`` e ``personagens_jogaveis``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_jogador | id | Identificador único do jogador envolvido na batalha | 1 - 999999999 | Não | PK e FK | |
| id_monstro | id | Identificador único do monstro envolvido na batalha | 1 - 999999999 | Não | PK e FK | |

### Tabela: corredores_sala_destino
#### Descrição:  a tabela corredores_sala_destino possui identificadores únicos de sala e corredor na transição entre salas.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``salas`` e ``corredores``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_sala | id | Identificador único da sala destino ou origem | 1 - 999999999 | Não | PK e FK | |
| id_corredor | id | Identificador único do corredor destino ou origem | 1 - 999999999 | Não | PK e FK | |

### Tabela: tipos_personagem
#### Descrição:  a tabela tipos_personagem armazena informações para identificação única do personagem, assim como seu tipo.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``personagens_jogaveis`` e ``npcs``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_personagem | id | Identificador único do personagem | 1 - 999999999 | Não | PK e FK | |
| tipo | tipo_personagem | Tipo do personagem | 'personagem jogavel', <br> 'NPC,  | Não | | |

### Tabela: inventarios_possuem_instancias_item
#### Descrição:  a tabela inventarios_possuem_instancias_item armazena os identificadores únicos de instância de item e de inventário.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``inventarios`` e ``instancias_de_item``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_instancias_de_item | id | Identificador único da instancia de item | 1 - 999999999 | Não | PK e FK | |
| id_invetario | id | Identificador único do inventário | 1 - 999999999  | Não | PK e FK | |

### Tabela: entrega_missoes
#### Descrição:  a tabela entrega_missoes armazena os identificadores únicos de jogador e de npc, na interação de entre de missões.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``personagens_jogaveis`` e ``npcs``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_jogador | id | Identificador único do jogador | 1 - 999999999 | Não | PK e FK | |
| id_npc | id | Identificador único do NPC | 1 - 999999999  | Não | PK e FK | |

### Tabela: tipos_feitico
#### Descrição:  a tabela tipos_feitico armazena o identificador único e o tipo do feitiço.
#### Observação: essa tabela possui chave estrangeira para as tabelas ``feiticos_dano`` e ``feiticos_status``.
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | id | Identificador único do feitiço | 1 - 999999999 | Não | PK e FK | |
| tipo | funcao_feitico | Tipo do feitiço | 'status', <br> 'dano' | Não | | |

### Tabela: personagens_possuem_pericias
#### Descrição: a a tabela personagens_possuem_pericias armazena os identificadores únicos de jogador e as percícias que ele possui 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_personagem | id | Identificador único do personagem | 1 - 999999999 | Não | PK e FK | |
| id_pericia | id | Identificador único da perícia | 1 - 999999999 | Não | PK e FK| |
| valor_atual | smallint | Valor atual daquela perícia | 1 - 100 | Não | | |

## Domínios criados

Os domínios são uma funcionalidade do SQL que permitem a criação de tipos personalizados de dados. Assim, eles garantem uma melhor manutenabilidade do código, pois a edição de um domínio pode alterar atributos em diferentes tabelas, evitando que essa alteração seja feita tabela por tabela. Além disso, eles auxiliam a manter a integridade dos dados do banco, uma vez que restringem o tipo de dado que pode ser inserido em uma célula.

Essa seção contém uma tabela de todos os domínios que foram criados no arquivo DDL do projeto, explicando aquele domínio, o tipo primário e os seus valores permitidos. Cabe ressaltar também que os domínios podem estar sujeitos a mudaças para comportar novos tipos de dado no banco.

| Nome do domínio | Tipo Primário | Descrição | Valores permitidos | Observações |
| :-------------: | :-----------: | :-------: | :----------------: | :---------: |
| id              | Integer       | É o domínio utilizado quando é preciso declarar o tipo de um id no banco de dados | 1 - 999999999 | |
| dano            | Smallint      | É domnínio utilizado quando é preciso declarar o tipo de dano de um monstro ou arma | 1 - 500 | |
| sexo            | Character(9)  | É domínio utilizado quando é preciso declarar o sexo de um personagem ou NPC | 'masculino', <br> 'feminino' | |
| atributo        | Smallint      | É domínio utilizado quando é preciso declarar o valor de um atributo do personagem jogável | 3 - 18 | Os valores do atributo se referem aos valores que podem ser obtidos ao jogar três dados de seis faces e somar seus resultados |
| idade           | Smallint      | É domínio utilizado quando é preciso declarar o valor da idade de um personagem jogável ou NPC | 1 - 120 | |
| tipo_monstro_agressivo | Character(8) | É domínio utilizado quando é preciso declarar o tipo de um monstro agressivo | 'psiquico', <br> 'magico', <br> 'fisico' | |
| tipo_monstro_pacifico | Character(9) | É o domínio utilizado quando é preciso declarar o tipo de um monstro pacífico | 'humanoide', <br> 'sobrenatural' | |
| tipo_monstro | Character(9) | É o domínio utilizado quando é preciso declarar o tipo de um monstro | 'agressivo', <br> 'pacifico'| |
| tipo_personagem | Character(18) | É o domínio utilizado quando é preciso declarar o tipo de um personagem | 'personagem jogavel', <br> 'NPC, | |
| tipo_item | Character(9) | É o domínio utilizado quando é preciso declarar o tipo de um item | 'armadura', <br> 'arma', <br> 'cura' | |
| tipo_municao | Character(13) | É domínio utilizado quando é preciso declarar o tipo da munição de uma arma | 'baixo-calibre', <br> 'medio-calibre', <br> 'alto-calibre' | |
| funcao_armadura | Character(8) | É domínio utilizado quando é preciso declarar qual parte do corpo aquela armadura protege | 'cabeca', <br> 'peitoral', <br> 'bracos', <br> 'pernas', <br> 'pes', <br> 'mao' | |
| tipo_dano | Charater(5) | É o domínio utilizado quando é preciso declarar o tipo de dado de uma arma | 'area', <br> 'unico' | |
| funcao_feitico | Character(6) | É o domínio utilizado quando é preciso declarar qual á função de um feitiço | 'status', <br> 'dano' | |
| tipo_status | Character(8) | É o domínio utilizado quando é preciso declarar qual o tipo de status que um feitiço de status atua | 'vida', <br> 'sanidade' | |
| tipo_atributo_personagem | Character(12) | É o domínio utilizado quando é preciso declrar o tipo do atributo de um personagem | 'forca', <br> 'constituicao', <br> 'poder',  <br> 'destreza', <br> 'aparencia', <br> 'tamanho', <br> 'inteligencia', <br> 'educacao' | |
| tipo_missao | Character(12) | É o domínio utilizado quando é preciso declarar o tipo de uma missão | 'principal', <br> 'secundaria', <br> 'coleta', <br> 'eliminacao', <br> 'escolta' | |
| funcao_arma | Character(32) | É o domínio utilizado quando é preciso declarar a função de uma arma | 'corpo_a_corpo_leve', <br> 'corpo_a_corpo_pesada', <br> 'arremesso', <br> 'disparo_unico', <br> 'disparo_rajada' |
| funcao_cura | Character(32) | É o domínio utilizado quando é preciso declarar a função de um feitiço de cura | 'restaurar_vida', <br> 'restaurar_sanidade', <br> 'remover_veneno', <br> 'remover_maldicao', <br> 'antidoto_insanidade' |
| funcao_magica | Character(32) | É o domínio utilizado quando é preciso declarar a função de um item mágico | 'revelar_invisivel', <br> 'abrir_fechadura', <br> 'encantar_arma', <br> 'invocar_criatura', <br> 'teleporte', <br> 'protecao_elemental'| |
| gatilho_agressividade | Character(32) | É o domínio utilizado quando é preciso declarar o gatilho de agressividade de um monstro agressivo | 'proximidade', <br> 'ataque_direto', <br> 'barulho_alto', <br> 'alvo_especifico', <br> 'horario_noturno', <br> 'ver_item_sagrado' | |
| comportamento_pacifico | Character(32) | É o domínio utilizado quando é preciso declarar o tipo de comportamento de um monstro pacífico | 'indiferente', <br> 'medroso', <br> 'amigavel', <br> 'sob_controle_mental', <br> 'adormecido', <br> 'curioso' | |
| nome | Character(128) | É o domínio utilizado quando é preciso declarar o tipo do atributo nome em uma tabela | a-z, A,Z | Aceita até 128 caracteres | 
| descricao | Character(256) | É o domínio utilizado quando é preciso declarar o tipo do atributo descrição em uma tabela | a-z, A,Z | Aceita até 256 caracteres |
| ocupacao | Character(64) | É o domínio utilizado quando é preciso declarar o tipo do atributo ocupação em uma tabela | a-z, A,Z | Aceita até 64 caracteres |
| residencia | Character(96) | É o domínio utilizado quando é preciso declarar o tipo do atributo residência em uma tabela | a-z, A,Z | Aceita até 96 caracteres |
| local_nascimento | Character(96) | É o domínio utilizado quando é preciso declarar o tipo do atributo local de nascimento em uma tabela | a-z, A,Z | Aceita até 64 caracteres |
| script_dialogo | Character(512) | É o domínio utiizado quando é preciso declarar o tipo do atributo script diálogo em uma tabela | a-z, A,Z | Aceita até 512 caracteres |

É importante ressaltar a escolha dos tipo Character ao invés de Varchar, ao utilizar uma quantidade fixa de caracteres para os dados de uma tabela, as suas linhas passam a ter um tamanho fixo. Essa característica para uma tabela de um banco de dados pode ser útil, uma vez que facilita as pesquisas feitas pelo banco, dado que para avançar uma linha basta multiplicar o valor pelo tamanho da tupla daquela tabela pelo número da linha que se quer.













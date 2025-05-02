## Histórico de versões

| Versão |    Data    | Descrição               | Autor                                                                                                                 |
| :----: | :--------: | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `1.0`  | 01/05/25 | Criação do documento DD | [Christopher Paraizo](https://github.com/wChrstphr)                                                                  |
| `1.1`  | 02/05/25 | Populando o DD | [Christopher Paraizo](https://github.com/wChrstphr)                                                                  |

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

## Entidade: NPC

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
| **localBoolean** | boolean | Verifica onde o NPC está, sendo 1 para sala e 0 para corredor | 1-0 | Não | | 
| **local** | int | Local onde o NPC está | 1 - 5000 | Não | FK |


## Entidade: PersonagemJogavel

#### Descrição: A entidade Personagem Jogável armazena informações sobre o identificador único, dados pessoais (nome, ocupação, idade, sexo, residência, local de nascimento), atributos de status (força, destreza, magia, inteligência, sorte, entre outros), equipamentos (arma, armadura), inventário e localização atual do personagem controlado pelo jogador. Inclui também características físicas e habilidades específicas, como tamanho, aparência, educação e conhecimento, essenciais para interações e mecânicas de jogo.

#### Observação: essa tabela possui chave estrangeira para as entidades `Sanidade`, `Pts_de_magia`, `Pericia`, `Instancia_de_item`, `Inventario`, `Sala` e `Corredor`

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do personagem | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome completo do personagem  | a-z, A,z | Não | |
| pts_de_magia | int | Identificador de magia que o personagem possui | 1 - 5000 | Não | FK |
| pericia | int | Identificador de perícia que o personagem possui | 1 - 5000 | Não | FK |
| sanidade | int | Identificador de sanidade mental que o personagem possui | 1 - 5000 | Não | FK |
| ocupacao | varchar[100] | Ocupação do personagem na história do jogo | a-z, A,z | Não | |
| idade | int | Idade do personagem | 1 - 200 | Não | |
| sexo | char[1] | Sexo do personagem | F, M | Não | |
| residencia | varchar[200] | Descrição de onde o personagem reside | a-z, A-z, !-/ | Não | |
| local_nascimento | varchar[100] | Local onde o personagem nasceu | a-z, A-z, !-/ | Não | | 
| armadura | int | Identificador de qual armadura o personagem equipa | 1 - 5000 | Não | FK |
| arma | int | Identificador de qual arma o personagem equipa | 1 - 5000 | Não | FK |
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
| local | int | Local onde o personagem está | 1 - 5000 | Não | FK |


## Entidade: Inventario

#### Descrição: A entidade Inventário armazena informações sobre o identificador único e tamanho do inventário, que representa a capacidade disponível para armazenamento.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id | int | Identificador único do inventário | 1 - 5000 | Não | PK | |
| tamanho | int | Tamanho do invetário do personagem | 10 - 100 | Não | | Valor padrão = 10 | 

## Entidade: Templo

#### Descrição: A entidade Templo armazena informações sobre seu identificador único, nome e descrição detalhada do local.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_templo | int | Identificador único do templo | 1 - 5000 | Não | PK | |
| nome | varchar[100] | Nome do templo | a-z, A-z | Não | | | 
| descricao | varchar[200] | Descrição do templo |  a-z, A-z, !-/ | Não | | | 

## Entidade: Andar

#### Descrição: A entidade Andar armazena informações sobre seu identificador único, descrição, sala inicial e a referência ao templo ao qual pertence. 

#### Observação: essa entidade possui chave estrangeira para as Entidades ``Templo`` e ``Sala``

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| numero | int | Número do andar | 1 - 50 | Não | PK | |
| descricao | varchar[200] | Descrição do andar |  a-z, A-z, !-/ | Não | | | 
| salaInicial | int | Sala inicial daquele andar | 1 - 5000 | Não | FK | |
| Templo | int | Templo no qual aquele andar está contido | 1 - 5000 | Não | FK | |

## Entidade: Sala

#### Descrição: A entidade Sala possui informações sobre seu identificador único e descrição

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_sala | int | Identificador único da sala | 1 - 5000 | Não | PK | |
| descricao | varchar[200] | Descrição da sala |  a-z, A-z, !-/ | Não | | | 

## Entidade: Corredor

#### Descrição: a entidade Corredor armazena os dados essenciais para identificar e caracterizar um corredor, como seu identificador único, o status atual e uma descrição.

#### Observação: 

| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| id_corredor | int | Identificador único da sala | 1 - 5000 | Não | PK | |
| status | boolean | Verifica se o corredor pode ser acessado ou não: 0 para inativo e 1 para ativo | Não | | 
| descricao | varchar[200] | Descrição do corredor |  a-z, A-z, !-/ | Não | | | 


## Entidade: InstanciaMonstro

#### Descrição: 

#### Observação: essa tabela possui chave estrangeira para as entidades ``Pacífico``, ``Agressivo``, ``Corredor`` e ``Sala``
| Nome Variável |     Tipo     |         Descrição          | Valores permitidos | Permite valores nulos? | É chave? | Observações
| :-----------: | :----------: | :------------------------: | :----------------: | :--------------------: | :------: | :-------: |
| Id_instancia_monstro | int | Identificador único da instância do monstro | 1 - 5000 | Não | PK | |
| id_monstro | int | Identificador do tipo daquele monstro | 1 - 5000 | Não | FK | |
| localBoolean | boolean | Verifica onde a instância do monstro está, sendo 1 para sala e 0 para corredor | Não | | 
| local | int | Identificador do tipo daquele monstro | 1 - 5000 | Não | FK | |
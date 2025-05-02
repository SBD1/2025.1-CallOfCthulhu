# Entrega 1

## Histórico de versões

| Versão |    Data    | Descrição               | Autor                                                                                                                 |
| :----: | :--------: | ----------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `0.1`  | 02/05/25 |  Adicionando o modelo entidade relacionamento  |        Equipe                |

## Modelo Entidade Relacionamento

O Modelo Entidade Relacionamento para bancos de dados é um modelo que descreve os objetos (entidades) envolvidos em um negócio, com suas características (atributos) e como elas se relacionam entre si (relacionamentos).

### 1. Entidades

- **Item**
    - **Consumível**
        - **Cura**
        - **Mágico**
    - **Equipável**
        - **Armadura**
        - **Arma**
- **Instância de Item**
- **Feitiço**
    - **Status**
    - **Dano**
- **Templo**
- **Andar**
- **Sala**
- **Corredor**
- **Personagem**
    - **NPC**
    - **PersonagemJogavel**
- **Inventário**
- **Sanidade**
- **Pontos de Magia**
- **Perícia**
- **Missão**
- **Monstro**
- **Agressivo**
    - **Psiquico**
    - **Mágico**
    - **Físico**
- **Pacífico**
    - **Sobrenatural**
    - **Humanóide**
- **InstanciaMonstro**
- **Batalha**

### 2. Atributos

- **Item**: <ins>id</ins>, tipo, nome, descrição, valor  
- **Consumível**  
  - **Cura**: <ins>id</ins>, função, qts_usos, qtd_pontos_sanidade_recupera, qtd_pontos_vida_recupera  
  - **Mágico**: <ins>id</ins>, id_feitiço, função, qts_usos, custo_sanidade  
- **Equipável**  
  - **Armadura**: <ins>id_item</ins>, atributo_necessário, durabilidade, perícia_necessária, função, qtd_atributo_recebe, tipo_atributo_recebe, qtd_dano_mitigado  
  - **Arma**: <ins>id</ins>, atributo_necessário, durabilidade, perícia_necessária, função, alcance, tipo_munição, tipo_dano, dano  
- **Instância de Item**: <ins>id</ins>, id_item, durabilidade, id_sala, missao_requer, missao_recompensa, batalha_jogador, batalha_monstro  
- **Feitiço**  
  - **Status**: <ins>id</ins>, nome, descrição, qtd_pontos_de_magia, qtd_buff_debuff, status_afetado, buff_ou_debuff
  - **Dano**: <ins>id</ins>, nome, descrição, qtd_pontos_de_magia, tipo_dano, qtd_dano  
- **Templo**: <ins>id</ins>, nome, descrição  
- **Andar**: <ins>id</ins>, descrição, id_sala_inicial, templo_id  
- **Sala**: <ins>id</ins>, descrição  
- **Corredor**: <ins>id</ins>, status, descrição  
- **NPC**: <ins>id</ins>, nome, ocupação, idade, sexo, residência, local_nascimento, script_dialogo, localBoolean, id_local  
- **PersonagemJogavel**: <ins>id</ins>, nome, id_pt_de_magia, id_pericia, id_sanidade, ocupação, idade, sexo, residência, local_nascimento, id_armadura, id_arma, força, destreza, constituição, tamanho, aparência, inteligência, poder, educação, ideia, conhecimento, movimento, sorte, id_inventario, localBoolean, id_local  
- **Inventário**: <ins>id</ins>, tamanho  
- **Sanidade**: <ins>id</ins>, sanidade_maxima, sanidade_atual, insanidade_temporaria, insanidade_indefinida  
- **Pontos de Magia**: <ins>id</ins>, valor_base, PM_max  
- **Perícia**: <ins>id</ins>, valor, eh_de_ocupacao  
- **Missão**: <ins>id</ins>, nome, descrição, tipo, ordem, id_npc  
- **Monstro**: <ins>id_monstro</ins>, tipo  
- **Agressivo**: <ins>id</ins>, nome, descrição, defesa, vida, catalisador_agressividade, poder, fisico, psiquico, magico, velocidade_ataque, loucura_induzida, ponto_magia, id_feitiço  
- **Pacífico**: <ins>id</ins>, nome, descrição, defesa, vida, motivo_passividade, humanidade, sobrenatural, conhecimento_geografico, conhecimento_proibido  
- **InstanciaMonstro**: <ins>id</ins>, id_monstro, localBoolean, id_local  
- **Batalha**: <ins>id_jogador</ins>, <ins>id_monstro</ins>

### 3. Relacionamentos

**Item possui Instância de Item**
- Um tipo de item pode possuir nenhuma ou várias (0,N) Instâncias, uma Instância está relacionada a apenas um tipo de Item (1,1).

**Item consumível tipo mágico utiliza um Feitiço**
- Um item tipo consumível utliza um Feitiço (1,1), mas um Feitiço é utilizado por nenhum ou vários itens (0,N).

**Um Personagem possui Inventário**
- Um Personagem possui apenas um Inventário (1,1) e um Inventário é possuido por apenas um Personagem (1,1).

**Inventário possui Instância de Item**
- Um Inventário possui nenhuma ou várias Instâncias de Item (0,N) e uma Instância de Item é possuída por nenhum ou apenas um Inventário (1,1).

**PersonagemJogavel equipa Instância de Item**
- Um PersonagemJogavel equipa nenhuma ou várias instância de item (0,N) e uma instância de item é equipada por nenhum ou apenas um PersonagemJogavel (0,1)

**Templo Contém andar**
- Um templo pode conter um ou vários andares (1,N) e um andar está contido em apenas um Templo.

**Andar conecta com Sala**
- Um Andar é conectado po VERIFICAR PRA TERMINAR

**Sala origina corredor**
- Uma sala origina apenas um corredor (1,1) e um corredor é originado por apenas uma sala (1,1).

**Corredor destina Sala**
- Um corredor destina uma sala (1,1) e uma sala é destinada por um corredor (1,1).

**Sala contém Instância de Item**
- Uma sala contém nenhuma ou várias instâncias de item (0,N), mas uma instância de item está contida em nenhuma ou apenas uma sala (0,1).

**Personagem está em corredor**
- Um personagem está em apenas um corredor (1,1) e em um corredor estão nenhum ou vários personagens(0,N).

**Personagem está em Sala**
- Um personagem está em apenas uma sala (1,1) e em uma sala estão nenhum ou vários personagens(0,N).

**PersonagemJogavel possui Sanidade**
- Um PersonagemJogavel possui apenas uma sanidade (1,1) e uma Sanidade é possuida por apenas um PersonagemJogavel (1,1).

**PersonagemJogavel possui Pontos de Magia**
- Um PersonagemJogavel possui apenas um Pontos de Magia (1,1) e um Pontos de magia é possuida por apenas um PersonagemJogavel (1,1).

**PersonagemJogavel possui Perícia**
- Um PersonagemJogavel possui apenas uma Perícia (1,1) e uma Perícia é possuida por apenas um PersonagemJogavel (1,1). VERIFICAR

**Monstro Agrssivo tipo Psiquico utiliza Feitiço**
- Um monstro tipo Psiquico utiliza nenhum ou vários Feitiços (0,N) e um Feitiço é utilizado por nenhum ou vários monstros tipo Psiquico (0,N).

**Monstro Agrssivo tipo Mágico utiliza Feitiço**
- Um monstro tipo Mágico utiliza nenhum ou vários Feitiços (0,N) e um Feitiço é utilizado por nenhum ou vários monstros tipo Mágico (0,N).

**InstanciaMonstro Está em Sala**
- Uma InstanciaMonstro está em apenas uma Sala (1,1) e uma Sala contém nenhuma ou várias InstanciaMonstro (0,N).

**InstanciaMonstro Está em Corredor**
- Uma InstanciaMonstro está em apenas um Corredor (1,1) e um Corerdor contém nenhuma ou várias InstanciaMonstro (0,N).

**Monstro possui InstanciaMonstro**
- Um Monstro possui nenhuma ou várias InstanciaMonstro (0, n) e uma InstanciaMonstro possui apenas um Monstro (1,1).

**InstanciaMonstro dropa Instancia de Item**
- Uma InstanciaMonstro dropa nenhuma ou várias Instâncias de Item (0,N) e uma Instancia de Item é dropada por nenhum ou apenas uma InstanciaMonstro (0,1).

**Missao recompensa com Instancia de Item**
- Uma Missao tem como recompensa uma ou várias Instancia de item (1,N) e uma Instancia de Item é recompensa de no máximo uma missão (0,1).

**Missão requer Instancia de Item**
- Uma Missao requer nenhuma ou várias Instancia de Item (0,N) e uma Instancia de Item é requerida por nenhuma ou várias missões (0,N).

**NPC possui Missao**
- Um NPC possui uma ou várias missões e uma missão é possuída por apenas um NPC.

**NPC entrega Missao para PersonagemJogavel**
-Um NPC entrega nenhuma ou várias missões para PersonagemJogavel e PersonagemJogavel recebe missão de nenhum ou vários NPC. 

**PersonagemJogavel enfrenta InstanciaMonstro**
-Um PersonagemJogavel enfrenta nenhum ou várias InstanciaMonstro e uma InstanciaMonstro enfrenta nenhum ou um PersonagemJogavel.

**InstanciaMonstro possui Instancia de Item**
- Uma InstanciaMonstro possui nenhuma ou várias Instancia de Item e uma Instância de Item é possuida por nenhum ou apenas uma InstanciaMonstro.







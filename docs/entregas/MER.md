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

### 2. Atributos

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

**Missao realiza Sala**
- Uma Missão pode ser realizada em uma Sala e uma Sala pode realiza uma Missão(1, 1)

**Personagemjogavel protagoniza Missão**
- Um Personagemjogavel protagoniza uma ou várias Missão (1, n) e uma Missão é protagonizada por nenhum ou vários Personagemjogavel (0, n)

**Monstro possui InstanciaMonstro**
- Um Monstro possui nenhuma ou várias InstanciaMonstro (0, n) e uma InstanciaMonstro possui apenas um Monstro (1,1)








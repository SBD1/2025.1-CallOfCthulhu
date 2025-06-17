# Linguagem de Consulta de Dados (DQL)

## Introdução

A **Linguagem de Consulta de Dados (DQL - *Data Query Language*)** é um dos principais subconjuntos da linguagem SQL, dedicada exclusivamente à **consulta e recuperação de informações** em um banco de dados. Enquanto a DDL cria a estrutura e a DML manipula os dados, a DQL tem como objetivo extrair informações específicas que auxiliam na tomada de decisão e na geração de relatórios.

O principal comando da DQL é o `SELECT`, que permite consultar dados de tabelas, realizar junções, aplicar filtros e efetuar ordenações. De acordo com Elmasri e Navathe, "o comando `SELECT` é a base para a recuperação eficiente de dados em sistemas de banco de dados" <a id="FRM1" href="#REF1">[1]</a>.

Dominar a DQL é essencial para profissionais que trabalham com dados, como desenvolvedores, DBAs, analistas e cientistas de dados, pois possibilita acessar e analisar os dados armazenados de forma precisa e eficiente.

## Metodologia

A construção das consultas deste trabalho seguiu as seguintes etapas:

- **Análise do Modelo Relacional:** Estudo das tabelas e seus relacionamentos para identificar as melhores formas de consulta.
- **Elaboração de Consultas:** Criação de instruções SQL utilizando o comando `SELECT` com diferentes níveis de complexidade.
- **Execução no PostgreSQL:** Testes e validação das consultas no ambiente PostgreSQL para garantir a integridade e o retorno esperado dos dados.
- **Ajustes e Otimizações:** Refinamento das consultas para melhorar a eficiência e a clareza dos resultados.

---

## DQL - Linguagem de Consulta de Dados

Para acessar o script completo, clique no link a seguir: [Visualizar DQL no GitHub](https://github.com/SBD1/2025.1-CallOfCthulhu/blob/main/docs/entregas/segunda/dql.sql)

```
/*

HISTÓRICO DE VERSÕES

Versão: 0.1
Data: 12/06/2025
Descrição: Criando a versão inicial do DQL com consultas básicas que envolvem somente uma tabela.
Autor: Luiz Guilherme

*/

-- ===============================================

--           CONSULTAS DE PERSONAGEM

-- ===============================================

-- MOSTRAR OS ATRIBUTOS DE UM PERSONAGEM JOGÁVEL
SELECT
    forca,
    constituicao,
    poder,
    destreza,
    aparencia,
    tamanho,
    inteligencia,
    educacao,
    ideia,
    conhecimento,
    sorte
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;

-- MOSTRAR A VIDA ATUAL E MÁXIMA DO PERSONAGEM JOGÁVEL
SELECT 
    pts_de_vida,
    pontos_de_vida_atual
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;

-- MOSTRAR A SANIDADE ATUAL E MÁXIMA DO PERSONAGEM JOGÁVEL
SELECT 
    sanidade,
    sanidade_atual
FROM 
    public.view_personagens_jogaveis_completos
WHERE 
    id = %s;
    
-- MOSTRAR SE O PERSONAGEM ESTÁ EM UMA SALA OU CORREDOR
SELECT
    pj.id AS id_personagem,
    pj.nome AS nome_personagem,
    pj.ocupacao,
    CASE
        WHEN pj.id_sala IS NOT NULL THEN 'Sala'
        WHEN pj.id_corredor IS NOT NULL THEN 'Corredor'
        ELSE 'Local Desconhecido (erro ou sem localização)' -- Caso inesperado
    END AS tipo_local,
    COALESCE(s.descricao, c.descricao) AS descricao_do_local
FROM
    public.personagens_jogaveis pj
LEFT JOIN
    public.salas s ON pj.id_sala = s.id
LEFT JOIN
    public.corredores c ON pj.id_corredor = c.id;

-- ===============================================

--           CONSULTAS DE NPC

-- ===============================================

-- MOSTRAR TODAS AS INFORMAÇÕES DE UM NPC
SELECT
    nome,
    ocupacao,
    idade,
    sexo,
    residencia,
    local_nascimento,
FROM 
    public.npcs
WHERE 
    id = %s;

-- ===============================================

--           CONSULTAS DE DIÁLOGOS

-- ===============================================

-- MOSTRAR OS DIÁLOGOS DE UM NPC
SELECT 
    script_dialogo
FROM 
    public.dialogos
WHERE 
    npc_id = %s;

-- ===============================================

--           CONSULTAS DE INVENTÁRIOS

-- ===============================================

-- ===============================================

--           CONSULTAS DE TEMPLOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM TEMPLO
SELECT 
    nome,
    descricao
FROM 
    public.templos
WHERE
    id = %s;

-- ===============================================

--           CONSULTAS DE ANDARES

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM ANDAR
SELECT 
    descricao
FROM 
    public.andares
WHERE
    id = %s;

-- ===============================================

--           CONSULTAS DE SALAS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA SALA
SELECT 
    descricao
FROM 
    public.salas
WHERE
    id = %s;

-- ===============================================

--           CONSULTAS DE CORREDORES

-- ===============================================

-- ===============================================

--           CONSULTAS DE PERÍCIAS

-- ===============================================

-- ===============================================

--         CONSULTAS MONSTROS AGRESSIVOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM MONSTRO AGRESSIVO
SELECT 
    nome,
    descricao,
    defesa,
    vida,
    catalisador_agressividade,
    poder,
    tipo_agressivo,
    velocidade_ataque,
    loucura_induzida,
    dano
FROM 
    public.agressivos
WHERE 
    id = %s;

-- ===============================================

--         CONSULTAS MONSTROS PACÍFICOS

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UM MONSTRO PACÍFICOS
SELECT 
    nome,
    descricao,
    defesa,
    vida,
    motivo_passividade,
    tipo_pacifico,
    conhecimento_geografico,
    conhecimento_proibido
FROM 
    public.pacificos
WHERE 
    id = %s;

-- ===============================================

--         CONSULTAS INSTÂNCIAS DE MOSNTRO

-- ===============================================

-- ===============================================

--              CONSULTAS MISSÕES

-- ===============================================

-- MOSTRAR AS INFORMAÇÕES DE UMA MISSÃO
SELECT
    nome,
    descricao,
    tipo,
    ordem
FROM
    public.missoes
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ITENS MÁGICOS

-- ===============================================

--  MOSTRA AS INFORMAÇÕES DE UM ITEM MÁGICO
SELECT
    i.nome,
    i.descricao,
    i.valor,
    m.funcao,
    m.qtd_usos,
    m.custo_sanidade
SELECT
    public.magicos m
JOIN 
    public.itens i ON m.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ITENS DE CURA

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UM ITEM DE CURA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    c.funcao,
    c.qtd_usos,
    c.qtd_pontos_sanidade_recupera,
    c.qtd_pontos_vida_recupera
SELECT
    public.curas c
JOIN 
    public.itens i ON c.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ARMADURAS

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UMA ARMADURA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    a.atributo_necessario,
    a.durabilidade,
    a.funcao,
    a.qtd_atributo_necessario,
    a.qtd_atributo_recebe,
    a.qtd_dano_mitigado
SELECT
    public.armaduras a
JOIN 
    public.itens i ON a.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS ARMAS

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UMA ARMA
SELECT
    i.nome,
    i.descricao,
    i.valor,
    a.atributo_necessario,
    a.durabilidade,
    a.funcao,
    a.qtd_atributo_necessario,
    a.alcance,
    a.tipo_municao,
    a.tipo_dano,
    a.dano
SELECT
    public.armas a 
JOIN 
    public.itens i ON a.id = i.id
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS FEITIÇOS DE STATUS

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UM FEITÇO DE STATUS
SELECT
    nome, 
    descricao,
    qtd_pontos_de_magia,
    buff_debuff,
    qtd_buff_debuff,
    status_afetado
SELECT
    public.feitico_status
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS FEITIÇOS DE DANO

-- ===============================================

--  MOSTRAR AS INFORMAÇÕES DE UM FEITÇO DE DANO
SELECT
    nome, 
    descricao,
    qtd_pontos_de_magia,
    tipo_dano,
    qtd_dano
SELECT
    public.feitico_dano
WHERE 
    id = %s;

-- ===============================================

--              CONSULTAS DE UM ITEM

-- ===============================================

--  Não possui consultas diretas

```

---

## DQL - Linguagem de Consulta de Dados
Dentro do nosso jogo a gente utilizou essas consultas basicas.
Para acessar o script completo, clique no link a seguir: [Visualizar DQL do Jogo no GitHub](https://github.com/SBD1/2025.1-CallOfCthulhu/blob/main/app/database.py)

```
def get_personagem(self, nome_personagem: str): 
        """
        Retorna um objeto Player (Personagem Jogável) pelo nome.
        Retorna None se o personagem não for encontrado ou em caso de erro.
        """
        query = """
        SELECT
            id, nome, ocupacao, residencia, local_nascimento, idade, sexo,
            forca, constituicao, poder, destreza, aparencia, tamanho, inteligencia, educacao,
            movimento, sanidade_atual, insanidade_temporaria, insanidade_indefinida,
            pm_base, pm_max, pontos_de_vida_atual,
            id_sala, id_corredor, id_inventario, id_armadura, id_arma
        FROM
            public.personagens_jogaveis
        WHERE
            nome = %s;
        """
        personagem_data = self._execute_query(query, (nome_personagem,), fetch_one=True)

        if personagem_data:
            return Player(
                idJogador=personagem_data['id'],
                nome=personagem_data['nome'],
                ocupacao=personagem_data['ocupacao'],
                residencia=personagem_data['residencia'],
                local_nascimento=personagem_data['local_nascimento'],
                idade=personagem_data['idade'],
                sexo=personagem_data['sexo'],
                forca=personagem_data['forca'],
                constituicao=personagem_data['constituicao'],
                poder=personagem_data['poder'],
                destreza=personagem_data['destreza'],
                aparencia=personagem_data['aparencia'],
                tamanho=personagem_data['tamanho'],
                inteligencia=personagem_data['inteligencia'],
                educacao=personagem_data['educacao'],
                movimento=personagem_data['movimento'],
                sanidade_atual=personagem_data['sanidade_atual'],
                insanidade_temporaria=personagem_data['insanidade_temporaria'],
                insanidade_indefinida=personagem_data['insanidade_indefinida'],
                PM_base=personagem_data['pm_base'], 
                PM_max=personagem_data['pm_max'],
                pontos_de_vida_atual=personagem_data['pontos_de_vida_atual'],
                id_sala=personagem_data['id_sala'],
                id_corredor=personagem_data['id_corredor'],
                id_inventario=personagem_data['id_inventario'],
                id_armadura=personagem_data['id_armadura'],
                id_arma=personagem_data['id_arma']
            )
        else:
            print(f"Personagem '{nome_personagem}' não encontrado ou erro na consulta.")
            return None

def get_sala_com_saidas(self, id_sala: int):
        resultado = {'id': id_sala, 'descricao': None, 'saidas': []}
        sala_data = self._execute_query("SELECT descricao FROM public.salas WHERE id = %s;", (id_sala,), fetch_one=True)
        if not sala_data: return None
        resultado['descricao'] = sala_data['descricao'].strip()

        saidas_query = """
            SELECT c.id AS id_saida, c.descricao AS desc_saida
            FROM public.corredores c
            JOIN public.corredores_salas_destino j ON c.id = j.id_corredor
            WHERE j.id_sala = %s;
        """
        saidas_data = self._execute_query(saidas_query, (id_sala,), fetch_all=True)
        if saidas_data:
            resultado['saidas'] = [{'id_saida': s['id_saida'], 'desc_saida': s['desc_saida'].strip()} for s in saidas_data]
        return resultado

    def get_corredor_com_saidas(self, id_corredor: int):
        resultado = {'id': id_corredor, 'descricao': None, 'saidas': []}
        corredor_data = self._execute_query("SELECT descricao FROM public.corredores WHERE id = %s;", (id_corredor,), fetch_one=True)
        if not corredor_data: return None
        resultado['descricao'] = corredor_data['descricao'].strip()

        saidas_query = """
            SELECT s.id AS id_saida, s.descricao AS desc_saida
            FROM public.salas s
            JOIN public.corredores_salas_destino j ON s.id = j.id_sala
            WHERE j.id_corredor = %s;
        """
        saidas_data = self._execute_query(saidas_query, (id_corredor,), fetch_all=True)
        if saidas_data:
            resultado['saidas'] = [{'id_saida': s['id_saida'], 'desc_saida': s['desc_saida'].strip()} for s in saidas_data]
        return resultado


    def update_localizacao_jogador_na_sala(self, id_jogador: int, nova_sala_id: int):
        """
        Atualiza a localização do jogador para um novo corredor no banco de dados.
        """
        # Define a nova sala e zera o corredor para cumprir a regra do banco de dados
        query = """
            UPDATE public.personagens_jogaveis
            SET id_sala = NULL, id_corredor = %s
            WHERE id = %s;
        """
        self._execute_query(query, (nova_sala_id, id_jogador))
        print(f"[DB] Localização do jogador {id_jogador} atualizada para corredor {nova_sala_id}.")

    def update_localizacao_jogador(self, id_jogador: int, nova_sala_id: int = None, novo_corredor_id: int = None):
        query = "UPDATE public.personagens_jogaveis SET id_sala = %s, id_corredor = %s WHERE id = %s;"
        self._execute_query(query, (nova_sala_id, novo_corredor_id, id_jogador))

    def get_ficha_personagem(self, id_jogador: int):
        """
        Obtém e exibe a ficha completa do personagem usando a view.
        """

        query = """
            SELECT nome, ocupacao, residencia, local_nascimento, idade, sexo, forca, constituicao, poder, destreza,
                   aparencia, tamanho, inteligencia, educacao, ideia, conhecimento, sorte, movimento, sanidade_maxima,
                   sanidade_atual, insanidade_temporaria, insanidade_indefinida, PM_base, PM_max,
                   pts_de_vida, pontos_de_vida_atual
            FROM public.view_personagens_jogaveis_completos
            WHERE id = %s;
        """

        ficha_data = self._execute_query(query, (id_jogador,), fetch_one=True)

        if ficha_data:
        
            # Trata o nome para ficar sem valores nulos depois do texto
            nome_limpo = ficha_data['nome'].strip()

            print("\n===========================================\n")
            print(f"              FICHA DE {nome_limpo.upper()}             \n")
            print("===========================================\n")
            print("* INFORMAÇÕES BÁSICAS")
            print(f"  Nome: .......................... {nome_limpo}")
            print(f"  Ocupação: ...................... {ficha_data['ocupacao'].strip()}")
            print(f"  Residência: .................... {ficha_data['residencia'].strip()}")
            print(f"  Local de Nascimento:............ {ficha_data['local_nascimento'].strip()}")
            print(f"  Idade: ......................... {ficha_data['idade']} anos")
            print(f"  Sexo: .......................... {ficha_data['sexo'].strip()}\n")

            print("* ATRIBUTOS")
            print(f"  Força: {ficha_data['forca']} | Constituição: {ficha_data['constituicao']} | Poder: {ficha_data['poder']}")
            print(f"  Destreza: {ficha_data['destreza']} | Aparência: {ficha_data['aparencia']} | Tamanho: {ficha_data['tamanho']}")
            print(f"  Inteligência: {ficha_data['inteligencia']} | Educação: {ficha_data['educacao']} | Movimento: {ficha_data['movimento']} \n")
            
            print("* ATRIBUTOS DERIVADOS")
            print(f"  Ideia: {ficha_data['ideia']} | Conhecimento: {ficha_data['conhecimento']} | Sorte: {ficha_data['sorte']}%\n")

            print("* STATUS DO PERSONAGEM")
            print(f"  Pontos de Vida: ................. {ficha_data['pontos_de_vida_atual']} / {ficha_data['pts_de_vida']}")
            print(f"  Sanidade: ....................... {ficha_data['sanidade_atual']} / {ficha_data['sanidade_maxima']}")
            print(f"  Insanidade Temporária: .......... {'Sim' if ficha_data['insanidade_temporaria'] else 'Não'}")
            print(f"  Insanidade Indefinida: .......... {'Sim' if ficha_data['insanidade_indefinida'] else 'Não'}")
            print(f"  Pontos de Magia: ................ {ficha_data['pm_base']} / {ficha_data['pm_max']}")
            print("\n===========================================")

        else:
            print(f"Não foi possível encontrar a ficha para o personagem com ID: {id_jogador}")
```

---

## 📚 Bibliografia

> <a id="REF1" href="#FRM1">[1]</a> ELMASRI, R.; NAVATHE, S. B. *Sistemas de Banco de Dados*. 7. ed. Pearson Education do Brasil, 2018.  
>
> DATE, C. J. *An Introduction to Database Systems*. 8. ed. Addison-Wesley, 2003.  
>
> SILBERSCHATZ, A.; KORTH, H. F.; SUDARSHAN, S. *Database System Concepts*. 7. ed. McGraw-Hill Education, 2019.
>
> Oracle Database SQL Language Reference. Disponível em: [https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/index.html](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/index.html) (Acesso em 28 de maio de 2025).
>
> PostgreSQL Documentation. Disponível em: [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/) (Acesso em 28 de maio de 2025).
>
> Microsoft SQL Server Documentation. Disponível em: [https://docs.microsoft.com/en-us/sql/sql-server/sql-server-documentation](https://docs.microsoft.com/en-us/sql/sql-server/sql-server-documentation) (Acesso em 28 de maio de 2025).


## 📑 Histórico de Versões

| Versão | Descrição            | Autor(es)                                      | Data de Produção | Revisor(es)                                    | Data de Revisão |
| :----: | -------------------- | ---------------------------------------------- | :--------------: | ---------------------------------------------- | :-------------: |
| `1.0`  | Criação do documento | [João Marcos](https://github.com/JJOAOMARCOSS) |     16/06/25     | [Christopher](https://github.com/wChrstphr) |    16/06/25     |
| `1.1`  | Corrige e adiciona o DQL | [João Marcos](https://github.com/JJOAOMARCOSS) |     16/06/25     | [Christopher](https://github.com/wChrstphr) |    16/06/25     |
| `1.2`  | Adiciona consultas atuais do jogo | [João Marcos](https://github.com/JJOAOMARCOSS) |     16/06/25     | [Christopher](https://github.com/wChrstphr) |    16/06/25     |
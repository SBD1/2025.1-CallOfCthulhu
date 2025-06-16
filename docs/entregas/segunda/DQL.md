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
| `1.0`  | Criação do documento | [João Marcos](https://github.com/JJOAOMARCOSS) |     16/06/25     | [João Marcos](https://github.com/JJOAOMARCOSS) |    16/06/25     |
| `1.1`  | Arruamando o DQL e colocando aqui | [João Marcos](https://github.com/JJOAOMARCOSS) |     16/06/25     | [João Marcos](https://github.com/JJOAOMARCOSS) |    16/06/25     |
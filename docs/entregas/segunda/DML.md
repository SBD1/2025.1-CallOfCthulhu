# Linguagem de Manipulação de Dados (DML)

## Introdução

A **Linguagem de Manipulação de Dados (DML - *Data Manipulation Language*)** é um subconjunto essencial da linguagem SQL, responsável por **consultar, inserir, atualizar e excluir dados** armazenados em um banco de dados. Enquanto a DDL define a estrutura do banco, a DML permite a interação dinâmica com o conteúdo das tabelas, sendo fundamental para o funcionamento e manutenção de sistemas que dependem de dados consistentes e atualizados.

Segundo Elmasri e Navathe, "a DML fornece comandos para recuperar e atualizar dados armazenados" <a id="FRM1" href="#REF1">[1]</a>. Esses comandos viabilizam a manipulação direta das informações, permitindo a execução das operações mais comuns no dia a dia de desenvolvedores, analistas e administradores de banco de dados.

Os principais comandos da DML incluem:

- **`SELECT`**: Recupera dados das tabelas.
- **`INSERT`**: Insere novos registros.
- **`UPDATE`**: Altera registros existentes.
- **`DELETE`**: Remove registros das tabelas.

No desenvolvimento deste trabalho, foram utilizados os comandos DML para popular e manipular os dados do banco de dados do projeto, utilizando o PostgreSQL como Sistema Gerenciador de Banco de Dados (SGBD). Todas as operações foram validadas para garantir integridade e consistência dos dados.

## Metodologia

A metodologia aplicada neste módulo seguiu as etapas descritas abaixo:

- **Levantamento das Necessidades:** Identificação dos dados a serem inseridos e manipulados no banco.
- **Construção dos Comandos:** Elaboração dos scripts SQL contendo as operações de inserção, atualização, exclusão e consulta.
- **Execução e Testes:** Aplicação dos comandos no banco de dados PostgreSQL, com validação da integridade referencial e consistência dos dados.
- **Ajustes Finais:** Revisão das instruções para garantir a eficiência e a correta manipulação dos dados.

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
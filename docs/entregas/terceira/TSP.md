# Triggers e Stored Procedure

## Introdução

**Triggers são um recurso do SQL (Structured Query Language)** que permite a execução automática de uma ação definida (como uma instrução `INSERT`, `UPDATE` ou `DELETE`) quando um evento específico ocorre em uma tabela ou visão. Elas são usadas para garantir a integridade dos dados, automatizar processos, e implementar regras de negócios diretamente no banco de dados, sem a necessidade de intervenção manual.

## Funções

Funções programadas no próprio SQL para realizar atividades basicas do jogo como mover um jogador, pegar um item, realizar troca entre outros.(Arruma depois)

A figura 1 mostra a representação do Security Definer.

<p align="center"><i>Figura 1:</i></p>

<p align="center">
  <img src="" width="600">
</p>

---

## Security Definer

Funções programadas no próprio SQL para realizar atividades basicas do jogo como mover um jogador, pegar um item, realizar troca entre outros.(Coloca a foto embaixo).

A figura 2 mostra a representação do Security Definer.

<p align="center"><i>Figura 2:</i></p>

<p align="center">
  <img src="" width="600">
</p>

---

## Triggers Normais

Triggers comuns que não precisam de permissão de um superusuario para serem executados.

A figura 3 mostra a representação do Security Definer.

<p align="center"><i>Figura 3:</i></p>

<p align="center">
  <img src="" width="600">
</p>

## Permissões do prison_trading_user

> Permissões que o usuário pode ou não fazer

> Vermelho: Não pode alterar diretamente.

> Azul: Não possui direito de update nesses campos.

A figura 4 mostra a representação do Security Definer.

<p align="center"><i>Figura 4:</i></p>

<p align="center">
  <img src="" width="600">
</p>

---

## Código

```
Coloca o codigo total aqui
```

---

## 📚 Referencia

> Prison Trading Disponível em:https://sbd1.github.io/2024.1-Prison-Trading/#/Modulo-3/Triggers Acesso em 05 de julho de 2025.

## 📚 Bibliografia

> ELMASRI, R.; NAVATHE, S. B. *Sistemas de Banco de Dados*. 7. ed. Pearson Education do Brasil, 2018.  
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

| Versão | Descrição            | Autor(es)                                      | Data de Produção | Revisor(es)                                 | Data de Revisão |
| :----: | -------------------- | ---------------------------------------------- | :--------------: | ------------------------------------------- | :-------------: |
| `1.0`  | Criação do documento | [João Marcos](https://github.com/JJOAOMARCOSS) |     05/07/25     | [Christopher](https://github.com/wChrstphr) |    05/07/25     |
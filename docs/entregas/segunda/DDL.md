# Linguagem de Definição de Dados (DDL)

## Introdução

A **Linguagem de Definição de Dados (DDL - *Data Definition Language*)** é o conjunto de comandos SQL responsável pela **criação, alteração e remoção da estrutura de banco de dados**, como tabelas, índices e relacionamentos. Segundo Elmasri e Navathe, "a DDL fornece comandos para definir esquemas, criar tabelas e estabelecer restrições de integridade" <a id="FRM1" href="#REF1">[1]</a>.  
A estruturação adequada do banco, através da DDL, é essencial para garantir a integridade dos dados, o bom desempenho e a organização do sistema.

Neste trabalho, desenvolvemos a modelagem e criação das tabelas do banco de dados, aplicando conceitos de normalização e restrições de integridade referencial, utilizando PostgreSQL como Sistema Gerenciador de Banco de Dados.

## Metodologia

A metodologia aplicada neste módulo seguiu as etapas descritas abaixo:

- **Construção Inicial:** Criação das tabelas com base na modelagem elaborada no dbdiagram.io.
- **Definição de Domínios:** Desenvolvimento de tipos personalizados para as tabelas.
- **Normalização:** Correção da estrutura e eliminação de redundâncias.
- **Ajustes e Correções:** Solução de bugs, validação de integridade referencial e ajustes conforme o dicionário de dados.
- **Geração de IDs:** Implementação de funções para geração automática de identificadores únicos.

### Contribuição dos Integrantes

Todos integrates do grupo participou da elaboração do DDL

| Nome           | GitHub                                                               |
| -------------- | -------------------------------------------------------------------- |
| Cayo Alencar   | [https://github.com/Cayoalencar](https://github.com/Cayoalencar)     |
| Christopher    | [https://github.com/wChrstphr](https://github.com/wChrstphr)         |
| Igor Daniel    | [https://github.com/igorvdaniel](https://github.com/igorvdaniel)     |
| João Marcos    | [https://github.com/JJOAOMARCOSS](https://github.com/JJOAOMARCOSS)   |
| Luiz Guilherme | [https://github.com/luizfaria1989](https://github.com/luizfaria1989) |

### Tabela de Contribuições

| Versão | Data       | Descrição                                                 | Autor                     |
| ------ | ---------- | --------------------------------------------------------- | ------------------------- |
| 0.1    | 28/05/2025 | Criação da versão inicial do DDL com base no dbdiagram.io | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.2    | 29/05/2025 | Adição de domínios personalizados para as tabelas         | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.3    | 30/05/2025 | Criação da seção de drop tables                           | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.4    | 02/06/2025 | Correção de bugs na criação das tabelas                   | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.5    | 03/06/2025 | Normalização e solução de erros de projeto                | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.6    | 08/06/2025 | Correção de bugs nas tabelas e domínios                   | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.7    | 10/06/2025 | Ajustes conforme o dicionário de dados                    | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.8    | 11/06/2025 | Ajustes nos domínios e chave estrangeira                  | [Christopher](https://github.com/wChrstphr) e [João Marcos](https://github.com/JJOAOMARCOSS) |
| 0.9    | 12/06/2025 | Criação de IDs automáticos e tabela inventário            | [João Marcos](https://github.com/JJOAOMARCOSS)               |
| 0.10   | 13/06/2025 | Criação de IDs especializados para cada tabela            | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.11   | 13/06/2025 | Melhorias nos domínios de IDs especializados              | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 0.12   | 13/06/2025 | Criação das funções automáticas de geração de IDs         | [Luiz Guilherme](https://github.com/luizfaria1989)            |
| 1.0    | 14/06/2025 | Implementação final dos geradores de IDs                  | [Luiz Guilherme](https://github.com/luizfaria1989)            |

----

## DDL - Linguagem de Definição de Dados

```

```

---

## 📚 Bibliografia

> <a id="REF1" href="#FRM1">[1]</a> ELMASRI, R.; NAVATHE, S. B. *Sistemas de Banco de Dados*. 7. ed. Pearson Education do Brasil, 2018.  
>
> <a id="REF2" href="#FRM2">[2]</a> DATE, C. J. *An Introduction to Database Systems*. 8. ed. Addison-Wesley, 2003.  
>
> <a id="REF3" href="#FRM3">[3]</a> SILBERSCHATZ, A.; KORTH, H. F.; SUDARSHAN, S. *Database System Concepts*. 7. ed. McGraw-Hill Education, 2019.


## 📑 Histórico de Versões

| Versão | Descrição            | Autor(es)                                      | Data de Produção | Revisor(es)                                    | Data de Revisão |
| :----: | -------------------- | ---------------------------------------------- | :--------------: | ---------------------------------------------- | :-------------: |
| `1.0`  | Criação do documento | [João Marcos](https://github.com/JJOAOMARCOSS) |     16/06/25     | [João Marcos](https://github.com/JJOAOMARCOSS) |    16/06/25     |
# 👕 Banco de Dados – Loja Virtual de Moda

## 📖 Descrição do Projeto

Este repositório contém o desenvolvimento de um banco de dados voltado para o funcionamento de uma **Loja Virtual de Moda**, simulando a estrutura de um sistema de e-commerce utilizado para venda de roupas e acessórios.

O projeto foi desenvolvido como atividade da disciplina de **Banco de Dados II**, com o objetivo de aplicar na prática conceitos fundamentais de modelagem e implementação de bancos relacionais.

Durante o desenvolvimento foram utilizados princípios de:

- Modelagem conceitual e lógica de dados
- Definição de relacionamentos entre entidades
- Implementação de restrições e chaves estrangeiras
- Criação de estruturas SQL utilizando comandos DDL

---

# 👨‍🎓 Integrantes

Bárbara Ferreira Esteves

Gabriel Augusto Ferrari

Kamilly Ribeiro de Oliveira

---

# 🗂️ Organização do Banco de Dados

A estrutura do banco foi projetada para representar os principais processos de uma loja virtual, desde o cadastro de clientes até a finalização de pedidos.

As principais tabelas presentes no sistema são:

- **cliente** – armazena os dados dos usuários cadastrados
- **categoria** – organiza os produtos em grupos
- **produto** – registra as informações gerais dos produtos
- **produto_variante** – controla variações como tamanho e cor
- **pedido** – registra as compras realizadas
- **item_pedido** – relaciona os produtos incluídos em cada pedido
- **pagamento** – armazena as informações de pagamento
- **entrega** – controla o envio e rastreamento dos pedidos

Essa estrutura permite representar corretamente as relações entre os elementos do sistema e evita redundância de informações.

---

# 🔗 Principais Relacionamentos

Algumas relações importantes definidas no banco incluem:

- Um **cliente** pode realizar vários **pedidos**
- Cada **pedido** pode conter vários **itens**
- Um **produto** pertence a uma **categoria**
- Um **pedido** possui um registro de **pagamento**
- Um **pedido** possui uma **entrega**
- Um **produto** pode possuir múltiplas **variantes**

Essas relações são implementadas utilizando **chaves estrangeiras**, garantindo a integridade dos dados.

---

# 📁 Arquivos do Repositório

Este projeto contém os seguintes arquivos principais:

- **script_loja_moda.sql** → script SQL responsável por criar o banco e suas tabelas
- **der_loja_moda.png** → diagrama entidade-relacionamento do banco de dados
- **dicionario-de-dados.md** → documentação detalhada das tabelas e atributos
- **README.md** → documentação geral do projeto

---

# 🧰 Ferramentas Utilizadas

O desenvolvimento do projeto utilizou as seguintes ferramentas:

- **MySQL** – sistema de gerenciamento de banco de dados
- **MySQL Workbench** – modelagem e execução de scripts
- **SQL (DDL)** – criação da estrutura do banco
- **GitHub** – controle de versão e hospedagem do projeto

---

# ▶️ Execução do Banco de Dados

Para criar o banco de dados localmente siga os passos abaixo:

1. Abrir o **MySQL Workbench**
2. Criar ou selecionar uma conexão com o servidor MySQL
3. Abrir o arquivo:
script_loja_moda.sql
4. Executar o script completo

Após a execução, o banco **loja_moda** será criado automaticamente com todas as tabelas e relacionamentos definidos.

---

# 📊 Objetivo Acadêmico

Este projeto tem como finalidade demonstrar a aplicação prática dos conceitos estudados em banco de dados, incluindo modelagem relacional, definição de entidades, implementação de restrições e documentação técnica da estrutura criada.

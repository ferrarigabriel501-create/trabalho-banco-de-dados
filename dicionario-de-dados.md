# 📚 Dicionário de Dados
## Banco de Dados – Loja Virtual de Moda

## 👥 Integrantes

Bárbara Ferreira Esteves

Gabriel Augusto Ferrari

Kamilly Ribeiro de Oliveira

---

## 📖 Introdução

Este documento apresenta a documentação estrutural do banco de dados utilizado no sistema **Loja Virtual de Moda**.  
O objetivo é descrever as tabelas existentes, seus atributos, tipos de dados, restrições e relações entre elas.

A modelagem foi desenvolvida seguindo princípios de **modelagem relacional**, garantindo:

- organização dos dados
- integridade referencial
- consistência entre entidades

---

# 🗄️ Estrutura das Tabelas

---

# 🔹 Tabela: cliente

📖 **Descrição:**  
Armazena as informações dos clientes cadastrados na loja.

| Campo | Tipo de Dado | Tamanho | Restrições | Descrição |
|------|-------------|---------|------------|-----------|
| id_cliente | BIGINT | — | PK, AUTO_INCREMENT | Identificador único do cliente |
| nome | VARCHAR | 120 | NOT NULL | Nome completo do cliente |
| email | VARCHAR | 160 | NOT NULL, UNIQUE | Email do cliente |
| cpf | VARCHAR | 14 | UNIQUE | CPF do cliente |
| telefone | VARCHAR | 20 | — | Telefone para contato |
| senha_hash | VARCHAR | 255 | NOT NULL | Senha criptografada do cliente |
| criado_em | DATETIME | — | DEFAULT CURRENT_TIMESTAMP | Data de criação do cadastro |

---

# 🔹 Tabela: categoria

📖 **Descrição:**  
Responsável por classificar os produtos da loja.

| Campo | Tipo de Dado | Tamanho | Restrições | Descrição |
|------|-------------|---------|------------|-----------|
| id_categoria | BIGINT | — | PK, AUTO_INCREMENT | Identificador da categoria |
| nome | VARCHAR | 80 | NOT NULL | Nome da categoria |
| slug | VARCHAR | 100 | UNIQUE | Identificador usado em URLs |
| id_categoria_pai | BIGINT | — | FK | Categoria superior |

🔗 **Chave Estrangeira**

id_categoria_pai → categoria(id_categoria)

---

# 🔹 Tabela: produto

📖 **Descrição:**  
Armazena as informações gerais dos produtos da loja.

| Campo | Tipo de Dado | Tamanho | Restrições | Descrição |
|------|-------------|---------|------------|-----------|
| id_produto | BIGINT | — | PK | Identificador do produto |
| id_categoria | BIGINT | — | FK | Categoria do produto |
| nome | VARCHAR | 140 | NOT NULL | Nome do produto |
| descricao | TEXT | — | — | Descrição detalhada |
| preco_base | DECIMAL | 10,2 | NOT NULL | Preço base |
| ativo | BOOLEAN | — | — | Indica se o produto está disponível |
| criado_em | DATETIME | — | — | Data de criação |

🔗 **Chave Estrangeira**

id_categoria → categoria(id_categoria)

---

# 🔹 Tabela: pedido

📖 **Descrição:**  
Registra os pedidos realizados pelos clientes.

| Campo | Tipo de Dado | Tamanho | Restrições | Descrição |
|------|-------------|---------|------------|-----------|
| id_pedido | BIGINT | — | PK | Identificador do pedido |
| id_cliente | BIGINT | — | FK | Cliente que realizou o pedido |
| id_endereco_entrega | BIGINT | — | FK | Endereço de entrega |
| status | ENUM | — | — | Status do pedido |
| subtotal | DECIMAL | 10,2 | — | Valor dos produtos |
| desconto | DECIMAL | 10,2 | — | Descontos aplicados |
| frete | DECIMAL | 10,2 | — | Valor do frete |
| total | DECIMAL | 10,2 | — | Valor total do pedido |
| criado_em | DATETIME | — | — | Data de criação |

🔗 **Chaves Estrangeiras**

id_cliente → cliente(id_cliente)  
id_endereco_entrega → endereco(id_endereco)

---

# 🔹 Tabela: item_pedido

📖 **Descrição:**  
Tabela responsável por armazenar os produtos presentes em cada pedido.

| Campo | Tipo de Dado | Tamanho | Restrições | Descrição |
|------|-------------|---------|------------|-----------|
| id_item_pedido | BIGINT | — | PK | Identificador do item |
| id_pedido | BIGINT | — | FK | Pedido relacionado |
| id_variante | BIGINT | — | FK | Variante do produto |
| qtd | INT | — | NOT NULL | Quantidade comprada |
| preco_unit | DECIMAL | 10,2 | — | Preço unitário |
| total_item | DECIMAL | 10,2 | — | Valor total do item |

🔗 **Chaves Estrangeiras**

id_pedido → pedido(id_pedido)  
id_variante → produto_variante(id_variante)

---

# 🔹 Tabela: pagamento

📖 **Descrição:**  
Registra as informações de pagamento dos pedidos.

| Campo | Tipo de Dado | Tamanho | Restrições | Descrição |
|------|-------------|---------|------------|-----------|
| id_pagamento | BIGINT | — | PK | Identificador do pagamento |
| id_pedido | BIGINT | — | FK | Pedido relacionado |
| forma | ENUM | — | — | Forma de pagamento |
| status | ENUM | — | — | Status do pagamento |
| valor | DECIMAL | 10,2 | — | Valor pago |
| transacao_id | VARCHAR | 120 | — | Código da transação |
| pago_em | DATETIME | — | — | Data do pagamento |

🔗 **Chave Estrangeira**

id_pedido → pedido(id_pedido)

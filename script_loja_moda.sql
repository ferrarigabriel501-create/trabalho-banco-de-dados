CREATE DATABASE IF NOT EXISTS loja_moda
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE loja_moda;

-- =========================
-- CLIENTE / ENDEREÇO
-- =========================
CREATE TABLE cliente (
  id_cliente      BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(120) NOT NULL,
  email           VARCHAR(160) NOT NULL UNIQUE,
  cpf             VARCHAR(14) UNIQUE,
  telefone        VARCHAR(20),
  senha_hash      VARCHAR(255) NOT NULL,
  criado_em       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE endereco (
  id_endereco     BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_cliente      BIGINT NOT NULL,
  logradouro      VARCHAR(160) NOT NULL,
  numero          VARCHAR(20) NOT NULL,
  complemento     VARCHAR(80),
  bairro          VARCHAR(80) NOT NULL,
  cidade          VARCHAR(80) NOT NULL,
  uf              CHAR(2) NOT NULL,
  cep             VARCHAR(10) NOT NULL,
  principal       BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_endereco_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- CATEGORIA / PRODUTO
-- =========================
CREATE TABLE categoria (
  id_categoria        BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome                VARCHAR(80) NOT NULL,
  slug                VARCHAR(100) NOT NULL UNIQUE,
  id_categoria_pai    BIGINT NULL,
  CONSTRAINT fk_categoria_pai
    FOREIGN KEY (id_categoria_pai) REFERENCES categoria(id_categoria)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE produto (
  id_produto      BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_categoria    BIGINT NOT NULL,
  nome            VARCHAR(140) NOT NULL,
  descricao       TEXT,
  preco_base      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  ativo           BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_produto_categoria
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Variante (tamanho/cor/SKU/estoque)
CREATE TABLE produto_variante (
  id_variante     BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_produto      BIGINT NOT NULL,
  sku             VARCHAR(60) NOT NULL UNIQUE,
  tamanho         VARCHAR(20),
  cor             VARCHAR(30),
  preco           DECIMAL(10,2) NOT NULL,
  estoque         INT NOT NULL DEFAULT 0,
  ativo           BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_variante_produto
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE imagem_produto (
  id_imagem     BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_produto    BIGINT NOT NULL,
  url           VARCHAR(255) NOT NULL,
  ordem         INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_imagem_produto
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- CARRINHO
-- =========================
CREATE TABLE carrinho (
  id_carrinho     BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_cliente      BIGINT NULL,
  status          ENUM('ATIVO','CONVERTIDO','ABANDONADO') NOT NULL DEFAULT 'ATIVO',
  criado_em       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_carrinho_cliente (id_cliente),
  CONSTRAINT fk_carrinho_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE item_carrinho (
  id_item_carrinho  BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_carrinho       BIGINT NOT NULL,
  id_variante       BIGINT NOT NULL,
  qtd               INT NOT NULL,
  preco_unit        DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_carrinho_carrinho
    FOREIGN KEY (id_carrinho) REFERENCES carrinho(id_carrinho)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_item_carrinho_variante
    FOREIGN KEY (id_variante) REFERENCES produto_variante(id_variante)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_item_carrinho_qtd CHECK (qtd > 0)
) ENGINE=InnoDB;

-- =========================
-- PEDIDO / ITENS
-- =========================
CREATE TABLE pedido (
  id_pedido             BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_cliente            BIGINT NOT NULL,
  id_endereco_entrega   BIGINT NOT NULL,
  status                ENUM('CRIADO','PAGO','ENVIADO','ENTREGUE','CANCELADO') NOT NULL DEFAULT 'CRIADO',
  subtotal              DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  desconto              DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  frete                 DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total                 DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  criado_em             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pedido_endereco
    FOREIGN KEY (id_endereco_entrega) REFERENCES endereco(id_endereco)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
  id_item_pedido   BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_pedido        BIGINT NOT NULL,
  id_variante      BIGINT NOT NULL,
  qtd              INT NOT NULL,
  preco_unit       DECIMAL(10,2) NOT NULL,
  total_item       DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_pedido_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_item_pedido_variante
    FOREIGN KEY (id_variante) REFERENCES produto_variante(id_variante)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_item_pedido_qtd CHECK (qtd > 0)
) ENGINE=InnoDB;

-- =========================
-- PAGAMENTO / ENTREGA
-- =========================
CREATE TABLE pagamento (
  id_pagamento     BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_pedido        BIGINT NOT NULL,
  forma            ENUM('PIX','CARTAO','BOLETO') NOT NULL,
  status           ENUM('PENDENTE','APROVADO','RECUSADO','ESTORNADO') NOT NULL DEFAULT 'PENDENTE',
  valor            DECIMAL(10,2) NOT NULL,
  transacao_id     VARCHAR(120),
  pago_em          DATETIME NULL,
  CONSTRAINT fk_pagamento_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE entrega (
  id_entrega       BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_pedido        BIGINT NOT NULL UNIQUE,
  transportadora   VARCHAR(80),
  codigo_rastreio  VARCHAR(80),
  status           ENUM('AGUARDANDO','ENVIADO','ENTREGUE','DEVOLVIDO') NOT NULL DEFAULT 'AGUARDANDO',
  enviado_em       DATETIME NULL,
  entregue_em      DATETIME NULL,
  CONSTRAINT fk_entrega_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Índices úteis
CREATE INDEX idx_produto_categoria ON produto(id_categoria);
CREATE INDEX idx_variante_produto ON produto_variante(id_produto);
CREATE INDEX idx_pedido_cliente ON pedido(id_cliente);
CREATE INDEX idx_item_pedido_pedido ON item_pedido(id_pedido);
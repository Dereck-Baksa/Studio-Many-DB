create database if not exists core_db;
use core_db;

show tables;

CREATE TABLE clientes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) UNIQUE,
    cpf VARCHAR(20),
    endereco VARCHAR(255),
    estagio_funil VARCHAR(100),
    observacoes VARCHAR(255),
    ativo BOOLEAN,
    data_cadastro DATETIME
);

CREATE TABLE funcionarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    cpf VARCHAR(20),
    especialidade VARCHAR(255),
    ativo BOOLEAN,
    data_cadastro DATETIME
);

CREATE TABLE servicos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    duracao_minutos INT,
    preco DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN
);

CREATE TABLE agendamentos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim DATETIME NOT NULL,
    status ENUM('PENDENTE','CONFIRMADO','CONCLUIDO','CANCELADO','NAO_COMPARECEU','REALIZADO'),
    observacoes VARCHAR(255),
    motivo_cancelamento TEXT,
    quantidade_parcelas INT,
    valor_sinal DECIMAL(10,2),
    valor_total DECIMAL(10,2),

    cliente_id BIGINT NOT NULL,
    funcionario_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,

    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id),
    FOREIGN KEY (servico_id) REFERENCES servicos(id)
);

CREATE TABLE pacotes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_sessoes INT NOT NULL,
    validade_dias INT,
    ativo BOOLEAN,
    data_cadastro DATETIME,

    servico_id BIGINT NOT NULL,
    FOREIGN KEY (servico_id) REFERENCES servicos(id)
);

CREATE TABLE cliente_pacotes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_compra DATETIME,
    data_validade DATE,
    sessoes_usadas INT NOT NULL,
    status ENUM('ATIVO','EXPIRADO','USADO'),

    cliente_id BIGINT NOT NULL,
    pacote_id BIGINT NOT NULL,

    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (pacote_id) REFERENCES pacotes(id)
);

CREATE TABLE comissoes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_comissao DATE,
    data_pagamento DATE,
    percentual DECIMAL(5,2),
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('PENDENTE','PAGA'),

    agendamento_id BIGINT NOT NULL,
    funcionario_id BIGINT NOT NULL,

    FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
);

CREATE TABLE funcionario_servicos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    percentual_comissao DECIMAL(5,2),

    funcionario_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,

    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id),
    FOREIGN KEY (servico_id) REFERENCES servicos(id)
);

CREATE TABLE horario_trabalho (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dia_semana INT NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,

    funcionario_id BIGINT NOT NULL,
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
);

CREATE TABLE bloqueios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    motivo VARCHAR(255),

    funcionario_id BIGINT NOT NULL,
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
);

CREATE TABLE lista_espera (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_cadastro DATETIME,
    data_desejada DATE,
    horario_desejado TIME,
    observacoes VARCHAR(255),
    status ENUM('AGUARDANDO','ATENDIDO','CANCELADO'),

    cliente_id BIGINT NOT NULL,
    funcionario_id BIGINT,
    servico_id BIGINT NOT NULL,

    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id),
    FOREIGN KEY (servico_id) REFERENCES servicos(id)
);

CREATE TABLE movimentos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_cadastro DATETIME,
    data_movimento DATE NOT NULL,
    descricao TEXT,
    tipo ENUM('RECEITA','DESPESA') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    referencia_id BIGINT,
    referencia_tipo VARCHAR(100)
);

CREATE TABLE parcelas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('PENDENTE','QUITADA','VENCIDA'),

    agendamento_id BIGINT NOT NULL,
    FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id)
);

CREATE TABLE produtos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2),
    estoque INT,
    ativo BOOLEAN,
    data_cadastro DATETIME
);

CREATE TABLE pedidos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATETIME,
    status ENUM('PENDENTE','PAGO','CANCELADO'),
    valor_total DECIMAL(10,2),

    cliente_id BIGINT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE pedido_itens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,

    pedido_id BIGINT NOT NULL,
    produto_id BIGINT NOT NULL,

    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','FUNCIONARIO') NOT NULL,
    ativo BOOLEAN,
    data_cadastro DATETIME,

    funcionario_id BIGINT,
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
);

CREATE TABLE auditoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    acao VARCHAR(255) NOT NULL,
    entidade VARCHAR(255) NOT NULL,
    entidade_id BIGINT NOT NULL,
    data_acao DATETIME NOT NULL,
    dados_anteriores TEXT,
    dados_novos TEXT,
    usuario VARCHAR(255)
);
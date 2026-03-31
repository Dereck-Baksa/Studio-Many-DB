CREATE DATABASE IF NOT EXISTS many;

USE many;

CREATE TABLE agendamentos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cliente_id BIGINT NOT NULL,
    funcionario_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,
    agendamento_original_id BIGINT,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim DATETIME NOT NULL,
    data_chegada DATETIME,
    data_confirmacao_sinal DATETIME,
    data_criacao DATETIME,
    data_finalizacao DATETIME,
    valor_total DECIMAL(10,2),
    valor_sinal DECIMAL(10,2),
    taxa_cancelamento DECIMAL(10,2),
    quantidade_parcelas INTEGER,
    quantidade_reagendamentos INTEGER,
    recorrente BIT,
    frequencia_recorrencia VARCHAR(255),
    comprovante_sinal VARCHAR(255),
    motivo_cancelamento TEXT,
    observacoes VARCHAR(255),
    status ENUM ('AGUARDANDO_CONFIRMACAO','CANCELADO','CONCLUIDO','CONFIRMADO','EM_ATENDIMENTO','NAO_COMPARECEU','PENDENTE','REAGENDADO'),
    PRIMARY KEY (id)
);

CREATE TABLE auditoria (
    id BIGINT NOT NULL AUTO_INCREMENT,
    usuario_id BIGINT,
    entidade_id BIGINT NOT NULL,
    entidade VARCHAR(255) NOT NULL,
    operacao VARCHAR(255) NOT NULL,
    dados_anteriores TEXT,
    dados_novos TEXT,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE bloqueios (
    id BIGINT NOT NULL AUTO_INCREMENT,
    funcionario_id BIGINT NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    motivo VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE cliente_pacotes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cliente_id BIGINT NOT NULL,
    pacote_id BIGINT NOT NULL,
    sessoes_usadas INTEGER NOT NULL,
    data_compra DATETIME,
    data_validade DATE,
    status ENUM ('ATIVO','EXPIRADO','USADO'),
    PRIMARY KEY (id)
);

CREATE TABLE clientes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    estagio_funil VARCHAR(255),
    observacoes VARCHAR(255),
    ativo BIT,
    data_cadastro DATETIME,
    PRIMARY KEY (id)
);

CREATE TABLE comissoes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    funcionario_id BIGINT NOT NULL,
    agendamento_id BIGINT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    percentual DECIMAL(5,2),
    data_comissao DATE,
    data_pagamento DATE,
    status ENUM ('PAGA','PENDENTE'),
    PRIMARY KEY (id)
);

CREATE TABLE funcionario_servicos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    funcionario_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,
    percentual_comissao DECIMAL(5,2),
    PRIMARY KEY (id)
);

CREATE TABLE funcionarios (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(255) NOT NULL,
    especialidade VARCHAR(255),
    ativo BIT,
    data_cadastro DATETIME,
    PRIMARY KEY (id)
);

CREATE TABLE horario_trabalho (
    id BIGINT NOT NULL AUTO_INCREMENT,
    funcionario_id BIGINT NOT NULL,
    dia_semana INTEGER NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE lista_espera (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cliente_id BIGINT NOT NULL,
    servico_id BIGINT NOT NULL,
    funcionario_id BIGINT,
    data_desejada DATE,
    horario_desejado TIME,
    data_cadastro DATETIME,
    observacoes VARCHAR(255),
    status ENUM ('AGUARDANDO','ATENDIDO','CANCELADO'),
    PRIMARY KEY (id)
);

CREATE TABLE movimentos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    usuario_id BIGINT,
    agendamento_id BIGINT,
    valor DECIMAL(10,2) NOT NULL,
    tipo ENUM ('DESPESA','RECEITA') NOT NULL,
    descricao TEXT,
    data_movimento DATE NOT NULL,
    data_cadastro DATETIME,
    PRIMARY KEY (id)
);

CREATE TABLE pacotes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    servico_id BIGINT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_sessoes INTEGER NOT NULL,
    validade_dias INTEGER,
    ativo BIT,
    data_cadastro DATETIME,
    PRIMARY KEY (id)
);

CREATE TABLE parcelas (
    id BIGINT NOT NULL AUTO_INCREMENT,
    agendamento_id BIGINT NOT NULL,
    numero INTEGER NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    status ENUM ('CANCELADA','PENDENTE','QUITADA','VENCIDA'),
    PRIMARY KEY (id)
);

CREATE TABLE pedido_itens (
    id BIGINT NOT NULL AUTO_INCREMENT,
    pedido_id BIGINT NOT NULL,
    produto_id BIGINT NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE pedidos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cliente_id BIGINT NOT NULL,
    valor_total DECIMAL(10,2),
    data_pedido DATETIME,
    status ENUM ('CANCELADO','PAGO','PENDENTE'),
    PRIMARY KEY (id)
);

CREATE TABLE produtos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2),
    estoque INTEGER,
    ativo BIT,
    data_cadastro DATETIME,
    PRIMARY KEY (id)
);

CREATE TABLE servicos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    duracao_minutos INTEGER,
    ativo BIT,
    confirmacao_automatica BIT,
    PRIMARY KEY (id)
);

CREATE TABLE usuarios (
    id BIGINT NOT NULL AUTO_INCREMENT,
    funcionario_id BIGINT,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    role ENUM ('ADMIN','FUNCIONARIO') NOT NULL,
    ativo BIT,
    data_cadastro DATETIME,
    PRIMARY KEY (id)
);

ALTER TABLE cliente_pacotes ADD CONSTRAINT UK_cli_pac UNIQUE (cliente_id, pacote_id);
ALTER TABLE clientes ADD CONSTRAINT UK_cli_cpf UNIQUE (cpf);
ALTER TABLE clientes ADD CONSTRAINT UK_cli_email UNIQUE (email);
ALTER TABLE funcionarios ADD CONSTRAINT UK_func_email UNIQUE (email);
ALTER TABLE horario_trabalho ADD CONSTRAINT UK_func_horario UNIQUE (funcionario_id, dia_semana, hora_inicio);
ALTER TABLE usuarios ADD CONSTRAINT UK_user_email UNIQUE (email);

ALTER TABLE agendamentos ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);
ALTER TABLE agendamentos ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
ALTER TABLE agendamentos ADD FOREIGN KEY (servico_id) REFERENCES servicos (id);
ALTER TABLE auditoria ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (id);
ALTER TABLE bloqueios ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
ALTER TABLE cliente_pacotes ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);
ALTER TABLE cliente_pacotes ADD FOREIGN KEY (pacote_id) REFERENCES pacotes (id);
ALTER TABLE comissoes ADD FOREIGN KEY (agendamento_id) REFERENCES agendamentos (id);
ALTER TABLE comissoes ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
ALTER TABLE funcionario_servicos ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
ALTER TABLE funcionario_servicos ADD FOREIGN KEY (servico_id) REFERENCES servicos (id);
ALTER TABLE horario_trabalho ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
ALTER TABLE lista_espera ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);
ALTER TABLE lista_espera ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
ALTER TABLE lista_espera ADD FOREIGN KEY (servico_id) REFERENCES servicos (id);
ALTER TABLE movimentos ADD FOREIGN KEY (agendamento_id) REFERENCES agendamentos (id);
ALTER TABLE movimentos ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (id);
ALTER TABLE pacotes ADD FOREIGN KEY (servico_id) REFERENCES servicos (id);
ALTER TABLE parcelas ADD FOREIGN KEY (agendamento_id) REFERENCES agendamentos (id);
ALTER TABLE pedido_itens ADD FOREIGN KEY (pedido_id) REFERENCES pedidos (id);
ALTER TABLE pedido_itens ADD FOREIGN KEY (produto_id) REFERENCES produtos (id);
ALTER TABLE pedidos ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);
ALTER TABLE usuarios ADD FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id);
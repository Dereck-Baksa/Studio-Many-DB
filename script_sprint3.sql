CREATE DATABASE IF NOT EXISTS studiomanydb;
USE studiomanydb;

CREATE TABLE tipo_pagamentos(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45) NOT NULL
);

CREATE TABLE status_pagamentos(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(45)
);

CREATE TABLE status_clientes_pacotes(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(45)
);

CREATE TABLE anamneses(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    informacao VARCHAR(45),
    arquivo_url VARCHAR(255)
);

CREATE TABLE tipos_sinais(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(45)
);

CREATE TABLE status_agendamentos(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(45)
);

CREATE TABLE perfis(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    perfil VARCHAR(45) NOT NULL
);

CREATE TABLE usuarios(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME,

    perfil_id INT NOT NULL,

    FOREIGN KEY (perfil_id) REFERENCES perfis(id)
);

CREATE TABLE profissionais(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(75),
    foto_url VARCHAR(75),
    ativo BOOLEAN,
    criado_em DATETIME,

    usuario_id INT UNIQUE,

    FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE bloqueios(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    inicio DATETIME NOT NULL,
    fim DATETIME NOT NULL,
    motivo VARCHAR(255),

    profissional_id INT,

    FOREIGN KEY (profissional_id) REFERENCES profissionais(id)
);

CREATE TABLE servicos(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(255),
    foto_url VARCHAR(255),
    duracao_minutos INT,
    preco DECIMAL(8,2),
    sinal_valor DECIMAL(8,2),
    ativo BOOLEAN,
    criado_em DATETIME,

    tipos_sinais_id INT,

    FOREIGN KEY (tipos_sinais_id) REFERENCES tipos_sinais(id)
);

CREATE TABLE clientes(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(75) NOT NULL,
    telefone VARCHAR(30) NOT NULL,
    documento VARCHAR(75),
    total_no_shows INT,
    bloqueado_motivo VARCHAR(255),
    lgpd_consentimento BOOLEAN,
    criado_em DATETIME,
    ativo BOOLEAN,

    usuario_id INT UNIQUE,

    FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE anamnese_clientes(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	anamneses_id INT NOT NULL,
    clientes_id INT NOT NULL,

    FOREIGN KEY (anamneses_id) REFERENCES anamneses(id),
    FOREIGN KEY (clientes_id) REFERENCES clientes(id)
);

CREATE TABLE servicos_profissionais(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	servicos_id INT NOT NULL,
    profissionais_id INT NOT NULL,

    FOREIGN KEY (servicos_id) REFERENCES servicos(id),
    FOREIGN KEY (profissionais_id) REFERENCES profissionais(id)
);

CREATE TABLE pacotes(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    total_sessoes INT,
    preco_total DECIMAL(8,2),
    validade_dias INT,
    ativo BOOLEAN,
    criado_em DATETIME,

    servicos_id INT,

    FOREIGN KEY (servicos_id) REFERENCES servicos(id)
);

CREATE TABLE agendamentos(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    inicio DATETIME,
    fim DATETIME,
    cancelamento_motivo VARCHAR(255),
    cancelado_em DATETIME,
    qtd_remarcacoes INT,
    remarcacao_aprovacao_necessaria BOOLEAN,
    criado_por_usuario_id INT,
    criado_em DATETIME,

    cliente_id INT,
    status_agendamento_id INT,

	FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (status_agendamento_id) REFERENCES status_agendamentos(id),
    FOREIGN KEY (criado_por_usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE pagamentos(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    valor DECIMAL(8,2),
    pago_em DATETIME,
    comprovante_url VARCHAR(255),

    agendamento_id INT,
    status_pagamento_id INT,
    tipo_pagamentos_id INT,

    FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id),
    FOREIGN KEY (status_pagamento_id) REFERENCES status_pagamentos(id),
    FOREIGN KEY (tipo_pagamentos_id) REFERENCES tipo_pagamentos(id)
);

CREATE TABLE cliente_pacotes(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	sessoes_restantes INT,
    valido_ate DATETIME,
    criado_em DATETIME,

    cliente_id INT,
    pacote_id INT,
    pagamento_id INT,
    status_cliente_pacote_id INT,

    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (pacote_id) REFERENCES pacotes(id),
    FOREIGN KEY (pagamento_id) REFERENCES pagamentos(id),
    FOREIGN KEY (status_cliente_pacote_id) REFERENCES status_clientes_pacotes(id)
);

CREATE TABLE agendamento_itens(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	inicio_atendimento DATETIME,
    fim_atendimento DATETIME,
    checkin_em DATETIME,
    preco DECIMAL(8,2),
    desconto_porcentagem DECIMAL(5,2),
    preco_final DECIMAL(8,2),

    agendamento_id INT,
    servico_id INT,
    profissional_id INT,

    FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id),
	FOREIGN KEY (servico_id) REFERENCES servicos(id),
    FOREIGN KEY (profissional_id) REFERENCES profissionais(id)
);

-- 1. Cadastros Básicos (Tabelas de Apoio)
INSERT INTO perfis (perfil) VALUES ('Administrador'), ('Profissional'), ('Cliente');
INSERT INTO status_agendamentos (estado) VALUES ('Agendado'), ('Concluído'), ('Cancelado');
INSERT INTO status_pagamentos (estado) VALUES ('Pendente'), ('Pago');
INSERT INTO tipos_sinais (tipo) VALUES ('Não Requer'), ('Valor Fixo'), ('Percentual');

-- 2. Criando um Usuário e um Profissional
INSERT INTO usuarios (email, senha, perfil_id, criado_em) VALUES ('ana.estetica@email.com', 'hash123', 2, NOW());
INSERT INTO profissionais (nome, ativo, usuario_id, criado_em) VALUES ('Ana Silva', TRUE, 1, NOW());

-- 3. Criando um Serviço e um Pacote
INSERT INTO servicos (nome, preco, duracao_minutos, ativo, tipos_sinais_id) VALUES ('Limpeza de Pele', 150.00, 60, TRUE, 1);
INSERT INTO pacotes (nome, total_sessoes, preco_total, validade_dias, ativo, servicos_id, criado_em) VALUES ('Combo Verão 5x Limpeza', 5, 600.00, 90, TRUE, 1, NOW());

-- 4. Cadastrando um Cliente e sua Anamnese (Link para o PDF)
INSERT INTO usuarios (email, senha, perfil_id, criado_em) VALUES ('cliente.joana@email.com', 'hash456', 3, NOW());
INSERT INTO clientes (nome, telefone, usuario_id, criado_em) VALUES ('Joana Santos', '11999999999', 2, NOW());
INSERT INTO anamneses (informacao, arquivo_url) VALUES ('Ficha Inicial Joana', 'https://storage.studiomany.com/fichas/joana_anamnese.pdf');
INSERT INTO anamnese_clientes (anamneses_id, clientes_id) VALUES (1, 1);

-- 5. Fluxo de Agendamento (O "Carrinho")
-- Primeiro criamos o cabeçalho do agendamento
INSERT INTO agendamentos (inicio, fim, cliente_id, status_agendamento_id, criado_em) 
VALUES ('2023-10-25 14:00:00', '2023-10-25 15:00:00', 1, 1, NOW());

-- Depois inserimos o item (serviço) dentro desse agendamento
INSERT INTO agendamento_itens (agendamento_id, servico_id, profissional_id, preco, preco_final) 
VALUES (1, 1, 1, 150.00, 150.00);

-- 6. Registro de Pagamento
INSERT INTO pagamentos (valor, pago_em, agendamento_id, status_pagamento_id) 
VALUES (150.00, NOW(), 1, 2);
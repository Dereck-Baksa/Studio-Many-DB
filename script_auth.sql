create database if not exists newauth;
use newauth;

create table if not exists perfis(
	id int not null primary key auto_increment,
    nome varchar(75) not null
);

create table if not exists usuarios(
	id int not null primary key auto_increment,
    nome varchar(100) not null,
    email varchar(255) not null,
    senha varchar(255) not null,
    
	perfil_id int not null,
    
    foreign key (perfil_id) references perfis(id)
);

create table if not exists agendamentos(
	id int not null primary key auto_increment,
    data_hora datetime not null,
    servico varchar(45) not null,
    valor double not null,
    
    cliente_id int not null,
    funcionario_id int not null,
    
    foreign key (cliente_id) references usuarios(id),
    foreign key (funcionario_id) references usuarios(id)
);

insert into perfis(nome) values
("ROLE_ADMIN"), -- 1
("ROLE_FUNCIONARIO"), -- 2
("ROLE_RECEPCIONISTA"), -- 3
("ROLE_CLIENTE"); -- 4
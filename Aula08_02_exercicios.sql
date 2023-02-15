--Exercicio 1.2.3
create table correntista(
cpf integer not null,
nome varchar(40),
data_nasc date,
cidade varchar(30),
uf varchar(2),
constraint pk_cpf primary key (cpf),
constraint ck_idade check(cast((current_date - data_nasc)/365 as integer) >=18)
);

create table conta_corrente(
num_conta integer,
saldo integer,
cpf integer,
constraint pk_num_conta primary key (num_conta),
constraint fk_cpf_conta foreign key (cpf) references correntista,
constraint ck_saldo check(saldo >= 500)
);

--Inserções
insert into correntista values ('123', 'joao', '30/12/2000','Votuporanga', 'SP');
insert into conta_corrente values (2,'321', 5000);

insert into correntista values ('321', 'carlos', '01/10/2015','Cosmorama', 'SP');
insert into conta_corrente values (1,'123', 40);

insert into correntista values ('321', 'marta', '11/12/1999','São Paulo', 'SP');
insert into conta_corrente values (3,'456', 500);

--1.3.1 Modelo Relacional para uso de Sequências

--Exercicio 1.3.4
create sequence sid_func;

insert into seq_funcionario values(nextval('sid_func') ,'123456789','Zé','Ruazinha','Mirasol',8521);













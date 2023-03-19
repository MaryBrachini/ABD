--1.6 Exemplo1
create or replace function f_InsereFuncionario (cpfPar varchar, nomePar varchar, enderecoPar varchar, cidadePar varchar, salarioPar numeric)
returns Integer AS
$$
Declare
resultado integer;
Begin
insert into seq_funcionario (id_func, cpf, nome, ender, cidade, salario)
values (nextval('sid_func'), cpfPar, nomePar, enderecoPar, cidadePar, salarioPar)
RETURNING id_func INTO resultado;
return resultado;
end;
$$
language plpgsql;

drop function f_InsereFuncionario;

select f_InsereFuncionario ('5221', 'Paulo Afonso', 'Rua das Acácias', 'Votuporanga', 9811);

--1.7.3.1 Exemplo1
create or replace function f_verifica_horario() returns trigger as
$$
begin
IF extract (hour from current_time) NOT BETWEEN 10 AND 15 THEN
raise 'Operação não pode ser executada fora do horário bancário' 
using ERRCODE = 'EHO01';
end if;

if new.numero_con = 'xxx' then 
raise 'Operação não pode ser executada com o valor xxx' 
using errcode = 'EHO02';
end if;

return new;
end;
$$
language plpgsql;

create trigger trg_verifica_horario
before insert or update or delete
on conta for each row
execute procedure f_verifica_horario();

insert into conta values (3,'A-120',600);
insert into conta (cod_age_con, numero_con, saldo_con) values (3,'xxx',600);

--Exemplo 2: Uma prática comum utilizada no processo de auditoria de sistemas é o registro das
--alterações realizadas nos salários dos funcionários. Dependendo do caso, é importante realizar o registro periódico de cada aumento ocorrido na remuneração de um empregado. Abaixo, segue o código
--de um trigger para registrar as alterações ocorridas na tabela de salário dos funcionários:

--1) Inicialmente, cria-se as sequências sid_func para registro na tabela seq_funcionario e a sequencia sid_salreg para a tabela seq_salario_registro:
create sequence sid_func;
create sequence sid_salreg;

--2) Criação da função do trigger que implementa a regra de negócio
create or replace function f_salario_registro() returns trigger
as
$$
begin
insert into seq_salario_registro
values (nextval('sid_salreg'), new.id_func, new.salario,current_date);
return null;
end;
$$ 
language plpgsql;

--3) Criação do trigger
create trigger tr_salario_registro
after insert or update
on seq_funcionario for each row
execute procedure f_salario_registro();

insert into seq_funcionario (id_func, cpf,nome,ender,cidade,salario)
values (20, '321', 'Pedro da Silva', 'Rua A', 'Votuporanga', 4000);

update seq_funcionario set salario = 6000 where id_func = 20;

select * from seq_salario_registro;


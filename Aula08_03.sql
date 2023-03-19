--1.6.1
create or replace function f_olamundo() returns text as
$$
begin
return 'Olá Mundo!'; -- Função que mostra a frase Olá Mundo!;
end;
$$
language PLPGSQL; --Para executar: select f_olamundo();

--1.6.2
CREATE OR REPLACE FUNCTION f_substringPorNome(nomePar varchar, posicaoInicialPar integer) RETURNS varchar
AS
$$-- Sinaliza que dentro dos sifroes e uma linguagem especifica, informando qual apos fechar a tag
BEGIN
RETURN substring(nomePar,posicaoInicialPar);
END;
$$ 
LANGUAGE plpgsql;-- informa a linguagem do codigo que esta dentro dos sifroes

select f_substringPorNome('Borodin', 2);

--1.6.3
CREATE OR REPLACE FUNCTION f_SomaTresPar(Valor1 numeric, Valor2 integer, Valor3 Numeric) RETURNS numeric
AS
$$
DECLARE
Resultado numeric;
BEGIN
resultado = Valor1+Valor2+Valor3;
RETURN resultado;
END;
$$
LANGUAGE plpgsql;

select f_SomaTresPar(2.2,4,6.3);

--1.6.4
create or replace function f_definicao (sexo char) returns text
as
$$
begin
if (sexo='M' or sexo='m') then
return 'Masculino';
elsif (sexo='F' or sexo='f') then
return 'Feminino';
else
return 'Indefinido';
end if;
end;
$$
language plpgsql;

select f_definicao('M');

--1.6.5
--Ex1
CREATE OR REPLACE FUNCTION f_SomaSelect (num1 numeric, num2 numeric) RETURNS
numeric
AS
$$
DECLARE retval numeric;
BEGIN
SELECT num1 + num2 INTO retval;
RETURN retval;
END;
$$
LANGUAGE plpgsql;

--Ex2
CREATE OR REPLACE FUNCTION f_Nome_Endereco (codcliente integer) RETURNS text
AS
$$
DECLARE nomecli varchar;
enderecocli varchar;
BEGIN
SELECT nome_cliente, endereco INTO nomecli, enderecocli
FROM cliente
WHERE codigo_cliente = codcliente;
RETURN nomecli || ' - ' || enderecocli ;
END;
$$
LANGUAGE plpgsql;

select f_Nome_Endereco (720);

--1.6.6 Exercicio
--Ex1 Implemente um procedimento que receba 4 parâmetros. Os dois primeiros serão números que sofrerão uma
--das quatro operações básicas da matemática adição, subtração, multiplicação e divisão; o terceiro parâmetro
--será uma variável que armazenará o resultado da operação e por fim, o quarto parâmetro indicará qual será
--a operação realizada. Após implementar, teste o procedimento e veja se está funcionando corretamente.
CREATE OR REPLACE FUNCTION f_procedimento (op varchar,num1 integer,num2 integer) RETURNS integer
AS
$$
DECLARE resul integer;
begin
if (op='soma') then
resul = num1 + num2;
return resul;
elsif (op='subtracao') then
resul = num1 - num2;
return resul;
elsif (op='multiplicacao') then
resul = num1 * num2;
return resul;
else
resul = num1 / num2;
return resul;
end if;
end;
$$
language plpgsql;

select f_procedimento('soma',4,24);

--Ex2 Projete uma função que informado o código do cliente por parâmetro, encontre o valor total das compras
--desse cliente. Como retorno, a função deve informar o nome do cliente concatenado com o valor da compra.
--Você deverá usar as tabelas cliente, pedido, item_pedido e produto

CREATE OR REPLACE FUNCTION f_Nome_valor (codcliPar integer) RETURNS text
AS
$$
DECLARE nome_clienteRetorno cliente.nome_cliente;
Valor_TotalRetorno numeric;

BEGIN
SELECT cliente.nome_cliente SUM() INTO nomecliPar FROM cliente WHERE codigo_cliente = codcliPar;
END;
$$
LANGUAGE plpgsql;

select f_Nome_valor(720);

--Página 38
Declare
  nome_clienteRetorno cliente.nome_cliente%type;
  Valor_TotalRetorno numeric;

begin
  select cliente.nome_cliente, 
         SUM(produto.valor_venda * item_pedido.quantidade) "Valor Total" 
         INTO nome_clienteRetorno, Valor_TotalRetorno 
  FROM 
         public.cliente, public.pedido, public.produto, public.item_pedido
  WHERE 
         cliente.codigo_cliente = pedido.codigo_cliente AND
         pedido.num_pedido = item_pedido.num_pedido AND
         item_pedido.codigo_produto = produto.codigo_produto AND
         cliente.codigo_cliente = codigo_clientePar
  GROUP BY cliente.nome_cliente;

  RETURN nome_clienteRetorno || ': ' || Valor_TotalRetorno;
end;
$$
language plpgsql;
uso: select f_TotalCliente(720);








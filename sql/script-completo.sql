-- HUGO GABRIEL SILVA MENDES E RAÍ CÉSAR GOMES DA SILVA 4°ADS MATUTINO

-- BANCO DE DADOS
create database if not exists db_multi_empresa;
use db_multi_empresa;

-- ENDEREÇO
create table if not exists endereco (
    id int primary key auto_increment,
    cep varchar(9) not null,
    estado_sigla varchar(2) not null,
    cidade varchar(40) not null,
    rua varchar(40) not null,
    numero int(6) not null
);

-- EMPRESA
create table if not exists empresa (
    id int primary key auto_increment,
    nome varchar(50) not null,
    cnpj varchar(20) not null unique,
    telefone varchar(15) not null,
    endereco_id int not null,
    foreign key (endereco_id)
        references endereco (id)
);

-- CARGO
create table if not exists cargo (
    id int primary key auto_increment,
    nome varchar(50) not null
);

-- DEPARTAMENTO
create table if not exists departamento (
    id int primary key auto_increment,
    nome varchar(50) not null unique
);

-- USUÁRIO
create table if not exists usuario (
    id int primary key auto_increment,
    nome varchar(50) not null,
    email varchar(80) not null unique,
    senha varchar(50) not null,
    telefone varchar(15) not null,
    endereco_id int not null,
    empresa_id int not null,
    cargo_id int not null,
    departamento_id int not null,
    foreign key (endereco_id)
        references endereco (id),
    foreign key (empresa_id)
        references empresa (id),
    foreign key (cargo_id)
        references cargo (id),
    foreign key (departamento_id)
        references departamento (id)
);

-- FORNECEDOR
create table if not exists fornecedor (
    id int primary key auto_increment,
    nome varchar(50) not null,
    cnpj varchar(20) not null unique,
    telefone varchar(15) not null,
    endereco_id int not null,
    empresa_id int not null,
    condicao enum('bloqueado', 'normal') not null,
    foreign key (endereco_id)
        references endereco (id),
    foreign key (empresa_id)
        references empresa (id)
);

-- TIPO DE CONTRATO
create table if not exists tipo_contrato (
    id int primary key auto_increment,
    nome varchar(50) not null,
    descricao varchar(60) not null
);

-- CLIENTE
create table if not exists cliente (
    id int primary key auto_increment,
    nome varchar(50) not null,
    cpf varchar(14) not null unique,
    telefone varchar(15) not null,
    endereco_id int not null,
    empresa_id int not null,
    tipo_contrato_id int not null,
    dia_pagamento int(2) not null,
    condicao enum('bloqueado', 'normal') not null,
    foreign key (endereco_id)
        references endereco (id),
    foreign key (empresa_id)
        references empresa (id),
    foreign key (tipo_contrato_id)
        references tipo_contrato (id)
);

-- BANCO
create table if not exists banco (
    id int primary key auto_increment,
    nome varchar(50) not null,
    cnpj varchar(20) not null unique
);

-- CONTA BANCÁRIA
create table if not exists conta_bancaria (
    id int primary key auto_increment,
    banco_id int not null,
    numero varchar(12) not null,
    agencia varchar(5) not null,
    digito varchar(2) not null,
    empresa_id int not null,
    foreign key (banco_id)
        references banco (id),
    foreign key (empresa_id)
        references empresa (id)
);

-- CENTRO DE CUSTO
create table if not exists centro_custo (
    id int primary key auto_increment,
    nome varchar(50) not null,
    tipo enum('pagar', 'receber') not null,
    departamento_id int not null,
    empresa_id int not null,
    foreign key (departamento_id)
        references departamento (id),
    foreign key (empresa_id)
        references empresa (id)
);

-- CONTA FINANCEIRA
create table if not exists conta_financeira (
    id int primary key auto_increment,
    tipo enum('pagar', 'receber') not null,
    descricao varchar(100) not null,
    valor decimal(10, 2) not null,
    data_emissao date not null,
    data_vencimento date not null,
    data_pagamento date null,
    condicao enum('pendente', 'pago', 'atrasado', 'cancelado') not null default 'pendente',
    centro_custo_id int not null,
    cliente_id int null,
    fornecedor_id int null,
    empresa_id int not null,
    foreign key (centro_custo_id) 
        references centro_custo (id),
    foreign key (cliente_id) 
        references cliente (id),
    foreign key (fornecedor_id) 
        references fornecedor (id),
    foreign key (empresa_id)
        references empresa (id)
);

-- BOLETO EMITIDO
create table if not exists boleto_emitido (
    id int primary key auto_increment,
    conta_financeira_id int not null,
    codigo_barras varchar(60) not null,
    linha_digitavel varchar(80) not null,
    foreign key (conta_financeira_id)
        references conta_financeira (id)
);

-- LANÇAMENTO DE CHEQUE
create table if not exists lancamento_cheque (
    id int primary key auto_increment,
    conta_financeira_id int not null,
    conta_bancaria_id int not null,
    numero_cheque varchar(20) not null,
    data_compensacao date null,
    foreign key (conta_financeira_id)
        references conta_financeira(id),
    foreign key (conta_bancaria_id)
        references conta_bancaria(id)
);
 
 
-- STORED PROCEDURES

-- INSERIR CONTAS A PAGAR
DELIMITER //
create procedure inserir_contas_pagar(in descricao varchar(100), in valor decimal(10,2), in data_emissao date, in data_vencimento date, 
in centro_custo_id int, in cliente_id int, in fornecedor_id int, in empresa_id int)
begin 
	insert into conta_financeira(tipo, descricao, valor, data_emissao, data_vencimento, data_pagamento, centro_custo_id, cliente_id, 
	fornecedor_id, empresa_id) values ('pagar', descricao, valor, data_emissao, data_vencimento, NULL, centro_custo_id, cliente_id, 
	fornecedor_id, empresa_id);
end //
DELIMITER ;

-- INSERIR CONTAS A RECEBER
DELIMITER //
create procedure inserir_contas_receber(in descricao varchar(100), in valor decimal(10,2), in data_emissao date, in data_vencimento date, 
in centro_custo_id int, in cliente_id int, in fornecedor_id int, in empresa_id int)
begin 
	insert into conta_financeira(tipo, descricao, valor, data_emissao, data_vencimento, data_pagamento, centro_custo_id, cliente_id, 
	fornecedor_id, empresa_id) values ('receber', descricao, valor, data_emissao, data_vencimento, NULL, centro_custo_id, cliente_id, 
	fornecedor_id, empresa_id);
end //
DELIMITER ;

-- CLIENTES CONTAS ATRASADAS
DELIMITER //
create procedure clientes_contas_atrasadas ()
begin
    select c.nome, c.cpf, c.telefone, cf.tipo, cf.valor, cf.condicao from conta_financeira as cf
    inner join cliente as c on c.id = cf.cliente_id
    where cf.condicao = 'atrasado';
end //
DELIMITER ;

-- VALOR MOVIMENTADO EM UM PERÍODO
DELIMITER //
create procedure valor_movimentado_periodo(in data_minima date, in data_maxima date)
begin
	select sum(valor) as valor_movimentado from conta_financeira as cf
	where cf.condicao = 'pago' and cf.data_emissao between data_minima and data_maxima;  
end //
DELIMITER ;

-- VIEW PARA EXIBIR LISTA DE CLIENTES GERAL
create view clientes_geral as select * from cliente;


-- INSERTS (SEED)
insert into endereco (cep, estado_sigla, cidade, rua, numero) values
('01001-000', 'SP', 'São Paulo', 'Av. Paulista', 1000),
('20040-020', 'RJ', 'Rio de Janeiro', 'Rua das Laranjeiras', 250),
('30130-010', 'MG', 'Belo Horizonte', 'Av. Afonso Pena', 900),
('40010-000', 'BA', 'Salvador', 'Rua Chile', 150),
('70040-010', 'DF', 'Brasília', 'Esplanada dos Ministérios', 1);


insert into empresa (nome, cnpj, telefone, endereco_id) values
('TechFinance LTDA', '12.345.678/0001-90', '(11) 99999-0001', 1),
('BlueBank SA', '98.765.432/0001-10', '(21) 98888-0002', 2),
('DataCorp Solutions', '45.123.789/0001-22', '(31) 97777-0003', 3),
('Nordic Systems', '67.890.123/0001-44', '(71) 96666-0004', 4),
('PrimeTech Holdings', '11.222.333/0001-55', '(61) 95555-0005', 5);


insert into cargo (nome) values
('Analista Financeiro'),
('Desenvolvedor Back-End'),
('Gerente de Projetos'),
('Contador'),
('Diretor Executivo');


insert into departamento (nome) values
('Financeiro'),
('Tecnologia'),
('Recursos Humanos'),
('Marketing'),
('Operações');


insert into usuario (nome, email, senha, telefone, endereco_id, empresa_id, cargo_id, departamento_id) values
('Lucas Almeida', 'lucas@techfinance.com', '123456', '(11) 90000-1111', 1, 1, 2, 2),
('Maria Silva', 'maria@bluebank.com', '123456', '(21) 90000-2222', 2, 2, 1, 1),
('João Costa', 'joao@datacorp.com', '123456', '(31) 90000-3333', 3, 3, 3, 1),
('Ana Souza', 'ana@nordic.com', '123456', '(71) 90000-4444', 4, 4, 4, 3),
('Pedro Lima', 'pedro@primetech.com', '123456', '(61) 90000-5555', 5, 5, 5, 4);


insert into fornecedor (nome, cnpj, telefone, endereco_id, empresa_id, condicao) values
('ABC Suprimentos', '55.111.222/0001-10', '(11) 88888-1111', 1, 1, 'normal'),
('GlobalTech', '66.222.333/0001-20', '(21) 88888-2222', 2, 2, 'bloqueado'),
('OfficeMax', '77.333.444/0001-30', '(31) 88888-3333', 3, 3, 'normal'),
('SoftLine', '88.444.555/0001-40', '(71) 88888-4444', 4, 4, 'normal'),
('PrimeHardware', '99.555.666/0001-50', '(61) 88888-5555', 5, 5, 'normal');


insert into tipo_contrato (nome, descricao) values
('Mensal', 'Cobrança mensal por serviços'),
('Anual', 'Plano anual com desconto'),
('Por Projeto', 'Cobrança por projeto'),
('Consultoria', 'Serviços de consultoria sob demanda'),
('Manutenção', 'Contrato de suporte e manutenção');


insert into cliente (nome, cpf, telefone, endereco_id, empresa_id, tipo_contrato_id, dia_pagamento, condicao) values
('Carlos Andrade', '123.456.789-00', '(11) 91111-1111', 1, 1, 1, 10, 'normal'),
('Fernanda Torres', '234.567.890-11', '(21) 92222-2222', 2, 2, 2, 15, 'bloqueado'),
('Rodrigo Melo', '345.678.901-22', '(31) 93333-3333', 3, 3, 3, 20, 'normal'),
('Juliana Ramos', '456.789.012-33', '(71) 94444-4444', 4, 4, 4, 25, 'normal'),
('Eduardo Pires', '567.890.123-44', '(61) 95555-5555', 5, 5, 5, 5, 'normal');


insert into banco (nome, cnpj) values
('Banco do Brasil', '00.000.000/0001-91'),
('Itaú Unibanco', '60.701.190/0001-04'),
('Bradesco', '60.746.948/0001-12'),
('Caixa Econômica Federal', '00.360.305/0001-04'),
('Santander', '90.400.888/0001-42');


insert into conta_bancaria (banco_id, numero, agencia, digito, empresa_id) values
(1, '123456', '1001', '1', 1),
(2, '654321', '2002', '2', 2),
(3, '789012', '3003', '3', 3),
(4, '345678', '4004', '4', 4),
(5, '901234', '5005', '5', 5);


insert into centro_custo (nome, tipo, departamento_id, empresa_id) values
('Serviços Gerais', 'pagar', 1, 1),
('Vendas Internas', 'receber', 2, 2),
('Infraestrutura', 'pagar', 3, 3),
('Desenvolvimento', 'receber', 4, 4),
('RH e Benefícios', 'pagar', 5, 5);


insert into conta_financeira (tipo, descricao, valor, data_emissao, data_vencimento, data_pagamento, condicao, centro_custo_id, 
cliente_id, fornecedor_id, empresa_id) values
('pagar', 'Compra de equipamentos', 12000, '2025-10-01', '2025-10-10', NULL, 'pendente', 1, 5, 1, 1),
('receber', 'Venda de software', 3000, '2025-09-20', '2025-10-20', NULL, 'atrasado', 2, 1, 1, 2),
('pagar', 'Serviços de manutenção', 5000, '2025-10-05', '2025-10-25', NULL, 'pendente', 3, 3, 2, 3),
('receber', 'Consultoria financeira', 15000, '2025-09-01', '2025-09-30', '2025-09-28', 'pago', 4, 2, 2, 4),
('pagar', 'Licença de software', 8000, '2025-09-10', '2025-09-25', NULL, 'atrasado', 5, 4, 3, 5);


insert into boleto_emitido (conta_financeira_id, codigo_barras, linha_digitavel) values
(2, '23793381286000000001560000012345678901234567', '23791.23456 78901.234567 89012.345678 1 23450000012345'),
(4, '10490000090300000001234560000078901234567890', '10491.23456 78901.234567 89012.345678 9 01230000056789'),
(1, '34191790080000010001234560007890123456789012', '34191.23456 78901.234567 89012.345678 0 00010000012345'),
(3, '03399123456000000007890123456789012345678901', '03399.12345 67890.123456 78901.234567 8 00000000089012'),
(5, '00193381286000000001560000012345678901234567', '00191.23456 78901.234567 89012.345678 1 23450000012345');

insert into lancamento_cheque (conta_financeira_id, conta_bancaria_id, numero_cheque, data_compensacao) values
(1, 1, '000111', '2025-10-11'),
(3, 3, '000222', '2025-10-26'),
(5, 5, '000333', NULL),
(2, 2, '000444', NULL),
(4, 4, '000555', '2025-09-28');


-- VISUALIZAÇÂO DAS TABELAS
select * from endereco;
select * from empresa;
select * from cargo;
select * from departamento;
select * from usuario;
select * from fornecedor;
select * from tipo_contrato;
select * from clientes_geral; -- USANDO A VIEW CRIADA PARA EXIBIR OS CLIENTES
select * from banco;
select * from conta_bancaria;
select * from centro_custo;
select * from lancamento_cheque;
select * from boleto_emitido;
select * from conta_financeira;

-- TESTANDO AS STORED PROCEDURES
call inserir_contas_pagar('Pacote Office', 1200, '2025-11-07', '2026-09-25', 5, 4, 3, 5);
call inserir_contas_receber('Web Scraping', 1500, '2025-10-07', '2025-11-25', 1, 2, 3, 2);
call clientes_contas_atrasadas();
call valor_movimentado_periodo('2025-09-01', '2025-11-07');





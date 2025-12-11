# :bar_chart: Sistema Financeiro - Banco de Dados Multi-Empresas (MySQL)

Este projeto apresenta a criação completa do banco de dados multi_empresas, incluindo todas as tabelas, relacionamentos, seeds (inserções de dados), stored procedures e uma view.
Trata-se de um modelo acadêmico de um sistema financeiro de contas a pagar e a receber, projetado para representar fielmente a estrutura real de um ambiente multi-empresas. 

## :round_pushpin: Contexto

Projeto desenvolvido como atividade prática da disciplina Banco de Dados, ministrada na Fatec Franca – Dr. Thomaz Novelino.

O objetivo era modelar e implementar um banco consistente, completo e funcional, seguindo o enunciado fornecido pelo professor.

## :pencil: Enunciado(Resumo)

O sistema deve contemplar:
- Multi-empresas.
- Multi-usuários.
- Cadastros: contas a pagar, contas a receber, clientes, fornecedores, bancos, contas bancárias.
- Lançamento de cheques (pagar/receber).
- Lançamento de boletos (pagar/receber).
- Lançamento de cheques emitidos (pagar).
- Relatórios financeiros (pagas, recebidas, atrasadas).
- Clientes com bloqueio de crédito.
- Cadastro de tipos de contas e formas de pagamento.
- Clientes com telefone e endereço.
- Criação de todas as tabelas com PK/FK, incluindo pelo menos 5 inserts por tabela.
- 2 stored procedures: inserir contas a pagar e receber.
- 1 stored procedure: listar clientes com contas atrasadas.
- 1 stored procedure: retornar valor movimentado em um período.
- 1 view com a lista geral de clientes.

## :white_check_mark: O que foi feito

Antes da implementação, foi realizada uma análise dos requisitos para ajusar entidades e atributos à realidade de um sistema financeiro.

**Foram desenvolvidos:**

- Banco de dados completo (MySQL).
- Todas as tabelas com chaves primárias e estrangeiras.
- Seeds com mínimo de 5 inserts por tabela.
- Stores Procedures:
    - inserir_contas_pagar.
    - inserir_contas_receber.
    - clientes_contas_atrasadas.
    - valor_movimentado_periodo.
- View:
    - clientes_geral.
- Modelo fisico simplificado no LucidChart.

## :hammer_and_wrench: Tecnologias utilizadas

- MySQL 8+.
- MySQL Workbench (modelagem e script).
- LucidChart.

## :arrow_forward: Como rodar

1. Instale MySQL 8+.
2. Abra o arquivo "**script-completo.sql**" no MySQL Workbench.
3. Execute o script completo.
4. As tabelas, seeds, procedures e view serão criadas automaticamente.
5. Rode os comandos de teste ao final do script para validar o funcionamento.

## :busts_in_silhouette: Colaboradores

Este projeto foi desenvolvido em dupla:

**Rai César Gomes da Silva**
- Diagrama DER.
- Criação do banco e das tabelas.
- Procedures:
    - inserir_contas_pagar.
    - inserir_contas_receber.
- View: clientes_geral.

**Hugo Gabriel Silva Mendes**
- Seeds (inserções de dados).
- Comandos SELECT para validação.
- Procedures:
    - clientes_contas_atrasadas.
    - valor_movimentado_periodo.
- Testes gerais.

## :bulb: Melhorias Futuras

- Implementar triggers de auditoria.
- Validar regras de negócio com constraints avançadas.
- Criar stored procedures mais completas (relatórios detalhados).
- Criar versão adaptada para PostgreSQL.
- Criar tabela de endereço nichada para cada entidade conforme necessário.
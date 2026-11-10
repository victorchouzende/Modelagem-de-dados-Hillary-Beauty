# Banco lógico --- Hillary Beauty (PostgreSQL / Supabase)

Este diretório contém os scripts SQL do modelo lógico da Hillary Beauty
e as instruções para executá-los no Supabase ou em uma instalação
PostgreSQL compatível.

## Conteúdo do diretório

  -----------------------------------------------------------------------
  Arquivo                             Finalidade
  ----------------------------------- -----------------------------------
  `01_schema.sql`                     Criação das tabelas, PKs, FKs,
                                      constraints, índices, triggers, log
                                      de auditoria, views e configuração
                                      de RLS.

  `02_seed_dados.sql`                 Carga de dados fictícios para
                                      demonstração dos fluxos.

  `03_consultas.sql`                  Consultas de conferência,
                                      histórico, estoque, comissão e
                                      demais exemplos documentados.

  `04_testes_regras.sql`              Testes das regras de negócio e das
                                      operações que devem ser recusadas
                                      pelo banco.

  `manutencao/limpar_dados.sql`       Limpa os dados de demonstração,
                                      preservando a estrutura.

  `manutencao/apagar_tudo.sql`        Remove a estrutura e os dados do
                                      banco; utilizar somente quando a
                                      intenção for reconstruir o
                                      ambiente.

  `prints/`                           Evidências visuais do ambiente e
                                      das tabelas, quando disponíveis.
  -----------------------------------------------------------------------

## Correspondência com o roteiro da Entrega 2

  -----------------------------------------------------------------------
  Etapa                               Onde está
  ----------------------------------- -----------------------------------
  1\. `CREATE DATABASE`               No Supabase, o banco é criado junto
                                      com o projeto (**New project**). O
                                      script não cria um segundo banco.
                                      Em PostgreSQL próprio, crie
                                      previamente um banco vazio,
                                      conecte-se a ele e execute os
                                      arquivos.

  2 e 3. `CREATE TABLE` e constraints `01_schema.sql`.
  (`PK`, `FK`, `NOT NULL`, `UNIQUE`,  
  `CHECK`, `EXCLUDE`)                 

  4\. `INSERT INTO` e massa de dados  `02_seed_dados.sql`.

  5\. `SELECT` com `JOIN`             `03_consultas.sql` e as consultas
                                      gerenciais deste README.

  6\. `UPDATE`                        Exemplos na seção "UPDATE e
                                      DELETE"; o seed também atualiza
                                      estados de agendamento para
                                      percorrer as regras.

  7\. `DELETE`                        Exemplos na seção "UPDATE e
                                      DELETE".

  8\. Consultas gerenciais            Seção "Consultas gerenciais" e
                                      views criadas no schema.

  9\. Consultas de auditoria          Seção "Consultas de auditoria",
                                      consultas de log em
                                      `03_consultas.sql` e testes em
                                      `04_testes_regras.sql`.
  -----------------------------------------------------------------------

## Pré-requisitos

-   Projeto Supabase criado ou instância PostgreSQL compatível.
-   Acesso ao **SQL Editor** do Supabase com permissão para executar DDL
    e DML.
-   Arquivos deste diretório disponíveis localmente.
-   Ambiente de demonstração vazio, preferencialmente criado
    exclusivamente para este trabalho.

> **Atenção:** `manutencao/apagar_tudo.sql` é destrutivo. Não execute em
> ambiente com dados que devam ser preservados.

## Execução no Supabase

1.  Acesse o projeto no Supabase.
2.  Abra **SQL Editor** e crie uma nova consulta.
3.  Abra `01_schema.sql`, copie seu conteúdo integral para o editor e
    execute.
4.  Após a criação da estrutura, execute `02_seed_dados.sql`.
5.  Execute as consultas de `03_consultas.sql` individualmente para
    conferir os resultados.
6.  Execute `04_testes_regras.sql` conforme as instruções e comentários
    existentes no próprio arquivo.
7.  Consulte o **Table Editor** e o **Schema Visualizer** para
    visualizar as tabelas e os relacionamentos.

O SQL Editor pode exibir apenas o resultado da última instrução
selecionada em uma execução com várias consultas. Para conferir
resultados distintos, selecione e execute cada `SELECT` separadamente.

## Massa de dados

A carga é demonstrativa e utiliza dados fictícios. O volume documentado
para o seed é:

  -----------------------------------------------------------------------------
  Tabela                        Registros               Observação
  ----------------------------- ----------------------- -----------------------
  `cliente`                     25                      Dois cadastros são
                                                        inativados ao final da
                                                        carga, preservando o
                                                        histórico.

  `profissional`                6                       Cinco profissionais e
                                                        uma recepcionista.

  `categoria_profissional`      3                       Categorias e
                                                        percentuais fictícios.

  `procedimento`                22                      Procedimentos do
                                                        levantamento e valores
                                                        de referência.

  `profissional_procedimento`   24                      Relações de
                                                        habilitação.

  `agendamento`                 30                      18 realizados, 4
                                                        confirmados, 3
                                                        aguardando sinal, 3
                                                        cancelados e 2 não
                                                        comparecimentos.

  `pagamento`                   43                      Sinais e pagamentos
                                                        restantes.

  `atendimento`                 18                      Um para cada
                                                        agendamento realizado.

  `produto`                     12                      Esmaltes, EPIs e
                                                        descartáveis.

  `movimentacao_estoque`        87                      Entradas e saídas,
                                                        incluindo consumo
                                                        vinculado ou não a
                                                        atendimento.
  -----------------------------------------------------------------------------

Os registros de demonstração não representam a quantidade real de
clientes, atendimentos ou consumo da empresa. O volume foi escolhido
para exercitar estados e regras do modelo.

## Consultas gerenciais

Execute cada consulta separadamente, após o schema e o seed. Os
resultados indicados são referências para o seed original e podem mudar
se os dados forem alterados.

### G1. Faturamento recebido por mês

``` sql
select date_trunc('month', data_pagamento)::date as mes,
       sum(valor) filter (where tipo_pagamento = 'Sinal') as sinais,
       sum(valor) filter (where tipo_pagamento = 'Restante') as restantes,
       sum(valor) as total_recebido
  from pagamento
 group by 1
 order by 1;
```

Resultado esperado no seed: agosto/2026 = R\$ 659,00; setembro/2026 =
R\$ 506,00; outubro/2026 = R\$ 1.180,00; novembro/2026 = R\$ 2.652,00.
Total = R\$ 4.997,00.

### G2. Atendimentos, valor recebido e ticket médio

``` sql
select count(distinct a.id_atendimento) as atendimentos,
       sum(pg.valor) as valor_recebido,
       round(sum(pg.valor) / count(distinct a.id_atendimento), 2) as ticket_medio
  from atendimento a
  join pagamento pg on pg.id_agendamento = a.id_agendamento;
```

Resultado esperado: 18 atendimentos, R\$ 3.645,00 recebidos e ticket
médio de R\$ 202,50. O cálculo considera os pagamentos associados aos
atendimentos e deve ser interpretado conforme a definição adotada para
receita.

### G3. Agendamentos por status

``` sql
select status_agendamento,
       count(*) as quantidade,
       round(100.0 * count(*) / sum(count(*)) over (), 1) as percentual
  from agendamento
 group by status_agendamento
 order by quantidade desc;
```

Resultado esperado: 18 Realizado (60,0%), 4 Confirmado (13,3%), 3
Agendado (10,0%), 3 Cancelado (10,0%) e 2 Não Compareceu (6,7%).

### G4. Receita e atendimentos por procedimento

``` sql
select pr.nome as procedimento,
       count(distinct a.id_atendimento) as atendimentos,
       sum(pg.valor) as receita
  from atendimento a
  join procedimento pr on pr.id_procedimento = a.id_procedimento
  join pagamento pg on pg.id_agendamento = a.id_agendamento
 group by pr.id_procedimento, pr.nome
 order by receita desc, procedimento;
```

A consulta permite ordenar os procedimentos pela receita registrada no
período de demonstração.

### G5. Sinais associados a cancelamentos e não comparecimentos

``` sql
select a.status_agendamento,
       count(*) as agendamentos,
       sum(pg.valor) as sinais
  from agendamento a
  join pagamento pg on pg.id_agendamento = a.id_agendamento
                   and pg.tipo_pagamento = 'Sinal'
 where a.status_agendamento in ('Cancelado', 'Não Compareceu')
 group by a.status_agendamento
 order by a.status_agendamento;
```

No seed original, a consulta retorna um agendamento cancelado com R\$
28,00 de sinal e dois não comparecimentos com R\$ 152,00; total de R\$
180,00. Esse valor representa sinais associados a esses estados, não
comprovação de retenção: o banco não registra justificativa nem
devolução do sinal.

### G6. Frequência de atendimento por cliente

``` sql
select c.nome as cliente,
       count(*) as atendimentos,
       max(a.data_atendimento) as ultimo_atendimento
  from atendimento a
  join cliente c on c.id_cliente = a.id_cliente
 group by c.id_cliente, c.nome
 order by atendimentos desc, cliente
 limit 10;
```

No seed, Mariana Duarte aparece com três atendimentos; Ana Beatriz Moura
e Renata Barbosa aparecem com dois cada.

### G7. Consumo mensal por produto

``` sql
select p.nome as produto,
       date_trunc('month', m.data_movimentacao)::date as mes,
       sum(m.quantidade) as consumo
  from movimentacao_estoque m
  join produto p on p.id_produto = m.id_produto
 where m.tipo_movimentacao = 'Saída'
 group by p.id_produto, p.nome, date_trunc('month', m.data_movimentacao)
 order by produto, mes;
```

### Views gerenciais existentes

  ------------------------------------------------------------------------
  View                                 Finalidade
  ------------------------------------ -----------------------------------
  `vw_estoque_baixo`                   Produtos com quantidade igual ou
                                       abaixo do estoque mínimo.

  `vw_atendimentos_por_profissional`   Atendimentos por profissional e
                                       mês.

  `vw_atendimentos_por_procedimento`   Atendimentos por procedimento e
                                       mês.

  `vw_historico_cliente`               Histórico de atendimentos por
                                       cliente.

  `vw_comissao_profissional`           Comissão calculada por profissional
                                       e mês.
  ------------------------------------------------------------------------

## Consultas de auditoria

As consultas a seguir procuram inconsistências. Para o seed original, as
consultas de detecção devem retornar zero linhas, salvo A0, que
apresenta um resumo.

### A0. Resumo do log por tabela e operação

``` sql
select tabela, operacao, count(*) as eventos
  from log_auditoria
 group by tabela, operacao
 order by tabela, operacao;
```

### A1. Agendamento realizado sem atendimento

``` sql
select a.id_agendamento, a.data_agendamento, a.status_agendamento
  from agendamento a
  left join atendimento t on t.id_agendamento = a.id_agendamento
 where a.status_agendamento = 'Realizado'
   and t.id_atendimento is null;
```

### A2. Agendamento confirmado ou realizado sem sinal

``` sql
select a.id_agendamento, a.data_agendamento, a.status_agendamento
  from agendamento a
 where a.status_agendamento in ('Confirmado', 'Realizado')
   and not exists (
       select 1
         from pagamento p
        where p.id_agendamento = a.id_agendamento
          and p.tipo_pagamento = 'Sinal'
   );
```

### A3. Saldo diferente da soma das movimentações

``` sql
select p.id_produto, p.nome, p.quantidade_atual,
       coalesce(sum(case when m.tipo_movimentacao = 'Entrada'
                         then m.quantidade else -m.quantidade end), 0) as saldo_calculado
  from produto p
  left join movimentacao_estoque m on m.id_produto = p.id_produto
 group by p.id_produto, p.nome, p.quantidade_atual
having p.quantidade_atual <>
       coalesce(sum(case when m.tipo_movimentacao = 'Entrada'
                         then m.quantidade else -m.quantidade end), 0);
```

### A4. Atendimento por profissional sem habilitação

``` sql
select t.id_atendimento, t.id_profissional, t.id_procedimento, t.data_atendimento
  from atendimento t
  left join profissional_procedimento h
    on h.id_profissional = t.id_profissional
   and h.id_procedimento = t.id_procedimento
 where h.id_profissional is null;
```

### A5. Procedimento ativo sem profissional habilitada

``` sql
select pr.id_procedimento, pr.nome
  from procedimento pr
 where pr.status_procedimento = 'Ativo'
   and not exists (
       select 1 from profissional_procedimento h
        where h.id_procedimento = pr.id_procedimento
   );
```

### A6. Sinal diferente de 40% do valor de referência

``` sql
select a.id_agendamento, pr.nome as procedimento,
       pr.valor as valor_referencia, pg.valor as sinal_pago,
       round(pr.valor * 0.40, 2) as sinal_esperado
  from pagamento pg
  join agendamento a on a.id_agendamento = pg.id_agendamento
  join procedimento pr on pr.id_procedimento = a.id_procedimento
 where pg.tipo_pagamento = 'Sinal'
   and pg.valor <> round(pr.valor * 0.40, 2);
```

A consulta é uma verificação indicativa: procedimentos com preço
variável podem ter valor efetivo diferente do valor de referência.

### A7. Total pago diferente do valor de referência

``` sql
select a.id_agendamento, pr.nome as procedimento,
       pr.valor as valor_referencia, sum(pg.valor) as total_pago
  from agendamento a
  join procedimento pr on pr.id_procedimento = a.id_procedimento
  join pagamento pg on pg.id_agendamento = a.id_agendamento
 where a.status_agendamento = 'Realizado'
 group by a.id_agendamento, pr.nome, pr.valor
having sum(pg.valor) <> pr.valor;
```

Diferenças podem ser legítimas quando o preço depende de área, região,
sessão ou avaliação.

### A8. Atendimento associado a status incompatível

``` sql
select t.id_atendimento, a.id_agendamento, a.status_agendamento
  from atendimento t
  join agendamento a on a.id_agendamento = t.id_agendamento
 where a.status_agendamento not in ('Confirmado', 'Realizado');
```

### A9. Data ou horário do atendimento diferente do agendamento

``` sql
select t.id_atendimento, t.data_atendimento, a.data_agendamento,
       t.horario_atendimento, a.horario_inicio
  from atendimento t
  join agendamento a on a.id_agendamento = t.id_agendamento
 where t.data_atendimento <> a.data_agendamento
    or t.horario_atendimento <> a.horario_inicio;
```

Uma diferença pode exigir análise manual, pois atrasos ou ajustes
operacionais podem justificar divergência.

### A10. Cliente inativa com agendamento futuro em aberto

``` sql
select c.nome as cliente, a.id_agendamento,
       a.data_agendamento, a.status_agendamento
  from agendamento a
  join cliente c on c.id_cliente = a.id_cliente
 where c.status_cliente = 'Inativo'
   and a.status_agendamento in ('Agendado', 'Confirmado')
   and a.data_agendamento >= current_date;
```

Outras verificações são realizadas pelo `04_testes_regras.sql` e pelas
consultas de histórico e auditoria presentes em `03_consultas.sql`.

## UPDATE e DELETE

Os exemplos abaixo são demonstrativos. Execute em ambiente de teste, um
bloco por vez. O log de auditoria registra as operações; portanto, mesmo
que o dado operacional seja restaurado, os eventos correspondentes
permanecem no log.

### UPDATE --- corrigir telefone e consultar auditoria

``` sql
update cliente
   set telefone = '(11) 90000-9999'
 where nome = 'Mariana Duarte';
```

Consultar o último evento registrado:

``` sql
select data_hora, operacao,
       dados_antes ->> 'telefone' as telefone_antes,
       dados_depois ->> 'telefone' as telefone_depois
  from log_auditoria
 where tabela = 'cliente'
   and id_registro = (
       select id_cliente::text from cliente where nome = 'Mariana Duarte'
   )
 order by id_log desc
 limit 1;
```

No seed documentado, o telefone original esperado é `(11) 90000-0003`.
Para restaurá-lo:

``` sql
update cliente
   set telefone = '(11) 90000-0003'
 where nome = 'Mariana Duarte';
```

### DELETE permitido --- cadastro sem histórico

``` sql
insert into cliente (nome, telefone)
values ('Cliente de Teste (excluir)', '(11) 90000-0000');

delete from cliente
 where nome = 'Cliente de Teste (excluir)';

select count(*) as restantes
  from cliente
 where nome = 'Cliente de Teste (excluir)';
```

Resultado esperado: `restantes = 0`.

### DELETE recusado --- cliente com histórico

``` sql
delete from cliente
 where nome = 'Mariana Duarte';
```

Resultado esperado: erro de integridade referencial, pois a cliente
possui registros relacionados. O comportamento esperado para preservar o
histórico é inativar o cadastro, e não excluir a cliente.

## Segurança e dados

-   Os dados de demonstração são fictícios.
-   Os procedimentos e valores de referência foram baseados no
    levantamento descrito no Anexo B do README principal; preços
    variáveis foram simplificados para fins de demonstração.
-   O percentual de sinal e as categorias/percentuais de comissão devem
    ser interpretados conforme a documentação do projeto; os percentuais
    de comissão usados no seed são fictícios.
-   O RLS está habilitado nas tabelas sem políticas públicas. Assim, a
    API pública não deve ser considerada uma interface de acesso ao
    banco. A aplicação futura deverá implementar autenticação e
    políticas adequadas.
-   Não publique chaves, tokens, senhas ou credenciais do projeto
    Supabase.

## Limpar e recriar

-   Para limpar os registros e manter a estrutura, utilize
    `manutencao/limpar_dados.sql`.
-   Para remover a estrutura e os dados, utilize
    `manutencao/apagar_tudo.sql`.
-   Após a limpeza, execute novamente `02_seed_dados.sql` para carregar
    a massa demonstrativa.

## Problemas comuns

  -----------------------------------------------------------------------
  Problema                            Possível causa / ação
  ----------------------------------- -----------------------------------
  Erro de objeto já existente         O schema já foi executado. Utilize
                                      um projeto vazio ou a rotina de
                                      limpeza/recriação apropriada.

  Erro de chave estrangeira durante o O schema ou parte da massa não foi
  seed                                executado na ordem correta; recrie
                                      o ambiente e execute os arquivos na
                                      sequência documentada.

  Consulta não retorna o resultado    Confirme se o seed foi executado
  esperado                            sem alterações e rode o `SELECT`
                                      individualmente.

  API não consegue ler as tabelas     Verifique o RLS e as políticas; por
                                      padrão, não há políticas públicas
                                      liberando acesso.

  Erro ao excluir cliente com         É a proteção esperada da
  histórico                           integridade referencial; inative o
                                      cadastro em vez de excluí-lo.
  -----------------------------------------------------------------------

## Evidências

A pasta `prints/` pode conter capturas do Schema Visualizer, tabelas e
resultados de execução. As imagens devem corresponder ao estado real do
banco e não substituir os scripts SQL como fonte de verdade.

-- Hillary Beauty - conferência e consultas (somente leitura).
-- No SQL Editor do Supabase só o resultado da ÚLTIMA consulta aparece:
-- selecione cada bloco e use "Run selected" (ou rode uma consulta por vez).

-- 1) Contagens esperadas após o seed:
--    cliente 25, profissional 6, procedimento 22, habilitacao 24, agendamento 30,
--    pagamento 43, atendimento 18, produto 12, movimentacao 87
select 'cliente' as tabela, count(*) from cliente
union all select 'profissional', count(*) from profissional
union all select 'procedimento', count(*) from procedimento
union all select 'habilitacao', count(*) from profissional_procedimento
union all select 'agendamento', count(*) from agendamento
union all select 'pagamento', count(*) from pagamento
union all select 'atendimento', count(*) from atendimento
union all select 'produto', count(*) from produto
union all select 'movimentacao', count(*) from movimentacao_estoque;

-- 2) Agendamentos por status: Agendado 3, Cancelado 3, Confirmado 4, Não Compareceu 2, Realizado 18
select status_agendamento, count(*) from agendamento group by 1 order by 1;

-- 3) Quantidade de atendimentos por profissional (RF13)
select * from vw_atendimentos_por_profissional order by profissional, mes;

-- 4) Atendimentos por procedimento (RF13)
select * from vw_atendimentos_por_procedimento order by procedimento, mes;

-- 5) Histórico de uma cliente (RF03)
select * from vw_historico_cliente where cliente = 'Mariana Duarte' order by data_atendimento;

-- 6) Produtos com estoque baixo (RF12) - esperado: Esmalte em gel nude e Luva descartável (par)
select * from vw_estoque_baixo;

-- 7) Comissão por profissional e mês (RF15): percentual da categoria sobre o valor pago
select * from vw_comissao_profissional order by profissional, mes;

-- 8) Estoque atual de todos os produtos
select nome, quantidade_atual, estoque_minimo,
       case when quantidade_atual <= estoque_minimo then 'REPOR' else 'ok' end as situacao
  from produto order by nome;

-- 9) Agenda futura (a partir de hoje)
select a.data_agendamento, a.horario_inicio, a.horario_fim, c.nome as cliente,
       p.nome as profissional, pr.nome as procedimento, a.status_agendamento
  from agendamento a
  join cliente c       on c.id_cliente = a.id_cliente
  join profissional p  on p.id_profissional = a.id_profissional
  join procedimento pr on pr.id_procedimento = a.id_procedimento
 where a.data_agendamento >= current_date
 order by 1, 2;

-- 10) Pagamentos de um agendamento (sinal de 40% + restante)
select c.nome as cliente, pr.nome as procedimento, pr.valor as valor_referencia,
       pg.tipo_pagamento, pg.valor, pg.data_pagamento
  from pagamento pg
  join agendamento a   on a.id_agendamento = pg.id_agendamento
  join cliente c       on c.id_cliente = a.id_cliente
  join procedimento pr on pr.id_procedimento = a.id_procedimento
 where c.nome = 'Renata Barbosa'
 order by pg.data_pagamento, pg.tipo_pagamento desc;

-- 11) Últimos eventos do log de auditoria
select data_hora, usuario, tabela, operacao, id_registro
  from log_auditoria order by id_log desc limit 20;

-- 12) Histórico de um agendamento no log (ex.: o primeiro): criação, confirmação e realização
select data_hora, operacao,
       dados_antes  ->> 'status_agendamento' as status_antes,
       dados_depois ->> 'status_agendamento' as status_depois
  from log_auditoria
 where tabela = 'agendamento' and id_registro = '1'
 order by id_log;

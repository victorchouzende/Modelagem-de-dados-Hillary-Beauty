-- =====================================================================
-- Hillary Beauty - TESTES DAS REGRAS (use para gerar os prints de evidência)
-- Pré-requisito: 01_schema.sql e 02_seed_dados.sql executados.
-- Cada TESTE deve ser rodado SEPARADO (selecione o bloco e use "Run selected").
-- Os testes 1 a 15 devem terminar em ERRO, com a mensagem indicada. Nenhum altera dados.
-- O teste 16 deve FUNCIONAR e desfaz tudo no final (rollback).
-- =====================================================================

-- TESTE 1: agendamento não pode nascer já Confirmado
-- esperado: "Todo agendamento deve ser criado com status Agendado (recebido: Confirmado)"
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio, status_agendamento)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-12-01', '10:00', 'Confirmado'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Bruna Siqueira' and p.nome = 'Marina Albuquerque' and pr.nome = 'Design estratégico';

-- TESTE 2: profissional só recebe procedimento para o qual está habilitada
-- esperado: "Profissional não habilitada para este procedimento"
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-12-01', '10:00'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Bruna Siqueira' and p.nome = 'Débora Cordeiro' and pr.nome = 'Brow lamination';

-- TESTE 3: a recepcionista (sem habilitações) não recebe agendamentos
-- esperado: "Profissional não habilitada para este procedimento"
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-12-01', '10:00'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Bruna Siqueira' and p.nome = 'Yasmin Furtado' and pr.nome = 'Manicure em gel';

-- TESTE 4: cliente inativa não pode agendar
-- esperado: "Cliente inexistente ou inativo"
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-12-01', '10:00'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Joana Medeiros' and p.nome = 'Débora Cordeiro' and pr.nome = 'Manicure em gel';

-- TESTE 5: só confirma com o sinal pago (a Rafaela está "Agendado", sem sinal)
-- esperado: "O agendamento só pode ser confirmado após o pagamento do sinal"
update agendamento set status_agendamento = 'Confirmado'
 where id_cliente = (select id_cliente from cliente where nome = 'Rafaela Correia')
   and status_agendamento = 'Agendado';

-- TESTE 6: horário já reservado da profissional (Luana tem Lash Lifting com a Marina, 14:00-15:00)
-- esperado: "A profissional já possui um horário reservado neste período"
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-11-10', '14:30'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Bruna Siqueira' and p.nome = 'Marina Albuquerque' and pr.nome = 'Design estratégico';

-- TESTE 7: a mesma cliente não pode ter dois horários reservados ao mesmo tempo
-- (Luana está com a Marina 14:00-15:00; a Sabrina está livre nesse horário)
-- esperado: "A cliente já possui um horário reservado neste período"
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-11-10', '14:30'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Luana Cavalcanti' and p.nome = 'Sabrina Lacerda' and pr.nome = 'Hidraglos';

-- TESTE 8: após a confirmação não se troca o horário
-- esperado: "Após a confirmação não é permitido trocar ou remanejar o horário"
update agendamento set horario_inicio = '16:00'
 where id_cliente = (select id_cliente from cliente where nome = 'Luana Cavalcanti')
   and status_agendamento = 'Confirmado';

-- TESTE 9: agendamento cancelado não é reativado
-- esperado: "Agendamento Cancelado não pode ser reativado; crie um novo agendamento"
update agendamento set status_agendamento = 'Confirmado'
 where id_cliente = (select id_cliente from cliente where nome = 'Karen Batista')
   and status_agendamento = 'Cancelado';

-- TESTE 10: atendimento só existe para agendamento confirmado ou realizado
-- esperado: "Atendimento só pode ser registrado para agendamento confirmado ou realizado (status atual: Agendado)"
insert into atendimento (id_agendamento, id_cliente, id_profissional, id_procedimento, data_atendimento, horario_atendimento)
select id_agendamento, id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio
  from agendamento
 where id_cliente = (select id_cliente from cliente where nome = 'Rafaela Correia')
   and status_agendamento = 'Agendado';

-- TESTE 11: no máximo um sinal por agendamento
-- esperado: erro de chave duplicada em "uq_pagamento_sinal"
insert into pagamento (id_agendamento, valor, tipo_pagamento)
select id_agendamento, 10, 'Sinal'
  from agendamento
 where id_cliente = (select id_cliente from cliente where nome = 'Luana Cavalcanti')
   and status_agendamento = 'Confirmado';

-- TESTE 12: estoque nunca fica negativo
-- esperado: "Estoque insuficiente: disponível 90, solicitado 1000"
insert into movimentacao_estoque (id_produto, tipo_movimentacao, quantidade, motivo)
select id_produto, 'Saída', 1000, 'Teste de estoque negativo'
  from produto where nome = 'Luva descartável (par)';

-- TESTE 13: movimentação de estoque não pode ser alterada nem apagada
-- esperado: "Movimentações de estoque não podem ser alteradas nem excluídas; registre uma movimentação de ajuste/estorno"
update movimentacao_estoque set quantidade = 1 where id_movimentacao = 1;

-- TESTE 14: data de nascimento no futuro
-- esperado: "Data de nascimento deve ser anterior à data atual"
insert into cliente (nome, telefone, data_nascimento) values ('Teste Nascimento', '(11) 90000-9999', '2030-01-01');

-- TESTE 15: o log de auditoria não pode ser apagado
-- esperado: "O log de auditoria não pode ser alterado nem excluído"
delete from log_auditoria;

-- TESTE 16: "Agendado" NÃO reserva horário (só o sinal reserva). Deve FUNCIONAR.
-- A Rafaela está "Agendado" com a Débora, 11:00-12:15, aguardando o sinal.
-- Outra cliente consegue pedir o mesmo horário; o resultado mostra os dois "Agendado" e depois tudo é desfeito.
begin;
insert into agendamento (id_cliente, id_profissional, id_procedimento, data_agendamento, horario_inicio)
select c.id_cliente, p.id_profissional, pr.id_procedimento, '2026-11-17', '11:30'
  from cliente c, profissional p, procedimento pr
 where c.nome = 'Bruna Siqueira' and p.nome = 'Débora Cordeiro' and pr.nome = 'Pedicure em gel';
select c.nome as cliente, a.horario_inicio, a.horario_fim, a.status_agendamento
  from agendamento a join cliente c using (id_cliente)
 where a.id_profissional = (select id_profissional from profissional where nome = 'Débora Cordeiro')
   and a.data_agendamento = '2026-11-17';
rollback;

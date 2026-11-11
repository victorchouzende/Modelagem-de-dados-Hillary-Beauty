-- =====================================================================
-- Hillary Beauty - ARQUIVO 2 DE 2: DADOS, CONSULTAS, TESTES E LIMPEZA
-- Pré-requisito: hillary-beauty-schema.sql já executado.
-- Parte A: massa de dados fictícia (rodar o arquivo inteiro de uma vez).
-- Parte B: consultas (rodar cada uma com "Run selected").
-- Parte C: testes das regras (comentados; descomente e rode um por vez).
-- Parte D: limpeza (comentada; use só quando quiser refazer o banco).
-- =====================================================================

-- ===================== PARTE A - MASSA DE DADOS ======================
-- =====================================================================
-- Hillary Beauty - SEED (DADOS FICTÍCIOS para demonstração)
-- 25 clientes | 5 profissionais + 1 recepcionista | 22 procedimentos | 30 agendamentos | 12 produtos
--
-- ATENÇÃO - o que é real e o que é fictício:
--   * Procedimentos, valores de referência e intervalos de retorno: vêm do Anexo B do README.
--     Quando o valor é uma faixa (ex.: R$ 60,00 a R$ 150,00), usa-se o menor valor ("a partir de").
--   * FICTÍCIOS: nomes e telefones de clientes e da equipe, duração dos procedimentos,
--     habilitações (quem faz o quê), categorias e percentuais de comissão, produtos e quantidades
--     de estoque, agendamentos, pagamentos e atendimentos. Nada aqui representa dado real.
--   * Estoque controlado somente para esmaltes, EPIs e descartáveis (como no README).
--
-- Pré-requisito: 01_schema.sql já executado, banco sem dados.
-- Rodar INTEIRO no SQL Editor do Supabase, UMA vez. Tudo roda numa transação:
-- se algum passo falhar, nada é gravado.
-- Para rodar de novo, limpe antes com manutencao/limpar_dados.sql.
--
-- Regras seguidas (triggers do schema):
--   Agendado -> pagamento do Sinal (40% do valor) -> Confirmado -> atendimento -> Realizado
--   Estoque: produtos nascem com 0; o saldo vem só de Entradas/Saídas.
--   Sem IDs fixos: todas as chaves são resolvidas por nome.
-- =====================================================================

begin;

-- 1. Categorias de profissional (percentuais fictícios)
insert into categoria_profissional (nome, percentual_comissao) values
    ('Categoria A', 30),
    ('Categoria B', 40),
    ('Categoria C', 50);

-- 2. Equipe (5 profissionais + 1 recepcionista, que não tem especialidade, categoria nem habilitações)
insert into profissional (nome, telefone, status_profissional, especialidade, id_categoria)
select v.nome, v.telefone, v.status, v.especialidade, c.id_categoria
  from (values
    ('Marina Albuquerque', '(11) 90000-0101', 'Ativa', 'Sobrancelhas e cílios'::varchar, 'Categoria B'::varchar),
    ('Débora Cordeiro', '(11) 90000-0102', 'Ativa', 'Unhas'::varchar, 'Categoria A'::varchar),
    ('Sabrina Lacerda', '(11) 90000-0103', 'Ativa', 'Estética facial'::varchar, 'Categoria B'::varchar),
    ('Tatiane Moraes', '(11) 90000-0104', 'Ativa', 'Harmonização e estética avançada'::varchar, 'Categoria C'::varchar),
    ('Vanessa Pimentel', '(11) 90000-0105', 'Ativa', 'Estética corporal e massagens'::varchar, 'Categoria A'::varchar),
    ('Yasmin Furtado', '(11) 90000-0106', 'Ativa', null::varchar, null::varchar)
  ) as v(nome, telefone, status, especialidade, categoria)
  left join categoria_profissional c on c.nome = v.categoria;

-- 3. Procedimentos (Anexo B do README; durações fictícias, em minutos)
insert into procedimento (nome, descricao, duracao, valor, intervalo_retorno) values
    ('Brow lamination', null, 60, 160.00, '35 dias'),
    ('Design estratégico', null, 45, 70.00, '20 dias'),
    ('Nanofios', null, 150, 700.00, '8 meses'),
    ('Lash Lifting', null, 60, 150.00, '45 dias'),
    ('Hidraglos', null, 60, 150.00, '30 dias'),
    ('Remoção de micropigmentação', 'Valor por sessão. Em média, 3 a 5 sessões', 60, 250.00, '20 dias'),
    ('Extensão de cílios', 'Intervalo informado como manutenção', 120, 200.00, '20 dias'),
    ('Biorepair', 'Valor por sessão. Em média, 3 sessões', 60, 150.00, '20 dias'),
    ('Depilação a laser', 'Valor de R$ 60,00 a R$ 150,00, depende da área', 30, 60.00, '30 dias'),
    ('Remoção de estrias', 'Valor de R$ 300,00 a R$ 600,00, depende da região', 60, 300.00, '45 dias entre as sessões'),
    ('Manicure tradicional', null, 45, 45.00, '7 dias'),
    ('Pedicure tradicional', null, 60, 50.00, '15 dias'),
    ('Manicure em gel', null, 60, 80.00, '15 dias'),
    ('Pedicure em gel', null, 75, 80.00, '15 dias'),
    ('Quiropraxia', 'Valor por sessão', 45, 160.00, 'Depende de avaliação'),
    ('Limpeza de pele', null, 75, 200.00, 'Depende de avaliação'),
    ('Microagulhamento', null, 60, 450.00, '40 dias'),
    ('Massagens', 'Valor de R$ 100,00 a R$ 150,00', 60, 100.00, null),
    ('Preenchimento facial', 'Valor por ml', 60, 1200.00, 'Retoque anual'),
    ('Bioestimulador de colágeno', null, 60, 2500.00, '1 ano'),
    ('Preenchimento glúteo', 'Valor para 55 ml', 90, 6000.00, 'Retoque somente com avaliação'),
    ('Laser Lavien', null, 45, 700.00, '40 dias');

-- 4. Habilitações (profissional x procedimento) - fictícias
insert into profissional_procedimento (id_profissional, id_procedimento)
select p.id_profissional, pr.id_procedimento
  from (values
    ('Marina Albuquerque', 'Brow lamination'),
    ('Marina Albuquerque', 'Design estratégico'),
    ('Marina Albuquerque', 'Nanofios'),
    ('Marina Albuquerque', 'Lash Lifting'),
    ('Marina Albuquerque', 'Hidraglos'),
    ('Marina Albuquerque', 'Remoção de micropigmentação'),
    ('Marina Albuquerque', 'Extensão de cílios'),
    ('Débora Cordeiro', 'Manicure tradicional'),
    ('Débora Cordeiro', 'Pedicure tradicional'),
    ('Débora Cordeiro', 'Manicure em gel'),
    ('Débora Cordeiro', 'Pedicure em gel'),
    ('Sabrina Lacerda', 'Design estratégico'),
    ('Sabrina Lacerda', 'Hidraglos'),
    ('Sabrina Lacerda', 'Biorepair'),
    ('Sabrina Lacerda', 'Limpeza de pele'),
    ('Sabrina Lacerda', 'Microagulhamento'),
    ('Tatiane Moraes', 'Preenchimento facial'),
    ('Tatiane Moraes', 'Bioestimulador de colágeno'),
    ('Tatiane Moraes', 'Preenchimento glúteo'),
    ('Tatiane Moraes', 'Laser Lavien'),
    ('Vanessa Pimentel', 'Depilação a laser'),
    ('Vanessa Pimentel', 'Remoção de estrias'),
    ('Vanessa Pimentel', 'Quiropraxia'),
    ('Vanessa Pimentel', 'Massagens')
  ) as v(profissional, procedimento)
  join profissional p  on p.nome  = v.profissional
  join procedimento pr on pr.nome = v.procedimento;

-- 5. Clientes (todas entram 'Ativo'; 2 viram 'Inativo' no final, pois o trigger só aceita agendar clientes ativas)
insert into cliente (nome, telefone, data_nascimento, data_cadastro) values
    ('Ana Beatriz Moura', '(11) 90000-0001', date '1994-11-28', date '2026-07-22'),
    ('Larissa Fernandes', '(11) 90000-0002', null, date '2026-10-12'),
    ('Mariana Duarte', '(11) 90000-0003', date '1997-09-14', date '2026-07-26'),
    ('Camila Teixeira', '(11) 90000-0004', date '2004-12-25', date '2026-07-23'),
    ('Gabriela Nogueira', '(11) 90000-0005', date '2002-10-15', date '2026-10-15'),
    ('Renata Barbosa', '(11) 90000-0006', null, date '2026-08-24'),
    ('Isabela Cardoso', '(11) 90000-0007', null, date '2026-08-31'),
    ('Letícia Ramos', '(11) 90000-0008', null, date '2026-08-12'),
    ('Amanda Freitas', '(11) 90000-0009', date '1999-08-22', date '2026-09-14'),
    ('Bruna Siqueira', '(11) 90000-0010', date '1986-06-12', date '2026-09-16'),
    ('Carolina Peixoto', '(11) 90000-0011', date '2001-09-21', date '2026-09-10'),
    ('Daniela Vasconcelos', '(11) 90000-0012', date '1980-09-18', date '2026-10-10'),
    ('Elisa Monteiro', '(11) 90000-0013', date '1982-11-23', date '2026-10-15'),
    ('Fabiana Azevedo', '(11) 90000-0014', date '1978-12-12', date '2026-10-04'),
    ('Giovana Pires', '(11) 90000-0015', date '1980-07-19', date '2026-09-17'),
    ('Helena Queiroz', '(11) 90000-0016', date '1981-07-17', date '2026-09-30'),
    ('Ingrid Machado', '(11) 90000-0017', date '1997-08-13', date '2026-09-08'),
    ('Joana Medeiros', '(11) 90000-0018', date '2005-07-19', date '2026-06-28'),
    ('Karen Batista', '(11) 90000-0019', date '1994-09-26', date '2026-09-11'),
    ('Luana Cavalcanti', '(11) 90000-0020', date '2002-03-27', date '2026-10-31'),
    ('Mônica Brandão', '(11) 90000-0021', date '1994-11-04', date '2026-11-01'),
    ('Natália Guimarães', '(11) 90000-0022', date '1993-03-16', date '2026-07-19'),
    ('Olívia Santana', '(11) 90000-0023', date '1981-11-23', date '2026-10-06'),
    ('Priscila Tavares', '(11) 90000-0024', date '2000-09-09', date '2026-10-21'),
    ('Rafaela Correia', '(11) 90000-0025', date '1987-09-26', date '2026-10-21');

-- 6. Produtos: esmaltes, EPIs e descartáveis (quantidade_atual = 0; o saldo vem das entradas abaixo)
insert into produto (nome, descricao, unidade_medida, quantidade_atual, estoque_minimo) values
    ('Esmalte tradicional vermelho', 'Esmalte tradicional (item de demonstração)', 'unidade', 0, 4),
    ('Esmalte tradicional nude', 'Esmalte tradicional (item de demonstração)', 'unidade', 0, 4),
    ('Esmalte em gel nude', 'Esmalte em gel (item de demonstração)', 'unidade', 0, 6),
    ('Esmalte em gel rosa claro', 'Esmalte em gel (item de demonstração)', 'unidade', 0, 6),
    ('Luva descartável (par)', 'EPI (item de demonstração)', 'unidade', 0, 100),
    ('Máscara descartável', 'EPI (item de demonstração)', 'unidade', 0, 50),
    ('Touca descartável', 'EPI (item de demonstração)', 'unidade', 0, 50),
    ('Algodão em disco (pacote)', 'Descartável (item de demonstração)', 'unidade', 0, 10),
    ('Lixa descartável', 'Descartável (item de demonstração)', 'unidade', 0, 30),
    ('Lençol descartável (rolo)', 'Descartável (item de demonstração)', 'unidade', 0, 3),
    ('Palito de unha (pacote)', 'Descartável (item de demonstração)', 'unidade', 0, 5),
    ('Papel toalha (rolo)', 'Descartável (item de demonstração)', 'unidade', 0, 6);

-- 7. Entradas de estoque (compra inicial + reposição)
insert into movimentacao_estoque (id_produto, tipo_movimentacao, quantidade, data_movimentacao, motivo)
select p.id_produto, 'Entrada', v.qtd, v.data, v.motivo
  from (values
    ('Esmalte tradicional vermelho', 16::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Esmalte tradicional nude', 9::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Esmalte tradicional nude', 2::numeric, date '2026-10-12', 'Reposição de estoque'),
    ('Esmalte em gel nude', 5::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Esmalte em gel nude', 3::numeric, date '2026-10-12', 'Reposição de estoque'),
    ('Esmalte em gel rosa claro', 18::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Luva descartável (par)', 146::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Luva descartável (par)', 60::numeric, date '2026-10-12', 'Reposição de estoque'),
    ('Máscara descartável', 200::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Máscara descartável', 40::numeric, date '2026-10-12', 'Reposição de estoque'),
    ('Touca descartável', 240::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Algodão em disco (pacote)', 30::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Lixa descartável', 50::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Lixa descartável', 30::numeric, date '2026-10-12', 'Reposição de estoque'),
    ('Lençol descartável (rolo)', 10::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Palito de unha (pacote)', 13::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Papel toalha (rolo)', 17::numeric, date '2026-07-31', 'Compra inicial de estoque'),
    ('Papel toalha (rolo)', 6::numeric, date '2026-10-12', 'Reposição de estoque')
  ) as v(produto, qtd, data, motivo)
  join produto p on p.nome = v.produto;

-- 8. Agendamentos, pagamentos, atendimentos e saídas de estoque ligadas a atendimento
-- Cada linha percorre o fluxo real: Agendado -> Sinal -> Confirmado -> (Realizado | Cancelado | Não Compareceu)
do $seed$
declare
    r        record;
    v_ag     integer;
    v_at     integer;
    v_valor  numeric;
    v_sinal  numeric;
begin
    for r in
        select * from (values
            (1, 'Ana Beatriz Moura', 'Marina Albuquerque', 'Design estratégico', date '2026-08-04', time '10:00', 'Realizado', true, date '2026-08-01', 'Primeira vez no studio'::text),
            (2, 'Joana Medeiros', 'Débora Cordeiro', 'Manicure em gel', date '2026-08-06', time '14:00', 'Realizado', true, date '2026-08-03', null::text),
            (3, 'Mariana Duarte', 'Marina Albuquerque', 'Extensão de cílios', date '2026-08-12', time '09:30', 'Realizado', true, date '2026-08-09', null::text),
            (4, 'Natália Guimarães', 'Sabrina Lacerda', 'Limpeza de pele', date '2026-08-20', time '11:00', 'Realizado', true, date '2026-08-17', null::text),
            (5, 'Camila Teixeira', 'Débora Cordeiro', 'Manicure tradicional', date '2026-08-27', time '15:00', 'Realizado', true, date '2026-08-24', null::text),
            (6, 'Ana Beatriz Moura', 'Marina Albuquerque', 'Brow lamination', date '2026-09-03', time '10:00', 'Realizado', true, date '2026-08-31', null::text),
            (7, 'Renata Barbosa', 'Vanessa Pimentel', 'Massagens', date '2026-09-10', time '13:00', 'Realizado', true, date '2026-09-07', null::text),
            (8, 'Isabela Cardoso', 'Débora Cordeiro', 'Pedicure em gel', date '2026-09-12', time '09:00', 'Realizado', true, date '2026-09-09', null::text),
            (9, 'Letícia Ramos', 'Marina Albuquerque', 'Lash Lifting', date '2026-09-17', time '16:00', 'Realizado', true, date '2026-09-14', null::text),
            (10, 'Amanda Freitas', 'Vanessa Pimentel', 'Depilação a laser', date '2026-09-24', time '10:30', 'Realizado', true, date '2026-09-21', null::text),
            (11, 'Mariana Duarte', 'Débora Cordeiro', 'Pedicure tradicional', date '2026-10-01', time '14:00', 'Realizado', true, date '2026-09-28', null::text),
            (12, 'Bruna Siqueira', 'Marina Albuquerque', 'Brow lamination', date '2026-10-06', time '09:00', 'Realizado', true, date '2026-10-03', null::text),
            (13, 'Giovana Pires', 'Débora Cordeiro', 'Manicure em gel', date '2026-10-08', time '16:00', 'Não Compareceu', true, date '2026-10-05', null::text),
            (14, 'Ingrid Machado', 'Marina Albuquerque', 'Design estratégico', date '2026-10-13', time '15:00', 'Cancelado', true, date '2026-10-08', 'Cancelou com antecedência'::text),
            (15, 'Carolina Peixoto', 'Sabrina Lacerda', 'Microagulhamento', date '2026-10-15', time '11:30', 'Realizado', true, date '2026-10-12', null::text),
            (16, 'Karen Batista', 'Débora Cordeiro', 'Pedicure tradicional', date '2026-10-20', time '10:00', 'Cancelado', false, date '2026-10-17', null::text),
            (17, 'Daniela Vasconcelos', 'Débora Cordeiro', 'Pedicure em gel', date '2026-10-22', time '15:30', 'Realizado', true, date '2026-10-19', null::text),
            (18, 'Helena Queiroz', 'Vanessa Pimentel', 'Remoção de estrias', date '2026-10-27', time '14:30', 'Não Compareceu', true, date '2026-10-24', null::text),
            (19, 'Mariana Duarte', 'Marina Albuquerque', 'Extensão de cílios', date '2026-10-29', time '10:00', 'Realizado', true, date '2026-10-26', 'Manutenção'::text),
            (20, 'Elisa Monteiro', 'Sabrina Lacerda', 'Limpeza de pele', date '2026-11-03', time '13:00', 'Realizado', true, date '2026-10-31', null::text),
            (21, 'Fabiana Azevedo', 'Vanessa Pimentel', 'Quiropraxia', date '2026-11-05', time '09:30', 'Realizado', true, date '2026-11-02', null::text),
            (22, 'Renata Barbosa', 'Tatiane Moraes', 'Preenchimento facial', date '2026-11-07', time '10:00', 'Realizado', true, date '2026-11-04', 'Retoque com avaliação'::text),
            (23, 'Luana Cavalcanti', 'Marina Albuquerque', 'Lash Lifting', date '2026-11-10', time '14:00', 'Confirmado', true, date '2026-11-07', null::text),
            (24, 'Mônica Brandão', 'Tatiane Moraes', 'Bioestimulador de colágeno', date '2026-11-12', time '10:00', 'Confirmado', true, date '2026-11-08', null::text),
            (25, 'Olívia Santana', 'Débora Cordeiro', 'Manicure em gel', date '2026-11-13', time '15:00', 'Confirmado', true, date '2026-11-08', null::text),
            (26, 'Priscila Tavares', 'Sabrina Lacerda', 'Limpeza de pele', date '2026-11-14', time '09:30', 'Confirmado', true, date '2026-11-08', null::text),
            (27, 'Rafaela Correia', 'Débora Cordeiro', 'Pedicure em gel', date '2026-11-17', time '11:00', 'Agendado', false, date '2026-11-08', null::text),
            (28, 'Gabriela Nogueira', 'Marina Albuquerque', 'Brow lamination', date '2026-11-18', time '14:00', 'Cancelado', false, date '2026-11-08', null::text),
            (29, 'Ana Beatriz Moura', 'Marina Albuquerque', 'Design estratégico', date '2026-11-19', time '16:00', 'Agendado', false, date '2026-11-08', null::text),
            (30, 'Larissa Fernandes', 'Sabrina Lacerda', 'Hidraglos', date '2026-11-21', time '10:00', 'Agendado', false, date '2026-11-08', 'Primeira vez no studio'::text)
        ) as t(ord, cliente, profissional, procedimento, data_ag, hora, status_final, tem_sinal, data_sinal, obs)
        order by ord
    loop
        -- nasce sempre 'Agendado'
        insert into agendamento (id_cliente, id_profissional, id_procedimento,
                                 data_agendamento, horario_inicio, observacao)
        select c.id_cliente, p.id_profissional, pr.id_procedimento, r.data_ag, r.hora, r.obs
          from cliente c, profissional p, procedimento pr
         where c.nome = r.cliente and p.nome = r.profissional and pr.nome = r.procedimento
        returning id_agendamento into v_ag;

        if v_ag is null then
            raise exception 'Linha % do seed: cliente/profissional/procedimento não encontrado', r.ord;
        end if;

        select valor into v_valor from procedimento where nome = r.procedimento;
        v_sinal := round(v_valor * 0.40, 2);

        if r.tem_sinal then
            insert into pagamento (id_agendamento, valor, data_pagamento, tipo_pagamento)
            values (v_ag, v_sinal, r.data_sinal, 'Sinal');
            update agendamento set status_agendamento = 'Confirmado' where id_agendamento = v_ag;
        end if;

        if r.status_final = 'Realizado' then
            insert into atendimento (id_agendamento, id_cliente, id_profissional, id_procedimento,
                                     data_atendimento, horario_atendimento, observacao)
            select id_agendamento, id_cliente, id_profissional, id_procedimento,
                   data_agendamento, horario_inicio, observacao
              from agendamento where id_agendamento = v_ag
            returning id_atendimento into v_at;

            update agendamento set status_agendamento = 'Realizado' where id_agendamento = v_ag;

            insert into pagamento (id_agendamento, valor, data_pagamento, tipo_pagamento)
            values (v_ag, v_valor - v_sinal, r.data_ag, 'Restante');

            -- consumo de estoque ligado ao atendimento
            insert into movimentacao_estoque (id_produto, tipo_movimentacao, quantidade,
                                              data_movimentacao, motivo, id_atendimento)
            select pd.id_produto, 'Saída', sc.qtd, r.data_ag, 'Consumo no atendimento', v_at
              from (values
                    ('Brow lamination', 'Luva descartável (par)', 2::numeric),
                    ('Design estratégico', 'Luva descartável (par)', 2::numeric),
                    ('Nanofios', 'Luva descartável (par)', 2::numeric),
                    ('Lash Lifting', 'Luva descartável (par)', 2::numeric),
                    ('Hidraglos', 'Luva descartável (par)', 2::numeric),
                    ('Remoção de micropigmentação', 'Luva descartável (par)', 2::numeric),
                    ('Extensão de cílios', 'Luva descartável (par)', 2::numeric),
                    ('Biorepair', 'Luva descartável (par)', 2::numeric),
                    ('Depilação a laser', 'Luva descartável (par)', 2::numeric),
                    ('Remoção de estrias', 'Luva descartável (par)', 2::numeric),
                    ('Manicure tradicional', 'Luva descartável (par)', 2::numeric),
                    ('Manicure tradicional', 'Esmalte tradicional nude', 1::numeric),
                    ('Manicure tradicional', 'Lixa descartável', 1::numeric),
                    ('Pedicure tradicional', 'Luva descartável (par)', 2::numeric),
                    ('Pedicure tradicional', 'Esmalte tradicional nude', 1::numeric),
                    ('Pedicure tradicional', 'Lixa descartável', 1::numeric),
                    ('Manicure em gel', 'Luva descartável (par)', 2::numeric),
                    ('Manicure em gel', 'Esmalte em gel nude', 1::numeric),
                    ('Manicure em gel', 'Lixa descartável', 1::numeric),
                    ('Pedicure em gel', 'Luva descartável (par)', 2::numeric),
                    ('Pedicure em gel', 'Esmalte em gel nude', 1::numeric),
                    ('Pedicure em gel', 'Lixa descartável', 1::numeric),
                    ('Quiropraxia', 'Luva descartável (par)', 2::numeric),
                    ('Limpeza de pele', 'Luva descartável (par)', 2::numeric),
                    ('Microagulhamento', 'Luva descartável (par)', 2::numeric),
                    ('Massagens', 'Luva descartável (par)', 2::numeric),
                    ('Preenchimento facial', 'Luva descartável (par)', 2::numeric),
                    ('Bioestimulador de colágeno', 'Luva descartável (par)', 2::numeric),
                    ('Preenchimento glúteo', 'Luva descartável (par)', 2::numeric),
                    ('Laser Lavien', 'Luva descartável (par)', 2::numeric)
              ) as sc(procedimento, produto, qtd)
              join produto pd on pd.nome = sc.produto
             where sc.procedimento = r.procedimento;

        elsif r.status_final in ('Cancelado', 'Não Compareceu') then
            update agendamento set status_agendamento = r.status_final where id_agendamento = v_ag;
        end if;
    end loop;
end
$seed$;

-- 9. Saídas de consumo geral (sem atendimento; motivo obrigatório)
insert into movimentacao_estoque (id_produto, tipo_movimentacao, quantidade, data_movimentacao, motivo)
select p.id_produto, 'Saída', v.qtd, v.data, v.motivo
  from (values
    ('Esmalte tradicional vermelho', 2::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Esmalte em gel rosa claro', 2::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Luva descartável (par)', 20::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Máscara descartável', 30::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Touca descartável', 25::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Algodão em disco (pacote)', 3::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Lençol descartável (rolo)', 1::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Palito de unha (pacote)', 1::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Papel toalha (rolo)', 3::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Lixa descartável', 5::numeric, date '2026-08-31', 'Consumo geral do período'),
    ('Esmalte tradicional vermelho', 2::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Esmalte em gel rosa claro', 2::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Luva descartável (par)', 20::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Máscara descartável', 30::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Touca descartável', 25::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Algodão em disco (pacote)', 3::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Lençol descartável (rolo)', 1::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Palito de unha (pacote)', 1::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Papel toalha (rolo)', 3::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Lixa descartável', 5::numeric, date '2026-09-30', 'Consumo geral do período'),
    ('Esmalte tradicional vermelho', 2::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Esmalte em gel rosa claro', 2::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Luva descartável (par)', 20::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Máscara descartável', 30::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Touca descartável', 25::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Algodão em disco (pacote)', 3::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Lençol descartável (rolo)', 1::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Palito de unha (pacote)', 1::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Papel toalha (rolo)', 3::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Lixa descartável', 5::numeric, date '2026-10-31', 'Consumo geral do período'),
    ('Esmalte tradicional vermelho', 2::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Esmalte em gel rosa claro', 2::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Luva descartável (par)', 20::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Máscara descartável', 30::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Touca descartável', 25::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Algodão em disco (pacote)', 3::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Lençol descartável (rolo)', 1::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Palito de unha (pacote)', 1::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Papel toalha (rolo)', 3::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Lixa descartável', 5::numeric, date '2026-11-07', 'Consumo geral do período'),
    ('Esmalte em gel nude', 1::numeric, date '2026-10-09', 'Descarte por vencimento')
  ) as v(produto, qtd, data, motivo)
  join produto p on p.nome = v.produto;

-- 10. Clientes inativas (histórico preservado)
update cliente set status_cliente = 'Inativo'
 where nome in ('Joana Medeiros', 'Natália Guimarães');

commit;


-- ===================== PARTE B - CONSULTAS ==========================
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


-- ===================== PARTE C - TESTES DAS REGRAS ==================
-- Os TESTES 1 a 15 devem terminar em ERRO; o 16 funciona e faz rollback.
-- Para usar: apague a linha "/*" abaixo e a linha "*/" final, selecione um teste e use "Run selected".
/*
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

*/

-- ===================== PARTE D - LIMPEZA ============================
-- CUIDADO: apagam dados. Descomente (apague "/*" e "*/") só se for refazer.
/*
-- D1) Limpar dados (mantém a estrutura):
-- =====================================================================
-- Hillary Beauty - LIMPAR DADOS (mantém tabelas, triggers, views e regras)
-- CUIDADO: apaga TODOS os registros de todas as tabelas, inclusive o log.
-- Os contadores de ID voltam a 1. Depois, rode 02_seed_dados.sql para repopular.
-- =====================================================================

truncate table
    log_auditoria,
    movimentacao_estoque,
    produto,
    pagamento,
    atendimento,
    agendamento,
    profissional_procedimento,
    procedimento,
    profissional,
    cliente,
    categoria_profissional
restart identity cascade;

-- D2) Apagar tudo (estrutura e dados):
-- =====================================================================
-- Hillary Beauty - APAGAR TUDO (tabelas, views, funções e triggers)
-- CUIDADO: remove a estrutura inteira e todos os dados.
-- Depois, rode 01_schema.sql e 02_seed_dados.sql para recriar o banco do zero.
-- A extensão btree_gist (schema "extensions") é mantida.
-- =====================================================================

drop view if exists vw_comissao_profissional, vw_historico_cliente,
                    vw_atendimentos_por_procedimento, vw_atendimentos_por_profissional,
                    vw_estoque_baixo;

drop table if exists log_auditoria, movimentacao_estoque, produto, pagamento, atendimento,
                     agendamento, profissional_procedimento, procedimento, profissional,
                     cliente, categoria_profissional cascade;

drop function if exists fn_agendamento_validar(), fn_atendimento_validar(), fn_movimentacao_aplicar(),
                        fn_cliente_validar(), fn_imutavel(), fn_log_auditoria();

*/

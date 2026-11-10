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

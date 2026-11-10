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

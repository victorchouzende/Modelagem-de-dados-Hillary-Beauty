# Banco lógico — Hillary Beauty (PostgreSQL / Supabase)

Esta pasta contém os scripts do **modelo lógico** do projeto: o banco foi criado em **PostgreSQL**, usando o **Supabase** como ambiente de execução. Todos os scripts foram testados em um banco novo, do zero. As regras de negócio, as decisões de modelagem e a explicação de cada restrição estão na seção **"Modelo Lógico"** do [README principal](../README.md).

## Conteúdo

|Arquivo|Para que serve|Quando rodar|
|-|-|-|
|`01_schema.sql`|Cria tabelas, chaves, restrições, índices, triggers (regras de negócio), log de auditoria, views e ativa o RLS|1º, em banco sem as tabelas|
|`02_seed_dados.sql`|Insere **dados fictícios** de demonstração|2º, depois do schema|
|`03_consultas.sql`|Consultas de conferência e as consultas previstas no README (atendimentos, histórico, estoque baixo, comissão, log)|3º, para conferir|
|`04_testes_regras.sql`|16 testes que provam que o banco recusa o que as regras proíbem|Opcional, para evidências|
|`manutencao/limpar_dados.sql`|Apaga todos os dados e mantém a estrutura|Para repopular|
|`manutencao/apagar_tudo.sql`|Apaga estrutura e dados|Para recriar do zero|
|`prints/`|Imagens de evidência do banco funcionando|Documentação|

## Pré-requisitos

* Uma conta gratuita no [Supabase](https://supabase.com) e um projeto criado (**New project**). Anote a senha do banco em local seguro.
* Nenhuma instalação no computador: tudo é feito pelo navegador.

## Passo a passo

1. **Abra o SQL Editor** do projeto no Supabase (menu lateral) e clique em **New query**.
2. **Crie a estrutura:** copie todo o conteúdo de `01_schema.sql`, cole no editor e clique em **Run**. Se o Supabase avisar *"Potential issue detected"* (tabelas sem RLS), escolha **Run and enable RLS**: o script já ativa o RLS em todas as tabelas. Resultado esperado: *Success. No rows returned*. No **Table Editor** devem aparecer 11 tabelas.
3. **Popule com dados fictícios:** em uma nova query, cole todo o `02_seed_dados.sql` e clique em **Run**. O script roda dentro de uma transação: se algo falhar, nada é gravado.
4. **Confira:** em uma nova query, cole `03_consultas.sql`. O editor mostra só o resultado da **última** consulta, então selecione uma consulta por vez e use **Run selected**. Os números esperados estão nos comentários do arquivo (por exemplo: 25 clientes, 30 agendamentos, 18 atendimentos).
5. **Teste as regras (opcional):** `04_testes_regras.sql` traz 16 testes. Rode **um por vez**. Os testes 1 a 15 devem terminar em erro, com a mensagem indicada no comentário, e não alteram dados. O teste 16 funciona e é desfeito no final.
6. **Diagrama:** no painel do Supabase, abra o **Schema Visualizer** (seção Database) para ver as tabelas e os relacionamentos criados.

## Limpar e recriar

|Objetivo|O que rodar|
|-|-|
|Apagar os dados e repopular|`manutencao/limpar_dados.sql` e depois `02_seed_dados.sql`|
|Recriar o banco do zero|`manutencao/apagar_tudo.sql`, depois `01_schema.sql` e `02_seed_dados.sql`|

Atenção: os dois scripts de manutenção **apagam dados de forma definitiva**. Use só no banco de demonstração.

## Problemas comuns

|Mensagem|Causa|Solução|
|-|-|-|
|`relation "..." already exists`|O `01_schema.sql` já foi executado|Rode `manutencao/apagar_tudo.sql` e execute o `01` de novo|
|Erro ou dados duplicados ao rodar o `02`|O seed já foi executado antes|Rode `manutencao/limpar_dados.sql` e execute o `02` de novo|
|`relation "cliente" does not exist` ao rodar o `02`|O `01_schema.sql` ainda não foi executado|Execute o `01` primeiro|

## Segurança e dados

* **Os dados são fictícios.** Nomes, telefones, agendamentos, pagamentos e estoque foram inventados para demonstração. Do levantamento real, o seed usa apenas os procedimentos, valores de referência e intervalos de retorno do Anexo B do README. Os detalhes estão no cabeçalho do `02_seed_dados.sql`.
* O RLS está ativo em todas as tabelas e não há políticas: a API pública do Supabase (chaves `anon`/`authenticated`) **não acessa** os dados. O SQL Editor e o Table Editor continuam funcionando.
* **Nunca** coloque no GitHub a senha do banco, a *connection string* ou as chaves do projeto.

## Evidências (prints)

A pasta `prints/` reúne imagens do banco funcionando, por exemplo: tabelas no Table Editor, diagrama do Schema Visualizer, resultado das consultas do `03_consultas.sql` e as mensagens de erro dos testes do `04_testes_regras.sql`.

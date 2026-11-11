# Modelo Conceitual — Hillary Beauty

Este documento apresenta o Dicionário de Dados Conceitual do sistema da clínica de estética Hillary Beauty. O objetivo é descrever as entidades (elementos do domínio do negócio), seus propósitos operacionais e seus relacionamentos, focando estritamente nas regras de negócio em detrimento das especificações tecnológicas.

## 0. Visão Geral do Negócio (Fluxo Operacional)

O fluxo de processos da clínica estrutura-se a partir da jornada do **Cliente**. O ciclo tem início mediante a formalização de um **Agendamento** com um **Profissional**. O comparecimento do cliente consolida-se em um **Atendimento**, momento em que um **Procedimento** é executado. 

A partir deste evento central, desdobram-se três fluxos interligados: a baixa de itens de estoque (**Uso de Produto**), a liquidação financeira por parte do cliente (**Pagamento**) e o provisionamento de honorários ao especialista (**Comissão**). Todos os dados sensíveis de evolução são documentados no **Histórico Clínico** para acompanhamento do paciente, e a integridade de todo o processo é resguardada continuamente pelo **Log de Auditoria**.

## 1. Entidades Principais (Cadastros Base)

### Cliente
* **Conceito:** A pessoa física que usufrui dos serviços de estética e saúde oferecidos pela instituição.
* **Atributos de Negócio:** Nome, Telefone de Contato e Data de Nascimento.
* **Relacionamentos:**
  * Pode registrar **vários (N)** Agendamentos ao longo do tempo.
  * Possui **vários (N)** registros no Histórico Clínico (prontuário).

### Profissional
* **Conceito:** O especialista do corpo clínico responsável pela prestação direta dos serviços.
* **Atributos de Negócio:** Nome e Status Operacional (Ativo/Inativo).
* **Relacionamentos:**
  * É alocado em **vários (N)** Agendamentos.
  * É o beneficiário de **várias (N)** Comissões oriundas dos serviços prestados.

### Procedimento
* **Conceito:** O serviço padronizado constante no catálogo da clínica (ex.: Limpeza de Pele, Aplicação de Toxina Botulínica).
* **Atributos de Negócio:** Nome, Valor Base de Referência, Percentual Padrão de Repasse (Comissão) e Intervalo Sugerido para Retorno.
* **Relacionamentos:**
  * É referenciado em **vários (N)** Atendimentos.

### Produto (Estoque)
* **Conceito:** Os insumos físicos consumíveis mantidos nas dependências da clínica.
* **Atributos de Negócio:** Nome, Quantidade Disponível em Estoque e Nível de Estoque Mínimo (ponto de ressuprimento).
* **Relacionamentos:**
  * Tem seu saldo reduzido através de **vários (N)** registros de Uso de Produto.

## 2. Entidades Transacionais (Operação Contínua)

### Agendamento
* **Conceito:** A reserva de um intervalo de tempo na agenda da instituição para a realização de um serviço.
* **Atributos de Negócio:** Data, Hora e Situação da Reserva (Pendente, Concluído, Cancelado).
* **Relacionamentos:**
  * Está vinculado a **um (1)** Cliente.
  * Aloca **um (1)** Profissional.
  * Quando efetivado, origina **exatamente um (1)** Atendimento.

### Atendimento
* **Conceito:** A execução efetiva do serviço em clínica. Representa o núcleo das operações e transações financeiras do sistema.
* **Atributos de Negócio:** Valor Final Efetivo (contemplando eventuais acréscimos ou descontos aplicados).
* **Relacionamentos:**
  * É derivado de **um (1)** Agendamento concluído.
  * Consiste na aplicação de **um (1)** Procedimento.
  * Fomenta **vários (N)** Pagamentos (ex.: liquidação fracionada entre cartões e espécie).
  * Origina **uma ou mais (N)** Comissões.
  * Registra **vários (N)** Usos de Produtos vinculados ao evento.

### Uso de Produto (Consumo)
* **Conceito:** O apontamento de saída de um insumo do controle de estoque, justificado por sua utilização clínica.
* **Atributos de Negócio:** Quantidade Consumida.
* **Relacionamentos:**
  * É atrelado a **um (1)** Atendimento específico.
  * Promove a baixa no estoque de **um (1)** Produto.

## 3. Entidades Financeiras e Clínicas

### Pagamento
* **Conceito:** A contabilização da entrada de receita financeira no caixa da clínica.
* **Atributos de Negócio:** Valor Liquidado, Modalidade de Pagamento e Data da Transação.
* **Relacionamentos:**
  * Amortiza (total ou parcialmente) o débito de **um (1)** Atendimento.

### Comissão
* **Conceito:** A obrigação financeira (contas a pagar) devida ao profissional como contrapartida pela prestação do serviço.
* **Atributos de Negócio:** Valor do Repasse.
* **Relacionamentos:**
  * É gerada em decorrência de **um (1)** Atendimento.
  * É destinada a **um (1)** Profissional.

### Histórico Clínico (Prontuário)
* **Conceito:** A base de dados médicos e evolutivos do paciente, contendo anamnese e registros multimídia.
* **Atributos de Negócio:** Anotações Evolutivas e Documentação Fotográfica (registros de "antes e depois").
* **Relacionamentos:**
  * Pertence estritamente a **um (1)** Cliente.
  * Pode, de maneira opcional, referenciar **um (1)** Atendimento para contextualização temporal e processual das informações.

## 4. Entidades de Governança

### Log de Auditoria
* **Conceito:** Mecanismo sistêmico de rastreabilidade voltado à conformidade e segurança da informação.
* **Atributos de Negócio:** Tabela Afetada, Natureza da Operação (Inclusão, Alteração, Exclusão), Estado Anterior dos Dados e Data/Hora da Ocorrência.
* **Relacionamentos:**
  * Entidade independente e passiva. Monitora os eventos de mutação de dados nas demais entidades (especialmente transacionais e financeiras) a fim de assegurar a integridade e evitar inconsistências não rastreáveis.
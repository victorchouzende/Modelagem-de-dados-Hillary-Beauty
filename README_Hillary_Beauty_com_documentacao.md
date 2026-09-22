# Hillary Beauty — Modelagem de Banco de Dados

# Integrantes do grupo

 - Tiago Stockmann Teixeira
 - Victor Chouzende
 - Carlos Eduardo Azevedo Alves
 - Davi Henrique Santos

## Sobre o Projeto

Este projeto apresenta a **modelagem de um banco de dados para a Hillary Beauty**, um studio de beleza localizado na Rua Nelson de Oliveira, 55, São Paulo — SP, Brasil.
WhatsApp: 11986194148
Instagram: _hillarybeauty

A empresa atua na área de estética e beleza e conta atualmente com **quatro profissionais** responsáveis pela realização dos procedimentos estéticos.

Atualmente, o processo de atendimento é realizado principalmente por meio de **WhatsApp e Instagram**. Os clientes entram em contato com uma das representantes, solicitam um procedimento, e a profissional verifica manualmente sua disponibilidade de agenda. Quando existe disponibilidade, o agendamento é realizado pela própria conversa e posteriormente anotado em um bloco de notas.

A empresa também não possui atualmente um sistema estruturado para:

* Cadastro de clientes;
* Controle de agendamentos;
* Controle da quantidade de atendimentos;
* Histórico dos atendimentos;
* Cadastro de produtos;
* Controle de estoque;
* Registro de entradas e saídas de produtos;
* Controle da disponibilidade das profissionais;
* Relacionamento entre clientes, profissionais e procedimentos.

Diante desse cenário, este projeto propõe uma estrutura de banco de dados capaz de **centralizar, organizar e preservar essas informações**, reduzindo problemas decorrentes do controle manual.

\---

# Objetivo do Projeto

O objetivo principal é desenvolver uma **modelagem de banco de dados estruturada** para apoiar os processos de atendimento, agendamento, cadastro de clientes, controle de profissionais, procedimentos e gerenciamento de estoque da Hillary Beauty.

O banco de dados deverá permitir que as informações sejam armazenadas de forma organizada e relacionadas entre si, possibilitando maior controle sobre as operações realizadas pela empresa.

Entre os principais objetivos estão:

* Centralizar os dados dos clientes;
* Organizar os agendamentos;
* Evitar conflitos de horários;
* Controlar os profissionais responsáveis pelos procedimentos;
* Registrar os atendimentos realizados;
* Manter o histórico de cada cliente;
* Contabilizar a quantidade de atendimentos;
* Controlar produtos utilizados nos procedimentos;
* Registrar entradas e saídas do estoque;
* Evitar estoque negativo;
* Identificar produtos próximos ou abaixo do estoque mínimo;
* Garantir maior integridade das informações.

\---

# Contexto da Empresa

**Empresa:** Hillary Beauty  
**Segmento:** Estética e beleza  
**Localização:** Rua Nelson de Oliveira, 55, São Paulo — SP, Brasil  
**Quantidade de profissionais:** 4 representantes da área de estética e beleza  
**Forma atual de agendamento:** WhatsApp e Instagram  
**Controle atual:** Conversas, agenda manual e bloco de notas  
**Controle de estoque:** Não estruturado em sistema próprio

\---

# Problema Identificado

Atualmente, os processos da Hillary Beauty são realizados de maneira pouco centralizada.

Os clientes entram em contato pelas redes sociais, principalmente WhatsApp e Instagram, para solicitar um procedimento. A profissional verifica manualmente sua disponibilidade e realiza o agendamento pela própria conversa.

Posteriormente, as informações podem ser anotadas em um bloco de notas, não existindo um banco de dados centralizado para armazenar essas informações.

Esse processo apresenta alguns riscos:

* Conflitos de horários;
* Perda de informações;
* Dificuldade para consultar agendamentos;
* Dificuldade para saber quantos atendimentos foram realizados;
* Falta de histórico organizado dos clientes;
* Ausência de cadastro estruturado dos clientes;
* Dificuldade para identificar os procedimentos realizados;
* Falta de controle sobre os produtos utilizados;
* Falta de controle sobre a quantidade disponível em estoque;
* Possibilidade de utilização de produtos sem controle da quantidade restante.

\---

# Motivo da Escolha

A Hillary Beauty foi escolhida por apresentar um cenário real em que a aplicação de um banco de dados estruturado pode contribuir significativamente para a organização dos processos da empresa.

A empresa possui processos de atendimento e gerenciamento de clientes que atualmente são realizados de forma pouco centralizada, principalmente por meio do WhatsApp e Instagram.

A existência de quatro profissionais e a necessidade de realizar atendimentos mediante agendamento tornam importante o controle dos horários disponíveis, dos profissionais responsáveis e dos procedimentos realizados.

Além disso, existe a necessidade de melhorar o controle dos produtos utilizados nos procedimentos e do estoque disponível.

A ausência de um sistema centralizado pode ocasionar conflitos de horários, perda de informações, dificuldade na consulta do histórico dos clientes e falta de controle sobre a quantidade de produtos disponíveis.

Dessa forma, a modelagem proposta busca representar e relacionar informações sobre **clientes, profissionais, procedimentos, agendamentos, atendimentos, produtos e movimentações de estoque**, proporcionando uma visão mais organizada das atividades realizadas pela empresa.

\---

# Processo Atual do Negócio

O processo atualmente ocorre da seguinte maneira:

```text
Cliente
   ↓
Contato pelo WhatsApp ou Instagram
   ↓
Solicitação de procedimento
   ↓
Profissional verifica manualmente a agenda
   ↓
Verificação da disponibilidade
   ↓
Existe disponibilidade?
   ├── NÃO → Cliente recebe outra opção de horário
   │
   └── SIM
         ↓
      Agendamento pela conversa
         ↓
      Anotação manual em bloco de notas
         ↓
      Realização do procedimento
```

O estoque segue um processo separado e sem controle estruturado:

```text
Produto utilizado
      ↓
Utilização no procedimento
      ↓
Não existe baixa automática
      ↓
Quantidade disponível não é atualizada
      ↓
Dificuldade para identificar estoque atual
```

\---

# Modelo Conceitual Proposto

O banco de dados será composto pelas seguintes entidades principais:

1. **Cliente**
2. **Profissional**
3. **Procedimento**
4. **Agendamento**
5. **Atendimento**
6. **Produto**
7. **Movimentação de Estoque**

Além dessas entidades principais, existe uma relação necessária para representar quais procedimentos cada profissional está habilitada a realizar.

Essa relação pode ser implementada por uma entidade associativa, por exemplo:

**Profissional\_Procedimento**

Essa estrutura evita armazenar vários procedimentos em um único atributo da profissional e permite representar corretamente uma relação de muitos-para-muitos.

\---

# Entidades

## 1\. Cliente

A entidade `Cliente` representa as pessoas que utilizam os serviços oferecidos pela Hillary Beauty.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_cliente`|Identificador único do cliente|Único e obrigatório|Necessário para identificar o cliente de forma única e manter a integridade dos relacionamentos no banco de dados.|
|`nome`|Nome completo do cliente|Obrigatório|Necessário para identificar corretamente o cliente nos cadastros, agendamentos e histórico de atendimentos.|
|`telefone`|Número utilizado para contato|Obrigatório|Necessário para permitir a identificação e o contato com o cliente para fins de atendimento e agendamento.|
|`data\_nascimento`|Data de nascimento|Deve ser válida||
|`data\_cadastro`|Data de cadastro|Registrada automaticamente||
|`status\_cliente`|Situação do cadastro|Ativo ou Inativo||

### Regra relacionada

Um cliente deverá estar previamente cadastrado para realizar ou agendar um procedimento.

\---

# 2\. Profissional

A entidade `Profissional` representa as quatro profissionais responsáveis pelos procedimentos estéticos e de beleza.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_profissional`|Identificador único|Único e obrigatório|Necessário para identificar a profissional de forma única e manter a integridade dos relacionamentos no banco de dados.|
|`nome`|Nome da profissional|Obrigatório|Necessário para identificar corretamente a profissional responsável por agendamentos e atendimentos.|
|`telefone`|Telefone da profissional|Deve ser válido quando informado||
|`status\_profissional`|Situação profissional|Ativa ou Inativa||
|`especialidade`|Área de atuação|Relacionada aos procedimentos habilitados||

### Regra relacionada

Uma profissional somente poderá receber um agendamento para procedimentos que esteja habilitada a realizar.

Profissionais inativas não poderão receber novos agendamentos.

\---

# 3\. Procedimento Estetico

A entidade `Procedimento` representa os serviços estéticos e de beleza oferecidos pela empresa.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_procedimento`|Identificador único|Único e obrigatório|Necessário para identificar o procedimento de forma única e manter a integridade dos relacionamentos no banco de dados.|
|`nome`|Nome do procedimento|Obrigatório|Necessário para identificar corretamente o serviço oferecido e permitir sua utilização nos agendamentos e atendimentos.|
|`descricao`|Descrição do procedimento|Opcional||
|`duracao`|Tempo estimado do procedimento|Obrigatório|Necessário para calcular o horário de término e verificar conflitos de agenda.|
|`valor`|Valor cobrado|Maior ou igual a zero||
|`status\_procedimento`|Situação do procedimento|Ativo ou Inativo||

### Regra relacionada

O procedimento deverá estar cadastrado e ativo para poder ser agendado.

A duração do procedimento será utilizada para determinar o horário de término do agendamento.

\---

# 4\. Agendamento

A entidade `Agendamento` representa a reserva de um horário para que determinado cliente realize um procedimento com uma profissional.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_agendamento`|Identificador único|Único e obrigatório|Necessário para identificar cada agendamento de forma única e manter seus relacionamentos no banco de dados.|
|`id\_cliente`|Cliente relacionado|Obrigatório|Necessário para identificar quem realizará o procedimento e manter o vínculo do agendamento com o cliente.|
|`id\_profissional`|Profissional responsável|Obrigatório|Necessário para identificar quem realizará o procedimento e verificar sua disponibilidade e habilitação.|
|`id\_procedimento`|Procedimento solicitado|Obrigatório|Necessário para identificar qual serviço será realizado e determinar sua duração e demais regras.|
|`data\_agendamento`|Data do procedimento|Obrigatória|Necessária para definir quando o procedimento ocorrerá e permitir o controle da agenda.|
|`horario\_inicio`|Horário de início|Obrigatório|Necessário para reservar o período correto na agenda e evitar conflitos de horários.|
|`horario\_fim`|Horário de término|Compatível com a duração||
|`status\_agendamento`|Situação do agendamento|Agendado, Confirmado, Realizado, Cancelado ou Não Compareceu||
|`observacao`|Informações adicionais|Opcional||

### Regras relacionadas

* O cliente deve estar cadastrado.
* A profissional deve estar ativa.
* A profissional deve estar habilitada para o procedimento.
* O procedimento deve estar ativo.
* A profissional deve estar disponível.
* Não podem existir horários conflitantes.
* Alterações de horário devem passar novamente pela verificação de disponibilidade.
* Cancelamentos devem liberar o horário.

\---

# 5\. Atendimento

A entidade `Atendimento` representa um procedimento que foi efetivamente realizado.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_atendimento`|Identificador único|Único e obrigatório|Necessário para identificar cada atendimento de forma única e manter seu histórico e relacionamentos.|
|`id\_agendamento`|Agendamento relacionado|Obrigatório|Necessário para comprovar a origem do atendimento e garantir que ele esteja vinculado a um agendamento existente.|
|`id\_cliente`|Cliente atendido|Deve corresponder ao agendamento||
|`id\_profissional`|Profissional responsável|Deve corresponder ao agendamento||
|`id\_procedimento`|Procedimento realizado|Deve corresponder ao agendamento||
|`data\_atendimento`|Data do atendimento|Obrigatória|Necessária para registrar quando o serviço foi efetivamente realizado e manter o histórico cronológico.|
|`horario\_atendimento`|Horário do atendimento|Compatível com o agendamento||
|`observacao`|Observações do atendimento|Opcional||

### Regras relacionadas

Um atendimento somente poderá ser registrado quando existir um agendamento correspondente.

Os atendimentos realizados deverão permanecer registrados para formar o histórico do cliente.

Somente atendimentos efetivamente realizados deverão ser contabilizados na quantidade total de atendimentos.

\---

# 6\. Produto

A entidade `Produto` representa os produtos utilizados durante os procedimentos.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_produto`|Identificador único|Único e obrigatório|Necessário para identificar o produto de forma única e manter a integridade das movimentações de estoque.|
|`nome`|Nome do produto|Obrigatório|Necessário para identificar corretamente o produto utilizado e permitir seu controle no estoque.|
|`descricao`|Características do produto|Opcional||
|`unidade\_medida`|Unidade de controle|Ex.: unidade, ml, g||
|`quantidade\_atual`|Quantidade disponível|Nunca pode ser negativa||
|`estoque\_minimo`|Limite mínimo|Maior ou igual a zero||
|`status\_produto`|Situação do produto|Ativo ou Inativo||

### Regras relacionadas

* O produto deverá estar cadastrado.
* A quantidade nunca poderá ser negativa.
* Produtos inativos não deverão receber novas movimentações de utilização.
* O sistema deverá sinalizar produtos abaixo ou no estoque mínimo.

\---

# 7\. Movimentação de Estoque

A entidade `Movimentacao\_Estoque` representa as entradas e saídas dos produtos.

### Atributos

|Atributo|Descrição|Regra|Motivo da obrigatoriedade|
|-|-|-|-|
|`id\_movimentacao`|Identificador único|Único e obrigatório|Necessário para identificar cada movimentação de estoque de forma única e preservar seu histórico.|
|`id\_produto`|Produto movimentado|Obrigatório|Necessário para identificar qual produto teve sua quantidade alterada e manter a integridade do estoque.|
|`tipo\_movimentacao`|Entrada ou saída|Valores controlados||
|`quantidade`|Quantidade movimentada|Maior que zero||
|`data\_movimentacao`|Data da movimentação|Obrigatória|Necessária para registrar quando a alteração de estoque ocorreu e manter o histórico das movimentações.|
|`motivo`|Justificativa da movimentação|Informado quando necessário||
|`id\_atendimento`|Atendimento relacionado|Obrigatório quando a saída estiver ligada ao procedimento|Necessário para rastrear a utilização do produto ao atendimento que originou a saída e preservar a rastreabilidade do estoque.|

### Regras relacionadas

Uma entrada deverá aumentar a quantidade disponível.

Uma saída deverá reduzir a quantidade disponível.

Uma saída somente poderá ocorrer quando houver quantidade suficiente em estoque.

\---

# Relacionamentos

## Cliente → Agendamento

Um cliente pode realizar vários agendamentos.

Um agendamento pertence obrigatoriamente a um cliente.

**Cardinalidade:**

```text
Cliente 1 ───────── N Agendamento
```

\---

## Profissional → Agendamento

Uma profissional pode possuir vários agendamentos.

Cada agendamento possui uma única profissional responsável.

**Cardinalidade:**

```text
Profissional 1 ───────── N Agendamento
```

\---

## Procedimento → Agendamento

Um procedimento pode aparecer em diversos agendamentos.

Cada agendamento corresponde a um único procedimento.

**Cardinalidade:**

```text
Procedimento 1 ───────── N Agendamento
```

\---

## Agendamento → Atendimento

Um agendamento poderá resultar em um atendimento realizado.

O atendimento deverá estar relacionado a um agendamento existente.

**Cardinalidade proposta:**

```text
Agendamento 1 ───────── 0..1 Atendimento
```

O `0..1` é importante porque um agendamento pode ser cancelado ou resultar em não comparecimento e, nesses casos, não haverá atendimento realizado.

\---

## Cliente → Atendimento

Um cliente pode possuir vários atendimentos ao longo do tempo.

Cada atendimento pertence a um único cliente.

**Cardinalidade:**

```text
Cliente 1 ───────── N Atendimento
```

\---

## Profissional → Atendimento

Uma profissional pode realizar diversos atendimentos.

Cada atendimento possui uma única profissional responsável.

**Cardinalidade:**

```text
Profissional 1 ───────── N Atendimento
```

\---

## Procedimento → Atendimento

Um procedimento pode ser realizado várias vezes.

Cada atendimento corresponde a um único procedimento.

**Cardinalidade:**

```text
Procedimento 1 ───────── N Atendimento
```

\---

## Produto → Movimentação de Estoque

Um produto pode possuir diversas movimentações.

Cada movimentação pertence a um único produto.

**Cardinalidade:**

```text
Produto 1 ───────── N Movimentação\_Estoque
```

\---

## Atendimento → Movimentação de Estoque

Um atendimento pode gerar uma ou várias saídas de produtos.

Uma movimentação de estoque poderá estar associada a um atendimento quando a movimentação ocorrer devido à utilização de produto em um procedimento.

**Cardinalidade:**

```text
Atendimento 1 ───────── N Movimentação\_Estoque
```

Uma movimentação de entrada não precisa estar relacionada a um atendimento.

\---

# Profissional × Procedimento

Uma profissional pode estar habilitada para realizar vários procedimentos.

Um procedimento também pode ser realizado por várias profissionais.

Portanto, existe uma relação **N:N (muitos-para-muitos)**.

Para representar essa relação adequadamente, recomenda-se utilizar uma entidade associativa:

## Profissional\_Procedimento

|Atributo|Descrição|
|-|-|
|`id\_profissional`|Profissional habilitada|
|`id\_procedimento`|Procedimento que pode realizar|

A chave primária poderá ser composta por:

```text
(id\_profissional, id\_procedimento)
```

### Cardinalidade

```text
Profissional 1 ─── N Profissional\_Procedimento N ─── 1 Procedimento
```

Essa estrutura permite verificar se uma determinada profissional está habilitada para realizar o procedimento antes que um agendamento seja confirmado.

\---

# Resumo das Entidades

|Entidade|Finalidade|
|-|-|
|**Cliente**|Armazenar os dados e informações dos clientes|
|**Profissional**|Controlar as quatro profissionais e seus dados|
|**Procedimento**|Cadastrar os serviços oferecidos|
|**Profissional\_Procedimento**|Controlar quais procedimentos cada profissional pode realizar|
|**Agendamento**|Controlar datas, horários, clientes, profissionais e procedimentos|
|**Atendimento**|Registrar os procedimentos efetivamente realizados|
|**Produto**|Cadastrar e acompanhar os produtos utilizados|
|**Movimentação\_Estoque**|Registrar entradas e saídas dos produtos|

\---

# Requisitos do Sistema

## 1\. Cadastro de Clientes

O sistema deverá permitir cadastrar, consultar, alterar e excluir clientes, armazenando informações como:

* Nome;
* Telefone;
* Data de nascimento;
* Data de cadastro;
* Status do cliente;
* Histórico de atendimentos.

\---

## 2\. Gerenciamento de Agendamentos

O sistema deverá permitir realizar agendamentos informando:

* Cliente;
* Procedimento;
* Profissional;
* Data;
* Horário.

O sistema deverá verificar automaticamente a disponibilidade da profissional e impedir conflitos de horários.

\---

## 3\. Controle de Atendimentos

O sistema deverá registrar cada atendimento realizado, relacionando:

* Cliente;
* Profissional;
* Procedimento;
* Agendamento;
* Data;
* Horário.

Também deverá permitir consultar o histórico e a quantidade de atendimentos realizados.

\---

## 4\. Controle de Estoque

O sistema deverá permitir:

* Cadastrar produtos;
* Registrar entradas;
* Registrar saídas;
* Atualizar automaticamente a quantidade disponível;
* Identificar estoque baixo;
* Impedir estoque negativo;
* Relacionar utilização de produtos aos atendimentos.

\---

# Requisitos Funcionais

### RF01 — Cadastro de clientes

O sistema deve permitir cadastrar, consultar, alterar e excluir clientes, armazenando seus dados pessoais e informações de contato.

### RF02 — Gerenciamento de agendamentos

O sistema deve permitir registrar um agendamento informando cliente, procedimento, profissional, data e horário, verificando automaticamente a disponibilidade da agenda.

### RF03 — Registro de atendimentos

O sistema deve permitir registrar um atendimento realizado, vinculando o cliente, profissional, procedimento e agendamento, mantendo um histórico dos atendimentos.

### RF04 — Controle de estoque

O sistema deve permitir cadastrar produtos e registrar suas entradas e saídas, atualizando automaticamente a quantidade disponível em estoque.

\---

# Requisitos Não Funcionais

## RNF01 — Desempenho

O sistema deve responder às consultas e operações realizadas pelo usuário em até **3 segundos**, mesmo durante o acesso simultâneo de diferentes profissionais.

## RNF02 — Segurança

O sistema deve proteger os dados dos clientes e usuários por meio de autenticação com login e senha.

Somente usuários autorizados deverão ter acesso às informações do sistema.

## RNF03 — Usabilidade

O sistema deve possuir uma interface simples, intuitiva e responsiva.

As profissionais devem conseguir realizar cadastros, agendamentos, registros de atendimentos e consultas de estoque de maneira rápida e fácil.

## RNF04 — Disponibilidade e Integridade

O sistema deve estar disponível durante o horário de funcionamento da Hillary Beauty.

Os dados devem ser armazenados de maneira segura, evitando perda ou inconsistência das informações.

\---

# Regras de Negócio

## Cadastro de Clientes

Todo cliente que realizar ou agendar um procedimento deverá estar previamente cadastrado no sistema.

O cadastro deverá conter, no mínimo:

* Nome;
* Telefone;
* Data de nascimento.

\---

## Cadastro de Profissionais

Cada profissional deverá possuir um cadastro individual.

O sistema deverá manter informações de identificação e os procedimentos que a profissional está habilitada a realizar.

\---

## Cadastro de Procedimentos

Todo procedimento oferecido pela empresa deverá estar cadastrado.

O cadastro deverá conter:

* Nome;
* Descrição;
* Duração;
* Valor, quando aplicável;
* Status.

\---

## Agendamento

Todo agendamento deverá estar obrigatoriamente vinculado a:

* Um cliente;
* Uma profissional;
* Um procedimento;
* Uma data;
* Um horário.

\---

## Disponibilidade da Profissional

Uma profissional não poderá possuir dois agendamentos conflitantes no mesmo período.

O sistema deverá verificar automaticamente a disponibilidade antes de confirmar um novo agendamento.

\---

## Profissional Habilitada

Um procedimento somente poderá ser agendado com uma profissional que esteja habilitada a realizá-lo.

\---

## Status do Agendamento

Todo agendamento deverá possuir um status.

Os status possíveis são:

* Agendado;
* Confirmado;
* Realizado;
* Cancelado;
* Não Compareceu.

\---

## Registro do Atendimento

Um atendimento somente poderá ser registrado como realizado quando estiver relacionado a um agendamento existente.

\---

## Histórico do Cliente

Todos os atendimentos realizados deverão permanecer registrados no histórico do cliente.

O histórico deverá permitir consultar:

* Procedimentos realizados;
* Datas;
* Horários;
* Profissionais responsáveis.

\---

## Contabilização dos Atendimentos

O sistema deverá permitir contabilizar a quantidade de atendimentos realizados.

As consultas poderão ser realizadas por:

* Cliente;
* Profissional;
* Procedimento;
* Período;
* Empresa.

Somente atendimentos efetivamente realizados deverão ser contabilizados.

\---

## Cadastro de Produtos

Todo produto utilizado nos procedimentos deverá possuir cadastro no sistema.

O cadastro deverá conter:

* Nome;
* Descrição;
* Unidade de medida;
* Quantidade disponível;
* Estoque mínimo;
* Status.

\---

## Entrada de Produtos

Toda entrada de produto deverá ser registrada.

Após a entrada, a quantidade disponível deverá ser aumentada automaticamente.

\---

## Saída de Produtos

Toda utilização de produto durante um procedimento deverá gerar uma saída correspondente no estoque.

A quantidade disponível deverá ser reduzida automaticamente.

\---

## Estoque Negativo

O sistema não poderá permitir que a quantidade disponível de um produto fique abaixo de zero.

\---

## Estoque Mínimo

Cada produto poderá possuir uma quantidade mínima definida.

Quando o estoque atingir ou ficar abaixo desse limite, o sistema deverá sinalizar a necessidade de reposição.

\---

## Cancelamento

Quando um agendamento for cancelado, o horário da profissional deverá ficar disponível novamente para novos agendamentos.

Um agendamento cancelado não poderá posteriormente ser registrado como atendimento realizado.

\---

## Alteração de Agendamento

Qualquer alteração de data ou horário deverá realizar novamente a verificação de disponibilidade da profissional.

\---

## Integridade dos Registros

O sistema deverá manter os relacionamentos entre:

* Clientes;
* Profissionais;
* Procedimentos;
* Agendamentos;
* Atendimentos;
* Produtos;
* Movimentações de estoque.

Não deverão existir registros sem as informações necessárias para manter a integridade do banco.

\---

# Regras Operacionais

### RO01 — Cadastro obrigatório do cliente

Um agendamento só poderá ser realizado se o cliente estiver previamente cadastrado.

### RO02 — Agendamento condicionado à disponibilidade

Um procedimento somente poderá ser agendado se a profissional responsável estiver disponível na data e horário solicitados.

### RO03 — Impedimento de conflito de horários

Uma profissional não poderá possuir dois agendamentos conflitantes.

### RO04 — Profissional habilitada

Um procedimento somente poderá ser agendado com uma profissional habilitada.

### RO05 — Dados obrigatórios

Um agendamento somente poderá ser confirmado quando possuir:

* Cliente;
* Profissional;
* Procedimento;
* Data;
* Horário.

### RO06 — Registro do atendimento

Um atendimento somente poderá ser registrado após existir um agendamento correspondente.

### RO07 — Histórico de atendimento

Todo atendimento realizado deverá ser registrado no histórico do respectivo cliente.

### RO08 — Alteração de agendamento

Uma alteração de data ou horário somente poderá ser realizada quando o novo horário estiver disponível.

### RO09 — Cancelamento

Um agendamento cancelado não poderá ser registrado como atendimento realizado e deverá liberar o horário da profissional.

### RO10 — Registro de produtos

Um produto somente poderá ser utilizado no controle de estoque se estiver previamente cadastrado.

### RO11 — Saída de estoque

A utilização de um produto deverá gerar uma saída correspondente no estoque.

### RO12 — Disponibilidade de estoque

Um produto somente poderá ser utilizado se houver quantidade suficiente disponível.

### RO13 — Proibição de estoque negativo

Uma saída não poderá ser registrada quando a quantidade solicitada for superior à quantidade disponível.

### RO14 — Entrada de estoque

Uma entrada deverá aumentar automaticamente a quantidade disponível.

### RO15 — Alerta de estoque baixo

Quando a quantidade atingir ou ficar abaixo do estoque mínimo, o sistema deverá sinalizar a necessidade de reposição.

### RO16 — Contabilização

Somente atendimentos registrados como realizados deverão ser contabilizados.

### RO17 — Responsabilidade pelo atendimento

Cada atendimento deverá estar associado a uma única profissional responsável.

### RO18 — Integridade das informações

Um registro não deverá ser excluído caso sua exclusão provoque perda de informações necessárias para manter o histórico de agendamentos, atendimentos ou movimentações de estoque.

\---



\---

# Chaves Primárias e Estrangeiras

## Cliente

```text
PK: id\_cliente
```

## Profissional

```text
PK: id\_profissional
```

## Procedimento

```text
PK: id\_procedimento
```

## Profissional\_Procedimento

```text
PK: id\_profissional + id\_procedimento

FK: id\_profissional → Profissional
FK: id\_procedimento → Procedimento
```

## Agendamento

```text
PK: id\_agendamento

FK: id\_cliente → Cliente
FK: id\_profissional → Profissional
FK: id\_procedimento → Procedimento
```

## Atendimento

```text
PK: id\_atendimento

FK: id\_agendamento → Agendamento
FK: id\_cliente → Cliente
FK: id\_profissional → Profissional
FK: id\_procedimento → Procedimento
```

## Produto

```text
PK: id\_produto
```

## Movimentação\_Estoque

```text
PK: id\_movimentacao

FK: id\_produto → Produto
FK: id\_atendimento → Atendimento
```

\---

# Cardinalidades

|Relacionamento|Cardinalidade|
|-|-|
|Cliente → Agendamento|1:N|
|Profissional → Agendamento|1:N|
|Procedimento → Agendamento|1:N|
|Agendamento → Atendimento|1:0..1|
|Cliente → Atendimento|1:N|
|Profissional → Atendimento|1:N|
|Procedimento → Atendimento|1:N|
|Produto → Movimentação|1:N|
|Atendimento → Movimentação|1:N|
|Profissional ↔ Procedimento|N:N|

\---

# Justificativa da Modelagem

A modelagem foi estruturada dessa maneira porque cada entidade representa uma informação ou conceito importante para o funcionamento da Hillary Beauty.

A entidade **Cliente** é necessária porque o sistema precisa manter informações de identificação e contato das pessoas atendidas. Sem ela, não seria possível construir um histórico confiável de atendimentos ou relacionar um agendamento a uma pessoa específica.

A entidade **Profissional** foi criada para representar individualmente as quatro profissionais da empresa. Isso permite saber quem é responsável por cada agendamento e atendimento, além de possibilitar o controle da disponibilidade de cada profissional.

A entidade **Procedimento** representa os serviços oferecidos pela empresa. Separá-la da entidade profissional evita repetir informações como nome, duração e valor em cada agendamento.

A entidade **Profissional\_Procedimento** é utilizada porque uma profissional pode realizar diversos procedimentos e um mesmo procedimento pode ser realizado por várias profissionais. Dessa forma, a relação N:N é representada corretamente sem armazenar múltiplos valores dentro de um único campo.

A entidade **Agendamento** representa uma reserva futura de horário. Ela é separada do atendimento porque um agendamento não significa necessariamente que o procedimento foi realizado. O cliente pode cancelar ou não comparecer, por exemplo.

A entidade **Atendimento** representa o fato de o procedimento ter sido efetivamente realizado. Essa separação permite manter o histórico real dos serviços prestados e contabilizar corretamente os atendimentos.

A entidade **Produto** representa os itens utilizados nos procedimentos, enquanto a entidade **Movimentação\_Estoque** registra as entradas e saídas. Essa separação permite manter um histórico das movimentações em vez de simplesmente alterar a quantidade atual e perder a informação sobre o que aconteceu anteriormente.

\---

# Controle de Estoque

O estoque será controlado por meio de movimentações.

### Entrada

```text
Produto
   ↓
Movimentação
   ↓
Tipo = ENTRADA
   ↓
Quantidade aumenta
```

### Saída

```text
Atendimento
   ↓
Produto utilizado
   ↓
Movimentação
   ↓
Tipo = SAÍDA
   ↓
Quantidade diminui
```

### Exemplo

Supondo que a Hillary Beauty possua:

```text
Produto: Creme Facial
Quantidade atual: 10 unidades
```

Durante um atendimento foram utilizadas 2 unidades:

```text
Quantidade anterior: 10
Saída: 2
Quantidade atual: 8
```

O sistema deverá impedir uma nova saída de quantidade superior ao estoque disponível.

\---

# Controle de Agendamento

O sistema deverá verificar conflitos de horários.

Por exemplo:

```text
Profissional: Ana
Data: 10/09/2026
Horário: 14:00 - 15:00
```

Se já existir outro agendamento da mesma profissional que ocupe esse período, o sistema deverá impedir o novo agendamento.

O controle deve considerar não somente o horário inicial, mas também a **duração do procedimento e o horário final**.

Isso evita situações como:

```text
Agendamento 1
14:00 ───────── 15:00

Agendamento 2
14:30 ───────── 15:30

          CONFLITO
```

\---

# Consultas que o Banco Deverá Permitir

A modelagem permite futuramente criar consultas como:

### Quantidade de atendimentos por profissional

```text
Profissional | Atendimentos
-------------|-------------
Ana          | 25
Maria        | 31
Joana        | 19
Carla        | 27
```

### Atendimentos por procedimento

```text
Procedimento          | Quantidade
----------------------|-----------
Limpeza de pele       | 32
Design de sobrancelha | 18
Procedimento X        | 15
```

### Histórico do cliente

```text
Cliente: Maria Silva

Data       Procedimento       Profissional
---------- ------------------ -------------
02/09/2026 Limpeza de pele    Ana
15/09/2026 Procedimento X     Maria
```

### Produtos com estoque baixo

```text
Produto       Atual    Mínimo
------------- -------- -------
Creme Facial  3        5
Máscara X     2        3
```

\---

# Integridade e Segurança dos Dados

O banco de dados deverá utilizar chaves primárias e estrangeiras para manter os relacionamentos entre as entidades.

As chaves estrangeiras deverão impedir que sejam criados registros apontando para clientes, profissionais, procedimentos, produtos ou atendimentos inexistentes.

Também deverão ser utilizadas restrições para:

* Impedir quantidade negativa no estoque;
* Impedir quantidades de movimentação iguais ou menores que zero;
* Garantir campos obrigatórios;
* Controlar status;
* Evitar registros órfãos;
* Preservar o histórico dos atendimentos;
* Preservar movimentações de estoque;
* Evitar conflitos de agendamento.

\---

\---

# Benefícios Esperados

A implementação dessa modelagem poderá proporcionar à Hillary Beauty:

* Maior organização dos dados;
* Centralização das informações;
* Redução de erros manuais;
* Redução de conflitos de horários;
* Melhor controle da agenda;
* Identificação da profissional responsável;
* Histórico completo dos clientes;
* Contabilização dos atendimentos;
* Controle das entradas e saídas de produtos;
* Identificação de estoque baixo;
* Prevenção de estoque negativo;
* Maior segurança das informações;
* Facilidade para consultas e relatórios;
* Maior eficiência na gestão da empresa.

\---

# Conclusão

A modelagem proposta para a Hillary Beauty busca solucionar problemas existentes no processo atual de atendimento e gerenciamento da empresa.

A utilização de um banco de dados estruturado permitirá substituir o controle descentralizado realizado por WhatsApp, Instagram, conversas e anotações manuais por uma estrutura organizada e integrada.

As entidades **Cliente, Profissional, Procedimento, Agendamento, Atendimento, Produto e Movimentação de Estoque**, juntamente com a relação **Profissional\_Procedimento**, permitem representar os principais processos do negócio.

A separação entre **agendamento e atendimento** permite diferenciar aquilo que foi planejado daquilo que realmente foi realizado. Da mesma forma, a separação entre **produto e movimentação de estoque** possibilita controlar a quantidade atual e manter o histórico das entradas e saídas.

Com isso, a modelagem fornece uma base adequada para o desenvolvimento futuro de um sistema de gerenciamento da Hillary Beauty, permitindo maior controle sobre os atendimentos, profissionais, clientes, procedimentos e estoque.



\---

# Documentação do Uso de Inteligência Artificial

## 1\. Ferramenta e etapa

Durante o desenvolvimento do projeto de modelagem de banco de dados da Hillary Beauty, foi utilizada uma ferramenta de inteligência artificial generativa, o ChatGPT, como recurso de apoio em diferentes etapas do trabalho.

A ferramenta foi utilizada principalmente para organizar as informações fornecidas pelo grupo, estruturar os requisitos do sistema, auxiliar na identificação de entidades, atributos e relacionamentos, definir cardinalidades, organizar regras de negócio e revisar a redação da documentação.

As principais etapas em que a IA foi utilizada foram:

|Etapa|Utilização da IA|
|-|-|
|Levantamento do problema|Organização e estruturação das informações sobre os problemas atuais da empresa|
|Organização do projeto|Estruturação do contexto, objetivo e justificativa da escolha da Hillary Beauty|
|Modelagem conceitual|Identificação e organização das entidades, atributos e relacionamentos|
|Cardinalidades|Apoio na definição das relações 1:N, 1:0..1 e N:N|
|Requisitos|Estruturação dos requisitos do sistema e requisitos funcionais|
|Requisitos não funcionais|Organização dos requisitos relacionados a desempenho, segurança, usabilidade e disponibilidade|
|Regras de negócio|Transformação das necessidades do negócio em regras que o sistema deverá obedecer|
|Regras operacionais|Organização das restrições operacionais do sistema|
|Estrutura relacional|Organização das chaves primárias, chaves estrangeiras e tabelas|
|Justificativa da modelagem|Apoio na explicação das decisões tomadas na abstração dos dados|
|Revisão textual|Organização, padronização e correção da documentação|

A documentação final apresenta as entidades **Cliente, Profissional, Procedimento, Agendamento, Atendimento, Produto e Movimentação de Estoque**, além da entidade associativa **Profissional\_Procedimento**.

## 2\. Motivação

A utilização da IA teve como principal objetivo auxiliar o grupo na organização e estruturação das informações levantadas sobre a Hillary Beauty, transformando os problemas identificados no funcionamento da empresa em elementos que pudessem ser representados em um banco de dados.

A empresa realiza atualmente grande parte dos seus processos por meio de WhatsApp e Instagram, com verificação manual da agenda e anotações posteriores em bloco de notas.

Diante disso, a IA foi utilizada como ferramenta de apoio para:

* Organizar as informações coletadas;
* Transformar problemas em necessidades de sistema;
* Estruturar requisitos funcionais e não funcionais;
* Identificar entidades e relacionamentos;
* Auxiliar na definição das cardinalidades;
* Organizar as regras de negócio;
* Revisar e padronizar a documentação.

A intenção não foi substituir a análise do grupo, mas utilizar a IA como ferramenta de apoio à organização, elaboração e revisão do trabalho.

## 3\. Prompt(s) utilizados

O arquivo final não contém um histórico completo dos prompts utilizados. Portanto, não é possível afirmar que os textos abaixo sejam uma transcrição literal dos prompts originais.

Considerando o conteúdo produzido no README e as etapas de elaboração do projeto, os pedidos utilizados podem ser documentados de forma muito próxima aos comandos empregados no desenvolvimento.

### Prompt relacionado à escolha e justificativa da empresa

> Com base nessas informações sobre a Hillary Beauty, faça a justificativa da escolha da empresa para um trabalho de modelagem de banco de dados, explicando os problemas atuais e por que um banco de dados seria importante para a empresa.

### Prompt relacionado ao processo atual

> Com base nas informações fornecidas, monte o fluxo do processo atual de atendimento e agendamento da Hillary Beauty, considerando que o cliente entra em contato pelo WhatsApp ou Instagram, a profissional verifica a disponibilidade e o agendamento é anotado manualmente.

### Prompt relacionado às necessidades do sistema

> Com base nessas informações, indique 4 requisitos de sistema necessários para uma modelagem de banco de dados que automatize o registro dos processos da Hillary Beauty.

### Prompt relacionado aos requisitos funcionais

> Agora, com os mesmos requisitos, apresente 4 requisitos funcionais que o sistema deve possuir, seguindo o formato "o sistema deve permitir...".

### Prompt relacionado aos requisitos não funcionais

> Com a mesma base de informações, apresente os requisitos não funcionais do sistema, considerando desempenho, segurança, usabilidade e disponibilidade.

### Prompt relacionado às regras de negócio

> Com base nas informações da Hillary Beauty, crie as regras de negócio e regras operacionais que o sistema deverá seguir, incluindo agendamento, profissionais, procedimentos, atendimento e controle de estoque.

### Prompt relacionado à modelagem

> Com base em todas essas informações, identifique as entidades, atributos, relacionamentos e cardinalidades necessários para criar o modelo conceitual do banco de dados da Hillary Beauty.

### Prompt relacionado à justificativa da modelagem

> Explique e defenda as decisões de abstração e modelagem tomadas: por que essas entidades, esses atributos, esses relacionamentos e essas cardinalidades, e não outras alternativas possíveis? Faça de forma cordial e sem tópicos.

**Observação:** os prompts acima representam uma reconstrução aproximada das solicitações realizadas. Eles não devem ser considerados uma transcrição literal de todo o histórico de conversas caso o grupo não possua esse histórico registrado.

## 4\. Resposta recebida

A IA auxiliou na construção de uma modelagem que centraliza os principais processos da empresa.

Entre os principais resultados estão:

* Identificação da entidade **Cliente**;
* Identificação da entidade **Profissional**;
* Identificação da entidade **Procedimento**;
* Criação da entidade **Agendamento**;
* Criação da entidade **Atendimento**;
* Criação da entidade **Produto**;
* Criação da entidade **Movimentação\_Estoque**;
* Criação da entidade associativa **Profissional\_Procedimento**.

A entidade associativa foi utilizada porque uma profissional pode realizar vários procedimentos e um procedimento pode ser realizado por várias profissionais, caracterizando uma relação N:N.

A IA também auxiliou na separação entre **Agendamento** e **Atendimento**, permitindo diferenciar aquilo que foi planejado daquilo que realmente aconteceu.

Outro resultado foi a separação entre **Produto** e **Movimentação\_Estoque**, permitindo controlar a quantidade atual e manter o histórico das entradas e saídas.

Além disso, foram estruturados requisitos funcionais, requisitos não funcionais, regras de negócio, regras operacionais, chaves primárias, chaves estrangeiras e cardinalidades para a modelagem.

## 5\. Fontes consultadas e verificadas

De acordo com o arquivo analisado, não foram registradas fontes externas consultadas pela IA.

As informações utilizadas na modelagem tiveram como base o cenário da Hillary Beauty fornecido para o desenvolvimento do projeto.

O documento registra, por exemplo, que:

* A empresa atua no segmento de estética e beleza;
* Possui quatro profissionais;
* Utiliza WhatsApp e Instagram para agendamento;
* Utiliza controle manual;
* Não possui controle estruturado de estoque.

Também não há, no arquivo, indicação de links, artigos, legislação ou bases externas utilizadas para justificar a modelagem.

Portanto:

> Não foram registradas fontes externas utilizadas pela IA no desenvolvimento da documentação. As informações sobre o funcionamento da empresa foram baseadas no cenário fornecido ao grupo e utilizadas como referência para a modelagem.

Não devem ser atribuídas à IA fontes ou dados externos que não estejam efetivamente registrados e verificados pelo grupo.

## 6\. Trechos rejeitados ou corrigidos

O README final não possui um histórico de versões que permita identificar exatamente quais respostas da IA foram rejeitadas.

Assim, não é possível apontar literalmente quais trechos foram descartados.

Entretanto, a estrutura final demonstra que as sugestões foram analisadas e adaptadas ao contexto específico da Hillary Beauty, em vez de simplesmente utilizar uma estrutura genérica de banco de dados.

Um exemplo importante é a criação de **Profissional\_Procedimento**. Em vez de colocar vários procedimentos diretamente dentro do cadastro da profissional, a documentação utiliza uma entidade associativa para representar corretamente o relacionamento N:N.

Outro exemplo é a separação entre agendamento e atendimento. O documento não considera que todo agendamento necessariamente resulte em atendimento, estabelecendo a cardinalidade **1:0..1**.

Dessa forma, registra-se que:

> As sugestões geradas pela IA foram analisadas e adaptadas pelo grupo conforme o cenário apresentado. Não foi mantido um registro separado de todos os trechos rejeitados ou corrigidos, portanto não é possível apresentar uma relação exata das sugestões descartadas.

## 7\. Justificativa da escolha final

A solução final foi mantida porque consegue representar os principais processos identificados na Hillary Beauty.

A entidade **Cliente** permite armazenar os dados das pessoas atendidas. A entidade **Profissional** representa individualmente as quatro profissionais. A entidade **Procedimento** representa os serviços oferecidos.

A entidade **Agendamento** foi separada de **Atendimento** porque o agendamento representa uma reserva futura, enquanto o atendimento representa aquilo que efetivamente foi realizado. Dessa forma, cancelamentos e não comparecimentos não são confundidos com atendimentos efetivamente realizados.

A relação **Profissional\_Procedimento** foi mantida para representar corretamente quais procedimentos cada profissional pode executar, evitando colocar vários valores em um único atributo.

Para o estoque, a utilização de **Produto** juntamente com **Movimentação\_Estoque** permite controlar entradas e saídas sem perder o histórico das movimentações.

Dessa maneira, a estrutura final atende diretamente aos problemas identificados no cenário da empresa, principalmente a falta de centralização dos clientes, agendamentos, atendimentos e estoque.

## 8\. Reflexão crítica sobre o uso da IA

A utilização da IA trouxe benefícios principalmente na organização das informações e na estruturação da documentação, mas suas respostas não devem ser consideradas automaticamente corretas.

Um dos principais limites é que uma IA pode sugerir estruturas genéricas que não necessariamente correspondem à realidade da empresa. Por isso, as entidades, atributos, relacionamentos e regras precisam ser analisados pelo grupo antes de serem incorporados ao modelo.

No caso da Hillary Beauty, foi necessário considerar especificamente que existem quatro profissionais, que os agendamentos são realizados atualmente por WhatsApp e Instagram e que existe uma deficiência no controle de estoque.

Outro ponto crítico é a possibilidade de a IA criar informações que não foram efetivamente observadas. Por esse motivo, dados fictícios, exemplos e sugestões da IA não devem ser tratados como fatos reais da empresa sem validação.

Também é necessário analisar criticamente as regras propostas. O documento, por exemplo, estabelece que uma saída de estoque somente pode ocorrer quando houver quantidade suficiente disponível e que o sistema não pode permitir estoque negativo. Essas regras fazem sentido para o modelo proposto, mas devem ser confirmadas de acordo com o funcionamento real do negócio.

Assim, a IA foi utilizada como **ferramenta de apoio**, e não como fonte absoluta de verdade. A responsabilidade pela seleção das informações, validação das regras e decisão final sobre a estrutura do banco de dados permanece com o grupo.

## Conclusão sobre o uso da IA

A inteligência artificial contribuiu para tornar a documentação mais organizada e facilitar a transformação das necessidades identificadas no negócio em elementos de uma modelagem de banco de dados.

Entretanto, o grupo manteve a responsabilidade pelas decisões finais, realizando análise crítica das sugestões recebidas e adequando-as ao contexto da Hillary Beauty.

O uso da IA, portanto, ocorreu de forma complementar ao trabalho do grupo, servindo como instrumento de apoio para pesquisa interna do problema apresentado, organização, redação, revisão e estruturação da modelagem.


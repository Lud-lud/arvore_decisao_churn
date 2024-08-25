<img src='https://raw.githubusercontent.com/Lud-lud/arvore_decisao_churn/main/capa_projeto_tmw_med.png' alt="Capa do projeto">


# Previsão de churn de um canal na Twitch

O objetivo deste projeto é analisar o perfil dos assinantes de realizam do canal educativo Teo Me Why na Twitch e treinar um modelo de machine learning que estime a probabilidade de churn dos inscritos.

Foi utilizado o framework Crisp-DM como orientador do passo-a-passo necessário para desenvolver este projeto.

<img src='https://raw.githubusercontent.com/Lud-lud/arvore_decisao_churn/main/Crisp-DM.jpeg' alt="Representação esquemática do framework Crisp-DM" width=600/>

Portanto, este workshop nos proporcionou experiências de entendimento de negócios, engenharia de dados e ciência de dados para a execução de um projeto de ciência de dados com dados reais do início ao fim.

## Entendimento do negócio
O canal da Twitch Teo Me Why possui um [sistema de pontos](https://teomewhy.org/twitch).  
Há 3 tipos de pontos: Datapoints, Pôneis e Cubos.
É possível termos pontos negativos, já que as transações em que os pontos são trocados por prêmios também são registradas.

## Entendimento dos dados

<img src='https://raw.githubusercontent.com/Lud-lud/arvore_decisao_churn/main/banco_dados.png' alt="Esquema do banco de dados">

### Dicionário de dados

[Cliente](https://teomewhy-primary.cloud.databricks.com/explore/data/silver/upsell/cliente?o=2977606981748304)

| Nome da Coluna     | Tipo de Dados | Descrição                                                                 |
|--------------------|---------------|---------------------------------------------------------------------------|
| idCliente          | string        | Identificador único do cliente. Chave primária         |
| nrPontosCliente    | bigint        | Número total de pontos acumulados pela pessoa inscrita no canal. |
| flEmailCliente     | bigint        | Indicador se a pessoa inscrita possui um email registrado. 1 para sim e 0 para não. |


[Produtos](https://teomewhy-primary.cloud.databricks.com/explore/data/silver/upsell/produtos?o=2977606981748304)

| Nome da Coluna     | Tipo de Dados | Descrição                                                                 |
|--------------------|---------------|---------------------------------------------------------------------------|
| descProduto        | string        | Descrição do produto, como nome, características e outras especificações.        |


[transacao_produto](https://teomewhy-primary.cloud.databricks.com/explore/data/silver/upsell/transacao_produto?o=2977606981748304)

| Nome da Coluna     | Tipo de Dados | Descrição                                                                 |
|--------------------|---------------|---------------------------------------------------------------------------|
| idTransacaoProduto       | string        | Identificador único da transação do produto. Chave primária         |
| idTransacao    | string      | Identificador único da transação. Relaciona a transação do produto com uma transação global ou um pedido específico.|
| descNomeProduto     | string       | Nome ou descrição do produto na transação. |
| nrQuantidadeProduto     | bigint        | Indica o número de unidades do produto envolvidas na transação. |

[transacoes](https://teomewhy-primary.cloud.databricks.com/explore/data/silver/upsell/transacoes?o=2977606981748304)

| Nome da Coluna     | Tipo de Dados | Descrição                                                                 |
|--------------------|---------------|---------------------------------------------------------------------------|
| idTransacao     | string        | Identificador único da transação.|
| idCliente   | string      | Identificador único do cliente associado à transação. Relaciona a transação a um cliente específico.|
| dtTransacao    | string       | Data em que a transação foi realizada. Pode ser armazenado como uma string no formato de data/hora.|
| nrPontosTransacao    | bigint        | Número de pontos acumulados ou usados durante a transação. Pode representar o valor em pontos de um programa de fidelidade. |

## Preparação dos dados
### Feature Store
Os dados foram trabalhados diretamente no Databricks em todas as atapas do projeto.
Para a criação da feature store, foi desenvolvido um script em Python que integra a query SQL de maneira a automatizar a coleta de dados para diferentes coortes.

Janela de observação: 28 dias  
Número de coortes (safras):

Portanto, temos os seguinte elementos na nossa feature store:
### Partição
* dtRef
### Id
* idCliente
### Features
* nrSomaPontos: número total de pontos do idCliente na dtRef
* nrSomaPontosPos: número total de pontos positivos do idCliente na dtRef
* nrSomaPontosNeg: número total de pontos negativos do idCliente na dtRef
* nrTicketMedio: ticket médio (número médio de pontos por transação)
* nrTicketMedioPos: ticket médio considerando apenas pontos positivos
* nrTicketMedioNeg: ticket médio considerando apenas pontos negativos


  
  

## Modelagem
## Avaliação
## Implementação (deployment)


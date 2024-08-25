<img src='https://raw.githubusercontent.com/Lud-lud/arvore_decisao_churn/main/capa_projeto_tmw_med.png' alt="Capa do projeto">


# Previsão de churn de um canal na Twitch

O objetivo deste projeto é analisar o perfil dos assinantes de realizam do canal educativo Teo Me Why na Twitch e treinar um modelo de machine learning que estime a probabilidade de churn dos inscritos.

Foi utilizado o framework Crisp-DM como orientador do passo-a-passo necessário para desenvolver este projeto.

<img src='https://raw.githubusercontent.com/Lud-lud/arvore_decisao_churn/main/Crisp-DM.jpeg' alt="Representação esquemática do framework Crisp-DM" width=600/>

Portanto, este workshop nos proporcionou experiências de entendimento de negócios, engenharia de dados e ciência de dados para a execução de um projeto de ciência de dados com dados reais do início ao fim.

## Entendimento do negócio
O canal da Twitch Teo Me Why possui um [sistema de pontos](https://teomewhy.org/twitch).  
Há 3 tipos de pontos: Datapoints, Pôneis e Cubos.  
Para este projeto, utilizaremos os pontos Cubos, que são pontos de CRM utilizados internamente para conhecer melhor o público.

## Entendimento dos dados

<img src='https://raw.githubusercontent.com/Lud-lud/arvore_decisao_churn/main/banco_dados.png' alt="Esquema do banco de dados">


Janela de observação:  
Número de coortes (safras):  
  


## Preparação dos dados
### Feature Store
Os dados foram obtidos do Databricks por meio da linguagem SQL com a seguinte query: (atualizar código)
```
SELECT 
       '2024-07-01' AS dtRef,
       idCliente,
       sum(nrPontosTransacao) AS nrSomaPontos,
       sum(CASE WHEN nrPontosTransacao > 0 THEN nrPontosTransacao ELSE 0 END) AS nrSomaPontosPos,
       sum(CASE WHEN nrPontosTransacao < 0 THEN nrPontosTransacao ELSE 0 END) AS nrSomaPontosNeg,

       sum(nrPontosTransacao)/COUNT(DISTINCT idTransacao) AS nrTicketMedio,

       coalesce(sum(CASE WHEN nrPontosTransacao > 0 THEN nrPontosTransacao ELSE 0 END) / COUNT(DISTINCT CASE WHEN nrPontosTransacao > 0 THEN idTransacao END),0) AS nrTicketMedioPos,

       coalesce(sum(CASE WHEN nrPontosTransacao < 0 THEN nrPontosTransacao ELSE 0 END) / COUNT(DISTINCT CASE WHEN nrPontosTransacao < 0 THEN idTransacao END),0) AS nrTicketMedioNeg,

       sum(nrPontosTransacao) / COUNT(DISTINCT DATE (dtTransacao)) AS nrPontosDia

FROM silver.upsell.transacoes

WHERE dtTransacao < '2024-07-01'
AND dtTransacao >= '2024-07-01' - INTERVAL 28 DAY

GROUP BY ALL
```

## Preparação dos dados
## Modelagem
## Avaliação
## Implementação (deployment)


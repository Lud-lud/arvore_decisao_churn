<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/capa_projeto.png' alt="Capa do projeto">

Este projeto foi realizado no workshop desenvolvido pelo **Mulheres em Dados** em parceria com **Téo Me Why**. Veja como apoiar estes projetos:
### Téo Me Why
[Apoia.se](apoia.se/teomewhy)
[LivePix](livepix.gg/teomewhy)
[Assinante na Twitch](twitch.tv/teomewhy)
[Membros no YouTube](youtube.com/@teomewhy)
[GitHub Sponsors](github.com/sponsors/TeoMeWhy)

### Mulheres em Dados
[Discord](https://lnkd.in/dUEymWsU)
[LinkedIn](https://www.linkedin.com/company/mulheresemdados/about/)
[YouTube](https://www.youtube.com/@MulheresemDados)
[Instagram](https://www.instagram.com/mulheresemdados/)

# Previsão de churn de um canal na Twitch

O objetivo deste projeto é analisar o perfil dos assinantes de realizam do canal educativo Teo Me Why na Twitch e treinar um modelo de machine learning que estime a probabilidade de churn dos inscritos.

Início: 05/08/24  
Entrega: 26/08/24  
Avaliação: 30/08/24  

Foi utilizado o framework Crisp-DM (Cross-Industry Standard Process for Data Mining) como orientador do passo-a-passo necessário para desenvolver este projeto.

<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/Crisp-DM.jpeg' alt="Representação esquemática do framework Crisp-DM" width=600/>

Portanto, este workshop nos proporcionou experiências de entendimento de negócios, engenharia de dados e ciência de dados para a execução de um projeto com dados reais do início ao fim.

## Entendimento do negócio
O canal da Twitch Teo Me Why possui um [sistema de pontos](https://teomewhy.org/twitch).  
Há 3 tipos de pontos: Datapoints, Pôneis e Cubos.
É possível termos pontos negativos, já que as transações em que os pontos são trocados por prêmios também são registradas.

O churn é caracterizado pela inatividade na conta dentro de um período de 28 dias. Portanto, denominaremos contas que deram "churn" como inativas, e as que não deram "churn" como ativas.

## Entendimento dos dados
### Dicionário de dados

[cliente](https://teomewhy-primary.cloud.databricks.com/explore/data/silver/upsell/cliente?o=2977606981748304)

| Nome da Coluna     | Tipo de Dados | Descrição                                                                 |
|--------------------|---------------|---------------------------------------------------------------------------|
| idCliente          | string        | Identificador único do cliente. Chave primária         |
| nrPontosCliente    | bigint        | Número total de pontos acumulados pela pessoa inscrita no canal. |
| flEmailCliente     | bigint        | Indicador se a pessoa inscrita possui um email registrado. 1 para sim e 0 para não. |


[produtos](https://teomewhy-primary.cloud.databricks.com/explore/data/silver/upsell/produtos?o=2977606981748304)

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
Número de coortes (safras): 7

Portanto, temos os seguinte elementos na nossa feature store:
*Partição*
* **dtRef**: data da observação (coorte), ou seja, último dia da janela de observação.
*Id*
* **idCliente**: código único do cliente.
*Features*
* **nrSomaPontos**: número total de pontos do idCliente na dtRef.
* **nrSomaPontosPos**: número total de pontos positivos do idCliente na dtRef.
* **nrSomaPontosNeg**: número total de pontos negativos do idCliente na dtRef.
* **nrTicketMedio**: ticket médio (número médio de pontos por transação).
* **nrTicketMedioPos**: ticket médio considerando apenas pontos positivos (representa o valor médio de pontos ganhos).
* **nrTicketMedioNeg**: ticket médio considerando apenas pontos negativos (representa a média de gastos do cliente).
* **nrPontosDia**: número médio de pontos por dia de acesso.
* **nrRecenciaDias**: menor diferença entre a última transação e data da safra.
* **nrQtdeDias**: frequência de atividade em dias.
* **nrQtdeTransacoes**: frequência de transações.
* **nrQtdeTransacaoDay2**: frequência de transações na segunda-feira.
* **nrQtdeTransacaoDay3**: frequência de transações na terça-feira.
* **nrQtdeTransacaoDay4**: frequência de transações na quarta-feira.
* **nrQtdeTransacaoDay5**: frequência de transações na quinta-feira.
* **nrQtdeTransacaoDay6**: frequência de transações na na sexta-feira.

### Análise Exploratória de Dados (Exploratory Data Analysis - EDA)
Embora a análise exploratória de dados seja feita normalmente na etapa de entendimento dos dados, realizamos uma EDA nesta etapa de preparação dos dados pois estamos interessadas em entender as features que foram construídas a partir dos dados brutos.

<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/contas_ativas_inativas.png' alt="Número de contas ativas e inativas entre fevereiro e agosto de 2024">
<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/contas_ativas_inativas_safra.png' alt="Contas ativas e inativas por safra">
<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/media_transacao_dia.png' alt="Média de transações por dia por status da conta">
<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/media_pontos_dia.png' alt="Número de contas por média de pontos por dia">
<img src='https://raw.githubusercontent.com/Lud-lud/previsao_churn_twitch_teomewhy/main/assets/recencia.png' alt="Número de contas por recência de transação">


## Modelagem
1. Método IterativeImputer para valores NaN

Durante o processo de treinamento e validação dos modelos de árvore de decisão e random forest, foi identificado que alguns valores estavam ausentes nos dados. Para lidar com esses valores ausentes, foi utilizada a técnica de imputação avançada conhecida como IterativeImputer, a qual foi importada do pacote `from sklearn.experimental import enable_iterative_imputer` e `from sklearn.impute import IterativeImputer`.

O IterativeImputer realiza a imputação de valores ausentes de forma iterativa, usando um modelo de regressão para prever os valores que estão faltando com base nas características observadas no restante dos dados. Isso se diferencia da simples substituição por média, pois considera a relação entre variáveis para estimar os valores ausentes. Este método não apenas ajuda a preencher os dados incompletos, mas também preserva a integridade das relações entre as variáveis, minimizando o viés e melhorando a precisão dos modelos de machine learning.

### Avaliação
1. Decision Tree (Árvore de decisão)

É um modelo de machine learning que toma decisões com base em uma estrutura de árvore. Cada nó representa uma pergunta sobre uma característica dos dados, e cada ramo mostra a resposta. A árvore divide os dados em subconjuntos menores até chegar a uma previsão ou classificação. 
   
2. Random Forest (floresta aleatória)

Combina muitas árvores de decisão, em que cada uma traz uma recomendação para tomada de decisão. <br>

A parte “aleatória” vem da forma como a floresta é construída. Cada árvore na floresta é treinada em um subconjunto diferente dos dados e usa características (perguntas) diferentes para fazer suas divisões. Essa aleatoriedade ajuda a criar uma variedade de árvores que juntas fazem melhores previsões. <br>

Quando a floresta aleatória precisa fazer uma previsão, ela pergunta a todas as árvores suas opiniões. Para tarefas de classificação (como prever se um assinante vai cancelar), ela conta os votos e escolhe o resultado mais popular.


## Implementação (deployment)


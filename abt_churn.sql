DROP TABLE IF EXISTS feature_store.med.abt_churn;
CREATE TABLE IF NOT EXISTS feature_store.med.abt_churn AS

WITH tb_cliente_dia AS (
  SELECT DISTINCT
        idCliente,
        date(dtTransacao) AS diaTransacao
  FROM silver.upsell.transacoes
),

tb_clientes_fl AS (

    SELECT t1.dtRef,
          t1.idCliente,
          max(CASE WHEN t2.idCliente IS NULL THEN 1 ELSE 0 END) flChurn

    FROM feature_store.med.fs_transacoes AS t1

    LEFT JOIN tb_cliente_dia AS t2
    ON t1.idCliente = t2.idCliente
    AND t1.dtRef <= t2.diaTransacao
    AND t1.dtRef > t2.diaTransacao - INTERVAL 28 DAY

    GROUP BY ALL

),

-- SELECT *,
--        row_number() OVER (PARTITION BY idCliente ORDER BY RAND() DESC) AS rank
-- FROM tb_clientes_fl
tb_churn AS (
    SELECT *
    FROM tb_clientes_fl
    QUALIFY row_number() OVER (PARTITION BY idCliente ORDER BY RAND() DESC) = 1
)

SELECT t1.dtRef,
       t1.idCliente,
       t1.flChurn,
       t3.nrSomaPontos,
       t3.nrSomaPontosPos,
       t3.nrSomaPontosNeg,
       t3.nrTicketMedio,
       t3.nrTicketMedioPos,
       t3.nrTicketMedioNeg,
       t3.nrPontosDia,
        t2.nrQtdeTransacoes,
        t2.nrQtdeDias,
        t2.nrRecenciaDias,
        t2.nrQtdeTransacaoDay2,
        t2.nrQtdeTransacaoDay3,
        t2.nrQtdeTransacaoDay4,
        t2.nrQtdeTransacaoDay5,
        t2.nrQtdeTransacaoDay6,
        t2.nrQtdeDay2,
        t2.nrQtdeDay3,
        t2.nrQtdeDay4,
        t2.nrQtdeDay5,
        t2.nrQtdeDay6,
        t2.nrAvgRecorrencia

FROM tb_churn AS t1

LEFT JOIN feature_store.med.fs_transacoes AS t2
ON t1.idCliente = t2.idCliente
AND t1.dtRef = t2.dtRef

LEFT JOIN feature_store.med.fs_pontos AS t3
ON t1.idCliente = t3.idCliente
AND t1.dtRef = t3.dtRef

WHERE t1.idCliente <> "5f8fcbe0-6014-43f8-8b83-38cf2f4887b3"
AND t1.dtRef < '2024-08-01'
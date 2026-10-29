-- Задание 2.1. Очень усердные ученики
-- Сколько учеников за текущий месяц правильно решили 20 и более горошин (задач)

SELECT
    COUNT(*)
FROM
    (SELECT 
        st_id,
        SUM(CAST(correct AS INT)) as sumcorr
    FROM peas
    WHERE
        date_trunc('month', timest) = date_trunc('month', now())
    GROUP BY
        st_id
    HAVING
        SUM(CAST(correct AS INT)) >= 20) as sq1;

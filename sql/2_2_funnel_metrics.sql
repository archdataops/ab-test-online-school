-- Задание 2.2. Оптимизация воронки
-- ARPU, ARPAU, CR в покупку, CR активного в покупку, CR активного по математике в покупку математики по группам теста

SELECT
    test_grp,
    SUM(total_revenue) / COUNT(DISTINCT st_id) AS ARPU,
    SUM(CASE WHEN active_stud = 1 THEN total_revenue ELSE 0 END) / COUNT(DISTINCT CASE WHEN active_stud = 1 THEN st_id END) AS ARPAU,
    COUNT(DISTINCT CASE WHEN total_revenue > 0 THEN st_id END) / COUNT(DISTINCT st_id) AS CR_to_buy,
    COUNT(DISTINCT CASE WHEN active_stud = 1 AND total_revenue > 0 THEN st_id END) / COUNT(DISTINCT CASE WHEN active_stud = 1 THEN st_id END) AS CR_active_to_buy,
    COUNT(DISTINCT CASE WHEN math_active_stud = 1 AND math_revenue > 0 THEN st_id END) / COUNT(DISTINCT CASE WHEN math_active_stud = 1 THEN st_id END) AS CR_math_active_to_buy_math
FROM
    (
    SELECT 
        l.test_grp as test_grp,
        l.st_id as st_id,
        r.active_stud as active_stud,
        r.math_active_stud as math_active_stud,
        r.total_revenue as total_revenue,
        r.math_revenue as math_revenue
    FROM
        (
        SELECT
            test_grp,
            st_id
        FROM studs
        ) as l
    LEFT JOIN
        (
        SELECT
            l.st_id as st_id,
            l.active_stud as active_stud,
            l.math_active_stud as math_active_stud,
            r.total_revenue as total_revenue,
            r.math_revenue as math_revenue
        FROM
            (
            SELECT
                st_id,
                CASE WHEN SUM(CAST(correct AS INT)) > 10 THEN 1 ELSE 0 END as active_stud,
                CASE WHEN SUM(CASE WHEN subject = 'Math' THEN CAST(correct AS INT) ELSE 0 END) >= 2 THEN 1 ELSE 0 END as math_active_stud
            FROM peas
            GROUP BY
                st_id
            ) as l
        LEFT JOIN
            (
            SELECT
                st_id,
                SUM(money) as total_revenue,
                SUM(CASE WHEN subject = 'Math' THEN money ELSE 0 END) as math_revenue
            FROM final_project_check
            GROUP BY st_id
            ) as r
        ON l.st_id = r.st_id
        ) as r
    ON l.st_id = r.st_id
    ) as subquery
GROUP BY
    test_grp;

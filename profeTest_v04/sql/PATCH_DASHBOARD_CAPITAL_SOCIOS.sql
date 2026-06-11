-- PATCH: Dashboard capital total aportado
-- Este patch no modifica datos. La corrección principal está en api/dashboard.php.
-- Verificación esperada: suma de partners.capital_usd activos.
SELECT COALESCE(SUM(capital_usd),0) AS capital_total_aportado
FROM partners
WHERE status='active';

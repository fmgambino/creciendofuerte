-- PATCH URGENTE 2026-06-11
-- Corrige fórmula de ganancias acumuladas y segmentación de notificaciones por socio.

ALTER TABLE notifications
  ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER type,
  ADD COLUMN IF NOT EXISTS partner_id INT UNSIGNED NULL AFTER user_id,
  ADD COLUMN IF NOT EXISTS audience ENUM('admin','partner','all') NOT NULL DEFAULT 'admin' AFTER partner_id;

-- Las notificaciones históricas sin destinatario quedan solo para administración.
UPDATE notifications SET audience='admin' WHERE audience IS NULL OR audience='all';

-- Recalcula partners.gains_usd con la fórmula correcta:
-- Ganancia acumulada = (SUM(partners_share_usd de broker_profits) / socios activos) - retiros pagados/acreditados/transferidos.
SET @active_partners := (SELECT COUNT(*) FROM partners WHERE status='active');
SET @global_partner_gain := (
  SELECT CASE WHEN @active_partners > 0 THEN ROUND(COALESCE(SUM(partners_share_usd),0) / @active_partners, 2) ELSE 0 END
  FROM broker_profits
);

UPDATE partners p
LEFT JOIN (
  SELECT partner_id, COALESCE(SUM(amount_usd),0) paid_withdrawals
  FROM withdrawals
  WHERE status IN ('pagado','acreditado','transferido')
  GROUP BY partner_id
) w ON w.partner_id = p.id
SET p.gains_usd = GREATEST(ROUND(@global_partner_gain - COALESCE(w.paid_withdrawals,0),2),0);

INSERT INTO app_settings(key_name,value) VALUES
('footer_url','https://electronicagambino.com')
ON DUPLICATE KEY UPDATE value=VALUES(value);

-- PATCH V05 · Login fondo configurable, notificaciones segmentadas y lectura por clic
CREATE TABLE IF NOT EXISTS app_settings (
  key_name varchar(80) NOT NULL PRIMARY KEY,
  value text NULL,
  updated_at datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO app_settings(key_name,value) VALUES
('login_bg_type','css'),('login_bg_url',''),('login_bg_path',''),
('footer_url','https://electronicagambino.com')
ON DUPLICATE KEY UPDATE value=VALUES(value);

ALTER TABLE notifications
  ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER type,
  ADD COLUMN IF NOT EXISTS partner_id INT UNSIGNED NULL AFTER user_id,
  ADD COLUMN IF NOT EXISTS audience ENUM('admin','partner','all') NOT NULL DEFAULT 'admin' AFTER partner_id;

UPDATE notifications SET audience='admin' WHERE audience IS NULL OR audience='' OR title LIKE '%cuenta%' OR title LIKE '%usuario%' OR title LIKE '%solicitud%';
UPDATE notifications n JOIN withdrawals w ON n.type='retiro' AND n.body LIKE CONCAT('%', w.amount_usd, '%') SET n.partner_id=w.partner_id, n.audience='partner' WHERE n.title LIKE '%Retiro pagado%' OR n.title LIKE '%retiro%cuenta%';

-- Recalcula ganancias acumuladas por socio: pool global por socio - retiros pagados/acreditados/transferidos.
UPDATE partners p
JOIN (SELECT COUNT(*) active_count FROM partners WHERE status='active') ac
JOIN (SELECT COALESCE(SUM(partners_share_usd),0) pool FROM broker_profits) bp
LEFT JOIN (SELECT partner_id, COALESCE(SUM(amount_usd),0) paid FROM withdrawals WHERE status IN('pagado','acreditado','transferido') GROUP BY partner_id) w ON w.partner_id=p.id
SET p.gains_usd = GREATEST(0, ROUND(IF(ac.active_count>0,bp.pool/ac.active_count,0) - COALESCE(w.paid,0), 2));

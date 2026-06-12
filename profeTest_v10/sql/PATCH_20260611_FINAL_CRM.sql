-- PATCH FINAL 2026-06-11 · CRM ganancias, footer, PHPMailer y saldos
-- Ejecutar una sola vez sobre la base actual. Es seguro para Hostinger/XAMPP.

CREATE TABLE IF NOT EXISTS app_settings (
  key_name VARCHAR(80) NOT NULL PRIMARY KEY,
  value TEXT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO app_settings(key_name,value) VALUES
('footer_text','© 2026 EL MASTER 10K - Todos los derechos Registrados - Desarrollado por Electrónica Gambino'),
('footer_url','https://electronicagambino.com'),
('smtp_enabled','0'),
('smtp_host',''),
('smtp_port','587'),
('smtp_username',''),
('smtp_password',''),
('smtp_secure','tls'),
('smtp_from_email',''),
('smtp_from_name','EL MASTER PROFE CRM')
ON DUPLICATE KEY UPDATE value=VALUES(value);

-- Recalcula la ganancia acumulada de cada socio:
-- distribuciones acreditadas al socio - retiros efectivamente retirados/transferidos/acreditados.
UPDATE partners p
LEFT JOIN (
  SELECT partner_id, COALESCE(SUM(amount_usd),0) total_distribuido
  FROM distributions
  GROUP BY partner_id
) d ON d.partner_id=p.id
LEFT JOIN (
  SELECT partner_id, COALESCE(SUM(amount_usd),0) total_retirado
  FROM withdrawals
  WHERE status IN('pagado','acreditado','transferido')
  GROUP BY partner_id
) w ON w.partner_id=p.id
SET p.gains_usd = GREATEST(COALESCE(d.total_distribuido,0)-COALESCE(w.total_retirado,0),0);

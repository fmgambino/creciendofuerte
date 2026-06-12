-- PATCH V10 - Google OAuth socios pendientes + SMTP Gmail
-- Ejecutar en Hostinger sobre la base u570224512_master10k

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;

CREATE TABLE IF NOT EXISTS `app_settings` (
  `key_name` varchar(80) NOT NULL,
  `value` text DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `app_settings` (`key_name`, `value`) VALUES
('pending_activation_text', 'Tu cuenta fue registrada correctamente y quedó pendiente de activación por el SuperAdmin. Este proceso puede demorar hasta 48 hs hábiles.'),
('smtp_host', 'smtp.gmail.com'),
('smtp_port', '587'),
('smtp_secure', 'tls'),
('smtp_username', 'electronicagambino@gmail.com'),
('smtp_from_email', 'electronicagambino@gmail.com'),
('smtp_from_name', 'Electrónica Gambino');

-- No se sobrescribe smtp_password para no borrar tu contraseña de aplicación.
-- Si querés activar SMTP por SQL, descomentá la línea siguiente:
-- REPLACE INTO `app_settings` (`key_name`, `value`) VALUES ('smtp_enabled', '1');

COMMIT;

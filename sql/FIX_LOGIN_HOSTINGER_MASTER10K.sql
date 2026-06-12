-- =========================================================
-- FIX LOGIN HOSTINGER - 10K CRM / MASTER10K
-- Fecha: 2026-06-11
-- Uso: importar en phpMyAdmin sobre la base u570224512_master10k
-- No borra datos. Corrige acceso SuperAdmin y ajustes críticos.
-- Usuario: fernando.m.gambino@gmail.com
-- Password temporal: Master10K2026!
-- Cambiar la contraseña desde el sistema luego de ingresar.
-- =========================================================

START TRANSACTION;

-- 1) Asegurar estructura mínima de usuarios compatible con el código PHP.
ALTER TABLE `users`
  MODIFY `email` varchar(160) NOT NULL,
  MODIFY `password_hash` varchar(255) NOT NULL,
  MODIFY `role` enum('superadmin','empleado','socio') NOT NULL DEFAULT 'socio',
  MODIFY `status` enum('active','inactive') NOT NULL DEFAULT 'active';

-- 2) Asegurar índice único de email si no existe.
SET @idx_exists := (
  SELECT COUNT(1)
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name = 'users'
    AND index_name = 'email'
);
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE `users` ADD UNIQUE KEY `email` (`email`)', 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3) Restaurar/activar usuario SuperAdmin principal.
INSERT INTO `users`
  (`full_name`, `email`, `password_hash`, `role`, `status`, `profile_photo`, `created_at`, `updated_at`)
VALUES
  ('Fernando Gambino', 'fernando.m.gambino@gmail.com', '$2y$12$K.9FFYi7YyHE.qt098MobegaFvc7yM3TLHyPnwK.fN/Qqkf5stYVq', 'superadmin', 'active', 'assets/img/avatar.svg', NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `full_name` = 'Fernando Gambino',
  `password_hash` = '$2y$12$K.9FFYi7YyHE.qt098MobegaFvc7yM3TLHyPnwK.fN/Qqkf5stYVq',
  `role` = 'superadmin',
  `status` = 'active',
  `updated_at` = NOW();

-- 4) Asegurar que el login no quede bloqueado por configuraciones incompletas.
INSERT INTO `app_settings` (`key_name`, `value`) VALUES
('developer_url', 'https://electronicagambino.com'),
('login_bg_type', 'css'),
('login_bg_url', ''),
('login_bg_path', ''),
('login_right_card_enabled', '0')
ON DUPLICATE KEY UPDATE `value` = VALUES(`value`), `updated_at` = NOW();

COMMIT;

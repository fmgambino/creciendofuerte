-- ============================================================
-- SQL COMPLETO DE ACTUALIZACION HOSTINGER
-- Proyecto: EL MASTER PROFE CRM / 10K CRM
-- Patch: V07 LOGIN YOUTUBE / IMAGEN
-- Fecha: 2026-06-11
-- Motor: MySQL / MariaDB
--
-- IMPORTANTE:
-- 1) Ejecutar en phpMyAdmin sobre la base de datos de Hostinger.
-- 2) Hacer backup antes de importar.
-- 3) Este SQL NO borra datos.
-- 4) Actualiza/crea las claves necesarias para que el login muestre
--    correctamente Animación CSS, Imagen o Video/YouTube según configuración.
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1) TABLA GENERAL DE CONFIGURACIONES
-- ============================================================

CREATE TABLE IF NOT EXISTS `app_settings` (
  `key_name` varchar(80) NOT NULL,
  `value` text NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2) CONFIGURACION EXCLUSIVA DEL FONDO DEL LOGIN
-- login_bg_type:
--   css   = Solo animación CSS
--   image = Solo imagen por URL o archivo adjunto
--   video = Solo video local/MP4 o YouTube embed
-- ============================================================

INSERT INTO `app_settings` (`key_name`, `value`) VALUES
('login_bg_type', 'css'),
('login_bg_url', ''),
('login_bg_path', '')
ON DUPLICATE KEY UPDATE
  `value` = `value`;

-- ============================================================
-- 3) CLAVES COMPLEMENTARIAS DE LOGIN / MARCA
-- Se crean sin pisar valores existentes.
-- ============================================================

INSERT INTO `app_settings` (`key_name`, `value`) VALUES
('app_name', '10K CRM'),
('brand_name', 'BACKOFFICES 10K CRM'),
('footer_text', '© 2026 10K CRM - BACKOFFICES - Todos los derechos Registrados'),
('developer_name', 'Electrónica Gambino'),
('developer_url', 'https://electronicagambino.com'),
('login_google_enabled', '1'),
('login_right_card_enabled', '0')
ON DUPLICATE KEY UPDATE
  `value` = `value`;

-- ============================================================
-- 4) NORMALIZACION DE VALORES INVALIDOS
-- Si en Hostinger quedó cargado un valor no válido, vuelve a CSS.
-- ============================================================

UPDATE `app_settings`
SET `value` = 'css'
WHERE `key_name` = 'login_bg_type'
  AND LOWER(TRIM(COALESCE(`value`, ''))) NOT IN ('css', 'image', 'video');

-- ============================================================
-- 5) ASEGURAR URL CORRECTA DE ELECTRONICA GAMBINO
-- ============================================================

INSERT INTO `app_settings` (`key_name`, `value`) VALUES
('developer_url', 'https://electronicagambino.com')
ON DUPLICATE KEY UPDATE
  `value` = 'https://electronicagambino.com';

-- ============================================================
-- 6) LIMPIEZA OPCIONAL SEGURA
-- No borra imagen/video configurados.
-- Solo asegura que las claves existan.
-- ============================================================

UPDATE `app_settings`
SET `value` = COALESCE(`value`, '')
WHERE `key_name` IN ('login_bg_url', 'login_bg_path');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- FIN DEL SQL
-- ============================================================

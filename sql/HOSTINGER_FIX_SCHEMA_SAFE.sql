-- =========================================================
-- HOSTINGER FIX SAFE · EL MASTER PROFE CRM
-- Base: u570224512_master10k en Hostinger / revenue_crm en local
-- Ejecutar en phpMyAdmin sobre la base correspondiente.
-- No borra datos existentes.
-- =========================================================
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS users (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(160) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role ENUM('superadmin','empleado','socio') NOT NULL DEFAULT 'socio',
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 profile_photo VARCHAR(255) DEFAULT 'assets/img/avatar.svg',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS partners (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 partner_code VARCHAR(40) NOT NULL UNIQUE,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(160) NOT NULL,
 phone VARCHAR(50) NULL,
 address VARCHAR(180) NULL,
 bank_account VARCHAR(180) NULL,
 capital_usd DECIMAL(12,2) NOT NULL DEFAULT 0.00,
 gains_usd DECIMAL(12,2) NOT NULL DEFAULT 0.00,
 kyc_status ENUM('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 joined_at DATE NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS broker_profits (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 profit_date DATE NOT NULL,
 gross_profit_usd DECIMAL(12,2) NOT NULL,
 master_share_usd DECIMAL(12,2) NOT NULL,
 partners_share_usd DECIMAL(12,2) NOT NULL,
 notes TEXT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS distributions (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 broker_profit_id INT UNSIGNED NULL,
 partner_id INT UNSIGNED NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 percent_share DECIMAL(8,4) NOT NULL DEFAULT 0.0000,
 status ENUM('pendiente','en_proceso','transferido','acreditado','pagado') NOT NULL DEFAULT 'acreditado',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY broker_profit_id (broker_profit_id),
 KEY partner_id (partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS capital_levels (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(80) NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 percent_share DECIMAL(8,4) NOT NULL DEFAULT 0.0000,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS withdrawals (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 partner_id INT UNSIGNED NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 request_type ENUM('ganancias','capital_total') NOT NULL DEFAULT 'ganancias',
 destination VARCHAR(255) NOT NULL,
 status ENUM('pendiente','en_proceso','transferido','acreditado','pagado','rechazado') NOT NULL DEFAULT 'pendiente',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY partner_id (partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS referrals (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 referrer_partner_id INT UNSIGNED NOT NULL,
 referred_name VARCHAR(150) NOT NULL,
 referred_email VARCHAR(160) NOT NULL,
 capital_usd DECIMAL(12,2) NOT NULL DEFAULT 0.00,
 commission_percent DECIMAL(6,2) NOT NULL DEFAULT 8.00,
 status ENUM('nuevo','activo','pagado','cancelado') NOT NULL DEFAULT 'nuevo',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY referrer_partner_id (referrer_partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS whatsapp_numbers (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 label VARCHAR(80) NOT NULL,
 phone VARCHAR(40) NOT NULL,
 message VARCHAR(255) NOT NULL DEFAULT 'Hola, necesito información sobre EL MASTER PROFE CRM.',
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notifications (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR(150) NOT NULL,
 body VARCHAR(255) NOT NULL,
 type VARCHAR(40) NOT NULL DEFAULT 'info',
 is_read TINYINT(1) NOT NULL DEFAULT 0,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS audit_logs (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event VARCHAR(255) NOT NULL,
 author VARCHAR(120) NOT NULL,
 type VARCHAR(60) NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS permissions (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 module_key VARCHAR(80) NOT NULL,
 module_name VARCHAR(120) NOT NULL,
 role VARCHAR(30) NOT NULL,
 can_view TINYINT(1) NOT NULL DEFAULT 0,
 can_create TINYINT(1) NOT NULL DEFAULT 0,
 can_edit TINYINT(1) NOT NULL DEFAULT 0,
 can_delete TINYINT(1) NOT NULL DEFAULT 0,
 can_export TINYINT(1) NOT NULL DEFAULT 0,
 UNIQUE KEY uk_perm (module_key, role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Columnas que pueden faltar en bases importadas de versiones anteriores.
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_photo VARCHAR(255) DEFAULT 'assets/img/avatar.svg';
ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS phone VARCHAR(50) NULL;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS address VARCHAR(180) NULL;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS bank_account VARCHAR(180) NULL;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS capital_usd DECIMAL(12,2) NOT NULL DEFAULT 0.00;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS gains_usd DECIMAL(12,2) NOT NULL DEFAULT 0.00;
ALTER TABLE partners ADD COLUMN IF NOT EXISTS kyc_status ENUM('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente';
ALTER TABLE partners ADD COLUMN IF NOT EXISTS joined_at DATE NULL;
ALTER TABLE distributions ADD COLUMN IF NOT EXISTS percent_share DECIMAL(8,4) NOT NULL DEFAULT 0.0000;
ALTER TABLE distributions ADD COLUMN IF NOT EXISTS status ENUM('pendiente','en_proceso','transferido','acreditado','pagado') NOT NULL DEFAULT 'acreditado';
ALTER TABLE withdrawals ADD COLUMN IF NOT EXISTS request_type ENUM('ganancias','capital_total') NOT NULL DEFAULT 'ganancias';
ALTER TABLE withdrawals ADD COLUMN IF NOT EXISTS destination VARCHAR(255) NOT NULL DEFAULT '';
ALTER TABLE withdrawals MODIFY COLUMN status ENUM('pendiente','en_proceso','transferido','acreditado','pagado','rechazado') NOT NULL DEFAULT 'pendiente';

-- Sincroniza socios que no tengan usuario asociado.
INSERT IGNORE INTO users(full_name,email,password_hash,role,status,profile_photo)
SELECT p.full_name, p.email, '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'socio', p.status, 'assets/img/avatar.svg'
FROM partners p
LEFT JOIN users u ON u.email = p.email
WHERE u.id IS NULL;

UPDATE partners p
JOIN users u ON u.email = p.email
SET p.user_id = u.id
WHERE p.user_id IS NULL OR p.user_id = 0;

-- Limpia y reinstala permisos sin usar ON DUPLICATE KEY UPDATE.
DELETE FROM permissions;

INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES
('dashboard','Dashboard','superadmin',1,1,1,1,1),('dashboard','Dashboard','empleado',1,0,0,0,1),('dashboard','Dashboard','socio',1,0,0,0,0),
('perfil','Mi Perfil','superadmin',1,1,1,1,1),('perfil','Mi Perfil','empleado',1,0,1,0,1),('perfil','Mi Perfil','socio',1,0,1,0,0),
('users','Usuarios','superadmin',1,1,1,1,1),('users','Usuarios','empleado',0,0,0,0,0),('users','Usuarios','socio',0,0,0,0,0),
('roles','Roles y permisos','superadmin',1,1,1,1,1),('roles','Roles y permisos','empleado',0,0,0,0,0),('roles','Roles y permisos','socio',0,0,0,0,0),
('socios','Socios','superadmin',1,1,1,1,1),('socios','Socios','empleado',1,1,1,0,1),('socios','Socios','socio',0,0,0,0,0),
('referidos','Referidos','superadmin',1,1,1,1,1),('referidos','Referidos','empleado',1,1,1,0,1),('referidos','Referidos','socio',0,0,0,0,0),
('profits','Ganancias broker','superadmin',1,1,1,1,1),('profits','Ganancias broker','empleado',1,1,1,0,1),('profits','Ganancias broker','socio',0,0,0,0,0),
('distribuciones','Distribuciones','superadmin',1,1,1,1,1),('distribuciones','Distribuciones','empleado',0,0,0,0,0),('distribuciones','Distribuciones','socio',0,0,0,0,0),
('capitales','Niveles de capital','superadmin',1,1,1,1,1),('capitales','Niveles de capital','empleado',1,0,0,0,1),('capitales','Niveles de capital','socio',0,0,0,0,0),
('retiros','Retiros','superadmin',1,1,1,1,1),('retiros','Retiros','empleado',1,1,1,0,1),('retiros','Retiros','socio',1,1,0,0,1),
('whatsapp','WhatsApp','superadmin',1,1,1,1,1),('whatsapp','WhatsApp','empleado',0,0,0,0,0),('whatsapp','WhatsApp','socio',0,0,0,0,0),
('notificaciones','Notificaciones','superadmin',1,1,1,1,1),('notificaciones','Notificaciones','empleado',1,1,1,0,1),('notificaciones','Notificaciones','socio',1,0,0,0,0),
('auditoria','Auditoría','superadmin',1,1,1,1,1),('auditoria','Auditoría','empleado',1,0,0,0,1),('auditoria','Auditoría','socio',0,0,0,0,0);

INSERT IGNORE INTO capital_levels(name,amount_usd,percent_share,status) VALUES
('Nivel 2K',2000,0,'active'),('Nivel 5K',5000,0,'active'),('Nivel 10K',10000,0,'active');

INSERT IGNORE INTO whatsapp_numbers(label,phone,message,status) VALUES
('Ventas','5493810000001','Hola, quiero información sobre EL MASTER PROFE.','active'),
('Soporte','5493810000002','Hola, necesito soporte del CRM.','active'),
('Administración','5493810000003','Hola, quiero consultar por retiros o ganancias.','active');

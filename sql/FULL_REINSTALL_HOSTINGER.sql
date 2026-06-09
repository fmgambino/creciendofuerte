CREATE DATABASE IF NOT EXISTS revenue_crm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE revenue_crm;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS audit_logs, notifications, whatsapp_numbers, withdrawals, distributions, broker_profits, referrals, partners, capital_levels, permissions, users;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(160) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role ENUM('superadmin','empleado','socio') NOT NULL DEFAULT 'socio',
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 profile_photo VARCHAR(255) DEFAULT 'assets/img/avatar.svg',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE permissions (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 module_key VARCHAR(80) NOT NULL,
 module_name VARCHAR(120) NOT NULL,
 role VARCHAR(30) NOT NULL,
 can_view TINYINT(1) NOT NULL DEFAULT 0,
 can_create TINYINT(1) NOT NULL DEFAULT 0,
 can_edit TINYINT(1) NOT NULL DEFAULT 0,
 can_delete TINYINT(1) NOT NULL DEFAULT 0,
 can_export TINYINT(1) NOT NULL DEFAULT 0,
 UNIQUE KEY uk_perm(module_key, role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE capital_levels (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(80) NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 percent_share DECIMAL(8,4) NOT NULL DEFAULT 0,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE partners (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 partner_code VARCHAR(40) NOT NULL UNIQUE,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(160) NOT NULL,
 phone VARCHAR(50) NULL,
 address VARCHAR(180) NULL,
 bank_account VARCHAR(180) NULL,
 capital_usd DECIMAL(12,2) NOT NULL DEFAULT 0,
 gains_usd DECIMAL(12,2) NOT NULL DEFAULT 0,
 kyc_status ENUM('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 joined_at DATE NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE referrals (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 referrer_partner_id INT UNSIGNED NOT NULL,
 referred_name VARCHAR(150) NOT NULL,
 referred_email VARCHAR(160) NOT NULL,
 capital_usd DECIMAL(12,2) NOT NULL DEFAULT 0,
 commission_percent DECIMAL(6,2) NOT NULL DEFAULT 8.00,
 status ENUM('nuevo','activo','pagado','cancelado') NOT NULL DEFAULT 'nuevo',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(referrer_partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE broker_profits (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 profit_date DATE NOT NULL,
 gross_profit_usd DECIMAL(12,2) NOT NULL,
 master_share_usd DECIMAL(12,2) NOT NULL,
 partners_share_usd DECIMAL(12,2) NOT NULL,
 notes TEXT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE distributions (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 broker_profit_id INT UNSIGNED NULL,
 partner_id INT UNSIGNED NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 percent_share DECIMAL(8,4) NOT NULL,
 status ENUM('pendiente','en_proceso','transferido','acreditado','pagado') NOT NULL DEFAULT 'acreditado',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(broker_profit_id) REFERENCES broker_profits(id) ON DELETE SET NULL,
 FOREIGN KEY(partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE withdrawals (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 partner_id INT UNSIGNED NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 request_type ENUM('ganancias','capital_total') NOT NULL DEFAULT 'ganancias',
 destination VARCHAR(255) NOT NULL,
 status ENUM('pendiente','en_proceso','transferido','acreditado','pagado','rechazado') NOT NULL DEFAULT 'pendiente',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE whatsapp_numbers (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 label VARCHAR(80) NOT NULL,
 phone VARCHAR(40) NOT NULL,
 message VARCHAR(255) NOT NULL DEFAULT 'Hola, necesito información sobre EL MASTER PROFE CRM.',
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE notifications (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR(150) NOT NULL,
 body VARCHAR(255) NOT NULL,
 type VARCHAR(40) NOT NULL DEFAULT 'info',
 is_read TINYINT(1) NOT NULL DEFAULT 0,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE audit_logs (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 event VARCHAR(255) NOT NULL,
 author VARCHAR(120) NOT NULL,
 type VARCHAR(60) NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO users(full_name,email,password_hash,role,status,profile_photo) VALUES
('Fernando Gambino','fernando.m.gambino@gmail.com','$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re','superadmin','active','assets/img/avatar.svg'),
('Mesa Operativa','mesa@masterprofe.demo','$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re','empleado','active','assets/img/avatar.svg'),
('Juan Pérez','juan@socio.demo','$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re','socio','active','assets/img/avatar.svg');

INSERT INTO capital_levels(name,amount_usd,percent_share,status) VALUES
('Nivel 2K',2000,0,'active'),('Nivel 5K',5000,0,'active'),('Nivel 10K',10000,0,'active');

INSERT INTO partners(user_id,partner_code,full_name,email,phone,address,bank_account,capital_usd,gains_usd,kyc_status,status,joined_at) VALUES
(3,'MSTR-JUAN-0001','Juan Pérez','juan@socio.demo','3815551111','San Miguel de Tucumán','USDT TRC20 - Tw...9aFt',8000,720,'aprobado','active','2026-01-01'),
(NULL,'MSTR-MARI-0002','Marina Soto','marina@socio.demo','3815552222','Tucumán','Banco Galicia ****4421',10000,907,'aprobado','active','2026-02-02'),
(NULL,'MSTR-DIEG-0003','Diego Vega','diego@socio.demo','3815553333','Tucumán','USDT TRC20 - Tw...9aFt',15000,1094,'pendiente','active','2026-03-03');

INSERT INTO broker_profits(profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes) VALUES
(CURDATE() - INTERVAL 5 DAY,1850,1110,740,'Demo'),(CURDATE() - INTERVAL 4 DAY,2200,1320,880,'Demo'),(CURDATE() - INTERVAL 3 DAY,2500,1500,1000,'Demo'),(CURDATE() - INTERVAL 2 DAY,1900,1140,760,'Demo'),(CURDATE() - INTERVAL 1 DAY,3100,1860,1240,'Demo'),(CURDATE(),10000,6000,4000,'Carga inicial demo');

INSERT INTO distributions(broker_profit_id,partner_id,amount_usd,percent_share,status) VALUES
(6,1,1333.33,33.3333,'acreditado'),(6,2,1333.33,33.3333,'acreditado'),(6,3,1333.34,33.3334,'acreditado');
INSERT INTO referrals(referrer_partner_id,referred_name,referred_email,capital_usd,commission_percent,status) VALUES
(1,'Referido Demo','referido@demo.com',2000,8,'activo');
INSERT INTO withdrawals(partner_id,amount_usd,request_type,destination,status) VALUES
(1,300,'ganancias','USDT TRC20 - Tw...9aFt','pendiente');
INSERT INTO whatsapp_numbers(label,phone,message,status) VALUES
('Ventas','5493810000001','Hola, quiero información sobre EL MASTER PROFE.','active'),
('Soporte','5493810000002','Hola, necesito soporte del CRM.','active'),
('Administración','5493810000003','Hola, quiero consultar por retiros o ganancias.','active');
INSERT INTO notifications(title,body,type) VALUES
('Nuevo retiro solicitado','Juan Pérez solicitó retirar US$ 300.','retiro'),
('Repartición acreditada','Se acreditaron distribuciones de la ganancia broker.','distribucion'),
('Nuevo referido','Juan Pérez registró un referido.','referido');

INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES
('dashboard','Dashboard','superadmin',1,1,1,1,1),
('dashboard','Dashboard','empleado',1,0,0,0,1),
('dashboard','Dashboard','socio',1,0,0,0,0),
('perfil','Mi Perfil','superadmin',1,1,1,1,1),
('perfil','Mi Perfil','empleado',1,0,0,0,1),
('perfil','Mi Perfil','socio',1,0,1,0,0),
('users','Usuarios','superadmin',1,1,1,1,1),
('users','Usuarios','empleado',0,0,0,0,1),
('users','Usuarios','socio',0,0,0,0,0),
('roles','Roles y permisos','superadmin',1,1,1,1,1),
('roles','Roles y permisos','empleado',0,0,0,0,0),
('roles','Roles y permisos','socio',0,0,0,0,0),
('socios','Socios','superadmin',1,1,1,1,1),
('socios','Socios','empleado',1,1,1,0,1),
('socios','Socios','socio',0,0,0,0,0),
('referidos','Referidos','superadmin',1,1,1,1,1),
('referidos','Referidos','empleado',1,1,1,0,1),
('referidos','Referidos','socio',1,1,1,0,1),
('profits','Ganancias broker','superadmin',1,1,1,1,1),
('profits','Ganancias broker','empleado',1,1,1,0,1),
('profits','Ganancias broker','socio',0,0,0,0,0),
('distribuciones','Distribuciones','superadmin',1,1,1,1,1),
('distribuciones','Distribuciones','empleado',0,0,0,0,0),
('distribuciones','Distribuciones','socio',0,0,0,0,0),
('capitales','Niveles de capital','superadmin',1,1,1,1,1),
('capitales','Niveles de capital','empleado',1,0,0,0,1),
('capitales','Niveles de capital','socio',0,0,0,0,0),
('retiros','Retiros','superadmin',1,1,1,1,1),
('retiros','Retiros','empleado',1,1,1,0,1),
('retiros','Retiros','socio',1,1,0,0,1),
('whatsapp','WhatsApp','superadmin',1,1,1,1,1),
('whatsapp','WhatsApp','empleado',0,0,0,0,0),
('whatsapp','WhatsApp','socio',0,0,0,0,0),
('notificaciones','Notificaciones','superadmin',1,1,1,1,1),
('notificaciones','Notificaciones','empleado',1,1,1,0,1),
('notificaciones','Notificaciones','socio',1,0,0,0,0),
('auditoria','Auditoría','superadmin',1,1,1,1,1),
('auditoria','Auditoría','empleado',1,0,0,0,1),
('auditoria','Auditoría','socio',0,0,0,0,0);

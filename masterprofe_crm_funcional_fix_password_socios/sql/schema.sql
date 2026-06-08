CREATE DATABASE IF NOT EXISTS revenue_crm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE revenue_crm;

DROP TABLE IF EXISTS audit_logs, notifications, whatsapp_numbers, withdrawals, distributions, broker_profits, referrals, partners, permissions, users;

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
 UNIQUE KEY uk_perm(module_key, role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE partners (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 partner_code VARCHAR(40) NOT NULL UNIQUE,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(160) NOT NULL,
 phone VARCHAR(50) NULL,
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
 status ENUM('pendiente','acreditado','pagado') NOT NULL DEFAULT 'acreditado',
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
 status ENUM('solicitado','en_revision','transferido','rechazado') NOT NULL DEFAULT 'solicitado',
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

INSERT INTO partners(user_id,partner_code,full_name,email,phone,capital_usd,gains_usd,kyc_status,status,joined_at) VALUES
(3,'MSTR-JUAN-0001','Juan Pérez','juan@socio.demo','3815551111',8000,720,'aprobado','active','2026-01-01'),
(NULL,'MSTR-MARI-0002','Marina Soto','marina@socio.demo','3815552222',10000,907,'aprobado','active','2026-02-02'),
(NULL,'MSTR-DIEG-0003','Diego Vega','diego@socio.demo','3815553333',15000,1094,'pendiente','active','2026-03-03');
INSERT INTO broker_profits(profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes) VALUES
(CURDATE(),2500,1500,1000,'Carga inicial demo');
INSERT INTO distributions(broker_profit_id,partner_id,amount_usd,percent_share,status) VALUES
(1,1,242.42,24.2424,'acreditado'),(1,2,303.03,30.3030,'acreditado'),(1,3,454.55,45.4545,'acreditado');
INSERT INTO referrals(referrer_partner_id,referred_name,referred_email,capital_usd,commission_percent,status) VALUES
(1,'Referido Demo','referido@demo.com',2000,8,'activo');
INSERT INTO withdrawals(partner_id,amount_usd,request_type,destination,status) VALUES
(1,300,'ganancias','USDT TRC20 - Tw...9aFt','solicitado');
INSERT INTO whatsapp_numbers(label,phone,message,status) VALUES
('Ventas','5493810000001','Hola, quiero información sobre EL MASTER PROFE.','active'),
('Soporte','5493810000002','Hola, necesito soporte del CRM.','active'),
('Administración','5493810000003','Hola, quiero consultar por retiros o ganancias.','active');
INSERT INTO notifications(title,body,type) VALUES
('Nuevo retiro solicitado','Juan Pérez solicitó retirar US$ 300.','retiro'),
('Repartición acreditada','Se acreditaron distribuciones de la ganancia broker.','distribucion'),
('Nuevo referido','Juan Pérez registró un referido.','referido');

INSERT INTO permissions(module_key,module_name,role,can_view)
SELECT m.k,m.n,r.role, CASE WHEN r.role='superadmin' THEN 1 WHEN r.role='empleado' AND m.k NOT IN('users','roles','whatsapp') THEN 1 WHEN r.role='socio' AND m.k IN('dashboard','socios','referidos','distribuciones','retiros','notificaciones') THEN 1 ELSE 0 END
FROM (SELECT 'dashboard' k,'Dashboard' n UNION SELECT 'users','Usuarios' UNION SELECT 'roles','Roles y permisos' UNION SELECT 'socios','Socios' UNION SELECT 'referidos','Referidos' UNION SELECT 'profits','Ganancias broker' UNION SELECT 'distribuciones','Distribuciones' UNION SELECT 'retiros','Retiros' UNION SELECT 'whatsapp','WhatsApp' UNION SELECT 'notificaciones','Notificaciones' UNION SELECT 'auditoria','Auditoría') m
CROSS JOIN (SELECT 'superadmin' role UNION SELECT 'empleado' UNION SELECT 'socio') r;

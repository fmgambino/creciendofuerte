DROP DATABASE IF EXISTS revenue_crm;
CREATE DATABASE revenue_crm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE revenue_crm;

CREATE TABLE users(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(180) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role ENUM('superadmin','employee','partner') NOT NULL DEFAULT 'partner',
 status ENUM('active','inactive','blocked') NOT NULL DEFAULT 'active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE partners(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(180) NOT NULL,
 partner_code VARCHAR(40) NOT NULL UNIQUE,
 capital_usd DECIMAL(14,2) NOT NULL DEFAULT 0,
 kyc_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 status ENUM('active','inactive','paused') NOT NULL DEFAULT 'active',
 bank_data TEXT NULL,
 join_date DATE NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE broker_profits(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 profit_date DATE NOT NULL,
 gross_profit_usd DECIMAL(14,2) NOT NULL,
 admin_share_usd DECIMAL(14,2) NOT NULL,
 partners_pool_usd DECIMAL(14,2) NOT NULL,
 notes TEXT NULL,
 created_by INT UNSIGNED NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE distributions(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 broker_profit_id INT UNSIGNED NOT NULL,
 partner_id INT UNSIGNED NOT NULL,
 capital_at_distribution DECIMAL(14,2) NOT NULL,
 participation_percent DECIMAL(8,4) NOT NULL,
 amount_usd DECIMAL(14,2) NOT NULL,
 status ENUM('pending','paid') NOT NULL DEFAULT 'pending',
 paid_at DATETIME NULL,
 FOREIGN KEY(broker_profit_id) REFERENCES broker_profits(id) ON DELETE CASCADE,
 FOREIGN KEY(partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE withdrawals(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 partner_id INT UNSIGNED NOT NULL,
 amount_usd DECIMAL(14,2) NOT NULL,
 type ENUM('profit','capital','total') NOT NULL DEFAULT 'profit',
 account VARCHAR(190) NOT NULL,
 status ENUM('requested','review','approved','paid','rejected') NOT NULL DEFAULT 'requested',
 admin_notes TEXT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE referrals(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 partner_id INT UNSIGNED NOT NULL,
 invited_name VARCHAR(150) NOT NULL,
 invited_email VARCHAR(180) NOT NULL,
 ref_code VARCHAR(50) NOT NULL,
 commission_percent DECIMAL(6,2) NOT NULL DEFAULT 8,
 capital_bonus_percent DECIMAL(6,2) NOT NULL DEFAULT 20,
 status ENUM('new','active','paid','cancelled') NOT NULL DEFAULT 'new',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE role_permissions(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 module VARCHAR(80) NOT NULL,
 superadmin TINYINT(1) NOT NULL DEFAULT 1,
 employee TINYINT(1) NOT NULL DEFAULT 1,
 partner TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE whatsapp_numbers(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 label VARCHAR(80) NOT NULL,
 phone VARCHAR(40) NOT NULL,
 message VARCHAR(255) NOT NULL DEFAULT 'Hola, necesito asistencia sobre EL MASTER 10K CRM.',
 active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE notifications(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR(120) NOT NULL,
 body VARCHAR(255) NOT NULL,
 is_read TINYINT(1) NOT NULL DEFAULT 0,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE audit_logs(
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 event VARCHAR(190) NOT NULL,
 author VARCHAR(120) NOT NULL,
 type VARCHAR(60) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO users(full_name,email,password_hash,role,status) VALUES
('Fernando Gambino','fernando.m.gambino@gmail.com','$2y$12$8mlO5ah6PDaIZ/4bEvFC0e47BKQNPsVutNXPXJDtUheZtSPKkyQC6','superadmin','active'),
('Mesa Operativa','empleado01@elmaster.vip','$2y$12$8mlO5ah6PDaIZ/4bEvFC0e47BKQNPsVutNXPXJDtUheZtSPKkyQC6','employee','active'),
('Juan Pérez','juan@socio.demo','$2y$12$8mlO5ah6PDaIZ/4bEvFC0e47BKQNPsVutNXPXJDtUheZtSPKkyQC6','partner','active');

INSERT INTO partners(full_name,email,partner_code,capital_usd,kyc_status,status,bank_data,join_date) VALUES
('Juan Pérez','socio1@masterclub.io','MSTR-Q8CC-T76C',8000,'pending','active','USDT TRC20 · Tw...9aFt','2025-01-01'),
('Marina Soto','socio2@masterclub.io','MSTR-D9VO-N5B3',10000,'approved','active','Banco Galicia ****4421','2025-02-02'),
('Diego Vega','socio3@masterclub.io','MSTR-BSW6-Y1VE',15000,'approved','active','USDT TRC20 · Tw...9aFt','2025-03-03'),
('Ana Ruiz','socio4@masterclub.io','MSTR-K9FQ-9TD2',25000,'approved','active','Banco Galicia ****4421','2025-04-04'),
('Pedro Gómez','socio5@masterclub.io','MSTR-L1NX-IOWZ',50000,'approved','active','USDT TRC20 · Tw...9aFt','2025-05-05');

INSERT INTO broker_profits(profit_date,gross_profit_usd,admin_share_usd,partners_pool_usd,notes,created_by) VALUES
(CURDATE()-INTERVAL 5 DAY,2200,1320,880,'Carga inicial',1),(CURDATE()-INTERVAL 4 DAY,3100,1860,1240,'Carga inicial',1),(CURDATE()-INTERVAL 3 DAY,2800,1680,1120,'Carga inicial',1),(CURDATE()-INTERVAL 2 DAY,3900,2340,1560,'Carga inicial',1),(CURDATE()-INTERVAL 1 DAY,4200,2520,1680,'Carga inicial',1),(CURDATE(),7357.75,4414.65,2943.10,'Carga inicial',1);

INSERT INTO withdrawals(partner_id,amount_usd,type,account,status) VALUES
(1,600,'profit','USDT TRC20 · Tw...9aFt','paid'),(2,750,'profit','Banco Galicia ****4421','requested'),(3,900,'capital','USDT TRC20 · Tw...9aFt','review');

INSERT INTO referrals(partner_id,invited_name,invited_email,ref_code,commission_percent,capital_bonus_percent,status) VALUES
(1,'Carlos Nuevo','carlos@mail.com','MASTER-A1B2',8,20,'new'),(2,'Lucía Campos','lucia@mail.com','MASTER-C3D4',8,20,'active'),(3,'Nicolás Vera','nico@mail.com','MASTER-E5F6',7,20,'paid');

INSERT INTO role_permissions(module,superadmin,employee,partner) VALUES
('Dashboard',1,1,1),('Usuarios',1,0,0),('Roles y permisos',1,0,0),('Ganancias broker',1,1,0),('Distribuciones',1,1,1),('Retiros',1,1,1),('Referidos',1,1,1),('Socios',1,0,0),('Empleados',1,0,0),('Whatsapp',1,0,0),('Auditoría',1,1,0);

INSERT INTO whatsapp_numbers(label,phone,message,active) VALUES
('Administración','5493810000001','Hola, necesito asistencia administrativa sobre EL MASTER 10K.',1),('Retiros','5493810000002','Hola, quiero consultar por un retiro.',1),('Soporte socios','5493810000003','Hola, necesito soporte para mi cuenta de socio.',1);

INSERT INTO notifications(title,body,is_read) VALUES
('Retiro solicitado','Marina Soto solicitó un retiro de ganancias.',0),('KYC pendiente','Juan Pérez tiene documentación KYC pendiente.',0),('Nueva ganancia cargada','Se cargó la ganancia diaria del broker.',0),('Referido nuevo','Ingresó un nuevo referido al programa.',0),('Reporte disponible','El reporte mensual puede exportarse en PDF.',0);

INSERT INTO audit_logs(event,author,type) VALUES
('Sistema inicializado','Sistema','system'),('Carga de datos demo','Admin','seed');

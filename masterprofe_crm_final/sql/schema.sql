CREATE DATABASE IF NOT EXISTS masterprofe_crm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE masterprofe_crm;

DROP TABLE IF EXISTS audit_logs, notifications, whatsapp_numbers, withdrawals, distributions, broker_profits, referrals, partners, roles, users;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('superadmin','empleado','socio') NOT NULL DEFAULT 'socio',
  status ENUM('active','inactive','blocked') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE roles (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(80) NOT NULL,
  module_name VARCHAR(80) NOT NULL,
  can_view TINYINT(1) DEFAULT 1,
  can_create TINYINT(1) DEFAULT 0,
  can_edit TINYINT(1) DEFAULT 0,
  can_delete TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE partners (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NULL,
  member_code VARCHAR(40) NOT NULL UNIQUE,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(160) NOT NULL,
  capital_usd DECIMAL(14,2) NOT NULL DEFAULT 0,
  gain_usd DECIMAL(14,2) NOT NULL DEFAULT 0,
  kyc_status ENUM('pendiente','aprobado','rechazado') DEFAULT 'pendiente',
  status ENUM('active','inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE referrals (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  partner_id INT UNSIGNED NOT NULL,
  referred_name VARCHAR(150) NOT NULL,
  referred_email VARCHAR(160) NULL,
  capital_usd DECIMAL(14,2) DEFAULT 0,
  commission_percent DECIMAL(5,2) DEFAULT 8.00,
  bonus_percent DECIMAL(5,2) DEFAULT 20.00,
  status ENUM('pendiente','active','pagado') DEFAULT 'pendiente',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE broker_profits (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  profit_date DATE NOT NULL,
  gross_profit_usd DECIMAL(14,2) NOT NULL,
  master_share_usd DECIMAL(14,2) NOT NULL DEFAULT 0,
  partners_share_usd DECIMAL(14,2) NOT NULL DEFAULT 0,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE distributions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  broker_profit_id INT UNSIGNED NULL,
  partner_id INT UNSIGNED NOT NULL,
  amount_usd DECIMAL(14,2) NOT NULL,
  percent_share DECIMAL(8,4) NOT NULL,
  status ENUM('pendiente','acreditado','pagado') DEFAULT 'acreditado',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (broker_profit_id) REFERENCES broker_profits(id) ON DELETE SET NULL,
  FOREIGN KEY (partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE withdrawals (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  partner_id INT UNSIGNED NOT NULL,
  amount_usd DECIMAL(14,2) NOT NULL,
  account_to VARCHAR(190) NOT NULL,
  status ENUM('solicitado','revision','transferido','rechazado') DEFAULT 'solicitado',
  requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES partners(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE whatsapp_numbers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  label VARCHAR(100) NOT NULL,
  phone VARCHAR(40) NOT NULL,
  message VARCHAR(255) DEFAULT 'Hola Master Profe, necesito asistencia.',
  status ENUM('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE notifications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(160) NOT NULL,
  body TEXT NULL,
  status ENUM('unread','read') DEFAULT 'unread',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE audit_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  event VARCHAR(190) NOT NULL,
  author VARCHAR(120) DEFAULT 'Sistema',
  type VARCHAR(60) DEFAULT 'sistema',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO users(full_name,email,password_hash,role,status) VALUES
('Fernando Gambino','fernando.m.gambino@gmail.com','$2y$10$3skVZbYAu4mZ7ciObTR1Iui6/6CQbJMQN78PA1sC5WHXGeBRxHSAe','superadmin','active'),
('Juan Pérez','juan@socio.demo','$2y$10$3skVZbYAu4mZ7ciObTR1Iui6/6CQbJMQN78PA1sC5WHXGeBRxHSAe','socio','active'),
('Mesa Operativa','mesa@masterprofe.demo','$2y$10$3skVZbYAu4mZ7ciObTR1Iui6/6CQbJMQN78PA1sC5WHXGeBRxHSAe','empleado','active');

INSERT INTO partners(member_code,full_name,email,capital_usd,gain_usd,kyc_status,status) VALUES
('MSTR-Q8CC-T76C','Juan Pérez','socio1@masterclub.io',8000,720,'pendiente','active'),
('MSTR-D9VO-N5B3','Marina Soto','socio2@masterclub.io',10000,907,'aprobado','active'),
('MSTR-BSW6-Y1VE','Diego Vega','socio3@masterclub.io',15000,1094,'aprobado','active'),
('MSTR-K9FQ-9TD2','Ana Ruiz','socio4@masterclub.io',25000,1281,'aprobado','active'),
('MSTR-L1NX-IOWZ','Pedro Gómez','socio5@masterclub.io',50000,1468,'aprobado','active');

INSERT INTO broker_profits(profit_date,gross_profit_usd,master_share_usd,partners_share_usd,notes) VALUES
('2026-06-01',2500,1500,1000,'Comisiones broker'),('2026-06-02',3100,1860,1240,'Comisiones broker'),('2026-06-03',2800,1680,1120,'Comisiones broker'),('2026-06-04',4200,2520,1680,'Comisiones broker'),('2026-06-05',3900,2340,1560,'Comisiones broker'),('2026-06-06',5200,3120,2080,'Comisiones broker');

INSERT INTO distributions(partner_id,amount_usd,percent_share,status) VALUES
(1,160,7.41,'acreditado'),(2,200,9.26,'acreditado'),(3,300,13.89,'acreditado'),(4,500,23.15,'acreditado'),(5,1000,46.29,'acreditado');

INSERT INTO referrals(partner_id,referred_name,referred_email,capital_usd,commission_percent,bonus_percent,status) VALUES
(1,'Referido A','refa@mail.com',1000,8,20,'pendiente'),(2,'Referido B','refb@mail.com',2500,8,20,'active'),(3,'Referido C','refc@mail.com',4000,8,20,'active');

INSERT INTO withdrawals(partner_id,amount_usd,account_to,status) VALUES
(1,600,'USDT TRC20 · Tw...9aFt','transferido'),(2,850,'Banco Galicia ****4421','revision'),(3,1250,'USDT TRC20 · Tw...9aFt','solicitado');

INSERT INTO whatsapp_numbers(label,phone,message,status) VALUES
('Administración','5493810000001','Hola Master Profe, necesito hablar con administración.','active'),
('Retiros','5493810000002','Hola Master Profe, quiero consultar por un retiro.','active'),
('Soporte socios','5493810000003','Hola Master Profe, necesito soporte con mi cuenta.','active');

INSERT INTO notifications(title,body,status) VALUES
('Nuevo retiro solicitado','Juan Pérez solicitó retiro de ganancias.','unread'),('Ganancia broker cargada','Se registró nueva comisión del broker.','unread'),('KYC aprobado','Marina Soto fue aprobada.','read');

INSERT INTO audit_logs(event,author,type) VALUES
('Aprobó retiro RT-1051','Admin','retiro'),('Cargó ganancia broker','Admin','profit'),('Modificó perfil de socio','Sistema','socio'),('KYC aprobado','Admin','kyc');

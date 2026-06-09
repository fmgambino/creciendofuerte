-- PATCH seguro para Hostinger/XAMPP: permisos + niveles de capital + corrección de distribución equitativa
-- Ejecutar dentro de la BD existente. No borra datos.

CREATE TABLE IF NOT EXISTS capital_levels (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(80) NOT NULL,
 amount_usd DECIMAL(12,2) NOT NULL,
 percent_share DECIMAL(8,4) NOT NULL DEFAULT 0,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO capital_levels(name,amount_usd,percent_share,status)
SELECT 'Nivel 2K',2000,0,'active' WHERE NOT EXISTS (SELECT 1 FROM capital_levels WHERE amount_usd=2000);
INSERT INTO capital_levels(name,amount_usd,percent_share,status)
SELECT 'Nivel 5K',5000,0,'active' WHERE NOT EXISTS (SELECT 1 FROM capital_levels WHERE amount_usd=5000);
INSERT INTO capital_levels(name,amount_usd,percent_share,status)
SELECT 'Nivel 10K',10000,0,'active' WHERE NOT EXISTS (SELECT 1 FROM capital_levels WHERE amount_usd=10000);

DELETE FROM permissions WHERE module_key IN ('dashboard','perfil','users','roles','socios','referidos','profits','distribuciones','capitales','retiros','whatsapp','notificaciones','auditoria');

INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES
('dashboard','Dashboard','superadmin',1,1,1,1,1),
('dashboard','Dashboard','empleado',1,0,0,0,1),
('dashboard','Dashboard','socio',1,0,0,0,0),
('perfil','Mi Perfil','superadmin',1,1,1,1,1),
('perfil','Mi Perfil','empleado',1,0,1,0,1),
('perfil','Mi Perfil','socio',1,0,1,0,0),
('users','Usuarios','superadmin',1,1,1,1,1),
('users','Usuarios','empleado',0,0,0,0,0),
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
('distribuciones','Distribuciones','empleado',1,0,0,0,1),
('distribuciones','Distribuciones','socio',1,0,0,0,1),
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

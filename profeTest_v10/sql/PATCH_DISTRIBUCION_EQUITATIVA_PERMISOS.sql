-- PATCH SEGURO - MASTER PROFE CRM
-- Compatible con XAMPP y Hostinger. No borra usuarios, socios ni movimientos.

ALTER TABLE distributions MODIFY status ENUM('pendiente','en_proceso','transferido','acreditado','pagado') NOT NULL DEFAULT 'acreditado';
ALTER TABLE withdrawals MODIFY status ENUM('pendiente','en_proceso','transferido','acreditado','pagado','rechazado') NOT NULL DEFAULT 'pendiente';

-- Agrega niveles de capital si no existen.
INSERT INTO capital_levels(name,amount_usd,percent_share,status)
SELECT 'Nivel 2K',2000,0,'active'
WHERE NOT EXISTS (SELECT 1 FROM capital_levels WHERE amount_usd=2000);
INSERT INTO capital_levels(name,amount_usd,percent_share,status)
SELECT 'Nivel 5K',5000,0,'active'
WHERE NOT EXISTS (SELECT 1 FROM capital_levels WHERE amount_usd=5000);
INSERT INTO capital_levels(name,amount_usd,percent_share,status)
SELECT 'Nivel 10K',10000,0,'active'
WHERE NOT EXISTS (SELECT 1 FROM capital_levels WHERE amount_usd=10000);

-- Permiso del módulo Distribuciones: solo SuperAdmin.
UPDATE permissions SET can_view=1, can_create=1, can_edit=1, can_delete=1, can_export=1
WHERE module_key='distribuciones' AND role='superadmin';
UPDATE permissions SET can_view=0, can_create=0, can_edit=0, can_delete=0, can_export=0
WHERE module_key='distribuciones' AND role IN('empleado','socio');

-- Si faltan permisos de Distribuciones, los crea sin usar ON DUPLICATE KEY UPDATE.
INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export)
SELECT 'distribuciones','Distribuciones','superadmin',1,1,1,1,1
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE module_key='distribuciones' AND role='superadmin');
INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export)
SELECT 'distribuciones','Distribuciones','empleado',0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE module_key='distribuciones' AND role='empleado');
INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export)
SELECT 'distribuciones','Distribuciones','socio',0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE module_key='distribuciones' AND role='socio');

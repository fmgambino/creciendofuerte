-- PATCH_SOCIOS_RETIROS_SYNC.sql
-- Corrige correlación Socios <-> Usuarios, permisos de retiros/distribuciones y estados.
-- Ejecutar sobre la base existente revenue_crm / u570224512_master10k.

-- Crear usuario socio para cada socio que no tenga usuario por email.
INSERT INTO users(full_name,email,password_hash,role,status,profile_photo)
SELECT p.full_name,p.email,'$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re','socio',p.status,'assets/img/avatar.svg'
FROM partners p
LEFT JOIN users u ON u.email=p.email
WHERE p.email IS NOT NULL AND p.email<>'' AND u.id IS NULL;

-- Vincular partners.user_id al usuario por email.
UPDATE partners p
JOIN users u ON u.email=p.email
SET p.user_id=u.id
WHERE p.user_id IS NULL OR p.user_id=0;

-- Normalizar roles de usuarios asociados a socios.
UPDATE users u
JOIN partners p ON p.user_id=u.id
SET u.role='socio', u.status=p.status;

-- Normalizar estados antiguos.
UPDATE withdrawals SET status='pendiente' WHERE status IN('solicitado','en_revision') OR status IS NULL OR status='';

-- Permisos recomendados: el socio crea y ve retiros, pero no edita estado ni elimina.
DELETE FROM permissions WHERE module_key='retiros' AND role IN('socio','superadmin','empleado');
INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES
('retiros','Retiros','superadmin',1,1,1,1,1),
('retiros','Retiros','empleado',1,1,1,0,1),
('retiros','Retiros','socio',1,1,0,0,1);

-- Distribuciones solo SuperAdmin por privacidad operativa.
DELETE FROM permissions WHERE module_key='distribuciones' AND role IN('socio','superadmin','empleado');
INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES
('distribuciones','Distribuciones','superadmin',1,1,1,1,1),
('distribuciones','Distribuciones','empleado',0,0,0,0,0),
('distribuciones','Distribuciones','socio',0,0,0,0,0);

CREATE TABLE IF NOT EXISTS app_settings (
  key_name VARCHAR(80) NOT NULL PRIMARY KEY,
  value TEXT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO app_settings(key_name,value) VALUES
('app_title','EL MASTER PROFE CRM'),
('app_short_title','EL MASTER'),
('app_subtitle','PROFE CRM'),
('title_color','#ffffff'),
('subtitle_color','#ffe05d'),
('brand_color','#3b747b'),
('accent_color','#69d3d1'),
('logo_path','assets/img/icon.svg'),
('favicon_path','assets/img/icon.svg'),
('pwa_icon_path','assets/img/icon.svg'),
('email_logo_path','assets/img/icon.svg');

DELETE FROM permissions WHERE module_key='configuraciones';
INSERT INTO permissions(module_key,module_name,role,can_view,can_create,can_edit,can_delete,can_export) VALUES
('configuraciones','Configuraciones','superadmin',1,1,1,1,1),
('configuraciones','Configuraciones','empleado',0,0,0,0,0),
('configuraciones','Configuraciones','socio',0,0,0,0,0);

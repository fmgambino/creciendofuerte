-- PATCH V06 - Login: selector de fondo exclusivo
-- Este patch no borra imágenes subidas; solo asegura valor válido por defecto.
CREATE TABLE IF NOT EXISTS app_settings (
  key_name varchar(80) NOT NULL PRIMARY KEY,
  value text NULL,
  updated_at datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO app_settings(key_name,value) VALUES ('login_bg_type','css')
ON DUPLICATE KEY UPDATE value = CASE WHEN value IN ('css','image','video') THEN value ELSE 'css' END;

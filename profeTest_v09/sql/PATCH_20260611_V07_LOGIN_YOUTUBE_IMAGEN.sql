-- PATCH V07 LOGIN YOUTUBE / IMAGEN
-- No modifica estructura crítica. Asegura tabla app_settings y claves usadas por el login.
CREATE TABLE IF NOT EXISTS app_settings (
  key_name varchar(80) NOT NULL PRIMARY KEY,
  value text NULL,
  updated_at datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO app_settings (key_name, value) VALUES
('login_bg_type', 'css'),
('login_bg_url', ''),
('login_bg_path', '')
ON DUPLICATE KEY UPDATE value = value;

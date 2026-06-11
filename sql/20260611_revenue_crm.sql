-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-06-2026 a las 23:55:42
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `revenue_crm`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `app_settings`
--

CREATE TABLE `app_settings` (
  `key_name` varchar(80) NOT NULL,
  `value` text DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `app_settings`
--

INSERT INTO `app_settings` (`key_name`, `value`, `updated_at`) VALUES
('accent_color', '#69d3d1', '2026-06-11 18:54:25'),
('app_short_title', 'BACKOFFICES', '2026-06-11 18:54:25'),
('app_subtitle', '10K CRM', '2026-06-11 18:54:25'),
('app_title', '10K CRM - BACKOFFICES© 2026', '2026-06-11 18:54:25'),
('brand_color', '#3b747b', '2026-06-11 18:54:25'),
('email_logo_path', 'assets/img/icon.svg', '2026-06-11 16:17:10'),
('favicon_path', 'assets/img/icon.svg', '2026-06-11 16:17:10'),
('footer_text', '© 2026 EL MASTER 10K - Todos los derechos Registrados - Desarrollado por Electrónica Gambino', '2026-06-11 18:54:25'),
('footer_url', 'https://electronicagambino.com', '2026-06-11 18:54:25'),
('login_bg_path', 'uploads/settings/login_bg_1781214865.png', '2026-06-11 18:54:25'),
('login_bg_type', 'image', '2026-06-11 18:54:25'),
('login_bg_url', 'https://www.youtube.com/watch?v=QQ1QOlMRXNs', '2026-06-11 18:54:25'),
('logo_path', 'assets/img/icon.svg', '2026-06-11 16:17:10'),
('pwa_icon_path', 'assets/img/icon.svg', '2026-06-11 16:17:10'),
('smtp_enabled', '0', '2026-06-11 18:54:25'),
('smtp_from_email', '', '2026-06-11 18:54:25'),
('smtp_from_name', 'EL MASTER PROFE CRM', '2026-06-11 18:54:25'),
('smtp_host', '', '2026-06-11 18:54:25'),
('smtp_password', 'demo123', '2026-06-11 18:54:25'),
('smtp_port', '587', '2026-06-11 18:54:25'),
('smtp_secure', 'tls', '2026-06-11 18:54:25'),
('smtp_username', 'fernando.m.gambino@gmail.com', '2026-06-11 18:54:25'),
('subtitle_color', '#ffe05d', '2026-06-11 18:54:25'),
('title_color', '#b9b6b6', '2026-06-11 18:54:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `event` varchar(255) NOT NULL,
  `author` varchar(120) NOT NULL,
  `type` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `event`, `author`, `type`, `created_at`) VALUES
(1, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 15:33:21'),
(2, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 15:36:54'),
(3, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 15:46:18'),
(4, 'Guardó withdrawals', 'Fernando Gambino', 'crud', '2026-06-11 15:48:51'),
(5, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 15:51:30'),
(6, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 15:51:40'),
(7, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 15:56:52'),
(8, 'Actualizó roles y permisos', 'Fernando Gambino', 'security', '2026-06-11 15:57:33'),
(9, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 15:57:39'),
(10, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 16:17:33'),
(11, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 16:40:04'),
(12, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 16:40:16'),
(13, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-11 16:42:03'),
(14, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-11 16:42:12'),
(15, 'Guardó withdrawals', 'Fernando Gambino', 'crud', '2026-06-11 16:44:19'),
(16, 'Guardó withdrawals', 'Fernando Gambino', 'crud', '2026-06-11 16:44:44'),
(17, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 16:44:55'),
(18, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 16:46:47'),
(19, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 16:47:02'),
(20, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 16:53:14'),
(21, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 17:11:05'),
(22, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 17:11:32'),
(23, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 17:21:45'),
(24, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 17:52:55'),
(25, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 17:53:18'),
(26, 'Actualizó roles y permisos', 'Fernando Gambino', 'security', '2026-06-11 17:53:32'),
(27, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 17:54:02'),
(28, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:04:52'),
(29, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:05:21'),
(30, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:14:41'),
(31, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:19:51'),
(32, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:20:46'),
(33, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:21:44'),
(34, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:25:08'),
(35, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:29:54'),
(36, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:33:12'),
(37, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:33:29'),
(38, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:36:10'),
(39, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:38:12'),
(40, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:39:47'),
(41, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:40:00'),
(42, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:40:17'),
(43, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:40:32'),
(44, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:40:53'),
(45, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:41:01'),
(46, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:41:20'),
(47, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:42:08'),
(48, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:44:24'),
(49, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:44:40'),
(50, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:44:42'),
(51, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:47:53'),
(52, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:48:09'),
(53, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-11 18:49:33'),
(54, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:51:04'),
(55, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:52:22'),
(56, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:52:36'),
(57, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:52:59'),
(58, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:53:58'),
(59, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:54:07'),
(60, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 18:54:11'),
(61, 'Actualizó configuraciones de la PWA', 'Fernando Gambino', 'config', '2026-06-11 18:54:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `broker_profits`
--

CREATE TABLE `broker_profits` (
  `id` int(10) UNSIGNED NOT NULL,
  `profit_date` date NOT NULL,
  `gross_profit_usd` decimal(12,2) NOT NULL,
  `master_share_usd` decimal(12,2) NOT NULL,
  `partners_share_usd` decimal(12,2) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `broker_profits`
--

INSERT INTO `broker_profits` (`id`, `profit_date`, `gross_profit_usd`, `master_share_usd`, `partners_share_usd`, `notes`, `created_at`) VALUES
(1, '2026-06-06', 1850.00, 1110.00, 740.00, 'Demo', '2026-06-11 15:33:11'),
(2, '2026-06-07', 2200.00, 1320.00, 880.00, 'Demo', '2026-06-11 15:33:11'),
(3, '2026-06-08', 2500.00, 1500.00, 1000.00, 'Demo', '2026-06-11 15:33:11'),
(4, '2026-06-09', 1900.00, 1140.00, 760.00, 'Demo', '2026-06-11 15:33:11'),
(5, '2026-06-10', 3100.00, 1860.00, 1240.00, 'Demo', '2026-06-11 15:33:11'),
(6, '2026-06-11', 10000.00, 6000.00, 4000.00, 'Carga inicial demo', '2026-06-11 15:33:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capital_levels`
--

CREATE TABLE `capital_levels` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(80) NOT NULL,
  `amount_usd` decimal(12,2) NOT NULL,
  `percent_share` decimal(8,4) NOT NULL DEFAULT 0.0000,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `capital_levels`
--

INSERT INTO `capital_levels` (`id`, `name`, `amount_usd`, `percent_share`, `status`, `created_at`) VALUES
(1, 'Nivel 2K', 2000.00, 0.0000, 'active', '2026-06-11 15:33:11'),
(2, 'Nivel 5K', 5000.00, 0.0000, 'active', '2026-06-11 15:33:11'),
(3, 'Nivel 10K', 10000.00, 0.0000, 'active', '2026-06-11 15:33:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `distributions`
--

CREATE TABLE `distributions` (
  `id` int(10) UNSIGNED NOT NULL,
  `broker_profit_id` int(10) UNSIGNED DEFAULT NULL,
  `partner_id` int(10) UNSIGNED NOT NULL,
  `amount_usd` decimal(12,2) NOT NULL,
  `percent_share` decimal(8,4) NOT NULL,
  `status` enum('pendiente','en_proceso','transferido','acreditado','pagado') NOT NULL DEFAULT 'acreditado',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `distributions`
--

INSERT INTO `distributions` (`id`, `broker_profit_id`, `partner_id`, `amount_usd`, `percent_share`, `status`, `created_at`) VALUES
(1, 6, 1, 1333.33, 33.3333, 'acreditado', '2026-06-11 15:33:11'),
(2, 6, 2, 1333.33, 33.3333, 'acreditado', '2026-06-11 15:33:11'),
(3, 6, 3, 1333.34, 33.3334, 'acreditado', '2026-06-11 15:33:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` varchar(255) NOT NULL,
  `type` varchar(40) NOT NULL DEFAULT 'info',
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `partner_id` int(10) UNSIGNED DEFAULT NULL,
  `audience` enum('admin','partner','all') NOT NULL DEFAULT 'admin',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `notifications`
--

INSERT INTO `notifications` (`id`, `title`, `body`, `type`, `user_id`, `partner_id`, `audience`, `is_read`, `created_at`) VALUES
(1, 'Nuevo retiro solicitado', 'Juan Pérez solicitó retirar US$ 300.', 'retiro', NULL, NULL, 'admin', 1, '2026-06-11 15:33:11'),
(2, 'Repartición acreditada', 'Se acreditaron distribuciones de la ganancia broker.', 'distribucion', NULL, NULL, 'admin', 1, '2026-06-11 15:33:11'),
(3, 'Nuevo referido', 'Juan Pérez registró un referido.', 'referido', NULL, NULL, 'admin', 1, '2026-06-11 15:33:11'),
(4, 'Nueva solicitud de cuenta', 'Se registró Carolina Gambino y espera aprobación.', 'usuario', NULL, NULL, 'admin', 1, '2026-06-11 16:15:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partners`
--

CREATE TABLE `partners` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `partner_code` varchar(40) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(160) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` varchar(180) DEFAULT NULL,
  `bank_account` varchar(180) DEFAULT NULL,
  `capital_usd` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gains_usd` decimal(12,2) NOT NULL DEFAULT 0.00,
  `kyc_status` enum('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `joined_at` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partners`
--

INSERT INTO `partners` (`id`, `user_id`, `partner_code`, `full_name`, `email`, `phone`, `address`, `bank_account`, `capital_usd`, `gains_usd`, `kyc_status`, `status`, `joined_at`, `created_at`) VALUES
(1, 3, 'MSTR-JUAN-0001', 'Juan Pérez', 'juan@socio.demo', '3815551111', 'San Miguel de Tucumán', 'USDT TRC20 - Tw...9aFt', 10000.00, 2573.33, 'aprobado', 'active', '2026-01-01', '2026-06-11 15:33:11'),
(2, NULL, 'MSTR-MARI-0002', 'Marina Soto', 'marina@socio.demo', '3815552222', 'Tucumán', 'Banco Galicia ****4421', 10000.00, 2873.33, 'aprobado', 'active', '2026-02-02', '2026-06-11 15:33:11'),
(3, 5, 'MSTR-DIEG-0003', 'Diego Vega', 'diego@socio.demo', '3815553333', 'Tucumán', 'USDT TRC20 - Tw...9aFt', 10000.00, 2873.33, 'aprobado', 'active', '2026-03-03', '2026-06-11 15:33:11'),
(4, 4, 'MSTR-CARO-0004', 'Carolina Gambino', 'fmgambino@hotmail.com', NULL, NULL, NULL, 0.00, 2873.33, 'pendiente', 'inactive', '2026-06-11', '2026-06-11 16:15:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `module_key` varchar(80) NOT NULL,
  `module_name` varchar(120) NOT NULL,
  `role` varchar(30) NOT NULL,
  `can_view` tinyint(1) NOT NULL DEFAULT 0,
  `can_create` tinyint(1) NOT NULL DEFAULT 0,
  `can_edit` tinyint(1) NOT NULL DEFAULT 0,
  `can_delete` tinyint(1) NOT NULL DEFAULT 0,
  `can_export` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `module_key`, `module_name`, `role`, `can_view`, `can_create`, `can_edit`, `can_delete`, `can_export`) VALUES
(1, 'dashboard', 'Dashboard', 'superadmin', 1, 1, 1, 1, 1),
(2, 'dashboard', 'Dashboard', 'empleado', 1, 0, 0, 0, 1),
(3, 'dashboard', 'Dashboard', 'socio', 1, 0, 0, 0, 0),
(4, 'perfil', 'Mi Perfil', 'superadmin', 1, 1, 1, 1, 1),
(5, 'perfil', 'Mi Perfil', 'empleado', 1, 0, 0, 0, 1),
(6, 'perfil', 'Mi Perfil', 'socio', 1, 0, 1, 0, 0),
(7, 'users', 'Usuarios', 'superadmin', 1, 1, 1, 1, 1),
(8, 'users', 'Usuarios', 'empleado', 0, 0, 0, 0, 1),
(9, 'users', 'Usuarios', 'socio', 0, 0, 0, 0, 0),
(10, 'roles', 'Roles y permisos', 'superadmin', 1, 1, 1, 1, 1),
(11, 'roles', 'Roles y permisos', 'empleado', 0, 0, 0, 0, 0),
(12, 'roles', 'Roles y permisos', 'socio', 0, 0, 0, 0, 0),
(13, 'socios', 'Socios', 'superadmin', 1, 1, 1, 1, 1),
(14, 'socios', 'Socios', 'empleado', 1, 1, 1, 0, 1),
(15, 'socios', 'Socios', 'socio', 0, 0, 0, 0, 0),
(16, 'referidos', 'Referidos', 'superadmin', 1, 1, 1, 1, 1),
(17, 'referidos', 'Referidos', 'empleado', 1, 1, 1, 0, 1),
(18, 'referidos', 'Referidos', 'socio', 0, 0, 0, 0, 0),
(19, 'profits', 'Ganancias broker', 'superadmin', 1, 1, 1, 1, 1),
(20, 'profits', 'Ganancias broker', 'empleado', 1, 1, 1, 0, 1),
(21, 'profits', 'Ganancias broker', 'socio', 1, 0, 0, 0, 0),
(22, 'distribuciones', 'Distribuciones', 'superadmin', 1, 1, 1, 1, 1),
(23, 'distribuciones', 'Distribuciones', 'empleado', 0, 0, 0, 0, 0),
(24, 'distribuciones', 'Distribuciones', 'socio', 1, 0, 0, 0, 0),
(25, 'capitales', 'Niveles de capital', 'superadmin', 1, 1, 1, 1, 1),
(26, 'capitales', 'Niveles de capital', 'empleado', 1, 0, 0, 0, 1),
(27, 'capitales', 'Niveles de capital', 'socio', 0, 0, 0, 0, 0),
(28, 'retiros', 'Retiros', 'superadmin', 1, 1, 1, 1, 1),
(29, 'retiros', 'Retiros', 'empleado', 1, 1, 1, 0, 1),
(30, 'retiros', 'Retiros', 'socio', 1, 1, 0, 0, 1),
(31, 'whatsapp', 'WhatsApp', 'superadmin', 1, 1, 1, 1, 1),
(32, 'whatsapp', 'WhatsApp', 'empleado', 0, 0, 0, 0, 0),
(33, 'whatsapp', 'WhatsApp', 'socio', 0, 0, 0, 0, 0),
(34, 'notificaciones', 'Notificaciones', 'superadmin', 1, 1, 1, 1, 1),
(35, 'notificaciones', 'Notificaciones', 'empleado', 1, 1, 1, 0, 1),
(36, 'notificaciones', 'Notificaciones', 'socio', 1, 1, 0, 0, 0),
(37, 'auditoria', 'Auditoría', 'superadmin', 1, 1, 1, 1, 1),
(38, 'auditoria', 'Auditoría', 'empleado', 1, 0, 0, 0, 1),
(39, 'auditoria', 'Auditoría', 'socio', 0, 0, 0, 0, 0),
(40, 'configuraciones', 'Configuraciones', 'superadmin', 1, 1, 1, 1, 1),
(41, 'configuraciones', 'Configuraciones', 'empleado', 0, 0, 0, 0, 0),
(42, 'configuraciones', 'Configuraciones', 'socio', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `referrals`
--

CREATE TABLE `referrals` (
  `id` int(10) UNSIGNED NOT NULL,
  `referrer_partner_id` int(10) UNSIGNED NOT NULL,
  `referred_name` varchar(150) NOT NULL,
  `referred_email` varchar(160) NOT NULL,
  `capital_usd` decimal(12,2) NOT NULL DEFAULT 0.00,
  `commission_percent` decimal(6,2) NOT NULL DEFAULT 8.00,
  `status` enum('nuevo','activo','pagado','cancelado') NOT NULL DEFAULT 'nuevo',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `referrals`
--

INSERT INTO `referrals` (`id`, `referrer_partner_id`, `referred_name`, `referred_email`, `capital_usd`, `commission_percent`, `status`, `created_at`) VALUES
(1, 1, 'Referido Demo', 'referido@demo.com', 2000.00, 8.00, 'activo', '2026-06-11 15:33:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(160) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('superadmin','empleado','socio') NOT NULL DEFAULT 'socio',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `profile_photo` varchar(255) DEFAULT 'assets/img/avatar.svg',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password_hash`, `role`, `status`, `profile_photo`, `created_at`, `updated_at`) VALUES
(1, 'Fernando Gambino', 'fernando.m.gambino@gmail.com', '$2y$10$2EyNGGUEQvZ7x9KZb9v4deCwOKo32v8okTqDjxE2Qe9q9QJgD5fSm', 'superadmin', 'active', 'uploads/profiles/profile_1_1781214485.png', '2026-06-11 15:33:11', '2026-06-11 18:48:05'),
(2, 'Mesa Operativa', 'mesa@masterprofe.demo', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'empleado', 'active', 'assets/img/avatar.svg', '2026-06-11 15:33:11', NULL),
(3, 'Juan Pérez', 'juan@socio.demo', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'socio', 'active', 'assets/img/avatar.svg', '2026-06-11 15:33:11', NULL),
(4, 'Carolina Gambino', 'fmgambino@hotmail.com', '$2y$10$4j/rJ1CKRSEuRWNhdIcveuPaxUfLFZoSKGN2GmpTQy82Kuq41GtNi', 'socio', 'inactive', 'assets/img/avatar.svg', '2026-06-11 16:15:43', NULL),
(5, 'Diego Vega', 'diego@socio.demo', '$2y$10$fqlK0kn2TkgvsqmsuqZk8.2hD5vfwp8/5no6uk3Fr6JTKUcZnYr5i', 'socio', 'active', 'assets/img/avatar.svg', '2026-06-11 16:42:03', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `whatsapp_numbers`
--

CREATE TABLE `whatsapp_numbers` (
  `id` int(10) UNSIGNED NOT NULL,
  `label` varchar(80) NOT NULL,
  `phone` varchar(40) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT 'Hola, necesito información sobre EL MASTER PROFE CRM.',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `whatsapp_numbers`
--

INSERT INTO `whatsapp_numbers` (`id`, `label`, `phone`, `message`, `status`, `created_at`) VALUES
(1, 'Ventas', '5493810000001', 'Hola, quiero información sobre EL MASTER PROFE.', 'active', '2026-06-11 15:33:11'),
(2, 'Soporte', '5493810000002', 'Hola, necesito soporte del CRM.', 'active', '2026-06-11 15:33:11'),
(3, 'Administración', '5493810000003', 'Hola, quiero consultar por retiros o ganancias.', 'active', '2026-06-11 15:33:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `withdrawals`
--

CREATE TABLE `withdrawals` (
  `id` int(10) UNSIGNED NOT NULL,
  `partner_id` int(10) UNSIGNED NOT NULL,
  `amount_usd` decimal(12,2) NOT NULL,
  `request_type` enum('ganancias','capital_total') NOT NULL DEFAULT 'ganancias',
  `destination` varchar(255) NOT NULL,
  `status` enum('pendiente','en_proceso','transferido','acreditado','pagado','rechazado') NOT NULL DEFAULT 'pendiente',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `withdrawals`
--

INSERT INTO `withdrawals` (`id`, `partner_id`, `amount_usd`, `request_type`, `destination`, `status`, `created_at`) VALUES
(1, 1, 300.00, 'ganancias', 'USDT TRC20 - Tw...9aFt', 'pagado', '2026-06-11 15:33:11');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`key_name`);

--
-- Indices de la tabla `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `broker_profits`
--
ALTER TABLE `broker_profits`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `capital_levels`
--
ALTER TABLE `capital_levels`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `distributions`
--
ALTER TABLE `distributions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `broker_profit_id` (`broker_profit_id`),
  ADD KEY `partner_id` (`partner_id`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `partners`
--
ALTER TABLE `partners`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `partner_code` (`partner_code`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_perm` (`module_key`,`role`);

--
-- Indices de la tabla `referrals`
--
ALTER TABLE `referrals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `referrer_partner_id` (`referrer_partner_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `whatsapp_numbers`
--
ALTER TABLE `whatsapp_numbers`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partner_id` (`partner_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `broker_profits`
--
ALTER TABLE `broker_profits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `capital_levels`
--
ALTER TABLE `capital_levels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `distributions`
--
ALTER TABLE `distributions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `partners`
--
ALTER TABLE `partners`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT de la tabla `referrals`
--
ALTER TABLE `referrals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `whatsapp_numbers`
--
ALTER TABLE `whatsapp_numbers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `distributions`
--
ALTER TABLE `distributions`
  ADD CONSTRAINT `distributions_ibfk_1` FOREIGN KEY (`broker_profit_id`) REFERENCES `broker_profits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `distributions_ibfk_2` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `partners`
--
ALTER TABLE `partners`
  ADD CONSTRAINT `partners_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `referrals`
--
ALTER TABLE `referrals`
  ADD CONSTRAINT `referrals_ibfk_1` FOREIGN KEY (`referrer_partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_ibfk_1` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

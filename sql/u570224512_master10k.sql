-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 11-06-2026 a las 22:04:18
-- Versión del servidor: 11.8.6-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u570224512_master10k`
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
('app_name', '10K CRM', '2026-06-11 22:02:34'),
('brand_name', 'BACKOFFICES 10K CRM', '2026-06-11 22:02:34'),
('developer_name', 'Electrónica Gambino', '2026-06-11 22:02:34'),
('developer_url', 'https://electronicagambino.com', '2026-06-11 22:02:34'),
('footer_text', '© 2026 10K CRM - BACKOFFICES - Todos los derechos Registrados', '2026-06-11 22:02:34'),
('login_bg_path', '', '2026-06-11 22:02:34'),
('login_bg_type', 'css', '2026-06-11 22:02:34'),
('login_bg_url', '', '2026-06-11 22:02:34'),
('login_google_enabled', '1', '2026-06-11 22:02:34'),
('login_right_card_enabled', '0', '2026-06-11 22:02:34');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `event`, `author`, `type`, `created_at`) VALUES
(1, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 16:22:17'),
(2, 'Actualizó roles y permisos', 'Fernando Gambino', 'security', '2026-06-10 16:22:17'),
(3, 'Guardó ganancias broker', 'Fernando Gambino', 'crud', '2026-06-10 16:22:17'),
(4, 'Nuevo retiro solicitado', 'Juan Pérez', 'retiro', '2026-06-10 16:22:17'),
(5, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 16:22:21'),
(6, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 16:23:26'),
(7, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 16:27:13'),
(8, 'Actualizó roles y permisos', 'Fernando Gambino', 'security', '2026-06-10 16:40:51'),
(9, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 16:41:13'),
(10, 'Guardó users', 'Fernando Gambino', 'crud', '2026-06-10 16:41:47'),
(11, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 16:44:45'),
(12, 'Guardó users', 'Fernando Gambino', 'crud', '2026-06-10 16:45:18'),
(13, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-10 16:45:25'),
(14, 'Inicio de sesión', 'Michael', 'auth', '2026-06-10 17:55:13'),
(15, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 18:12:52'),
(16, 'Guardó distributions', 'Fernando Gambino', 'crud', '2026-06-10 18:13:56'),
(17, 'Guardó distributions', 'Fernando Gambino', 'crud', '2026-06-10 18:14:03'),
(18, 'Guardó distributions', 'Fernando Gambino', 'crud', '2026-06-10 18:14:09'),
(19, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 18:17:29'),
(20, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-10 18:17:48'),
(21, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 18:28:51'),
(22, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 18:30:11'),
(23, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-10 18:32:22'),
(24, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-10 18:32:44'),
(25, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-10 18:32:54'),
(26, 'Guardó distributions', 'Fernando Gambino', 'crud', '2026-06-10 18:33:26'),
(27, 'Guardó distributions', 'Fernando Gambino', 'crud', '2026-06-10 18:33:38'),
(28, 'Guardó distributions', 'Fernando Gambino', 'crud', '2026-06-10 18:33:45'),
(29, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-10 18:34:35'),
(30, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-11 01:33:20');

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
(1, '2026-06-08', 2500.00, 1500.00, 1000.00, 'Carga inicial demo', '2026-06-08 17:35:18');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `status` enum('pendiente','acreditado','pagado') NOT NULL DEFAULT 'acreditado',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `distributions`
--

INSERT INTO `distributions` (`id`, `broker_profit_id`, `partner_id`, `amount_usd`, `percent_share`, `status`, `created_at`) VALUES
(1, 1, 1, 242.42, 33.3333, 'acreditado', '2026-06-08 17:35:18'),
(2, 1, 2, 303.03, 33.3333, 'acreditado', '2026-06-08 17:35:18'),
(3, 1, 3, 454.55, 33.3333, 'acreditado', '2026-06-08 17:35:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` varchar(255) NOT NULL,
  `type` varchar(40) NOT NULL DEFAULT 'info',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `notifications`
--

INSERT INTO `notifications` (`id`, `title`, `body`, `type`, `is_read`, `created_at`) VALUES
(1, 'Nuevo retiro solicitado', 'Juan Pérez solicitó retirar US$ 300.', 'retiro', 0, '2026-06-08 17:35:18'),
(2, 'Repartición acreditada', 'Se acreditaron distribuciones de la ganancia broker.', 'distribucion', 0, '2026-06-08 17:35:18'),
(3, 'Nuevo referido', 'Juan Pérez registró un referido.', 'referido', 0, '2026-06-08 17:35:18'),
(4, 'Nuevo usuario', 'Se creó el usuario Michael', 'usuario', 0, '2026-06-10 16:41:47');

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
  `capital_usd` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gains_usd` decimal(12,2) NOT NULL DEFAULT 0.00,
  `kyc_status` enum('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `joined_at` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `address` varchar(180) DEFAULT NULL,
  `bank_account` varchar(180) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partners`
--

INSERT INTO `partners` (`id`, `user_id`, `partner_code`, `full_name`, `email`, `phone`, `capital_usd`, `gains_usd`, `kyc_status`, `status`, `joined_at`, `created_at`, `address`, `bank_account`) VALUES
(1, 3, 'MSTR-JUAN-0001', 'Juan Pérez', 'juan@socio.demo', '3815551111', 10000.00, 0.00, 'aprobado', 'active', '2026-01-01', '2026-06-08 17:35:18', '', ''),
(2, 4, 'MSTR-MARI-0002', 'Marina Soto', 'marina@socio.demo', '3815552222', 10000.00, 0.00, 'aprobado', 'active', '2026-02-02', '2026-06-08 17:35:18', '', ''),
(3, 5, 'MSTR-DIEG-0003', 'Diego Vega', 'diego@socio.demo', '3815553333', 10000.00, 0.00, 'aprobado', 'active', '2026-03-03', '2026-06-08 17:35:18', '', '');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `module_key`, `module_name`, `role`, `can_view`, `can_create`, `can_edit`, `can_delete`, `can_export`) VALUES
(1, 'dashboard', 'Dashboard', 'superadmin', 1, 1, 1, 1, 1),
(2, 'dashboard', 'Dashboard', 'empleado', 0, 0, 0, 0, 0),
(3, 'dashboard', 'Dashboard', 'socio', 1, 0, 0, 0, 0),
(4, 'perfil', 'Mi Perfil', 'superadmin', 1, 1, 1, 1, 1),
(5, 'perfil', 'Mi Perfil', 'empleado', 0, 0, 0, 0, 0),
(6, 'perfil', 'Mi Perfil', 'socio', 1, 0, 0, 0, 0),
(7, 'users', 'Usuarios', 'superadmin', 1, 1, 1, 1, 1),
(8, 'users', 'Usuarios', 'empleado', 0, 0, 0, 0, 0),
(9, 'users', 'Usuarios', 'socio', 0, 0, 0, 0, 0),
(10, 'roles', 'Roles y permisos', 'superadmin', 1, 1, 1, 1, 1),
(11, 'roles', 'Roles y permisos', 'empleado', 0, 0, 0, 0, 0),
(12, 'roles', 'Roles y permisos', 'socio', 0, 0, 0, 0, 0),
(13, 'socios', 'Socios', 'superadmin', 1, 1, 1, 1, 1),
(14, 'socios', 'Socios', 'empleado', 0, 0, 0, 0, 0),
(15, 'socios', 'Socios', 'socio', 0, 0, 0, 0, 0),
(16, 'referidos', 'Referidos', 'superadmin', 1, 1, 1, 1, 1),
(17, 'referidos', 'Referidos', 'empleado', 0, 0, 0, 0, 0),
(18, 'referidos', 'Referidos', 'socio', 0, 0, 0, 0, 0),
(19, 'profits', 'Ganancias broker', 'superadmin', 1, 1, 1, 1, 1),
(20, 'profits', 'Ganancias broker', 'empleado', 0, 0, 0, 0, 0),
(21, 'profits', 'Ganancias broker', 'socio', 1, 0, 0, 0, 0),
(22, 'distribuciones', 'Distribuciones', 'superadmin', 1, 1, 1, 1, 1),
(23, 'distribuciones', 'Distribuciones', 'empleado', 0, 0, 0, 0, 0),
(24, 'distribuciones', 'Distribuciones', 'socio', 1, 0, 0, 0, 0),
(25, 'capitales', 'Niveles de capital', 'superadmin', 1, 1, 1, 1, 1),
(26, 'capitales', 'Niveles de capital', 'empleado', 0, 0, 0, 0, 0),
(27, 'capitales', 'Niveles de capital', 'socio', 0, 0, 0, 0, 0),
(28, 'retiros', 'Retiros', 'superadmin', 1, 1, 1, 1, 1),
(29, 'retiros', 'Retiros', 'empleado', 0, 0, 0, 0, 0),
(30, 'retiros', 'Retiros', 'socio', 1, 1, 0, 0, 0),
(31, 'whatsapp', 'WhatsApp', 'superadmin', 1, 1, 1, 1, 1),
(32, 'whatsapp', 'WhatsApp', 'empleado', 0, 0, 0, 0, 0),
(33, 'whatsapp', 'WhatsApp', 'socio', 1, 0, 0, 0, 0),
(34, 'notificaciones', 'Notificaciones', 'superadmin', 1, 1, 1, 1, 1),
(35, 'notificaciones', 'Notificaciones', 'empleado', 0, 0, 0, 0, 0),
(36, 'notificaciones', 'Notificaciones', 'socio', 1, 0, 0, 0, 0),
(37, 'auditoria', 'Auditoría', 'superadmin', 1, 1, 1, 1, 1),
(38, 'auditoria', 'Auditoría', 'empleado', 0, 0, 0, 0, 0),
(39, 'auditoria', 'Auditoría', 'socio', 0, 0, 0, 0, 0);

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
(1, 1, 'Referido Demo', 'referido@demo.com', 2000.00, 8.00, 'activo', '2026-06-08 17:35:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `module` varchar(80) NOT NULL,
  `superadmin` tinyint(1) NOT NULL DEFAULT 1,
  `employee` tinyint(1) NOT NULL DEFAULT 1,
  `partner` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role_permissions`
--

INSERT INTO `role_permissions` (`id`, `module`, `superadmin`, `employee`, `partner`) VALUES
(1, 'Dashboard', 1, 1, 1),
(2, 'Usuarios', 1, 0, 0),
(3, 'Roles y permisos', 1, 0, 0),
(4, 'Ganancias broker', 1, 1, 0),
(5, 'Distribuciones', 1, 1, 1),
(6, 'Retiros', 1, 1, 1),
(7, 'Referidos', 1, 1, 1),
(8, 'Socios', 1, 0, 0),
(9, 'Empleados', 1, 0, 0),
(10, 'Whatsapp', 1, 0, 0),
(11, 'Auditoría', 1, 1, 0);

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
(1, 'Fernando Gambino', 'fernando.m.gambino@gmail.com', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'superadmin', 'active', 'uploads/profiles/profile_1_1781108572.jpeg', '2026-06-08 17:35:18', '2026-06-10 16:22:52'),
(2, 'Mesa Operativa', 'mesa@masterprofe.demo', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'empleado', 'active', 'assets/img/avatar.svg', '2026-06-08 17:35:18', NULL),
(3, 'Juan Pérez', 'juan@socio.demo', '$2y$10$D.MGlLi/Xhx.yUTxzeHIHeuh07pBsKoJcDB5QwiBsbC6rfUhQ6utO', 'socio', 'active', 'uploads/profiles/profile_3_1780951572.png', '2026-06-08 17:35:18', '2026-06-10 16:45:18'),
(4, 'Marina Soto', 'marina@socio.demo', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'socio', 'active', 'assets/img/avatar.svg', '2026-06-10 16:34:07', NULL),
(5, 'Diego Vega', 'diego@socio.demo', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'socio', 'active', 'assets/img/avatar.svg', '2026-06-10 16:34:07', NULL),
(7, 'Michael', 'elmaster@gmail.com', '$2y$10$4ObSLNefepVvZrC1uOLF.OPezaFeCbpGqx.Jmvli1uJzIkGRy76iK', 'superadmin', 'active', 'assets/img/avatar.svg', '2026-06-10 16:41:47', NULL);

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
(1, 'Ventas', '5493810000001', 'Hola, quiero información sobre EL MASTER PROFE.', 'active', '2026-06-08 17:35:18'),
(2, 'Soporte', '5493810000002', 'Hola, necesito soporte del CRM.', 'active', '2026-06-08 17:35:18'),
(3, 'Administración', '5493810000003', 'Hola, quiero consultar por retiros o ganancias.', 'active', '2026-06-08 17:35:18');

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
(1, 1, 300.00, 'ganancias', 'USDT TRC20 - Tw...9aFt', '', '2026-06-08 17:35:18');

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
-- Indices de la tabla `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `broker_profits`
--
ALTER TABLE `broker_profits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `capital_levels`
--
ALTER TABLE `capital_levels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `referrals`
--
ALTER TABLE `referrals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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

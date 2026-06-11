-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-06-2026 a las 17:50:27
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
(1, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-09 10:39:58'),
(2, 'Guardó users', 'Fernando Gambino', 'crud', '2026-06-09 10:49:23'),
(3, 'Actualizó roles y permisos', 'Fernando Gambino', 'security', '2026-06-09 10:50:10'),
(4, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-09 10:50:19'),
(5, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-09 11:03:44'),
(6, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-09 11:04:38'),
(7, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-09 12:58:58'),
(8, 'Guardó broker_profits', 'Fernando Gambino', 'crud', '2026-06-09 13:00:13'),
(9, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-09 13:00:51'),
(10, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-09 13:22:49'),
(11, 'Guardó broker_profits', 'Fernando Gambino', 'crud', '2026-06-09 13:27:51'),
(12, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-09 14:40:18'),
(13, 'Eliminó distributions #3', 'Fernando Gambino', 'crud', '2026-06-09 14:41:37'),
(14, 'Eliminó distributions #2', 'Fernando Gambino', 'crud', '2026-06-09 14:41:41'),
(15, 'Eliminó distributions #1', 'Fernando Gambino', 'crud', '2026-06-09 14:41:46'),
(16, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-09 14:43:18'),
(17, 'Guardó partners', 'Fernando Gambino', 'crud', '2026-06-09 14:45:29'),
(18, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-09 14:45:40'),
(19, 'Inicio de sesión', 'Fernando Gambino', 'auth', '2026-06-10 12:46:59'),
(20, 'Actualizó roles y permisos', 'Fernando Gambino', 'security', '2026-06-10 12:48:20'),
(21, 'Inicio de sesión', 'Juan Pérez', 'auth', '2026-06-10 12:48:26');

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
(1, '2026-06-09', 10000.00, 6000.00, 4000.00, 'Carga inicial demo', '2026-06-09 10:35:57'),
(2, '2026-06-08', 1575.52, 945.31, 630.21, '', '2026-06-09 13:27:51');

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
(1, 'Nivel 2K', 2000.00, 0.0000, 'active', '2026-06-09 13:08:47'),
(2, 'Nivel 5K', 5000.00, 0.0000, 'active', '2026-06-09 13:08:47'),
(3, 'Nivel 10K', 10000.00, 0.0000, 'active', '2026-06-09 13:08:47');

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
(4, 2, 1, 210.07, 33.3333, 'acreditado', '2026-06-09 13:27:51'),
(5, 2, 2, 210.07, 33.3333, 'acreditado', '2026-06-09 13:27:51'),
(6, 2, 3, 210.07, 33.3333, 'acreditado', '2026-06-09 13:27:51');

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
(1, 'Nuevo retiro solicitado', 'Juan Pérez solicitó retirar US$ 300.', 'retiro', 0, '2026-06-09 10:35:57'),
(2, 'Repartición acreditada', 'Se acreditaron distribuciones de la ganancia broker.', 'distribucion', 0, '2026-06-09 10:35:57'),
(3, 'Nuevo referido', 'Juan Pérez registró un referido.', 'referido', 0, '2026-06-09 10:35:57'),
(4, 'Nueva repartición de ganancias', 'Se distribuyó equitativamente el 40% a los socios activos.', 'distribucion', 0, '2026-06-09 13:27:51');

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
(1, 3, 'MSTR-JUAN-0001', 'Juan Pérez', 'juan@socio.demo', '3815551111', 'San Miguel de Tucumán', 'USDT TRC20 - Tw...9aFt', 10000.00, 930.07, 'aprobado', 'active', '2026-01-01', '2026-06-09 10:35:57'),
(2, NULL, 'MSTR-MARI-0002', 'Marina Soto', 'marina@socio.demo', '3815552222', 'Tucumán', 'Banco Galicia ****4421', 10000.00, 1117.07, 'aprobado', 'active', '2026-02-02', '2026-06-09 10:35:57'),
(3, NULL, 'MSTR-DIEG-0003', 'Diego Vega', 'diego@socio.demo', '3815553333', 'Tucumán', 'USDT TRC20 - Tw...9aFt', 10000.00, 1304.07, 'aprobado', 'active', '2026-03-03', '2026-06-09 10:35:57');

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
(136, 'dashboard', 'Dashboard', 'superadmin', 1, 1, 1, 1, 1),
(137, 'dashboard', 'Dashboard', 'empleado', 1, 0, 0, 0, 1),
(138, 'dashboard', 'Dashboard', 'socio', 1, 0, 0, 0, 0),
(139, 'perfil', 'Mi Perfil', 'superadmin', 1, 1, 1, 1, 1),
(140, 'perfil', 'Mi Perfil', 'empleado', 1, 0, 1, 0, 1),
(141, 'perfil', 'Mi Perfil', 'socio', 1, 0, 1, 0, 0),
(142, 'users', 'Usuarios', 'superadmin', 1, 1, 1, 1, 1),
(143, 'users', 'Usuarios', 'empleado', 0, 0, 0, 0, 0),
(144, 'users', 'Usuarios', 'socio', 0, 0, 0, 0, 0),
(145, 'roles', 'Roles y permisos', 'superadmin', 1, 1, 1, 1, 1),
(146, 'roles', 'Roles y permisos', 'empleado', 0, 0, 0, 0, 0),
(147, 'roles', 'Roles y permisos', 'socio', 0, 0, 0, 0, 0),
(148, 'socios', 'Socios', 'superadmin', 1, 1, 1, 1, 1),
(149, 'socios', 'Socios', 'empleado', 1, 1, 1, 0, 1),
(150, 'socios', 'Socios', 'socio', 0, 0, 0, 0, 0),
(151, 'referidos', 'Referidos', 'superadmin', 1, 1, 1, 1, 1),
(152, 'referidos', 'Referidos', 'empleado', 1, 1, 1, 0, 1),
(153, 'referidos', 'Referidos', 'socio', 0, 0, 0, 0, 0),
(154, 'profits', 'Ganancias broker', 'superadmin', 1, 1, 1, 1, 1),
(155, 'profits', 'Ganancias broker', 'empleado', 1, 1, 1, 0, 1),
(156, 'profits', 'Ganancias broker', 'socio', 0, 0, 0, 0, 0),
(157, 'distribuciones', 'Distribuciones', 'superadmin', 1, 1, 1, 1, 1),
(158, 'distribuciones', 'Distribuciones', 'empleado', 0, 0, 0, 0, 0),
(159, 'distribuciones', 'Distribuciones', 'socio', 0, 0, 0, 0, 0),
(160, 'capitales', 'Niveles de capital', 'superadmin', 1, 1, 1, 1, 1),
(161, 'capitales', 'Niveles de capital', 'empleado', 1, 0, 0, 0, 1),
(162, 'capitales', 'Niveles de capital', 'socio', 0, 0, 0, 0, 0),
(163, 'retiros', 'Retiros', 'superadmin', 1, 1, 1, 1, 1),
(164, 'retiros', 'Retiros', 'empleado', 1, 1, 1, 0, 1),
(165, 'retiros', 'Retiros', 'socio', 1, 1, 0, 0, 1),
(166, 'whatsapp', 'WhatsApp', 'superadmin', 1, 1, 1, 1, 1),
(167, 'whatsapp', 'WhatsApp', 'empleado', 0, 0, 0, 0, 0),
(168, 'whatsapp', 'WhatsApp', 'socio', 0, 0, 0, 0, 0),
(169, 'notificaciones', 'Notificaciones', 'superadmin', 1, 1, 1, 1, 1),
(170, 'notificaciones', 'Notificaciones', 'empleado', 1, 1, 1, 0, 1),
(171, 'notificaciones', 'Notificaciones', 'socio', 1, 0, 0, 0, 0),
(172, 'auditoria', 'Auditoría', 'superadmin', 1, 1, 1, 1, 1),
(173, 'auditoria', 'Auditoría', 'empleado', 1, 0, 0, 0, 1),
(174, 'auditoria', 'Auditoría', 'socio', 0, 0, 0, 0, 0);

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
(1, 1, 'Referido Demo', 'referido@demo.com', 2000.00, 8.00, 'activo', '2026-06-09 10:35:57');

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
(1, 'Fernando Gambino', 'fernando.m.gambino@gmail.com', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'superadmin', 'active', 'uploads/profiles/profile_1_1781013857.jpeg', '2026-06-09 10:35:57', '2026-06-09 11:04:17'),
(2, 'Mesa Operativa', 'mesa@masterprofe.demo', '$2y$12$NfLavdL2uvgiqPdr9i7Y8OIg.RuG/kws.OW4QnsaK51.QZVWda7re', 'empleado', 'active', 'assets/img/avatar.svg', '2026-06-09 10:35:57', NULL),
(3, 'Juan Pérez', 'juan@socio.demo', '$2y$10$X8MVTSxqJNqnKVuVk7QVseW.C1XGSS0lbDi1HYjHX.2U6gIG7rKZa', 'socio', 'active', 'assets/img/avatar.svg', '2026-06-09 10:35:57', '2026-06-09 10:49:23');

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
(1, 'Ventas', '5493810000001', 'Hola, quiero información sobre EL MASTER PROFE.', 'active', '2026-06-09 10:35:57'),
(2, 'Soporte', '5493810000002', 'Hola, necesito soporte del CRM.', 'active', '2026-06-09 10:35:57'),
(3, 'Administración', '5493810000003', 'Hola, quiero consultar por retiros o ganancias.', 'active', '2026-06-09 10:35:57');

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
(1, 1, 300.00, 'ganancias', 'USDT TRC20 - Tw...9aFt', '', '2026-06-09 10:35:57');

--
-- Índices para tablas volcadas
--

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `broker_profits`
--
ALTER TABLE `broker_profits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `capital_levels`
--
ALTER TABLE `capital_levels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `distributions`
--
ALTER TABLE `distributions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT de la tabla `referrals`
--
ALTER TABLE `referrals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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

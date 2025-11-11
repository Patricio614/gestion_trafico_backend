-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-11-2025 a las 21:21:19
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
-- Base de datos: `gestion_transito`
--
CREATE DATABASE IF NOT EXISTS `gestion_transito` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `gestion_transito`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ambulancias`
--

DROP TABLE IF EXISTS `ambulancias`;
CREATE TABLE `ambulancias` (
  `id` int(11) NOT NULL,
  `conductor_id` int(11) NOT NULL,
  `patente` varchar(20) NOT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `tipo` enum('basica','avanzada','UCI') NOT NULL DEFAULT 'basica',
  `ubicacion_actual` varchar(255) DEFAULT NULL,
  `estado` enum('disponible','ocupada','mantenimiento') DEFAULT 'disponible',
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tablas antes de insertar `ambulancias`
--

TRUNCATE TABLE `ambulancias`;
--
-- Volcado de datos para la tabla `ambulancias`
--

INSERT INTO `ambulancias` (`id`, `conductor_id`, `patente`, `modelo`, `tipo`, `ubicacion_actual`, `estado`, `latitud`, `longitud`, `fecha_actualizacion`) VALUES
(1, 2, 'ABC123', 'Mercedes Sprinter', 'avanzada', 'Base Central', 'ocupada', -34.60370000, -58.38160000, '2025-10-24 18:20:24'),
(2, 2, 'DEF456', 'Ford Transit', 'basica', 'Base Norte', 'ocupada', -34.61000000, -58.39000000, '2025-10-24 18:22:25'),
(3, 2, 'GHI789', 'Volkswagen Crafter', 'UCI', 'Taller Central', 'disponible', -34.61500000, -58.40000000, '2025-10-24 18:18:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emergencias`
--

DROP TABLE IF EXISTS `emergencias`;
CREATE TABLE `emergencias` (
  `id` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `tipo` enum('accidente','emergencia_medica','incidente_vial','incendio','urgencia_medica','otro') NOT NULL,
  `prioridad` enum('baja','media','alta','critica') NOT NULL DEFAULT 'media',
  `estado` enum('pendiente','asignada','en_camino','en_lugar','completada','cancelada') NOT NULL DEFAULT 'pendiente',
  `conductor_asignado` int(11) DEFAULT NULL,
  `ambulancia_asignada` int(11) DEFAULT NULL,
  `creado_por` int(11) DEFAULT NULL,
  `ubicacion` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `latitud` decimal(10,8) NOT NULL,
  `longitud` decimal(11,8) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_asignacion` timestamp NULL DEFAULT NULL,
  `fecha_completada` timestamp NULL DEFAULT NULL,
  `notas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tablas antes de insertar `emergencias`
--

TRUNCATE TABLE `emergencias`;
--
-- Volcado de datos para la tabla `emergencias`
--

INSERT INTO `emergencias` (`id`, `titulo`, `tipo`, `prioridad`, `estado`, `conductor_asignado`, `ambulancia_asignada`, `creado_por`, `ubicacion`, `descripcion`, `latitud`, `longitud`, `fecha_creacion`, `fecha_asignacion`, `fecha_completada`, `notas`) VALUES
(1, 'Accidente vehicular - Av. 3 de Abril y Catamarca', 'accidente', 'alta', 'asignada', 2, 1, 1, 'Av. 3 de Abril 1250, Corrientes', 'Colisión frontal entre dos vehículos, 2 heridos leves', -27.47912300, -58.83156700, '2025-10-24 18:14:46', NULL, NULL, NULL),
(2, 'Emergencia cardíaca - Centro', '', 'critica', 'asignada', 2, 2, 1, 'Junín 780, Corrientes', 'Adulto mayor con dolor precordial agudo', -27.46789100, -58.83234500, '2025-10-24 18:15:01', NULL, NULL, NULL),
(3, 'Incendio en vivienda - Barrio Centro', 'incendio', 'media', 'asignada', 2, 3, 1, 'Córdoba 1480, Corrientes', 'Cortocircuito en instalación eléctrica', -27.47545600, -58.82712300, '2025-10-24 18:15:15', NULL, NULL, NULL),
(4, 'Emergencia Test 1761330020106', 'accidente', 'media', 'asignada', 2, 1, 1, 'Ubicación de prueba k4nkc', 'Esta es una emergencia de prueba', -34.61000000, -58.38000000, '2025-10-24 18:20:20', '2025-10-24 18:20:24', NULL, NULL),
(5, 'Emergencia Test 1761330137046', 'accidente', 'media', 'asignada', 2, 2, 1, 'Ubicación de prueba 9sc5d', 'Esta es una emergencia de prueba', -34.61000000, -58.38000000, '2025-10-24 18:22:17', '2025-10-24 18:22:25', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_emergencias`
--

DROP TABLE IF EXISTS `historial_emergencias`;
CREATE TABLE `historial_emergencias` (
  `id` int(11) NOT NULL,
  `emergencia_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `accion` varchar(100) NOT NULL,
  `detalles` text DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tablas antes de insertar `historial_emergencias`
--

TRUNCATE TABLE `historial_emergencias`;
--
-- Volcado de datos para la tabla `historial_emergencias`
--

INSERT INTO `historial_emergencias` (`id`, `emergencia_id`, `usuario_id`, `accion`, `detalles`, `fecha_registro`) VALUES
(3, 4, 1, 'creada', 'Emergencia creada por administrador', '2025-10-24 18:20:20'),
(4, 4, 2, 'asignada', 'Conductor aceptó la emergencia', '2025-10-24 18:20:24'),
(5, 5, 1, 'creada', 'Emergencia creada por administrador', '2025-10-24 18:22:17'),
(6, 5, 2, 'asignada', 'Conductor aceptó la emergencia', '2025-10-24 18:22:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `emergencia_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `tipo` enum('emergencia_nueva','emergencia_asignada','estado_actualizado','sistema') NOT NULL DEFAULT 'sistema',
  `leida` tinyint(1) DEFAULT 0,
  `estado` enum('pendiente','vista','atendida','leida') DEFAULT 'pendiente',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tablas antes de insertar `notificaciones`
--

TRUNCATE TABLE `notificaciones`;
--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id`, `emergencia_id`, `usuario_id`, `mensaje`, `tipo`, `leida`, `estado`, `fecha_creacion`) VALUES
(3, 4, 2, 'Nueva emergencia: Emergencia Test 1761330020106', 'emergencia_nueva', 0, 'pendiente', '2025-10-24 18:20:20'),
(4, 4, 3, 'Nueva emergencia: Emergencia Test 1761330020106', 'emergencia_nueva', 0, 'pendiente', '2025-10-24 18:20:20'),
(5, 4, 4, 'Nueva emergencia: Emergencia Test 1761330020106', 'emergencia_nueva', 0, 'pendiente', '2025-10-24 18:20:20'),
(6, 4, 2, 'Has aceptado una nueva emergencia', 'emergencia_asignada', 0, 'pendiente', '2025-10-24 18:20:24'),
(7, 5, 2, 'Nueva emergencia: Emergencia Test 1761330137046', 'emergencia_nueva', 0, 'pendiente', '2025-10-24 18:22:17'),
(8, 5, 3, 'Nueva emergencia: Emergencia Test 1761330137046', 'emergencia_nueva', 0, 'pendiente', '2025-10-24 18:22:17'),
(9, 5, 4, 'Nueva emergencia: Emergencia Test 1761330137046', 'emergencia_nueva', 0, 'pendiente', '2025-10-24 18:22:17'),
(10, 5, 2, 'Has aceptado una nueva emergencia', 'emergencia_asignada', 0, 'pendiente', '2025-10-24 18:22:25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('conductor','ambulancia','bombero','administrador','admin','conductor_especial','conductor_comun') DEFAULT NULL,
  `tipo` enum('admin','conductor_especial','conductor_comun') NOT NULL DEFAULT 'conductor_comun',
  `estado` enum('activo','inactivo') NOT NULL DEFAULT 'activo',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_login` timestamp NULL DEFAULT NULL,
  `ambulancia_asignada` varchar(50) DEFAULT NULL,
  `estado_operativo` enum('Disponible','Ocupado','Inactivo') DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tablas antes de insertar `usuarios`
--

TRUNCATE TABLE `usuarios`;
--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `telefono`, `password`, `rol`, `tipo`, `estado`, `fecha_creacion`, `ultimo_login`, `ambulancia_asignada`, `estado_operativo`) VALUES
(1, 'Paloma Admin', 'paloma@admin.com', '+1234567890', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'administrador', 'admin', 'activo', '2025-10-02 20:32:02', NULL, NULL, 'Disponible'),
(2, 'Conductor Especial', 'especial@conductor.com', '+1234567891', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'conductor_especial', 'conductor_especial', 'activo', '2025-10-02 20:32:02', NULL, 'AMB-001', 'Ocupado'),
(3, 'Gonzalo Conductor', 'gonzalo@conductor.com', '+1234567892', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'conductor', 'conductor_comun', 'activo', '2025-10-02 20:32:02', NULL, NULL, 'Disponible'),
(4, 'Maria Conductor', 'maria@conductor.com', '+1234567893', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'conductor', 'conductor_comun', 'activo', '2025-10-02 20:32:02', NULL, NULL, 'Disponible');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ambulancias`
--
ALTER TABLE `ambulancias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `placa` (`patente`),
  ADD KEY `usuario_id` (`conductor_id`);

--
-- Indices de la tabla `emergencias`
--
ALTER TABLE `emergencias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conductor_asignado` (`conductor_asignado`),
  ADD KEY `ambulancia_asignada` (`ambulancia_asignada`),
  ADD KEY `creado_por` (`creado_por`);

--
-- Indices de la tabla `historial_emergencias`
--
ALTER TABLE `historial_emergencias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `emergencia_id` (`emergencia_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `emergencia_id` (`emergencia_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ambulancias`
--
ALTER TABLE `ambulancias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `emergencias`
--
ALTER TABLE `emergencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `historial_emergencias`
--
ALTER TABLE `historial_emergencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ambulancias`
--
ALTER TABLE `ambulancias`
  ADD CONSTRAINT `ambulancias_ibfk_1` FOREIGN KEY (`conductor_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `emergencias`
--
ALTER TABLE `emergencias`
  ADD CONSTRAINT `emergencias_ibfk_1` FOREIGN KEY (`conductor_asignado`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `emergencias_ibfk_2` FOREIGN KEY (`ambulancia_asignada`) REFERENCES `ambulancias` (`id`),
  ADD CONSTRAINT `emergencias_ibfk_3` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `historial_emergencias`
--
ALTER TABLE `historial_emergencias`
  ADD CONSTRAINT `historial_emergencias_ibfk_1` FOREIGN KEY (`emergencia_id`) REFERENCES `emergencias` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `historial_emergencias_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`emergencia_id`) REFERENCES `emergencias` (`id`),
  ADD CONSTRAINT `notificaciones_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `notificaciones_ibfk_3` FOREIGN KEY (`emergencia_id`) REFERENCES `emergencias` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notificaciones_ibfk_4` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

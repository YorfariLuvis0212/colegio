-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-04-2025 a las 22:42:03
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
-- Base de datos: `colegio`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `nombre_completo_usuario` (`userId` INT) RETURNS VARCHAR(120) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE nombreCompleto VARCHAR(120);
    SELECT CONCAT(nombre, ' ', apellido) INTO nombreCompleto
    FROM usuario
    WHERE id = userId;
    RETURN nombreCompleto;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `accion` varchar(50) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id`, `usuario_id`, `accion`, `descripcion`, `fecha`) VALUES
(1, 1, 'INSERT', 'Se registró el usuario: juan.perez@colegio.edu', '2025-04-28 20:41:44'),
(2, 2, 'INSERT', 'Se registró el usuario: maria.gomez@colegio.edu', '2025-04-28 20:41:44'),
(3, 3, 'INSERT', 'Se registró el usuario: carlos.lopez@colegio.edu', '2025-04-28 20:41:44'),
(4, 4, 'INSERT', 'Se registró el usuario: laura.sanchez@colegio.edu', '2025-04-28 20:41:44'),
(5, 1, 'INSERT', 'Se registró un nuevo usuario Juan Pérez', '2025-04-28 20:41:44'),
(6, 2, 'INSERT', 'Se registró un nuevo usuario María Gómez', '2025-04-28 20:41:44'),
(7, 1, 'INSERT', 'Se registró un nuevo equipo Laptop HP', '2025-04-28 20:41:44'),
(8, 2, 'INSERT', 'Se registró un nuevo estudiante Sofía Martínez', '2025-04-28 20:41:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo`
--

CREATE TABLE `equipo` (
  `id` int(11) NOT NULL,
  `nombre_equipo` varchar(100) DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipo`
--

INSERT INTO `equipo` (`id`, `nombre_equipo`, `area`) VALUES
(1, 'Laptop HP', 'Informática'),
(2, 'Microscopio Óptico', 'Biología'),
(3, 'Proyector Epson', 'Audiovisuales'),
(4, 'Impresora LaserJet', 'Administración');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id`, `nombre`, `apellido`, `estado`) VALUES
(1, 'Pedro', 'Ramírez', 'activo'),
(2, 'Sofía', 'Martínez', 'activo'),
(3, 'Andrés', 'Castro', 'inactivo'),
(4, 'Valentina', 'García', 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscripcion`
--

CREATE TABLE `inscripcion` (
  `id` int(11) NOT NULL,
  `estudiante_id` int(11) DEFAULT NULL,
  `curso` varchar(100) DEFAULT NULL,
  `fecha_inscripcion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inscripcion`
--

INSERT INTO `inscripcion` (`id`, `estudiante_id`, `curso`, `fecha_inscripcion`) VALUES
(1, 1, 'Matemáticas', '2025-01-15'),
(2, 2, 'Ciencias Naturales', '2025-01-16'),
(3, 4, 'Lengua Castellana', '2025-01-17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `intentos_fallidos` int(11) DEFAULT 0,
  `bloqueado_until` datetime DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `nombre`, `apellido`, `email`, `password`, `intentos_fallidos`, `bloqueado_until`, `estado`) VALUES
(1, 'Juan', 'Pérez', 'juan.perez@colegio.edu', 'password123', 0, NULL, 'activo'),
(2, 'María', 'Gómez', 'maria.gomez@colegio.edu', 'password123', 0, NULL, 'activo'),
(3, 'Carlos', 'López', 'carlos.lopez@colegio.edu', 'password123', 2, NULL, 'activo'),
(4, 'Laura', 'Sánchez', 'laura.sanchez@colegio.edu', 'password123', 3, '2025-04-28 15:44:44', 'inactivo');

--
-- Disparadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `trigger_delete_usuario` AFTER DELETE ON `usuario` FOR EACH ROW BEGIN
    INSERT INTO auditoria (usuario_id, accion, descripcion)
    VALUES (OLD.id, 'DELETE', CONCAT('Se eliminó el usuario: ', OLD.email));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_insert_usuario` AFTER INSERT ON `usuario` FOR EACH ROW BEGIN
    INSERT INTO auditoria (usuario_id, accion, descripcion)
    VALUES (NEW.id, 'INSERT', CONCAT('Se registró el usuario: ', NEW.email));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigger_update_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW BEGIN
    INSERT INTO auditoria (usuario_id, accion, descripcion)
    VALUES (NEW.id, 'UPDATE', CONCAT('Se actualizó el usuario: ', NEW.email));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_auditoria`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_auditoria` (
`id` int(11)
,`email` varchar(100)
,`accion` varchar(50)
,`descripcion` text
,`fecha` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_equipos_area`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_equipos_area` (
`area` varchar(100)
,`equipos` mediumtext
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_estudiantes_activos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_estudiantes_activos` (
`id` int(11)
,`nombre_completo` varchar(101)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_inscripciones`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_inscripciones` (
`id` int(11)
,`estudiante` varchar(101)
,`curso` varchar(100)
,`fecha_inscripcion` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_usuarios_bloqueados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_usuarios_bloqueados` (
`id` int(11)
,`email` varchar(100)
,`bloqueado_until` datetime
,`intentos_fallidos` int(11)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_auditoria`
--
DROP TABLE IF EXISTS `vista_auditoria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_auditoria`  AS SELECT `a`.`id` AS `id`, `u`.`email` AS `email`, `a`.`accion` AS `accion`, `a`.`descripcion` AS `descripcion`, `a`.`fecha` AS `fecha` FROM (`auditoria` `a` left join `usuario` `u` on(`a`.`usuario_id` = `u`.`id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_equipos_area`
--
DROP TABLE IF EXISTS `vista_equipos_area`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_equipos_area`  AS SELECT `equipo`.`area` AS `area`, group_concat(`equipo`.`nombre_equipo` separator ', ') AS `equipos` FROM `equipo` GROUP BY `equipo`.`area` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_estudiantes_activos`
--
DROP TABLE IF EXISTS `vista_estudiantes_activos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_estudiantes_activos`  AS SELECT `estudiante`.`id` AS `id`, concat(`estudiante`.`nombre`,' ',`estudiante`.`apellido`) AS `nombre_completo` FROM `estudiante` WHERE `estudiante`.`estado` = 'activo' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_inscripciones`
--
DROP TABLE IF EXISTS `vista_inscripciones`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_inscripciones`  AS SELECT `i`.`id` AS `id`, concat(`e`.`nombre`,' ',`e`.`apellido`) AS `estudiante`, `i`.`curso` AS `curso`, `i`.`fecha_inscripcion` AS `fecha_inscripcion` FROM (`inscripcion` `i` join `estudiante` `e` on(`i`.`estudiante_id` = `e`.`id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_usuarios_bloqueados`
--
DROP TABLE IF EXISTS `vista_usuarios_bloqueados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_usuarios_bloqueados`  AS SELECT `usuario`.`id` AS `id`, `usuario`.`email` AS `email`, `usuario`.`bloqueado_until` AS `bloqueado_until`, `usuario`.`intentos_fallidos` AS `intentos_fallidos` FROM `usuario` WHERE `usuario`.`intentos_fallidos` >= 3 AND `usuario`.`bloqueado_until` is not null AND `usuario`.`bloqueado_until` > current_timestamp() ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `inscripcion`
--
ALTER TABLE `inscripcion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `equipo`
--
ALTER TABLE `equipo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `inscripcion`
--
ALTER TABLE `inscripcion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 07-12-2021 a las 01:12:39
-- Versión del servidor: 5.7.26
-- Versión de PHP: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `check`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activos`
--

DROP TABLE IF EXISTS `activos`;
CREATE TABLE IF NOT EXISTS `activos` (
  `id_activo` int(11) NOT NULL AUTO_INCREMENT,
  `patente` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `tipo_vehiculo` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `marca` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `modelo` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `numero_motor` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `chasis` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `color` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `anio` int(4) NOT NULL,
  `fecha_rev_tec` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `fecha_perm_circ` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `combustible` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `transmision` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL,
  `id_empresa` int(15) DEFAULT NULL,
  `id_prestador` int(15) DEFAULT NULL,
  `id_usuario` int(15) NOT NULL,
  PRIMARY KEY (`id_activo`),
  KEY `id_empresa` (`id_empresa`,`id_prestador`),
  KEY `id_prestador` (`id_prestador`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `activos`
--

INSERT INTO `activos` (`id_activo`, `patente`, `tipo_vehiculo`, `marca`, `modelo`, `numero_motor`, `chasis`, `color`, `anio`, `fecha_rev_tec`, `fecha_perm_circ`, `combustible`, `transmision`, `habilitado`, `id_empresa`, `id_prestador`, `id_usuario`) VALUES
(20, 'LZLJ40', 'auto', 'mazda', 'mazda3', '12345', '12345abc', 'plata', 2020, '2021-07-20', '2021-09-10', 'bencina', 'manual', 1, 13, 8, 13);

--
-- Disparadores `activos`
--
DROP TRIGGER IF EXISTS `activos_auditoria_guardar`;
DELIMITER $$
CREATE TRIGGER `activos_auditoria_guardar` BEFORE INSERT ON `activos` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'activos', 'guardar', CONCAT('INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES ('',new.patente,'','',new.tipo_vehiculo,'','',new.marca,'','',new.modelo,'','',new.numero_motor,'','',new.chasis,'','',new.color,'','',new.anio,'','',new.fecha_rev_tec,'','',new.fecha_perm_circ,'','',new.combustible,'','',new.transmision,'','',new.habilitado,'','',IFNULL(new.id_empresa, ''),'','',IFNULL(new.id_prestador, ''),'')'), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `activos_auditoria_modificar`;
DELIMITER $$
CREATE TRIGGER `activos_auditoria_modificar` BEFORE UPDATE ON `activos` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'activos',CASE WHEN new.habilitado = 1 THEN 'modificado' ELSE 'eliminado' END , CONCAT('UPDATE activos SET patente = '',new.patente,'', tipo_vehiculo = '',new.tipo_vehiculo,'', marca = '',new.marca,'', modelo = '',new.modelo,'', numero_motor = '',new.numero_motor,'', chasis = '',new.chasis,'', color = '',new.color,'', anio = '',new.anio,'', fecha_rev_tec = '',new.fecha_rev_tec,'', fecha_perm_circ = '',new.fecha_perm_circ,'', combustible = '',new.combustible,'', transmision = '',new.transmision,'', habilitado = '',new.habilitado,'', id_empresa = '',IFNULL(new.id_empresa, ''),'', id_prestador = '',IFNULL(new.id_prestador, ''),'' WHERE id = ',new.id_activo), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
CREATE TABLE IF NOT EXISTS `auditoria` (
  `id_auditoria` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `tabla` varchar(100) NOT NULL,
  `evento` varchar(100) NOT NULL,
  `consulta` varchar(900) DEFAULT NULL,
  `usuario` varchar(300) NOT NULL,
  PRIMARY KEY (`id_auditoria`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id_auditoria`, `fecha`, `tabla`, `evento`, `consulta`, `usuario`) VALUES
(1, '2021-04-27', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'17706289-8\',\'victor\',\'997131410\',\'fuentes.VIctor8@gmail.com\',\'pasaje manizales 6635\')', 'UsuarioA'),
(2, '2021-04-27', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'17706289-8\', nombre = \'victor fuentes\', telefono = \'997131410\', correo = \'fuentes.VIctor8@gmail.com\' direccion = \'pasaje manizales 6635\'  WHERE id = 4', 'UsuarioA'),
(3, '2021-04-27', 'prestador', 'eliminado', 'UPDATE prestadores SET rut = \'17706289-8\', nombre = \'victor fuentes\', telefono = \'997131410\', correo = \'fuentes.VIctor8@gmail.com\' direccion = \'pasaje manizales 6635\'  WHERE id = 4', 'UsuarioA'),
(4, '2021-04-27', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'10161531-6\',\'leonel\',\'99999999\',\'kpmg@kpmg.com\')', 'UsuarioA'),
(5, '2021-04-27', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'10161531-6\', nombre = \'leonel fuentes\', telefono = \'99999999\', correo = \'kpmg@kpmg.com\' WHERE id = 14', 'UsuarioA'),
(6, '2021-04-27', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'10161531-6\', nombre = \'leonel fuentes\', telefono = \'99999999\', correo = \'kpmg@kpmg.com\' WHERE id = 14', 'UsuarioA'),
(7, '2021-04-27', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'17706289-8\',\'victor\',\'fuentes\',\'tilleria\',\'997131410\',\'1\',\'12\',\'victor@kpmg.com\',\'$2b$12$Ya4qeiWHUgb.E3F0/m0WJ.4CiXeI3JsM.kpPlGkXsHW6BPBsal/Au\')', 'UsuarioA'),
(8, '2021-04-27', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor AAAA\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'victor@kpmg.com\', password = \'$2b$12$Ya4qeiWHUgb.E3F0/m0WJ..hbcysSCSbJBBDc7351ScZza/nFgmkm\' WHERE id = 12', 'UsuarioA'),
(9, '2021-04-27', 'persona', 'eliminado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor AAAA\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'victor@kpmg.com\', password = \'$2b$12$Ya4qeiWHUgb.E3F0/m0WJ..hbcysSCSbJBBDc7351ScZza/nFgmkm\' WHERE id = 12', 'UsuarioA'),
(10, '2021-04-27', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'XDXD51\',\'sedan\',\'chevrolet\',\'spark GT\',\'1.2\',\'aaaa\',\'azul\',\'2011\',\'2021-04-28\',\'2021-04-27\',\'bencina', 'UsuarioA'),
(11, '2021-04-27', 'activos', 'modificado', 'UPDATE activos SET patente = \'XDXD51\', tipo_vehiculo = \'sedan aaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-04-28\', fecha_perm_circ = \'2021-04-27\', combustible = \'bencina\', transmision = \'mecanico\', habi', 'UsuarioA'),
(12, '2021-04-27', 'activos', 'eliminado', 'UPDATE activos SET patente = \'XDXD51\', tipo_vehiculo = \'sedan aaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-04-28\', fecha_perm_circ = \'2021-04-27\', combustible = \'bencina\', transmision = \'mecanico\', habi', 'UsuarioA'),
(13, '2021-04-27', 'activos', 'modificado', 'UPDATE activos SET patente = \'CTCX515\', tipo_vehiculo = \'sedanaaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-04-29\', fecha_perm_circ = \'2021-04-28\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 3', 'UsuarioA'),
(14, '2021-04-27', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'10161531-6\',\'victor\',\'fuentes\',\'tilleria\',\'997131410\',\'1\',\'12\',\'victor@gmail.com\',\'$2b$12$kpAe2vX0p1h/bRqDKo6xk.rcpRspkqlyqApGkb9Riq73qA2BwzlvK\')', 'UsuarioA'),
(15, '2021-04-27', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'17706289-8\',\'leonel\',\'fuentes\',\'cordova\',\'997131410\',\'1\',\'12\',\'leonel@hotmail.com\',\'$2b$12$NX3KSpB7Jz/QSIoKsOBpquu1VNO09g3a1vrpFpnvEkHPUQvviYqPK\')', 'UsuarioA'),
(16, '2021-04-30', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'111111111-1\',\'EMPRESA 3\',\'997131410\',\'EMPRESA3@gmail.com\')', 'UsuarioA'),
(17, '2021-04-30', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'22222222-2\',\'empresa4\',\'99999999\',\'empresa4@gmail.com\')', 'UsuarioA'),
(18, '2021-04-30', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'33333333-3\',\'empresa5\',\'99999999\',\'empresa5@gmail.com\')', 'UsuarioA'),
(19, '2021-04-30', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'444444444-4\',\'empresa5\',\'99999999\',\'empresa6@gmail.com\')', 'UsuarioA'),
(20, '2021-04-30', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'444444444-44\', nombre = \'empresa55\', telefono = \'999999999\', correo = \'empresa6@gmaaail.com\' WHERE id = 18', 'UsuarioA'),
(21, '2021-04-30', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'444444444-44\', nombre = \'empresa55\', telefono = \'999999999\', correo = \'empresa6@gmaFFFFFasaail.com\' WHERE id = 18', 'UsuarioA'),
(22, '2021-04-30', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'444444444-44\', nombre = \'empresa55\', telefono = \'999999999\', correo = \'empresa6@gmaFFFFFasaail.com\' WHERE id = 18', 'UsuarioA'),
(23, '2021-04-30', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'444444444-44\', nombre = \'empresa55\', telefono = \'999999999\', correo = \'empresa6@gmaFFFFFasaail.com\' WHERE id = 18', 'UsuarioA'),
(24, '2021-04-30', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'444444444-44\', nombre = \'empresa55\', telefono = \'999999999\', correo = \'empresa6@gmaFFFFFasaail.com\' WHERE id = 18', 'UsuarioA'),
(25, '2021-04-30', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'12121212-1\',\'prestador4\',\'99999999\',\'prestador4@gmail.com\',\'calle 4\')', 'UsuarioA'),
(26, '2021-04-30', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'12121212-1\', nombre = \'prestador4444\', telefono = \'99999999\', correo = \'prestador4@gmFFFail.com\' direccion = \'calle 44\'  WHERE id = 5', 'UsuarioA'),
(27, '2021-04-30', 'prestador', 'eliminado', 'UPDATE prestadores SET rut = \'12121212-1\', nombre = \'prestador4444\', telefono = \'99999999\', correo = \'prestador4@gmFFFail.com\' direccion = \'calle 44\'  WHERE id = 5', 'UsuarioA'),
(28, '2021-04-30', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'33333333-3\', nombre = \'empresa5\', telefono = \'99999999\', correo = \'empresa5@gmail.com\' WHERE id = 17', 'UsuarioA'),
(29, '2021-04-30', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'13131313-1\',\'proveedor7\',\'99999999\',\'proveedor7@gmail.com\',\'calle6\')', 'UsuarioA'),
(30, '2021-05-01', 'prestador', 'eliminado', 'UPDATE prestadores SET rut = \'13131313-1\', nombre = \'proveedor7\', telefono = \'99999999\', correo = \'proveedor7@gmail.com\' direccion = \'calle6\'  WHERE id = 6', 'UsuarioA'),
(32, '2021-05-01', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'JJCC12\',\'sedan\',\'chevrolet\',\'spark\',\'1.6\',\'123456\',\'verde\',\'2019\',\'2021-05-10\',\'2021-05-17\',\'bencina\',\'mecanico\',\'1\',\'16\',\'2\')', 'UsuarioA'),
(33, '2021-05-01', 'activos', 'eliminado', 'UPDATE activos SET patente = \'JJCC12\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark\', numero_motor = \'1.6\', chasis = \'123456\', color = \'verde\', anio = \'2019\', fecha_rev_tec = \'2021-05-10\', fecha_perm_circ = \'2021-05-17\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'0\', id_empresa = \'16\', id_prestador = \'2\' WHERE id = 7', 'UsuarioA'),
(34, '2021-05-01', 'activos', 'eliminado', 'UPDATE activos SET patente = \'CTCX515\', tipo_vehiculo = \'sedanaaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-04-29\', fecha_perm_circ = \'2021-04-28\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'0\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 3', 'UsuarioA'),
(35, '2021-05-01', 'activos', 'modificado', 'UPDATE activos SET patente = \'ABCD12\', tipo_vehiculo = \'sedanaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-06\', fecha_perm_circ = \'2021-04-29\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 5', 'UsuarioA'),
(36, '2021-05-01', 'activos', 'modificado', 'UPDATE activos SET patente = \'JJCC12\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark\', numero_motor = \'1.6\', chasis = \'123456\', color = \'verde\', anio = \'2019\', fecha_rev_tec = \'2021-05-10\', fecha_perm_circ = \'2021-05-17\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'16\', id_prestador = \'2\' WHERE id = 7', 'UsuarioA'),
(37, '2021-05-01', 'activos', 'eliminado', 'UPDATE activos SET patente = \'JJCC12\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark\', numero_motor = \'1.6\', chasis = \'123456\', color = \'verde\', anio = \'2019\', fecha_rev_tec = \'2021-05-10\', fecha_perm_circ = \'2021-05-17\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'0\', id_empresa = \'16\', id_prestador = \'2\' WHERE id = 7', 'UsuarioA'),
(38, '2021-05-01', 'activos', 'modificado', 'UPDATE activos SET patente = \'JJCC12\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark\', numero_motor = \'1.6\', chasis = \'123456\', color = \'verde\', anio = \'2019\', fecha_rev_tec = \'2021-05-10\', fecha_perm_circ = \'2021-05-17\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'16\', id_prestador = \'2\' WHERE id = 7', 'UsuarioA'),
(39, '2021-05-01', 'activos', 'eliminado', 'UPDATE activos SET patente = \'JJCC12\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark\', numero_motor = \'1.6\', chasis = \'123456\', color = \'verde\', anio = \'2019\', fecha_rev_tec = \'2021-05-10\', fecha_perm_circ = \'2021-05-17\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'0\', id_empresa = \'16\', id_prestador = \'2\' WHERE id = 7', 'UsuarioA'),
(40, '2021-05-01', 'activos', 'modificado', 'UPDATE activos SET patente = \'ABCD12\', tipo_vehiculo = \'sedanaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-06\', fecha_perm_circ = \'2021-04-29\', combustible = \'bencinaaaaaaaa\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 5', 'UsuarioA'),
(41, '2021-05-01', 'activos', 'modificado', 'UPDATE activos SET patente = \'ABCD12\', tipo_vehiculo = \'camion\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-06\', fecha_perm_circ = \'2021-04-29\', combustible = \'bencinaaaaaaaa\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 5', 'UsuarioA'),
(42, '2021-05-01', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'22222222-2\', nombre = \'empresa4\', telefono = \'99999999\', correo = \'empresa4@gmail.com\' WHERE id = 16', 'UsuarioA'),
(43, '2021-05-01', 'persona', 'modificado', 'UPDATE persona SET rut = \'11111111-1\', nombre = \'UsuarioA\', apellido_paterno = \'BBBBB\', apellido_materno = \'C\', telefono = \'934047941\', id_permiso = \'1\', id_empresa = \'12\', correo = \'usuarioAdmin@abc.cl\', password = \'$2b$12$CQDihbqRi61dvbSv/B0yZ.nx6A1SwMo6tQXfDOYunzDsIe6iQpzrO\' WHERE id = 12', 'UsuarioA'),
(44, '2021-05-01', 'persona', 'modificado', 'UPDATE persona SET rut = \'11111111-1\', nombre = \'UsuarioA\', apellido_paterno = \'BBBBB\', apellido_materno = \'C\', telefono = \'934047941\', id_permiso = \'1\', id_empresa = \'12\', correo = \'usuarioAdmin@abc.cl\', password = \'$2b$12$qX9yvVfhHNIRDCHzZMdt3OFXED788VZhaUk75mHgqaZiitvCbi3Rq\' WHERE id = 12', 'victor'),
(45, '2021-05-01', 'persona', 'eliminado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'leonel\', apellido_paterno = \'fuentes\', apellido_materno = \'cordova\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'leonel@hotmail.com\', password = \'$2b$12$NX3KSpB7Jz/QSIoKsOBpquu1VNO09g3a1vrpFpnvEkHPUQvviYqPK\' WHERE id = 12', 'UsuarioA'),
(46, '2021-05-01', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'\',\'\',\'0\',\'\')', 'UsuarioA'),
(47, '2021-05-01', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'\', nombre = \'\', telefono = \'0\', correo = \'\' WHERE id = 19', 'UsuarioA'),
(48, '2021-05-01', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'17706289-8\',\'empresa\',\'997131410\',\'a@a.com\')', 'UsuarioA'),
(49, '2021-05-01', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'17706289-8\', nombre = \'empresa\', telefono = \'997131410\', correo = \'a@a.com\' WHERE id = 20', 'UsuarioA'),
(50, '2021-05-02', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'17706289-8\',\'Prestadorocho\',\'997131410\',\'prestador10@abc.cl\',\'maipu\')', 'UsuarioM'),
(51, '2021-05-02', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'98956262656\', nombre = \'Prestador1\', telefono = \'932165478\', correo = \'Prestador1@Prestador1.cl\' direccion = \'La obra 880\'  WHERE id = 2', 'UsuarioA'),
(54, '2021-05-02', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'000000000-0\',\'No Aplica\',\'0\',\'noaplica@noaplica.com\')', 'UsuarioA'),
(55, '2021-05-02', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'xxxx-22\',\'sedan\',\'open\',\'1234\',\'1234567\',\'12345678\',\'rojo\',\'2012\',\'14-10-2021\',\'15-11-2021\',\'bencina\',\'mecanico\',\'1\',\'12\',\'5\')', 'UsuarioA'),
(56, '2021-05-02', 'activos', 'guardar', NULL, 'UsuarioA'),
(58, '2021-05-02', 'activos', 'guardar', NULL, 'UsuarioA'),
(59, '2021-05-02', 'activos', 'guardar', NULL, 'UsuarioA'),
(62, '2021-05-02', 'activos', 'guardar', NULL, 'UsuarioA'),
(63, '2021-05-02', 'activos', 'guardar', NULL, 'UsuarioA'),
(64, '2021-05-02', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'10161531-6\',\'Prestador uno\',\'997131410\',\'prestador1@abc.cl\',\'maipu\')', 'UsuarioM'),
(65, '2021-05-02', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador uno\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'  WHERE id = 8', 'UsuarioM'),
(66, '2021-05-02', 'activos', 'guardar', NULL, 'UsuarioM'),
(68, '2021-05-02', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'16839765-8\',\'nicole\',\'ulloa\',\'matus\',\'997131410\',\'3\',\'13\',\'ulloaM@abc.cl\',\'$2b$12$fLeRf.xiq3rjy3T8qGZv1efZ2qijjga/Gkb45RE1nBo03PjR61AyG\')', 'UsuarioM'),
(69, '2021-05-02', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'nicoleeeeeee\', apellido_paterno = \'ulloa\', apellido_materno = \'matus\', telefono = \'997131410\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ulloaM@abc.cl\', password = \'$2b$12$fLeRf.xiq3rjy3T8qGZv1eV1vgVDNnaAgl.nqyEs702wdD0qOrlXe\' WHERE id = 13', 'UsuarioM'),
(70, '2021-05-02', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'nicole\', apellido_paterno = \'ulloa\', apellido_materno = \'matus\', telefono = \'997131410\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ulloaM@abc.cl\', password = \'$2b$12$fLeRf.xiq3rjy3T8qGZv1eQ6..RyANEuy6VGrEYpXFLoKB3FM.ePm\' WHERE id = 13', 'UsuarioM'),
(71, '2021-05-02', 'persona', 'modificado', 'UPDATE persona SET rut = \'33333333-3\', nombre = \'UsuarioP\', apellido_paterno = \'apellidoA\', apellido_materno = \'apellidoB\', telefono = \'932165478\', id_permiso = \'3\', id_empresa = \'13\', correo = \'usuarioPrestador@abc.cl\', password = \'$2b$12$4TD7ZIac96stLFjuoTt3/Om0vWZODSbjwZWk1/0eWvIxdomaxaSRG\' WHERE id = 13', 'UsuarioM'),
(72, '2021-05-02', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'20042741-6\',\'Jose\',\'Rodriguez\',\'Rodriguez\',\'934047941\',\'4\',\'13\',\'jose@abc.cl\',\'$2b$12$2XyBlpzcD1VxM.L8zfuV/.3NrDZ1YllsMWrtWXseVPbFhqkkMml3.\')', 'UsuarioP'),
(73, '2021-05-02', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'10890631-6\',\'Jose\',\'apellidoA\',\'Rodriguez\',\'934047941\',\'4\',\'13\',\'ecco1233@gmail.com\',\'$2b$12$AM/R1qtx9VuGn2LuLrbFnezsDne65L9gvo/BTovuB3oGeAs6i2oS6\')', 'UsuarioP'),
(74, '2021-05-02', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'nicole\', apellido_paterno = \'ulloa\', apellido_materno = \'matus\', telefono = \'997131410\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ulloaM@abc.cl\', password = \'$2b$12$F4zELjsyVmOBygOPRdT/IeOGzTQvpA9VfGF9Hvw6/B3wWnrkg5fcO\' WHERE id = 13', 'UsuarioA'),
(76, '2021-05-02', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'10890631-6\',\'Jose\',\'apellidoA\',\'Rodriguez\',\'934047941\',\'4\',\'13\',\'jperez@gmail.com\',\'$2b$12$n5NS7JcLEDNUltAtwL1t9edGJsunCA7F341KiwG9XcYpfexsFrPBG\')', 'nicole'),
(77, '2021-05-02', 'persona', 'guardar', NULL, 'nicole'),
(78, '2021-05-02', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password) VALUES (\'20042741-6\',\'Manuel\',\'B\',\'Rodriguez\',\'934047941\',\'3\',\'13\',\'ecco1233@gmail.com\',\'$2b$12$8lBJKDvCGvVBQrQVLELcTe5s5pOCKgA9nd4DWC1HY5R5D7m8omQAm\')', 'UsuarioM'),
(79, '2021-05-02', 'activos', 'guardar', NULL, 'nicole'),
(80, '2021-05-02', 'persona', 'modificado', 'UPDATE persona SET rut = \'10890631-6\', nombre = \'Jose\', apellido_paterno = \'apellidoA\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'13\', correo = \'jperez@gmail.com\', password = \'$2b$12$rFYJpW9YidGz6ve.itFfduPfwVuLqj9a0nieM/Da/3FX5I.zIplC2\' WHERE id = 13', 'UsuarioM'),
(81, '2021-05-03', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\',new.patente,\',\',new.tipo_vehiculo,\',\',new.marca,\',\',new.modelo,\',\',new.numero_motor,\',\',new.chasis,\',\',new.color,\',\',new.anio,\',\',new.fecha_rev_tec,\',\',new.fecha_perm_circ,\',\',new.combustible,\',\',new.transmision,\',\',new.habilitado,\',\',0,\',\',0,\')', 'UsuarioA'),
(82, '2021-05-03', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'AAAA-66\',\'sedan\',\'chevrolet\',\'spark GT\',\'1234567\',\'123456\',\'rojo\',\'2020\',\'2021-05-27\',\'2021-05-27\',\'bencina\',\'mecanico\',\'1\',\'0\',\'0\')', 'UsuarioA'),
(83, '2021-05-03', 'activos', 'guardar', NULL, 'UsuarioA'),
(84, '2021-05-03', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'CCCC-55\',\'sedan\',\'chevrolet\',\'spark GT\',\'1234567\',\'123456\',\'azul\',\'2020\',\'2021-05-20\',\'2021-05-28\',\'bencina\',\'mecanico\',\'1\',\'12\',\'\')', 'UsuarioA'),
(85, '2021-05-03', 'activos', 'modificado', 'UPDATE activos SET patente = \'CCCC-55\', tipo_vehiculo = \'sedanaaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1234567\', chasis = \'1234566666666666666666666\', color = \'azul\', anio = \'2020\', fecha_rev_tec = \'2021-05-20\', fecha_perm_circ = \'2021-05-28\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'\' WHERE id = 24', 'UsuarioA'),
(86, '2021-05-03', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'17706289-8\',\'EMPRESACUATRO\',\'997131410\',\'fuentes.VIctor8@gmail.com\')', 'UsuarioA'),
(87, '2021-05-03', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'17706289-8\', nombre = \'EMPRESACUATROAAAA\', telefono = \'997131410\', correo = \'fuentes.VIctor8@gmail.com\' WHERE id = 21', 'UsuarioA'),
(88, '2021-05-03', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'17706289-8\', nombre = \'EMPRESACUATROAAAA\', telefono = \'997131410\', correo = \'fuentes.VIctor8@gmail.com\' WHERE id = 21', 'UsuarioA'),
(89, '2021-05-03', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'10161531-6\',\'PRESTADORCUATRO\',\'997131410\',\'kpmg@kpmg.com\',\'pasaje manizales 6635\')', 'UsuarioA'),
(90, '2021-05-03', 'prestador', 'eliminado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'PRESTADORCUATRO\', telefono = \'997131410\', correo = \'kpmg@kpmg.com\' direccion = \'pasaje manizales 6635\'  WHERE id = 9', 'UsuarioA'),
(91, '2021-05-03', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'17706289-8\',\'victorprueba\',\'fuentes\',\'tilleria\',\'997131410\',\'1\',\'12\',\'victorA@abc.cl\',\'$2b$12$/.xJQzigncimU7Khl2tw1OfVx85xhubo3N5BQEyLjWGwxSKxMoNba\',\'1\',\'\',\'12\')', 'UsuarioA'),
(92, '2021-05-03', 'persona', 'eliminado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victorprueba\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'victorA@abc.cl\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OfVx85xhubo3N5BQEyLjWGwxSKxMoNba\', password = \'0\', password = \'\', password = \'12\' WHERE id = 12', 'UsuarioA'),
(93, '2021-05-03', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'JJJJ-11\',\'sedan\',\'chevrolet\',\'spark GT\',\'1234567\',\'aaaa\',\'azul\',\'2011\',\'2021-05-14\',\'2021-05-28\',\'bencina\',\'mecanico\',\'1\',\'12\',\'\')', 'UsuarioA'),
(94, '2021-05-03', 'activos', 'modificado', 'UPDATE activos SET patente = \'JJJJ-11\', tipo_vehiculo = \'sedan aaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1234567\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-14\', fecha_perm_circ = \'2021-05-28\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'\' WHERE id = 25', 'UsuarioA'),
(95, '2021-05-03', 'activos', 'eliminado', 'UPDATE activos SET patente = \'JJJJ-11\', tipo_vehiculo = \'sedan aaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1234567\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-14\', fecha_perm_circ = \'2021-05-28\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'0\', id_empresa = \'12\', id_prestador = \'\' WHERE id = 25', 'UsuarioA'),
(96, '2021-05-03', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador unoa\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioM'),
(97, '2021-05-03', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(98, '2021-05-03', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador unoA\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(99, '2021-05-03', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador unoA\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(100, '2021-05-03', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador unoA\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(101, '2021-05-03', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador unoB\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(102, '2021-05-03', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador unoB\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(103, '2021-06-18', 'activos', 'modificado', 'UPDATE activos SET patente = \'ABCD12\', tipo_vehiculo = \'camion\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-06-20\', fecha_perm_circ = \'2021-04-29\', combustible = \'bencinaaaaaaaa\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 5', 'UsuarioA'),
(104, '2021-06-18', 'activos', 'modificado', 'UPDATE activos SET patente = \'KKKK-11\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1233\', chasis = \'123456\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-13\', fecha_perm_circ = \'2021-06-22\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'\', id_prestador = \'\' WHERE id = 13', 'UsuarioA'),
(105, '2021-06-27', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'13\', correo = \'jose@abc.cl\', password = \'$2b$12$WkSyvZ7HtMm6nBjIDFrwMuRcgvwdNvE7BvRq6d/nVtsHxUncQpzu.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(106, '2021-06-27', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'13\', correo = \'jose@abc.cl\', password = \'$2b$12$WkSyvZ7HtMm6nBjIDFrwMu4ST2u3ZolI4aLOlwpUJbotmnKO.8yYa\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(107, '2021-06-27', 'activos', 'modificado', 'UPDATE activos SET patente = \'ABCD12\', tipo_vehiculo = \'camion\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1.2\', chasis = \'aaaa\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-06-30\', fecha_perm_circ = \'2021-04-29\', combustible = \'bencinaaaaaaaa\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'2\' WHERE id = 5', 'UsuarioA'),
(108, '2021-06-28', 'activos', 'modificado', 'UPDATE activos SET patente = \'KKKK-11\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1233\', chasis = \'123456\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-05-13\', fecha_perm_circ = \'2021-06-30\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'\', id_prestador = \'\' WHERE id = 13', 'UsuarioA'),
(109, '2021-06-28', 'activos', 'modificado', 'UPDATE activos SET patente = \'ERTY-11\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1234567\', chasis = \'123456\', color = \'rojo\', anio = \'2011\', fecha_rev_tec = \'2021-07-14\', fecha_perm_circ = \'2021-07-13\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'\', id_prestador = \'2\' WHERE id = 17', 'UsuarioA'),
(110, '2021-06-28', 'activos', 'modificado', 'UPDATE activos SET patente = \'POIU-44\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'12345\', chasis = \'123456\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-09-20\', fecha_perm_circ = \'2021-05-20\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'\' WHERE id = 18', 'UsuarioA'),
(111, '2021-06-28', 'activos', 'modificado', 'UPDATE activos SET patente = \'JKLM-66\', tipo_vehiculo = \'sedan\', marca = \'audi\', modelo = \'A1\', numero_motor = \'1234567\', chasis = \'123456789\', color = \'negro\', anio = \'2020\', fecha_rev_tec = \'2021-05-27\', fecha_perm_circ = \'2021-09-30\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'13\', id_prestador = \'\' WHERE id = 19', 'UsuarioM'),
(112, '2021-06-28', 'activos', 'modificado', 'UPDATE activos SET patente = \'LZLJ-40\', tipo_vehiculo = \'auto\', marca = \'mazda\', modelo = \'mazda3\', numero_motor = \'12345\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-20\', fecha_perm_circ = \'2021-09-10\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'1\', id_empresa = \'\', id_prestador = \'8\' WHERE id = 20', 'nicole'),
(113, '2021-06-28', 'activos', 'modificado', 'UPDATE activos SET patente = \'ABCD-12\', tipo_vehiculo = \'sedan\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1234567\', chasis = \'123456\', color = \'azul\', anio = \'2011\', fecha_rev_tec = \'2021-09-28\', fecha_perm_circ = \'2021-07-27\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'\' WHERE id = 21', 'UsuarioA'),
(114, '2021-07-11', 'persona', 'modificado', 'UPDATE persona SET rut = \'10890631-6\', nombre = \'Jose\', apellido_paterno = \'apellidoA\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'13\', correo = \'jperez@gmail.com\', password = \'$2b$12$xKm7Ac4AJ/w8TDSUFgmBKeUkpPaUfupiweqNq3qWm9KBWjWbp9eM6\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(115, '2021-07-11', 'activos', 'modificado', 'UPDATE activos SET patente = \'CCCC-55\', tipo_vehiculo = \'sedanaaaaaa\', marca = \'chevrolet\', modelo = \'spark GT\', numero_motor = \'1234567\', chasis = \'1234566666666666666666666\', color = \'azul\', anio = \'2020\', fecha_rev_tec = \'2022-05-20\', fecha_perm_circ = \'2022-05-28\', combustible = \'bencina\', transmision = \'mecanico\', habilitado = \'1\', id_empresa = \'12\', id_prestador = \'\' WHERE id = 24', 'UsuarioA'),
(116, '2021-07-23', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'17706289-8\',\'victor\',\'fuentes\',\'tilleria\',\'997131410\',\'1\',\'12\',\'fuentes.victor8@gmail.com\',\'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\',\'1\',\'\',\'12\')', 'UsuarioA'),
(117, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(118, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(119, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(120, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(121, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(122, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(123, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(124, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(125, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(126, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(127, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(128, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(129, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(130, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(131, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(132, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(133, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(134, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(135, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(136, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(137, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(138, '2021-07-23', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'10161531-6\',\'juan\',\'vivaz\',\'aaaa\',\'997131410\',\'1\',\'12\',\'juanc.vivasm@gmail.com\',\'$2b$12$mah/vCoOXlGIIufgBg.EJeRNovRZrJyCTCrkr5Ug0Z8LpzQ6L4odK\',\'1\',\'\',\'29\')', 'victor'),
(139, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'10161531-6\', nombre = \'juan\', apellido_paterno = \'vivaz\', apellido_materno = \'aaaa\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'juanc.vivasm@gmail.com\', password = \'$2b$12$mah/vCoOXlGIIufgBg.EJeRNovRZrJyCTCrkr5Ug0Z8LpzQ6L4odK\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'29\' WHERE id = 12', 'victor'),
(140, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(141, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(142, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(143, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(144, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(145, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(146, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(147, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(148, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(149, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(150, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(151, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(152, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(153, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(154, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA');
INSERT INTO `auditoria` (`id_auditoria`, `fecha`, `tabla`, `evento`, `consulta`, `usuario`) VALUES
(155, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(156, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(157, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(158, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(159, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(160, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(161, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(162, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(163, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(164, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(165, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(166, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(167, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(168, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(169, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(170, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(171, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(172, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(173, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(174, '2021-07-23', 'persona', 'modificado', 'UPDATE persona SET rut = \'17706289-8\', nombre = \'victor\', apellido_paterno = \'fuentes\', apellido_materno = \'tilleria\', telefono = \'997131410\', id_permiso = \'1\', id_empresa = \'12\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$Sny.5EhE4Jq4y42F/pJ8IO5HNoVpOv9fI6IxylLsvjlMlCU/5WVAi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(175, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(176, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(177, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(178, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(179, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(180, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(181, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(182, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(183, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$/.xJQzigncimU7Khl2tw1OHqcgLw6LWiRtLpAsBu1islwUp3sF2zW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(184, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$UbAJY6VLwiLxq8B/Xc4yEu1mGINNuaYnhxlDKYDce1W3EqlxuVy/O\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(185, '2021-07-25', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$PP37f/vYKflygXjRLOljh.0ENY7ploUWnotPWC4Pw6.Iaz27YILRO\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(186, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$PP37f/vYKflygXjRLOljh.0ENY7ploUWnotPWC4Pw6.Iaz27YILRO\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(187, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$PP37f/vYKflygXjRLOljh.NAos.AdJ.BurNAXnBBaV5wZRHC1Px5i\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(188, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$PP37f/vYKflygXjRLOljh.NAos.AdJ.BurNAXnBBaV5wZRHC1Px5i\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(189, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$m60R11eqtoNZHDC636M/pO2gAPT2ilyjCOAL8/n96exwk0cGiwXsu\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(190, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$5GYhA73QUuj/4.99NQs2FunHz0FcCZyvbrWGMGRPDRj9McRLgGN9C\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(191, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$5GYhA73QUuj/4.99NQs2FunHz0FcCZyvbrWGMGRPDRj9McRLgGN9C\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(192, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$5GYhA73QUuj/4.99NQs2FunHz0FcCZyvbrWGMGRPDRj9McRLgGN9C\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(193, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$v5sKmpjIMtefhggsLLMrqO70OAMYQFBp5em1tv5l3FCl7xXDwt1qK\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(194, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$v5sKmpjIMtefhggsLLMrqO70OAMYQFBp5em1tv5l3FCl7xXDwt1qK\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(195, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$v5sKmpjIMtefhggsLLMrqOip8Wlu3Qfn7V7TdlJkEYTFYSToQofRm\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(196, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$v5sKmpjIMtefhggsLLMrqOip8Wlu3Qfn7V7TdlJkEYTFYSToQofRm\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(197, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$7BETLj3ScwiIZsT45km9uuCmJ11s7jR3TJUybCl8qyu6N1TH9Xg5O\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(198, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$7BETLj3ScwiIZsT45km9uuCmJ11s7jR3TJUybCl8qyu6N1TH9Xg5O\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(199, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$7BETLj3ScwiIZsT45km9uuCmJ11s7jR3TJUybCl8qyu6N1TH9Xg5O\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(200, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$7BETLj3ScwiIZsT45km9uuCmJ11s7jR3TJUybCl8qyu6N1TH9Xg5O\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(201, '2021-07-26', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$1RWgsoYYFU3JrjHvJVaZjuQSoJZrsay5kwosYLBQC1hrffZImpJZW\', habilitado = \'1\', id_prestador = \'8\', id_usuario = \'13\' WHERE id = 13', 'UsuarioM'),
(202, '2021-07-27', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'20042741-6\',\'Jose\',\'934047941\',\'jrodlema@gmail.com\')', 'UsuarioA'),
(203, '2021-07-27', 'empresa', 'modificado', 'UPDATE empresa SET rut = \'20042741-6\', nombre = \'Jose Manuel\', telefono = \'934047941\', correo = \'jrodlema@gmail.com\', habilitado = \'1\' WHERE id = 22', 'UsuarioA'),
(204, '2021-07-27', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'20042741-6\', nombre = \'Jose Manuel\', telefono = \'934047941\', correo = \'jrodlema@gmail.com\', habilitado = \'0\' WHERE id = 22', 'UsuarioA'),
(205, '2021-07-27', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'10890631-6\',\'empresa dos\',\'934047941\',\'jrodlema@gmail.com\')', 'UsuarioA'),
(206, '2021-07-27', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'16839765-8\',\'Nicolee\',\'Ulloa\',\'Matus\',\'934047941\',\'2\',\'23\',\'nic.ulloa@gmail.com\',\'$2b$12$WlkEAkxSWoBrn2X2YeofQ.XYfvcgoGex.UKosE8v6.tF/qnox5Fyi\',\'1\',\'\',\'12\')', 'UsuarioA'),
(207, '2021-07-27', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'LBRF28\',\'camioneta\',\'nissan\',\'np300\',\'45657567\',\'12345abc\',\'plata\',\'2020\',\'2021-07-26\',\'2021-07-31\',\'bencina\',\'manual\',\'1\',\'23\',\'\')', 'Nicolee'),
(208, '2021-07-27', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'12287279-3\',\'Prestador dos\',\'934047941\',\'lperez@gmail.com\',\'Alameda 54\')', 'Nicolee'),
(209, '2021-07-27', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'20042741-6\',\'Jose\',\'Rodriguez\',\'Rodriguez\',\'934047941\',\'4\',\'23\',\'jrodlema@gmail.com\',\'$2b$12$WlkEAkxSWoBrn2X2YeofQ.Oeqos0b4tPXpVaCJiVBF9gpI97aE3vy\',\'1\',\'10\',\'31\')', 'Nicolee'),
(210, '2021-07-27', 'activos', 'modificado', 'UPDATE activos SET patente = \'LZLJ40\', tipo_vehiculo = \'camioneta\', marca = \'nissan\', modelo = \'np300\', numero_motor = \'45657567\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-26\', fecha_perm_circ = \'2021-07-31\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'1\', id_empresa = \'23\', id_prestador = \'\' WHERE id = 26', 'Nicolee'),
(211, '2021-07-27', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicolee\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'934047941\', id_permiso = \'2\', id_empresa = \'23\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$WlkEAkxSWoBrn2X2YeofQ.XYfvcgoGex.UKosE8v6.tF/qnox5Fyi\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 23', 'UsuarioA'),
(212, '2021-07-27', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicolee\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'934047941\', id_permiso = \'2\', id_empresa = \'23\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$WlkEAkxSWoBrn2X2YeofQ.6XmsLE8.17JcvCi/GH0jolMED7ittVO\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 23', 'UsuarioA'),
(213, '2021-07-27', 'persona', 'eliminado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'23\', correo = \'jrodlema@gmail.com\', password = \'$2b$12$WlkEAkxSWoBrn2X2YeofQ.Oeqos0b4tPXpVaCJiVBF9gpI97aE3vy\', habilitado = \'0\', id_prestador = \'10\', id_usuario = \'12\' WHERE id = 23', 'UsuarioA'),
(214, '2021-07-27', 'persona', 'eliminado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicolee\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'934047941\', id_permiso = \'2\', id_empresa = \'23\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$WlkEAkxSWoBrn2X2YeofQ.6XmsLE8.17JcvCi/GH0jolMED7ittVO\', habilitado = \'0\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 23', 'UsuarioA'),
(215, '2021-07-27', 'prestador', 'eliminado', 'UPDATE prestadores SET rut = \'12287279-3\', nombre = \'Prestador dos\', telefono = \'934047941\', correo = \'lperez@gmail.com\' direccion = \'Alameda 54\'habilitado = \'0\'  WHERE id = 10', 'UsuarioA'),
(216, '2021-07-27', 'activos', 'eliminado', 'UPDATE activos SET patente = \'LZLJ40\', tipo_vehiculo = \'camioneta\', marca = \'nissan\', modelo = \'np300\', numero_motor = \'45657567\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-26\', fecha_perm_circ = \'2021-07-31\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'0\', id_empresa = \'23\', id_prestador = \'\' WHERE id = 26', 'UsuarioA'),
(217, '2021-07-28', 'activos', 'eliminado', 'UPDATE activos SET patente = \'LZLJ-40\', tipo_vehiculo = \'auto\', marca = \'mazda\', modelo = \'mazda3\', numero_motor = \'12345\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-20\', fecha_perm_circ = \'2021-09-10\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'0\', id_empresa = \'\', id_prestador = \'8\' WHERE id = 20', 'UsuarioA'),
(218, '2021-07-28', 'persona', 'eliminado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'13\', correo = \'jose@abc.cl\', password = \'$2b$12$WkSyvZ7HtMm6nBjIDFrwMu4ST2u3ZolI4aLOlwpUJbotmnKO.8yYa\', habilitado = \'0\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(219, '2021-07-28', 'persona', 'eliminado', 'UPDATE persona SET rut = \'10890631-6\', nombre = \'Jose\', apellido_paterno = \'apellidoA\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'13\', correo = \'jperez@gmail.com\', password = \'$2b$12$xKm7Ac4AJ/w8TDSUFgmBKeUkpPaUfupiweqNq3qWm9KBWjWbp9eM6\', habilitado = \'0\', id_prestador = \'8\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(220, '2021-07-28', 'empresa', 'eliminado', 'UPDATE empresa SET rut = \'10890631-6\', nombre = \'empresa dos\', telefono = \'934047941\', correo = \'jrodlema@gmail.com\', habilitado = \'0\' WHERE id = 23', 'UsuarioA'),
(221, '2021-07-28', 'empresa', 'guardar', 'INSERT INTO empresa (rut, nombre, telefono, correo) VALUES (\'10890631-6\',\'Empresa dos\',\'934047941\',\'ecco1233@gmail.com\')', 'UsuarioA'),
(222, '2021-07-28', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'20042741-6\',\'Jose\',\'Rodriguez\',\'Rodriguez\',\'934047941\',\'2\',\'24\',\'jrodlema@gmail.com\',\'$2b$12$Z/1v2lb1OAXsuUiLY3Kl9Oa0G9Y2FpBG3XsSzQtekzyjn8ajfEU.K\',\'1\',\'\',\'12\')', 'UsuarioA'),
(223, '2021-07-28', 'persona', 'eliminado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'ManuelA\', apellido_paterno = \'B\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'3\', id_empresa = \'13\', correo = \'ecco1233@gmail.com\', password = \'$2b$12$1RWgsoYYFU3JrjHvJVaZjuQSoJZrsay5kwosYLBQC1hrffZImpJZW\', habilitado = \'0\', id_prestador = \'8\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(224, '2021-07-28', 'persona', 'eliminado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'4\', id_empresa = \'23\', correo = \'jrodlema@gmail.com\', password = \'$2b$12$WlkEAkxSWoBrn2X2YeofQ.Oeqos0b4tPXpVaCJiVBF9gpI97aE3vy\', habilitado = \'0\', id_prestador = \'10\', id_usuario = \'12\' WHERE id = 23', 'UsuarioA'),
(225, '2021-07-28', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'2\', id_empresa = \'24\', correo = \'jrodlema@gmail.com\', password = \'$2b$12$Z/1v2lb1OAXsuUiLY3Kl9Oa0G9Y2FpBG3XsSzQtekzyjn8ajfEU.K\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 24', 'UsuarioA'),
(226, '2021-07-28', 'persona', 'modificado', 'UPDATE persona SET rut = \'20042741-6\', nombre = \'Jose\', apellido_paterno = \'Rodriguez\', apellido_materno = \'Rodriguez\', telefono = \'934047941\', id_permiso = \'2\', id_empresa = \'24\', correo = \'jrodlema@gmail.com\', password = \'$2b$12$Z/1v2lb1OAXsuUiLY3Kl9O/uWr2e41fxr8FkTvsOy6hrIX9XvOJb6\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 24', 'UsuarioA'),
(227, '2021-07-28', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'12287279-3\',\'Manuel\',\'Rodriguez\',\'Rodriguez\',\'934047941\',\'2\',\'24\',\'nic.ulloa@gmail.com\',\'$2b$12$Z/1v2lb1OAXsuUiLY3Kl9O5Oc0T3QYWMIaE9wyX4ujn2N7AUaEKJu\',\'1\',\'\',\'12\')', 'UsuarioA'),
(228, '2021-07-28', 'prestador', 'guardar', 'INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES (\'8655491-7\',\'prestador once\',\'912345678\',\'lsoto@gmail.com\',\'La obra 880\')', 'UsuarioM'),
(229, '2021-07-28', 'activos', 'guardar', 'INSERT INTO activos (patente, tipo_vehiculo, marca, modelo, numero_motor, chasis, color, anio, fecha_rev_tec, fecha_perm_circ, combustible, transmision, habilitado, id_empresa, id_prestador) VALUES (\'LZLJ40\',\'auto\',\'mazda\',\'mazda3\',\'45657567\',\'12345abc\',\'plata\',\'2020\',\'2021-07-26\',\'2021-07-31\',\'bencina\',\'manual\',\'1\',\'\',\'11\')', 'UsuarioM'),
(230, '2021-07-28', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'17906159-7\',\'Jose\',\'Rodriguez\',\'Rodriguez\',\'934047941\',\'4\',\'13\',\'jose@gmail.com\',\'$2b$12$Z/1v2lb1OAXsuUiLY3Kl9Oa0G9Y2FpBG3XsSzQtekzyjn8ajfEU.K\',\'1\',\'11\',\'13\')', 'UsuarioM'),
(231, '2021-09-07', 'activos', 'modificado', 'UPDATE activos SET patente = \'LZLJ-40\', tipo_vehiculo = \'auto\', marca = \'mazda\', modelo = \'mazda3\', numero_motor = \'12345\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-20\', fecha_perm_circ = \'2021-09-10\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'1\', id_empresa = \'\', id_prestador = \'8\' WHERE id = 20', 'UsuarioA'),
(232, '2021-09-07', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador Mazda\', telefono = \'997131410\', correo = \'prestador1@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(233, '2021-09-07', 'prestador', 'eliminado', 'UPDATE prestadores SET rut = \'8655491-7\', nombre = \'prestador once\', telefono = \'912345678\', correo = \'lsoto@gmail.com\' direccion = \'La obra 880\'habilitado = \'0\'  WHERE id = 11', 'UsuarioA'),
(234, '2021-09-07', 'prestador', 'modificado', 'UPDATE prestadores SET rut = \'10161531-6\', nombre = \'Prestador Mazda\', telefono = \'997131410\', correo = \'prestadorMazda@abc.cl\' direccion = \'maipu\'habilitado = \'1\'  WHERE id = 8', 'UsuarioA'),
(235, '2021-11-12', 'persona', 'modificado', 'UPDATE persona SET rut = \'11111111-1\', nombre = \'UsuarioA\', apellido_paterno = \'ApellidoA\', apellido_materno = \'apellidoB\', telefono = \'934047941\', id_permiso = \'1\', id_empresa = \'12\', correo = \'usuarioAdmin@abc.cl\', password = \'$2b$12$xjTDVoi91KuauXVK/4mJfeiIDkDzksaR.9Isg0sKsFX1DkWzGqH1a\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(236, '2021-11-12', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'44444444-4\',\'UsuarioG\',\'apellidoA\',\'apellidoB\',\'934047941\',\'4\',\'13\',\'usuarioGuardia@abc.cl\',\'$2b$12$xjTDVoi91KuauXVK/4mJfeTVAZ049BNBcf0kkjkxAjZ02IwUcgoWq\',\'1\',\'\',\'12\')', 'UsuarioA'),
(237, '2021-11-12', 'activos', 'modificado', 'UPDATE activos SET patente = \'LZLJ-40\', tipo_vehiculo = \'auto\', marca = \'mazda\', modelo = \'mazda3\', numero_motor = \'12345\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-20\', fecha_perm_circ = \'2021-09-10\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'1\', id_empresa = \'13\', id_prestador = \'8\' WHERE id = 20', 'UsuarioA'),
(238, '2021-11-12', 'activos', 'modificado', 'UPDATE activos SET patente = \'LZLJ40\', tipo_vehiculo = \'auto\', marca = \'mazda\', modelo = \'mazda3\', numero_motor = \'12345\', chasis = \'12345abc\', color = \'plata\', anio = \'2020\', fecha_rev_tec = \'2021-07-20\', fecha_perm_circ = \'2021-09-10\', combustible = \'bencina\', transmision = \'manual\', habilitado = \'1\', id_empresa = \'13\', id_prestador = \'8\' WHERE id = 20', 'UsuarioM'),
(239, '2021-11-12', 'persona', 'modificado', 'UPDATE persona SET rut = \'11111111-1\', nombre = \'UsuarioA\', apellido_paterno = \'ApellidoA\', apellido_materno = \'apellidoB\', telefono = \'934047941\', id_permiso = \'1\', id_empresa = \'12\', correo = \'usuarioAdmin@abc.cl\', password = \'$2b$12$4TD7ZIac96stLFjuoTt3/Om0vWZODSbjwZWk1/0eWvIxdomaxaSRG\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(240, '2021-11-12', 'persona', 'modificado', 'UPDATE persona SET rut = \'11111111-1\', nombre = \'UsuarioA\', apellido_paterno = \'ApellidoA\', apellido_materno = \'apellidoB\', telefono = \'934047941\', id_permiso = \'1\', id_empresa = \'12\', correo = \'usuarioAdmin@abc.cl\', password = \'$2b$12$xjTDVoi91KuauXVK/4mJfevJke8g/opV6VruUGVpiS7kZi3sHbQCq\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 12', 'UsuarioA'),
(241, '2021-11-20', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'16839765-8\',\'Nicole\',\'Ulloa\',\'Matus\',\'982281647\',\'2\',\'13\',\'nic.ulloa@gmail.com\',\'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\',\'1\',\'\',\'12\')', 'UsuarioA'),
(242, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(243, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(244, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(245, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(246, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(247, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(248, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(249, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(250, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(251, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(252, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$8/4.GrYic0CEH9nNP869peU9DF0x.mC7l2OIZVJ7LBj5CJNhFdXH.\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(253, '2021-11-20', 'persona', 'modificado', 'UPDATE persona SET rut = \'16839765-8\', nombre = \'Nicole\', apellido_paterno = \'Ulloa\', apellido_materno = \'Matus\', telefono = \'982281647\', id_permiso = \'2\', id_empresa = \'13\', correo = \'nic.ulloa@gmail.com\', password = \'$2b$12$VTCWPujPsDl6ms42p1T2NeZ6eZa0wj3oDvv0iyCQFNLU8lQS7U2k2\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(254, '2021-11-26', 'persona', 'guardar', 'INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES (\'55555555-5\',\'Victor\',\'Fuentes\',\'Tilleria\',\'978233056\',\'2\',\'13\',\'fuentes.victor8@gmail.com\',\'$2b$12$eiF.ZDHBaEylQ0bI6zRz5O7AlKeR.BSPD4REB2Ov.r6Nlbqek/hou\',\'1\',\'\',\'12\')', 'UsuarioA'),
(255, '2021-12-01', 'persona', 'modificado', 'UPDATE persona SET rut = \'55555555-5\', nombre = \'Victor\', apellido_paterno = \'Fuentes\', apellido_materno = \'Tilleria\', telefono = \'978233056\', id_permiso = \'2\', id_empresa = \'13\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$eiF.ZDHBaEylQ0bI6zRz5O7AlKeR.BSPD4REB2Ov.r6Nlbqek/hou\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA'),
(256, '2021-12-01', 'persona', 'modificado', 'UPDATE persona SET rut = \'55555555-5\', nombre = \'Victor\', apellido_paterno = \'Fuentes\', apellido_materno = \'Tilleria\', telefono = \'978233056\', id_permiso = \'2\', id_empresa = \'13\', correo = \'fuentes.victor8@gmail.com\', password = \'$2b$12$D1dej02Q2LBZuol.fomf2uUg/p.4GPRkYcP0OCB8qlPwTdGJZpZCe\', habilitado = \'1\', id_prestador = \'\', id_usuario = \'12\' WHERE id = 13', 'UsuarioA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_usuario`
--

DROP TABLE IF EXISTS `auditoria_usuario`;
CREATE TABLE IF NOT EXISTS `auditoria_usuario` (
  `id_auditoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  PRIMARY KEY (`id_auditoria`)
) ENGINE=InnoDB AUTO_INCREMENT=299 DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `auditoria_usuario`
--

INSERT INTO `auditoria_usuario` (`id_auditoria`, `nombre`, `tipo`, `fecha_hora`) VALUES
(1, 'UsuarioA', 'salida', '2021-04-27 13:07:32'),
(2, 'UsuarioA', 'entrada', '2021-04-27 13:07:40'),
(3, 'UsuarioA', 'salida', '2021-04-27 13:08:15'),
(4, 'UsuarioA', 'entrada', '2021-04-27 13:10:30'),
(5, 'UsuarioA', 'salida', '2021-04-27 13:10:37'),
(6, 'UsuarioA', 'entrada', '2021-04-27 13:10:39'),
(7, 'UsuarioA', 'salida', '2021-04-27 13:29:24'),
(8, 'UsuarioA', 'entrada', '2021-04-27 13:29:29'),
(9, 'UsuarioA', 'entrada', '2021-04-27 19:22:14'),
(10, 'UsuarioA', 'salida', '2021-04-27 21:19:03'),
(11, 'UsuarioA', 'entrada', '2021-04-27 21:19:28'),
(12, 'UsuarioA', 'entrada', '2021-04-30 21:52:14'),
(13, 'UsuarioA', 'salida', '2021-04-30 22:05:34'),
(14, 'UsuarioA', 'entrada', '2021-04-30 22:10:59'),
(15, 'UsuarioA', 'salida', '2021-04-30 23:23:24'),
(16, 'UsuarioA', 'salida', '2021-04-30 23:27:17'),
(17, 'UsuarioA', 'salida', '2021-04-30 23:28:24'),
(18, 'UsuarioA', 'entrada', '2021-04-30 23:28:49'),
(19, 'UsuarioA', 'entrada', '2021-05-01 00:36:58'),
(20, 'victor', 'entrada', '2021-05-01 01:15:16'),
(21, 'victor', 'salida', '2021-05-01 01:15:37'),
(22, 'UsuarioA', 'entrada', '2021-05-01 01:15:43'),
(23, 'UsuarioA', 'salida', '2021-05-01 01:46:59'),
(24, 'UsuarioA', 'entrada', '2021-05-01 01:47:02'),
(25, 'UsuarioA', 'entrada', '2021-05-02 16:14:35'),
(26, 'UsuarioA', 'salida', '2021-05-02 16:14:47'),
(27, 'UsuarioA', 'entrada', '2021-05-02 16:16:14'),
(28, 'UsuarioA', 'salida', '2021-05-02 16:17:22'),
(29, 'UsuarioA', 'entrada', '2021-05-02 16:17:43'),
(30, 'UsuarioA', 'salida', '2021-05-02 16:17:48'),
(31, 'UsuarioA', 'entrada', '2021-05-02 16:18:26'),
(32, 'UsuarioA', 'salida', '2021-05-02 16:18:31'),
(33, 'UsuarioM', 'entrada', '2021-05-02 16:18:48'),
(34, 'UsuarioM', 'salida', '2021-05-02 17:12:02'),
(35, 'UsuarioA', 'entrada', '2021-05-02 17:12:07'),
(36, 'UsuarioA', 'salida', '2021-05-02 17:39:53'),
(37, 'UsuarioM', 'entrada', '2021-05-02 17:39:56'),
(38, 'UsuarioM', 'salida', '2021-05-02 17:46:21'),
(39, 'UsuarioA', 'entrada', '2021-05-02 17:46:26'),
(40, 'UsuarioA', 'salida', '2021-05-02 18:04:41'),
(41, 'UsuarioM', 'entrada', '2021-05-02 18:04:45'),
(42, 'UsuarioM', 'salida', '2021-05-02 18:07:15'),
(43, 'UsuarioA', 'entrada', '2021-05-02 18:07:19'),
(44, 'UsuarioA', 'salida', '2021-05-02 18:11:55'),
(45, 'UsuarioA', 'entrada', '2021-05-02 18:11:58'),
(46, 'UsuarioA', 'salida', '2021-05-02 18:12:02'),
(47, 'UsuarioM', 'entrada', '2021-05-02 18:12:05'),
(48, 'UsuarioM', 'salida', '2021-05-02 18:13:10'),
(49, 'UsuarioA', 'entrada', '2021-05-02 18:13:14'),
(50, 'UsuarioA', 'salida', '2021-05-02 18:13:47'),
(51, 'UsuarioM', 'entrada', '2021-05-02 18:13:50'),
(52, 'UsuarioM', 'salida', '2021-05-02 18:44:16'),
(53, 'UsuarioM', 'entrada', '2021-05-02 18:44:20'),
(54, 'UsuarioM', 'salida', '2021-05-02 18:48:37'),
(55, 'UsuarioP', 'entrada', '2021-05-02 19:15:40'),
(56, 'UsuarioP', 'salida', '2021-05-02 21:36:29'),
(57, 'UsuarioA', 'entrada', '2021-05-02 21:37:06'),
(58, 'UsuarioA', 'salida', '2021-05-02 21:45:04'),
(59, 'UsuarioA', 'entrada', '2021-05-02 21:45:24'),
(60, 'UsuarioA', 'salida', '2021-05-02 21:46:15'),
(61, 'nicole', 'entrada', '2021-05-02 21:46:25'),
(62, 'nicole', 'salida', '2021-05-02 22:02:23'),
(63, 'UsuarioP', 'entrada', '2021-05-02 22:02:46'),
(64, 'UsuarioP', 'salida', '2021-05-02 22:02:59'),
(65, 'UsuarioM', 'entrada', '2021-05-02 22:03:13'),
(66, 'UsuarioM', 'salida', '2021-05-02 22:09:28'),
(67, 'UsuarioP', 'entrada', '2021-05-02 22:09:37'),
(68, 'UsuarioP', 'salida', '2021-05-02 22:10:44'),
(69, 'nicole', 'entrada', '2021-05-02 22:11:17'),
(70, 'nicole', 'salida', '2021-05-02 22:16:49'),
(71, 'UsuarioM', 'entrada', '2021-05-02 22:17:01'),
(72, 'UsuarioM', 'salida', '2021-05-02 22:26:14'),
(73, 'UsuarioA', 'entrada', '2021-05-02 22:26:21'),
(74, 'UsuarioA', 'salida', '2021-05-02 22:33:02'),
(75, 'UsuarioM', 'entrada', '2021-05-02 22:33:09'),
(76, 'UsuarioA', 'entrada', '2021-05-03 13:27:05'),
(77, 'UsuarioA', 'salida', '2021-05-03 13:27:26'),
(78, 'UsuarioM', 'entrada', '2021-05-03 13:27:30'),
(79, 'UsuarioM', 'salida', '2021-05-03 17:10:23'),
(80, 'UsuarioA', 'entrada', '2021-05-03 17:10:43'),
(81, 'UsuarioA', 'entrada', '2021-05-03 19:25:06'),
(82, 'UsuarioA', 'salida', '2021-05-03 19:26:51'),
(83, 'UsuarioM', 'entrada', '2021-05-03 19:26:56'),
(84, 'UsuarioM', 'salida', '2021-05-03 19:34:16'),
(85, 'UsuarioM', 'entrada', '2021-05-03 19:34:44'),
(86, 'UsuarioM', 'salida', '2021-05-03 19:36:01'),
(87, 'UsuarioA', 'entrada', '2021-05-03 21:23:19'),
(88, 'UsuarioA', 'entrada', '2021-05-03 22:12:50'),
(89, 'UsuarioA', 'salida', '2021-05-03 22:37:15'),
(90, 'UsuarioM', 'entrada', '2021-05-03 22:37:21'),
(91, 'UsuarioM', 'salida', '2021-05-03 22:37:56'),
(92, 'UsuarioM', 'entrada', '2021-05-03 22:48:17'),
(93, 'UsuarioM', 'salida', '2021-05-03 22:48:25'),
(94, 'UsuarioA', 'entrada', '2021-05-03 22:48:29'),
(95, 'UsuarioM', 'entrada', '2021-05-25 00:11:07'),
(96, 'UsuarioM', 'entrada', '2021-05-25 18:54:04'),
(97, 'UsuarioM', 'salida', '2021-05-25 19:33:30'),
(98, 'victor', 'entrada', '2021-05-25 19:34:50'),
(99, 'victor', 'salida', '2021-05-25 19:35:02'),
(100, 'UsuarioM', 'entrada', '2021-05-25 19:35:05'),
(101, 'UsuarioM', 'entrada', '2021-06-05 16:40:02'),
(102, 'UsuarioM', 'entrada', '2021-06-05 16:54:32'),
(103, 'UsuarioM', 'entrada', '2021-06-07 22:07:48'),
(104, 'UsuarioA', 'entrada', '2021-06-18 20:32:28'),
(105, 'UsuarioA', 'entrada', '2021-06-23 21:34:47'),
(106, 'UsuarioA', 'entrada', '2021-06-27 13:20:15'),
(107, 'UsuarioA', 'salida', '2021-06-27 13:25:44'),
(108, 'Jose', 'entrada', '2021-06-27 13:25:52'),
(109, 'Jose', 'salida', '2021-06-27 13:26:51'),
(110, 'UsuarioA', 'entrada', '2021-06-27 13:32:09'),
(111, 'UsuarioA', 'salida', '2021-06-27 13:33:46'),
(112, 'UsuarioA', 'entrada', '2021-06-27 13:33:48'),
(113, 'UsuarioA', 'salida', '2021-06-27 13:35:29'),
(114, 'UsuarioA', 'entrada', '2021-06-27 13:35:31'),
(115, 'UsuarioA', 'salida', '2021-06-27 13:38:11'),
(116, 'UsuarioA', 'entrada', '2021-06-27 13:38:13'),
(117, 'UsuarioA', 'salida', '2021-06-27 14:09:35'),
(118, 'UsuarioM', 'entrada', '2021-06-27 14:09:38'),
(119, 'UsuarioM', 'salida', '2021-06-27 14:09:44'),
(120, 'UsuarioA', 'entrada', '2021-06-27 14:09:48'),
(121, 'UsuarioA', 'salida', '2021-06-27 14:13:20'),
(122, 'UsuarioM', 'entrada', '2021-06-27 14:13:25'),
(123, 'UsuarioM', 'salida', '2021-06-27 14:15:58'),
(124, 'UsuarioA', 'entrada', '2021-06-27 14:16:02'),
(125, 'UsuarioA', 'salida', '2021-06-27 22:06:18'),
(126, 'victor', 'entrada', '2021-06-27 22:06:25'),
(127, 'victor', 'salida', '2021-06-27 22:06:31'),
(128, 'victor', 'entrada', '2021-06-27 22:06:40'),
(129, 'victor', 'salida', '2021-06-27 22:06:45'),
(130, 'Jose', 'entrada', '2021-06-27 22:06:57'),
(131, 'Jose', 'salida', '2021-06-27 22:08:56'),
(132, 'UsuarioA', 'entrada', '2021-06-27 22:13:51'),
(133, 'UsuarioA', 'entrada', '2021-06-28 11:59:38'),
(134, 'UsuarioA', 'entrada', '2021-06-28 20:19:39'),
(135, 'UsuarioA', 'salida', '2021-06-28 20:21:45'),
(136, 'Jose', 'entrada', '2021-06-28 20:21:57'),
(137, 'Jose', 'salida', '2021-06-28 20:23:23'),
(138, 'UsuarioA', 'entrada', '2021-06-28 20:23:26'),
(139, 'UsuarioA', 'entrada', '2021-06-29 19:56:53'),
(140, 'UsuarioA', 'entrada', '2021-07-09 10:29:07'),
(141, 'UsuarioA', 'entrada', '2021-07-09 14:16:24'),
(142, 'UsuarioA', 'entrada', '2021-07-11 21:26:16'),
(143, 'UsuarioA', 'salida', '2021-07-11 21:26:41'),
(144, 'UsuarioA', 'entrada', '2021-07-11 21:26:59'),
(145, 'UsuarioA', 'salida', '2021-07-11 21:27:14'),
(146, 'Jose', 'entrada', '2021-07-11 21:27:20'),
(147, 'Jose', 'salida', '2021-07-11 21:40:07'),
(148, 'UsuarioA', 'entrada', '2021-07-11 21:40:09'),
(149, 'UsuarioA', 'entrada', '2021-07-18 17:12:04'),
(150, 'UsuarioA', 'salida', '2021-07-18 17:54:57'),
(151, 'UsuarioM', 'entrada', '2021-07-18 17:55:01'),
(152, 'UsuarioM', 'salida', '2021-07-18 19:06:41'),
(153, 'victor', 'entrada', '2021-07-18 19:06:49'),
(154, 'victor', 'salida', '2021-07-18 19:06:53'),
(155, 'Jose', 'entrada', '2021-07-18 19:07:30'),
(156, 'Jose', 'salida', '2021-07-18 21:34:35'),
(157, 'UsuarioA', 'entrada', '2021-07-18 21:34:39'),
(158, 'UsuarioA', 'salida', '2021-07-18 21:35:26'),
(159, 'UsuarioM', 'entrada', '2021-07-18 21:35:30'),
(160, 'UsuarioM', 'salida', '2021-07-18 21:37:38'),
(161, 'UsuarioA', 'entrada', '2021-07-18 21:37:42'),
(162, 'UsuarioA', 'entrada', '2021-07-23 13:30:33'),
(163, 'UsuarioA', 'salida', '2021-07-23 13:32:40'),
(164, 'UsuarioA', 'entrada', '2021-07-23 13:52:24'),
(165, 'UsuarioA', 'salida', '2021-07-23 13:53:23'),
(166, 'victor', 'entrada', '2021-07-23 16:29:10'),
(167, 'victor', 'salida', '2021-07-23 16:30:24'),
(168, 'juan', 'entrada', '2021-07-23 18:29:11'),
(169, 'juan', 'salida', '2021-07-23 18:32:38'),
(170, 'juan', 'entrada', '2021-07-23 19:02:36'),
(171, 'juan', 'salida', '2021-07-23 19:07:07'),
(172, 'juan', 'entrada', '2021-07-23 19:08:08'),
(173, 'juan', 'salida', '2021-07-23 19:14:08'),
(174, 'juan', 'entrada', '2021-07-23 19:21:26'),
(175, 'juan', 'salida', '2021-07-23 19:33:19'),
(176, 'ManuelA', 'entrada', '2021-07-25 16:28:53'),
(177, 'ManuelA', 'salida', '2021-07-26 22:14:12'),
(178, 'ManuelA', 'entrada', '2021-07-26 22:15:42'),
(179, 'ManuelA', 'salida', '2021-07-26 22:15:52'),
(180, 'ManuelA', 'entrada', '2021-07-26 22:39:29'),
(181, 'ManuelA', 'salida', '2021-07-26 22:39:42'),
(182, 'ManuelA', 'entrada', '2021-07-26 23:35:21'),
(183, 'ManuelA', 'salida', '2021-07-26 23:35:37'),
(184, 'ManuelA', 'entrada', '2021-07-26 23:47:17'),
(185, 'ManuelA', 'salida', '2021-07-27 21:59:45'),
(186, 'UsuarioA', 'entrada', '2021-07-27 22:00:04'),
(187, 'UsuarioA', 'salida', '2021-07-27 22:05:18'),
(188, 'Nicolee', 'entrada', '2021-07-27 22:05:36'),
(189, 'Nicolee', 'salida', '2021-07-27 22:11:57'),
(190, 'Jose', 'entrada', '2021-07-27 22:12:14'),
(191, 'Jose', 'salida', '2021-07-27 22:12:50'),
(192, 'Nicolee', 'entrada', '2021-07-27 22:13:02'),
(193, 'Nicolee', 'salida', '2021-07-27 22:13:23'),
(194, 'Jose', 'entrada', '2021-07-27 22:13:32'),
(195, 'Jose', 'salida', '2021-07-27 22:14:02'),
(196, 'Nicolee', 'entrada', '2021-07-27 22:16:01'),
(197, 'Nicolee', 'salida', '2021-07-27 22:16:17'),
(198, 'UsuarioA', 'entrada', '2021-07-27 22:16:23'),
(199, 'UsuarioA', 'salida', '2021-07-28 18:45:11'),
(200, 'UsuarioA', 'entrada', '2021-07-28 18:49:43'),
(201, 'UsuarioA', 'salida', '2021-07-28 18:53:21'),
(202, 'UsuarioA', 'entrada', '2021-07-28 19:21:08'),
(203, 'UsuarioA', 'salida', '2021-07-28 19:23:31'),
(204, 'ManuelA', 'entrada', '2021-07-28 19:24:04'),
(205, 'ManuelA', 'salida', '2021-07-28 19:24:23'),
(206, 'UsuarioA', 'entrada', '2021-07-28 19:24:35'),
(207, 'UsuarioA', 'salida', '2021-07-28 19:25:00'),
(208, 'UsuarioA', 'entrada', '2021-07-28 19:25:18'),
(209, 'UsuarioA', 'salida', '2021-07-28 19:25:26'),
(210, 'UsuarioA', 'entrada', '2021-07-28 19:26:31'),
(211, 'UsuarioA', 'salida', '2021-07-28 19:27:23'),
(212, 'UsuarioM', 'entrada', '2021-07-28 19:28:06'),
(213, 'UsuarioM', 'salida', '2021-07-28 19:30:29'),
(214, 'nicole', 'entrada', '2021-07-28 19:30:37'),
(215, 'nicole', 'salida', '2021-07-28 19:30:41'),
(216, 'UsuarioM', 'entrada', '2021-07-28 19:30:47'),
(217, 'UsuarioM', 'salida', '2021-07-28 19:31:42'),
(218, 'Jose', 'entrada', '2021-07-28 19:31:50'),
(219, 'Jose', 'salida', '2021-07-28 19:32:38'),
(220, 'UsuarioA', 'entrada', '2021-07-28 19:32:51'),
(221, 'UsuarioA', 'entrada', '2021-09-07 21:58:23'),
(222, 'UsuarioA', 'entrada', '2021-11-12 17:33:40'),
(223, 'UsuarioA', 'salida', '2021-11-12 17:34:18'),
(224, 'UsuarioM', 'entrada', '2021-11-12 17:34:27'),
(225, 'UsuarioM', 'salida', '2021-11-12 17:35:11'),
(226, 'UsuarioP', 'entrada', '2021-11-12 17:35:18'),
(227, 'UsuarioP', 'salida', '2021-11-12 17:35:34'),
(228, 'UsuarioA', 'entrada', '2021-11-12 17:35:57'),
(229, 'UsuarioA', 'salida', '2021-11-12 17:37:48'),
(230, 'UsuarioG', 'entrada', '2021-11-12 17:38:00'),
(231, 'UsuarioG', 'salida', '2021-11-12 17:41:39'),
(232, 'UsuarioM', 'entrada', '2021-11-12 17:41:49'),
(233, 'UsuarioM', 'salida', '2021-11-12 17:42:08'),
(234, 'UsuarioG', 'entrada', '2021-11-12 17:42:22'),
(235, 'UsuarioG', 'salida', '2021-11-12 17:42:55'),
(236, 'UsuarioM', 'entrada', '2021-11-12 17:43:01'),
(237, 'UsuarioM', 'salida', '2021-11-12 17:50:47'),
(238, 'UsuarioM', 'entrada', '2021-11-12 20:33:54'),
(239, 'UsuarioM', 'salida', '2021-11-12 20:36:12'),
(240, 'UsuarioP', 'entrada', '2021-11-12 20:36:19'),
(241, 'UsuarioP', 'salida', '2021-11-12 20:36:51'),
(242, 'UsuarioG', 'entrada', '2021-11-12 20:37:18'),
(243, 'UsuarioG', 'salida', '2021-11-12 20:38:31'),
(244, 'UsuarioM', 'entrada', '2021-11-12 20:41:01'),
(245, 'UsuarioM', 'salida', '2021-11-12 20:51:00'),
(246, 'UsuarioM', 'entrada', '2021-11-12 20:52:12'),
(247, 'UsuarioM', 'salida', '2021-11-12 20:54:57'),
(248, 'UsuarioA', 'entrada', '2021-11-12 21:00:12'),
(249, 'UsuarioA', 'salida', '2021-11-12 21:00:51'),
(250, 'UsuarioA', 'entrada', '2021-11-12 21:00:57'),
(251, 'UsuarioA', 'entrada', '2021-11-20 16:13:00'),
(252, 'UsuarioA', 'salida', '2021-11-20 16:24:44'),
(253, 'UsuarioM', 'entrada', '2021-11-20 16:24:53'),
(254, 'UsuarioM', 'salida', '2021-11-20 16:25:04'),
(255, 'UsuarioG', 'entrada', '2021-11-20 16:27:51'),
(256, 'UsuarioG', 'salida', '2021-11-20 16:28:41'),
(257, 'UsuarioA', 'entrada', '2021-11-20 16:29:13'),
(258, 'UsuarioA', 'salida', '2021-11-20 16:39:40'),
(259, 'UsuarioA', 'entrada', '2021-11-20 16:53:35'),
(260, 'UsuarioA', 'salida', '2021-11-20 17:09:47'),
(261, 'UsuarioA', 'entrada', '2021-11-20 17:36:41'),
(262, 'UsuarioA', 'salida', '2021-11-20 17:36:46'),
(263, 'Nicole', 'entrada', '2021-11-20 17:43:14'),
(264, 'Nicole', 'salida', '2021-11-20 17:43:28'),
(265, 'UsuarioA', 'entrada', '2021-11-20 17:43:55'),
(266, 'UsuarioA', 'salida', '2021-11-20 17:44:13'),
(267, 'UsuarioA', 'entrada', '2021-11-20 17:56:41'),
(268, 'UsuarioA', 'salida', '2021-11-20 20:35:09'),
(269, 'UsuarioM', 'entrada', '2021-11-20 20:35:30'),
(270, 'UsuarioM', 'salida', '2021-11-20 20:48:35'),
(271, 'UsuarioA', 'entrada', '2021-11-26 17:33:19'),
(272, 'UsuarioA', 'salida', '2021-11-26 20:45:18'),
(273, 'UsuarioA', 'entrada', '2021-12-01 22:37:09'),
(274, 'UsuarioA', 'salida', '2021-12-01 22:37:13'),
(275, 'UsuarioA', 'entrada', '2021-12-01 22:37:36'),
(276, 'UsuarioA', 'salida', '2021-12-01 22:37:39'),
(277, 'UsuarioA', 'entrada', '2021-12-01 22:41:12'),
(278, 'UsuarioA', 'salida', '2021-12-01 22:41:16'),
(279, 'UsuarioM', 'entrada', '2021-12-01 22:41:22'),
(280, 'UsuarioM', 'salida', '2021-12-01 22:41:25'),
(281, 'UsuarioA', 'entrada', '2021-12-01 22:44:50'),
(282, 'UsuarioA', 'salida', '2021-12-01 22:44:54'),
(283, 'UsuarioA', 'entrada', '2021-12-01 22:53:46'),
(284, 'UsuarioA', 'salida', '2021-12-01 22:54:56'),
(285, 'UsuarioM', 'entrada', '2021-12-01 22:55:17'),
(286, 'UsuarioM', 'salida', '2021-12-01 22:55:25'),
(287, 'UsuarioP', 'entrada', '2021-12-01 22:55:31'),
(288, 'UsuarioP', 'salida', '2021-12-01 22:55:40'),
(289, 'UsuarioG', 'entrada', '2021-12-01 22:55:51'),
(290, 'UsuarioG', 'salida', '2021-12-01 22:56:09'),
(291, 'Victor', 'entrada', '2021-12-01 22:57:39'),
(292, 'Victor', 'salida', '2021-12-01 22:57:49'),
(293, 'UsuarioA', 'entrada', '2021-12-02 17:51:17'),
(294, 'UsuarioA', 'salida', '2021-12-02 17:51:43'),
(295, 'UsuarioM', 'entrada', '2021-12-02 17:51:50'),
(296, 'UsuarioM', 'salida', '2021-12-02 17:51:57'),
(297, 'UsuarioP', 'entrada', '2021-12-02 17:52:04'),
(298, 'UsuarioP', 'salida', '2021-12-02 17:52:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

DROP TABLE IF EXISTS `empleados`;
CREATE TABLE IF NOT EXISTS `empleados` (
  `id_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `rut` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `apellido_paterno` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `apellido_materno` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `direccion` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `rol` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `correo` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_permiso` int(1) NOT NULL,
  `id_empresa` int(15) DEFAULT NULL,
  `habilitado` int(15) NOT NULL,
  `id_usuario` int(15) NOT NULL,
  `id_prestador` int(15) DEFAULT NULL,
  `token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  KEY `id_permiso` (`id_permiso`),
  KEY `id_empresa` (`id_empresa`),
  KEY `id_prestador` (`id_prestador`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `rut`, `nombre`, `apellido_paterno`, `apellido_materno`, `telefono`, `direccion`, `rol`, `correo`, `password`, `id_permiso`, `id_empresa`, `habilitado`, `id_usuario`, `id_prestador`, `token`) VALUES
(12, '11111111-1', 'UsuarioA', 'ApellidoA', 'apellidoB', '934047941', 'La obra 880', '1', 'usuarioAdmin@abc.cl', '$2b$12$xjTDVoi91KuauXVK/4mJfevJke8g/opV6VruUGVpiS7kZi3sHbQCq', 1, 12, 1, 12, NULL, ''),
(13, '22222222-2', 'UsuarioM', 'apellidoA', 'apellidoB', '934047921', 'La obra 880', '2', 'usuarioMinera@abc.cl', '$2b$12$dZxIqlOScd8WOOAOQNaYC.m2PJ2ZKG4LcUbeiobMiulchrvQ11lAa', 2, 13, 1, 0, NULL, ''),
(14, '33333333-3', 'UsuarioP', 'apellidoA', 'apellidoB', '932165478', 'La obra 880', '3', 'usuarioPrestador@abc.cl', '$2b$12$4TD7ZIac96stLFjuoTt3/Om0vWZODSbjwZWk1/0eWvIxdomaxaSRG', 3, 13, 1, 13, 8, ''),
(15, '44444444-4', 'UsuarioG', 'apellidoA', 'apellidoB', '934047941', 'La obra 880 El bosque', '4', 'usuarioGuardia@abc.cl', '$2b$12$xjTDVoi91KuauXVK/4mJfeTVAZ049BNBcf0kkjkxAjZ02IwUcgoWq', 4, 13, 1, 12, NULL, NULL),
(16, '16839765-8', 'Nicole', 'Ulloa', 'Matus', '982281647', 'Nuncio Laghi 5600', '2', 'nic.ulloa@gmail.com', '$2b$12$VTCWPujPsDl6ms42p1T2NeZ6eZa0wj3oDvv0iyCQFNLU8lQS7U2k2', 2, 13, 1, 12, NULL, '5d8b130c-2485-437d-93f2-c53cf4c93455'),
(17, '55555555-5', 'Victor', 'Fuentes', 'Tilleria', '978233056', 'la casa 1441', '2', 'fuentes.victor8@gmail.com', '$2b$12$D1dej02Q2LBZuol.fomf2uUg/p.4GPRkYcP0OCB8qlPwTdGJZpZCe', 2, 13, 1, 12, NULL, '8aaf0fe0-1846-40b9-aa52-4ea43d2880e9');

--
-- Disparadores `empleados`
--
DROP TRIGGER IF EXISTS `persona_auditoria_guardar`;
DELIMITER $$
CREATE TRIGGER `persona_auditoria_guardar` BEFORE INSERT ON `empleados` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'persona', 'guardar', CONCAT('INSERT INTO empresa (rut, nombre, apellido_paterno, apellido_materno, telefono, id_permiso, id_empresa, correo, password, habilitado, id_prestador, id_usuario) VALUES ('',new.rut,'','',new.nombre,'','',new.apellido_paterno,'','',new.apellido_materno,'','',new.telefono,'','',new.id_permiso,'','',IFNULL(new.id_empresa, ''),'','',new.correo,'','',new.password,'','',new.habilitado,'','',IFNULL(new.id_prestador, ''),'','',new.id_usuario,'')'), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `persona_auditoria_modificar`;
DELIMITER $$
CREATE TRIGGER `persona_auditoria_modificar` BEFORE UPDATE ON `empleados` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'persona',CASE WHEN new.habilitado = 1 THEN 'modificado' ELSE 'eliminado' END , CONCAT('UPDATE persona SET rut = '',new.rut,'', nombre = '',new.nombre,'', apellido_paterno = '',new.apellido_paterno,'', apellido_materno = '',new.apellido_materno,'', telefono = '',new.telefono,'', id_permiso = '',new.id_permiso,'', id_empresa = '',IFNULL(new.id_empresa, ''),'', correo = '',new.correo,'', password = '',new.password,'', habilitado = '',new.habilitado,'', id_prestador = '',IFNULL(new.id_prestador, ''),'', id_usuario = '',new.id_usuario,'' WHERE id = ',new.id_empresa), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

DROP TABLE IF EXISTS `empresa`;
CREATE TABLE IF NOT EXISTS `empresa` (
  `id_empresa` int(15) NOT NULL AUTO_INCREMENT,
  `rut` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` int(9) NOT NULL,
  `correo` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `habilitado` tinyint(1) NOT NULL,
  `id_usuario` int(15) NOT NULL,
  PRIMARY KEY (`id_empresa`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`id_empresa`, `rut`, `nombre`, `telefono`, `correo`, `habilitado`, `id_usuario`) VALUES
(12, '777777777-7', 'Empresa1', 934047941, 'empresa1@abc.cl', 1, 0),
(13, '88888888-8', 'Empresa2', 932165478, 'empresa2@abc.cl', 1, 0),
(15, '111111111-1', 'EMPRESA 3', 997131410, 'EMPRESA3@gmail.com', 1, 12);

--
-- Disparadores `empresa`
--
DROP TRIGGER IF EXISTS `empresa_auditoria_guardar`;
DELIMITER $$
CREATE TRIGGER `empresa_auditoria_guardar` BEFORE INSERT ON `empresa` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'empresa', 'guardar', CONCAT('INSERT INTO empresa (rut, nombre, telefono, correo) VALUES ('',new.rut,'','',new.nombre,'','',new.telefono,'','',new.correo,'')'), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `empresa_auditoria_modificar`;
DELIMITER $$
CREATE TRIGGER `empresa_auditoria_modificar` BEFORE UPDATE ON `empresa` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'empresa',CASE WHEN new.habilitado = 1 THEN 'modificado' ELSE 'eliminado' END , CONCAT('UPDATE empresa SET rut = '',new.rut,'', nombre = '',new.nombre,'', telefono = '',new.telefono,'', correo = '',new.correo,'', habilitado = '',new.habilitado,'' WHERE id = ',new.id_empresa), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

DROP TABLE IF EXISTS `permiso`;
CREATE TABLE IF NOT EXISTS `permiso` (
  `id_permiso` int(1) NOT NULL,
  `permiso` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id_permiso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`id_permiso`, `permiso`) VALUES
(1, 'Administrador'),
(2, 'Minera'),
(3, 'Proveedor'),
(4, 'Guardia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestador`
--

DROP TABLE IF EXISTS `prestador`;
CREATE TABLE IF NOT EXISTS `prestador` (
  `id_prestador` int(15) NOT NULL AUTO_INCREMENT,
  `rut` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` int(9) NOT NULL,
  `correo` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `direccion` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `Habilitado` tinyint(1) NOT NULL,
  `id_usuario` int(15) NOT NULL,
  `id_empresa` int(15) NOT NULL,
  PRIMARY KEY (`id_prestador`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `prestador`
--

INSERT INTO `prestador` (`id_prestador`, `rut`, `nombre`, `telefono`, `correo`, `direccion`, `Habilitado`, `id_usuario`, `id_empresa`) VALUES
(2, '98956262656', 'Prestador1', 932165478, 'Prestador1@Prestador1.cl', 'La obra 880', 1, 12, 15),
(3, '1089063', 'Prestador2', 912345678, 'Prestador2@Prestador2.cl', 'Estado 246', 1, 0, 0),
(8, '10161531-6', 'Prestador Mazda', 997131410, 'prestadorMazda@abc.cl', 'maipu', 1, 12, 15);

--
-- Disparadores `prestador`
--
DROP TRIGGER IF EXISTS `prestador_auditoria_guardar`;
DELIMITER $$
CREATE TRIGGER `prestador_auditoria_guardar` BEFORE INSERT ON `prestador` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'prestador', 'guardar', CONCAT('INSERT INTO prestadores (rut, nombre, telefono, correo, direccion) VALUES ('',new.rut,'','',new.nombre,'','',new.telefono,'','',new.correo,'','',new.direccion,'')'), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `prestador_auditoria_modificar`;
DELIMITER $$
CREATE TRIGGER `prestador_auditoria_modificar` BEFORE UPDATE ON `prestador` FOR EACH ROW INSERT INTO auditoria (fecha, tabla, evento, consulta, usuario) VALUES (CURRENT_DATE, 'prestador',CASE WHEN new.habilitado = 1 THEN 'modificado' ELSE 'eliminado' END , CONCAT('UPDATE prestadores SET rut = '',new.rut,'', nombre = '',new.nombre,'', telefono = '',new.telefono,'', correo = '',new.correo,'' direccion = '',new.direccion,''habilitado = '',new.habilitado,''  WHERE id = ',new.id_prestador), (SELECT nombre FROM empleados WHERE id_empleado = new.id_usuario))
$$
DELIMITER ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `activos`
--
ALTER TABLE `activos`
  ADD CONSTRAINT `activos_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`),
  ADD CONSTRAINT `activos_ibfk_2` FOREIGN KEY (`id_prestador`) REFERENCES `prestador` (`id_prestador`);

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_permiso`) REFERENCES `permiso` (`id_permiso`),
  ADD CONSTRAINT `empleados_ibfk_2` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`),
  ADD CONSTRAINT `empleados_ibfk_3` FOREIGN KEY (`id_prestador`) REFERENCES `prestador` (`id_prestador`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: finanzas_cliente
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aportadores`
--

DROP TABLE IF EXISTS `aportadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aportadores` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `fecha_registro` date DEFAULT (curdate()),
  `aporte_mensual` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aportes`
--

DROP TABLE IF EXISTS `aportes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aportes` (
  `id_aporte` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_ingreso` date DEFAULT (curdate()),
  PRIMARY KEY (`id_aporte`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `aportes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `aportadores` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `configuracion_aportes`
--

DROP TABLE IF EXISTS `configuracion_aportes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_aportes` (
  `id_config` int NOT NULL AUTO_INCREMENT,
  `limite_inferior` decimal(10,2) NOT NULL,
  `limite_superior` decimal(10,2) NOT NULL,
  `fecha_ultima_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_config`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingresos`
--

DROP TABLE IF EXISTS `ingresos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresos` (
  `id_ingreso` int NOT NULL AUTO_INCREMENT,
  `tipo_ingreso` enum('multiple','vehicular') NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_ingreso` date DEFAULT (curdate()),
  PRIMARY KEY (`id_ingreso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingresos_totales`
--

DROP TABLE IF EXISTS `ingresos_totales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingresos_totales` (
  `id_ingreso_total` int NOT NULL AUTO_INCREMENT,
  `monto_total` decimal(10,2) NOT NULL,
  `fecha_calculo` date DEFAULT (curdate()),
  PRIMARY KEY (`id_ingreso_total`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `intereses_generados`
--

DROP TABLE IF EXISTS `intereses_generados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intereses_generados` (
  `id_interes` int NOT NULL AUTO_INCREMENT,
  `total_interes_mes` decimal(10,2) NOT NULL,
  `fecha_calculo` date DEFAULT (curdate()),
  PRIMARY KEY (`id_interes`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prestamos`
--

DROP TABLE IF EXISTS `prestamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prestamos` (
  `id_prestamo` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `monto_prestado` decimal(10,2) NOT NULL,
  `interes_mensual` decimal(5,2) DEFAULT '2.00',
  `fecha_inicio` date DEFAULT (curdate()),
  `fecha_final` date DEFAULT NULL,
  `estado` enum('activo','pagado','mora') DEFAULT 'activo',
  PRIMARY KEY (`id_prestamo`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `prestamos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `aportadores` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id_trabajador` int NOT NULL AUTO_INCREMENT,
  `identification` int DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `fullname` varchar(255) DEFAULT '',
  PRIMARY KEY (`id_trabajador`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vista_ingresos_totales`
--

DROP TABLE IF EXISTS `vista_ingresos_totales`;
/*!50001 DROP VIEW IF EXISTS `vista_ingresos_totales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_ingresos_totales` AS SELECT 
 1 AS `total_aportes`,
 1 AS `total_multiples`,
 1 AS `total_vehiculares`,
 1 AS `total_general`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_prestamos_totales`
--

DROP TABLE IF EXISTS `vista_prestamos_totales`;
/*!50001 DROP VIEW IF EXISTS `vista_prestamos_totales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_prestamos_totales` AS SELECT 
 1 AS `id_prestamo`,
 1 AS `id_usuario`,
 1 AS `monto_prestado`,
 1 AS `interes_mensual`,
 1 AS `fecha_inicio`,
 1 AS `fecha_final`,
 1 AS `estado`,
 1 AS `monto_total_pagar`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_ingresos_totales`
--

/*!50001 DROP VIEW IF EXISTS `vista_ingresos_totales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_ingresos_totales` AS select ifnull(sum(`a`.`monto`),0) AS `total_aportes`,ifnull((select sum(`i`.`monto`) from `ingresos` `i` where (`i`.`tipo_ingreso` = 'multiple')),0) AS `total_multiples`,ifnull((select sum(`i`.`monto`) from `ingresos` `i` where (`i`.`tipo_ingreso` = 'vehicular')),0) AS `total_vehiculares`,((ifnull(sum(`a`.`monto`),0) + ifnull((select sum(`i`.`monto`) from `ingresos` `i` where (`i`.`tipo_ingreso` = 'multiple')),0)) + ifnull((select sum(`i`.`monto`) from `ingresos` `i` where (`i`.`tipo_ingreso` = 'vehicular')),0)) AS `total_general` from `aportes` `a` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_prestamos_totales`
--

/*!50001 DROP VIEW IF EXISTS `vista_prestamos_totales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_prestamos_totales` AS select `p`.`id_prestamo` AS `id_prestamo`,`p`.`id_usuario` AS `id_usuario`,`p`.`monto_prestado` AS `monto_prestado`,`p`.`interes_mensual` AS `interes_mensual`,`p`.`fecha_inicio` AS `fecha_inicio`,`p`.`fecha_final` AS `fecha_final`,`p`.`estado` AS `estado`,(`p`.`monto_prestado` + (`p`.`monto_prestado` * (`p`.`interes_mensual` / 100))) AS `monto_total_pagar` from `prestamos` `p` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-16 14:37:19

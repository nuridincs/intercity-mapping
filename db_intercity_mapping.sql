-- MySQL dump 10.13  Distrib 5.7.43, for osx10.17 (x86_64)
--
-- Host: localhost    Database: db_intercity_mapping
-- ------------------------------------------------------
-- Server version	5.7.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `intercity_mappings`
--

DROP TABLE IF EXISTS `intercity_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `intercity_mappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `warehouse_area` varchar(100) NOT NULL,
  `inspection_area` varchar(100) NOT NULL,
  `is_intercity` tinyint(1) NOT NULL,
  `result_logic` enum('INTERCITY','NOT INTERCITY') NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_mapping` (`warehouse_area`,`inspection_area`),
  KEY `idx_warehouse_area` (`warehouse_area`),
  KEY `idx_inspection_area` (`inspection_area`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intercity_mappings`
--

LOCK TABLES `intercity_mappings` WRITE;
/*!40000 ALTER TABLE `intercity_mappings` DISABLE KEYS */;
INSERT INTO `intercity_mappings` VALUES (1,'Bekasi','Jabodetabek & Cikarang',0,'NOT INTERCITY','Same metropolitan area','2025-06-25 06:11:16','2025-06-25 06:11:16'),(2,'Tangerang','Jabodetabek',0,'NOT INTERCITY','Same metropolitan area','2025-06-25 06:11:16','2025-06-25 06:11:16'),(3,'Bogor','Jabodetabek',0,'NOT INTERCITY','Same metropolitan area','2025-06-25 06:11:16','2025-06-25 06:11:16'),(4,'Medan','WH Medan Pusat Area',0,'NOT INTERCITY','Same city area','2025-06-25 06:11:16','2025-06-25 06:11:16'),(5,'Medan','WH Medan Pakam Area',0,'NOT INTERCITY','Same city area','2025-06-25 06:11:16','2025-06-25 06:11:16'),(6,'Lampung Metro','WH Area (Lampung Metro & Pringsewu)',0,'NOT INTERCITY','Same region','2025-06-25 06:11:16','2025-06-25 06:11:16'),(7,'Lampung Antasari (Kota)','WH Area (Lampung Antasari & Pringsewu)',0,'NOT INTERCITY','Same region','2025-06-25 06:11:16','2025-06-25 06:11:16'),(8,'Lampung Barat','WH Area (Lampung Metro & Lampung Antasari)',0,'NOT INTERCITY','Same region','2025-06-25 06:11:16','2025-06-25 06:11:16'),(9,'Yogyakarta','WH Area (Magelang)',0,'NOT INTERCITY','Same province - Central Java','2025-06-25 06:11:16','2025-06-25 06:11:16'),(10,'Magelang','WH Area (Yogyakarta)',0,'NOT INTERCITY','Same province - Central Java','2025-06-25 06:11:16','2025-06-25 06:11:16'),(11,'Kudus','WH Area (Semarang)',0,'NOT INTERCITY','Same province - Central Java','2025-06-25 06:11:16','2025-06-25 06:11:16'),(12,'Semarang','WH Area (Kudus)',0,'NOT INTERCITY','Same province - Central Java','2025-06-25 06:11:16','2025-06-25 06:11:16'),(13,'Purwokerto','WH Area (Yogyakarta)',0,'NOT INTERCITY','Same province - Central Java','2025-06-25 06:11:16','2025-06-25 06:11:16'),(14,'Karawang','WH Area (Cikarang)',0,'NOT INTERCITY','Same province - West Java','2025-06-25 06:11:16','2025-06-25 06:11:16'),(15,'Magelang','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16'),(16,'Yogyakarta','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16'),(17,'Medan','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16'),(18,'Lampung Metro','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16'),(19,'Palembang','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16'),(20,'Bengkulu','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16'),(21,'Denpasar','Jabodetabek',1,'INTERCITY','Different provinces','2025-06-25 06:11:16','2025-06-25 06:11:16');
/*!40000 ALTER TABLE `intercity_mappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouses`
--

DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `warehouse_name` varchar(100) NOT NULL,
  `area_mapping` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `open_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_name` (`warehouse_name`),
  KEY `idx_area_mapping` (`area_mapping`),
  KEY `idx_province` (`province`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
INSERT INTO `warehouses` VALUES (1,'Cikarang','Bekasi','Jabodetabek','Active','2024-09-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(2,'Jatibening','Bekasi','Jabodetabek','Active','2023-02-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(3,'Kranggan','Bekasi','Jabodetabek','Active','2023-03-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(4,'Balaraja Barat','Tangerang','Jabodetabek','Active','2023-03-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(5,'Cibodas','Tangerang','Jabodetabek','Active','2023-03-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(6,'Pondok Cabe','Tangerang','Jabodetabek','Active','2023-03-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(7,'Banten','Banten','Banten','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(8,'Puri Kembangan','Tangerang','Jabodetabek','Active','2023-03-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(9,'Tanah Sereal','Bogor','Jabodetabek','Active','2023-02-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(10,'Sukabumi','Sukabumi','Jawa Barat','Active','2024-09-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(11,'Bengkulu','Bengkulu','Bengkulu','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(12,'Pangkalpinang','Pangkal Pinang','Kepulauan Bangka Belitung','Active','2024-11-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(13,'Batam','Batam','Kepulauan Riau','Active','2024-02-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(14,'Pekanbaru','Pekanbaru','Riau','Active','2023-12-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(15,'Lubuklinggau','Lubuklinggau','Sumatera Selatan','Active','2023-12-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(16,'Palembang','Palembang','Sumatera Selatan','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(17,'Medan Palam','Medan','Sumatera Utara','Active','2024-08-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(18,'Medan Pusat','Medan','Sumatera Utara','Active','2023-07-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(19,'Duri','Duri','Riau','Active','2024-11-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(20,'Bukittinggi','Bukittinggi','Sumatera Barat','Active','2024-11-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(21,'Padang','Padang','Sumatera Barat','Active','2024-10-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(22,'Jambi','Jambi','Jambi','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(23,'Muara Bungo','Muara Bungo','Jambi','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(24,'Lampung Antasari','Lampung Antasari (Kota)','Lampung','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(25,'Lampung Metro','Lampung Metro','Lampung','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(26,'Pringsewu','Lampung Barat','Lampung','Active','2024-01-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(27,'Yogyakarta','Yogyakarta','Daerah Istimewa Yogyakarta','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(28,'Cilacap','Cilacap','Jawa Tengah','Active','2024-08-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(29,'Kebumen','Kebumen','Jawa Tengah','Active','2024-08-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(30,'Kudus','Kudus','Jawa Tengah','Active','2024-01-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(31,'Magelang','Magelang','Jawa Tengah','Active','2024-10-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(32,'Purwokerto','Purwokerto','Jawa Tengah','Active','2023-11-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(33,'Semarang Indraprasta','Semarang','Jawa Tengah','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(34,'Tegal','Tegal','Jawa Tengah','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(35,'Bandung Soekarno','Bandung','Jawa Barat','Active','2023-02-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(36,'Cirebon Kota','Cirebon','Jawa Barat','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(37,'Garut','Garut','Jawa Barat','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(38,'Karawang','Karawang','Jawa Barat','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(39,'Denpasar Gatot Subroto','Denpasar','Bali','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(40,'Mataram','Mataram','Nusa Tenggara Barat','Active','2023-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(41,'Pontianak','Pontianak','Kalimantan Barat','Active','2024-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(42,'Banjarmasin','Banjarmasin','Kalimantan Selatan','Active','2024-02-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(43,'Palangkaraya','Palangkaraya','Kalimantan Tengah','Active','2024-06-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(44,'Balikpapan','Balikpapan','Kalimantan Timur','Active','2024-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02'),(45,'Samarinda','Samarinda','Kalimantan Timur','Active','2024-05-01','2025-06-25 06:11:02','2025-06-25 06:11:02');
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-01  9:47:54

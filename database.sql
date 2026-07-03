CREATE DATABASE  IF NOT EXISTS `salon_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `salon_db`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: salon_db
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slot_id` int DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `payment_method` varchar(20) NOT NULL DEFAULT 'UPI',
  `payment_status` varchar(20) NOT NULL DEFAULT 'Paid',
  `transaction_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_booking_slot` (`slot_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`slot_id`) REFERENCES `slots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,2,'vj','vj@gmail.com','2026-03-02 09:56:52',500.00,'Cash','Paid',''),(3,28,'VIJAY V','2301107117@ptuniv.edu.in','2026-03-06 14:42:49',500.00,'UPI','Paid',''),(4,25,'VIJAY V','2301107117@ptuniv.edu.in','2026-03-06 14:49:00',500.00,'UPI','Paid','24849385462'),(5,63,'VIJAY V','2301107117@ptuniv.edu.in','2026-03-16 13:36:30',500.00,'UPI','Paid','24849385462'),(6,61,'VIJAY','2301107117@ptuniv.edu.in','2026-03-18 09:43:51',500.00,'UPI','Paid','24849385462'),(7,88,'Viknesh','2301107117@ptuniv.edu.in','2026-04-01 10:31:35',500.00,'UPI','Paid','742942324dc');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot`
--

DROP TABLE IF EXISTS `chatbot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `keywords` varchar(255) DEFAULT NULL,
  `answer` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot`
--

LOCK TABLES `chatbot` WRITE;
/*!40000 ALTER TABLE `chatbot` DISABLE KEYS */;
INSERT INTO `chatbot` VALUES (1,'working hours,time,open,close','We are open from 9 AM to 8 PM.'),(2,'haircut,price,cost,rate','Haircut price starts from ₹200.'),(3,'booking,appointment,book','You can book your appointment from our booking page.'),(4,'location,address,where','We are located in Muthialpet.'),(5,'contact,phone,number','You can contact us at 9876543210.');
/*!40000 ALTER TABLE `chatbot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `price` int NOT NULL,
  `image` varchar(200) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Hair Shampoo',200,'shampoo.jpg',1),(2,'Hair Conditioner',180,'conditioner.jpg',1),(3,'Face Cream',300,'facecream.jpg',1),(4,'Hair Oil',220,'hairoil.jpg',1),(5,'Hair Serum',350,'serum.jpg',1),(6,'Hair Mask',400,'hairmask.jpg',1),(7,'Face Serum',550,'faceserum.jpg',1),(8,'Body Lotion',280,'bodylotion.jpg',1),(9,'Facial Kit',800,'facialkit.jpg',1),(10,'Hair Treatment Cream',650,'hairtreatment.jpg',1),(11,'Activated Charcoal Beard Detox Cleanser',620,'beardcleanser.jpg',1),(12,'Handcrafted Premium Wooden Beard Comb',350,'woodencomb.jpg',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slots`
--

DROP TABLE IF EXISTS `slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) DEFAULT NULL,
  `slot_date` date DEFAULT NULL,
  `slot_time` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Available',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_slot_date_time` (`slot_date`,`slot_time`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slots`
--

LOCK TABLES `slots` WRITE;
/*!40000 ALTER TABLE `slots` DISABLE KEYS */;
INSERT INTO `slots` VALUES (1,'Hair Cut','2026-03-19','12.10pm','Available'),(2,'Salon Slot','2026-03-03','10:00 AM','Booked'),(3,'Salon Slot','2026-03-03','11:00 AM','Available'),(4,'Salon Slot','2026-03-03','12:00 PM','Available'),(6,'Salon Slot','2026-03-03','02:00 PM','Available'),(7,'Salon Slot','2026-03-03','03:00 PM','Available'),(8,'Salon Slot','2026-03-03','04:00 PM','Available'),(9,'Salon Slot','2026-03-03','05:00 PM','Available'),(10,'Salon Slot','2026-03-03','06:00 PM','Available'),(11,'Salon Slot','2026-03-03','07:00 PM','Available'),(12,'Salon Slot','2026-03-03','08:00 PM','Available'),(13,'Salon Slot','2026-03-03','09:00 PM','Available'),(14,'Salon Slot','2026-03-03','10:00 PM','Available'),(15,'Salon Slot','2026-03-10','10:00 AM','Available'),(16,'Salon Slot','2026-03-10','11:00 AM','Available'),(17,'Salon Slot','2026-03-10','12:00 PM','Available'),(18,'Salon Slot','2026-03-10','01:00 PM','Available'),(19,'Salon Slot','2026-03-10','02:00 PM','Available'),(20,'Salon Slot','2026-03-10','03:00 PM','Available'),(21,'Salon Slot','2026-03-10','04:00 PM','Available'),(22,'Salon Slot','2026-03-10','05:00 PM','Available'),(23,'Salon Slot','2026-03-10','06:00 PM','Available'),(24,'Salon Slot','2026-03-10','07:00 PM','Available'),(25,'Salon Slot','2026-03-10','08:00 PM','Booked'),(26,'Salon Slot','2026-03-10','09:00 PM','Available'),(27,'Salon Slot','2026-03-10','10:00 PM','Available'),(28,'Salon Slot','2026-03-12','10:00 AM','Booked'),(29,'Salon Slot','2026-03-12','11:00 AM','Available'),(30,'Salon Slot','2026-03-12','12:00 PM','Available'),(31,'Salon Slot','2026-03-12','01:00 PM','Available'),(32,'Salon Slot','2026-03-12','02:00 PM','Available'),(33,'Salon Slot','2026-03-12','03:00 PM','Available'),(34,'Salon Slot','2026-03-12','04:00 PM','Available'),(35,'Salon Slot','2026-03-12','05:00 PM','Booked'),(36,'Salon Slot','2026-03-12','06:00 PM','Available'),(37,'Salon Slot','2026-03-12','07:00 PM','Available'),(38,'Salon Slot','2026-03-12','08:00 PM','Available'),(39,'Salon Slot','2026-03-12','09:00 PM','Available'),(40,'Salon Slot','2026-03-12','10:00 PM','Available'),(41,'Salon Slot','2026-03-13','10:00 AM','Booked'),(42,'Salon Slot','2026-03-13','11:00 AM','Available'),(43,'Salon Slot','2026-03-13','12:00 PM','Available'),(44,'Salon Slot','2026-03-13','01:00 PM','Available'),(45,'Salon Slot','2026-03-13','02:00 PM','Available'),(46,'Salon Slot','2026-03-13','03:00 PM','Available'),(47,'Salon Slot','2026-03-13','04:00 PM','Available'),(48,'Salon Slot','2026-03-13','05:00 PM','Available'),(49,'Salon Slot','2026-03-13','06:00 PM','Available'),(50,'Salon Slot','2026-03-13','07:00 PM','Available'),(51,'Salon Slot','2026-03-13','08:00 PM','Available'),(52,'Salon Slot','2026-03-13','09:00 PM','Available'),(53,'Salon Slot','2026-03-13','10:00 PM','Available'),(54,'Salon Slot','2026-03-16','10:00 AM','Available'),(55,'Salon Slot','2026-03-16','11:00 AM','Available'),(56,'Salon Slot','2026-03-16','12:00 PM','Available'),(57,'Salon Slot','2026-03-16','01:00 PM','Available'),(58,'Salon Slot','2026-03-16','02:00 PM','Available'),(59,'Salon Slot','2026-03-16','03:00 PM','Available'),(60,'Salon Slot','2026-03-16','04:00 PM','Available'),(61,'Salon Slot','2026-03-16','05:00 PM','Booked'),(62,'Salon Slot','2026-03-16','06:00 PM','Available'),(63,'Salon Slot','2026-03-16','07:00 PM','Booked'),(64,'Salon Slot','2026-03-16','08:00 PM','Available'),(65,'Salon Slot','2026-03-16','09:00 PM','Available'),(66,'Salon Slot','2026-03-16','10:00 PM','Available'),(67,'Salon Slot','2026-03-24','10:00 AM','Available'),(68,'Salon Slot','2026-03-24','11:00 AM','Available'),(69,'Salon Slot','2026-03-24','12:00 PM','Available'),(70,'Salon Slot','2026-03-24','01:00 PM','Available'),(71,'Salon Slot','2026-03-24','02:00 PM','Available'),(72,'Salon Slot','2026-03-24','03:00 PM','Available'),(73,'Salon Slot','2026-03-24','04:00 PM','Available'),(74,'Salon Slot','2026-03-24','05:00 PM','Available'),(75,'Salon Slot','2026-03-24','06:00 PM','Available'),(76,'Salon Slot','2026-03-24','07:00 PM','Available'),(77,'Salon Slot','2026-03-24','08:00 PM','Available'),(78,'Salon Slot','2026-03-24','09:00 PM','Available'),(79,'Salon Slot','2026-03-24','10:00 PM','Available'),(80,'Salon Slot','2026-04-01','10:00 AM','Available'),(81,'Salon Slot','2026-04-01','11:00 AM','Available'),(82,'Salon Slot','2026-04-01','12:00 PM','Available'),(83,'Salon Slot','2026-04-01','01:00 PM','Available'),(84,'Salon Slot','2026-04-01','02:00 PM','Available'),(85,'Salon Slot','2026-04-01','03:00 PM','Available'),(86,'Salon Slot','2026-04-01','04:00 PM','Available'),(87,'Salon Slot','2026-04-01','05:00 PM','Available'),(88,'Salon Slot','2026-04-01','06:00 PM','Booked'),(89,'Salon Slot','2026-04-01','07:00 PM','Available'),(90,'Salon Slot','2026-04-01','08:00 PM','Available'),(91,'Salon Slot','2026-04-01','09:00 PM','Available'),(92,'Salon Slot','2026-04-01','10:00 PM','Available'),(93,'Salon Slot','2026-04-02','10:00 AM','Available'),(94,'Salon Slot','2026-04-02','11:00 AM','Available'),(95,'Salon Slot','2026-04-02','12:00 PM','Available'),(96,'Salon Slot','2026-04-02','01:00 PM','Available'),(97,'Salon Slot','2026-04-02','02:00 PM','Available'),(98,'Salon Slot','2026-04-02','03:00 PM','Available'),(99,'Salon Slot','2026-04-02','04:00 PM','Available'),(100,'Salon Slot','2026-04-02','05:00 PM','Available'),(101,'Salon Slot','2026-04-02','06:00 PM','Available'),(102,'Salon Slot','2026-04-02','07:00 PM','Available'),(103,'Salon Slot','2026-04-02','08:00 PM','Available'),(104,'Salon Slot','2026-04-02','09:00 PM','Available'),(105,'Salon Slot','2026-04-02','10:00 PM','Available');
/*!40000 ALTER TABLE `slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `experience` int DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `salary` double DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (5,'vijay','manager',1,'812347237',70000,'Active'),(6,'Vasanth','HAIR STYLIST',3,'9003530942',50000,'Active');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_cookies`
--

DROP TABLE IF EXISTS `user_cookies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_cookies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `cookie_name` varchar(100) DEFAULT NULL,
  `cookie_value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_cookies_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_cookies`
--

LOCK TABLES `user_cookies` WRITE;
/*!40000 ALTER TABLE `user_cookies` DISABLE KEYS */;
INSERT INTO `user_cookies` VALUES (1,11,'userEmail','vijay@gmail.com','2026-02-18 10:11:29'),(2,11,'userEmail','vijay@gmail.com','2026-02-18 10:19:43'),(3,11,'userEmail','vijay@gmail.com','2026-02-18 10:29:32'),(4,10,'userEmail','vignesh@gmail.com','2026-02-18 10:32:24'),(5,11,'userEmail','vijay@gmail.com','2026-02-18 10:33:04'),(6,11,'userEmail','vijay@gmail.com','2026-02-18 10:33:41'),(7,11,'userEmail','vijay@gmail.com','2026-02-25 10:13:06'),(8,11,'userEmail','vijay@gmail.com','2026-03-02 08:50:07'),(9,11,'userEmail','vijay@gmail.com','2026-03-02 09:13:24'),(10,11,'userEmail','vijay@gmail.com','2026-03-02 09:31:41'),(11,10,'userEmail','vignesh@gmail.com','2026-03-02 09:44:24'),(12,11,'userEmail','vijay@gmail.com','2026-03-02 09:53:07'),(13,11,'userEmail','vijay@gmail.com','2026-03-02 10:00:05'),(14,10,'userEmail','vignesh@gmail.com','2026-03-02 10:05:20'),(15,11,'userEmail','vijay@gmail.com','2026-03-02 11:57:40'),(16,11,'userEmail','vijay@gmail.com','2026-03-02 12:07:37'),(17,10,'userEmail','vignesh@gmail.com','2026-03-02 12:13:49'),(18,11,'userEmail','vijay@gmail.com','2026-03-02 15:31:49'),(19,11,'userEmail','vijay@gmail.com','2026-03-03 11:36:03'),(20,10,'userEmail','vignesh@gmail.com','2026-03-03 11:41:53'),(21,11,'userEmail','vijay@gmail.com','2026-03-03 11:42:40'),(22,11,'userEmail','vijay@gmail.com','2026-03-03 11:50:01'),(23,10,'userEmail','vignesh@gmail.com','2026-03-03 11:51:00'),(24,11,'userEmail','vijay@gmail.com','2026-03-03 11:53:45'),(25,11,'userEmail','vijay@gmail.com','2026-03-03 11:58:43'),(26,10,'userEmail','vignesh@gmail.com','2026-03-03 12:10:55'),(27,10,'userEmail','vignesh@gmail.com','2026-03-03 12:14:00'),(28,10,'userEmail','vignesh@gmail.com','2026-03-03 12:23:17'),(29,10,'userEmail','vignesh@gmail.com','2026-03-03 12:56:15'),(30,10,'userEmail','vignesh@gmail.com','2026-03-03 13:43:04'),(31,10,'userEmail','vignesh@gmail.com','2026-03-03 13:54:17'),(32,11,'userEmail','vijay@gmail.com','2026-03-03 13:56:20'),(33,10,'userEmail','vignesh@gmail.com','2026-03-03 13:57:15'),(34,10,'userEmail','vignesh@gmail.com','2026-03-03 15:39:42'),(35,10,'userEmail','vignesh@gmail.com','2026-03-03 16:24:01'),(36,10,'userEmail','vignesh@gmail.com','2026-03-03 16:35:38'),(37,11,'userEmail','vijay@gmail.com','2026-03-04 04:12:55'),(38,11,'userEmail','vijay@gmail.com','2026-03-04 04:14:16'),(39,10,'userEmail','vignesh@gmail.com','2026-03-04 04:14:28'),(40,10,'userEmail','vignesh@gmail.com','2026-03-04 04:17:55'),(41,10,'userEmail','vignesh@gmail.com','2026-03-04 04:28:09'),(42,10,'userEmail','vignesh@gmail.com','2026-03-04 09:26:51'),(43,10,'userEmail','vignesh@gmail.com','2026-03-04 09:42:18'),(44,10,'userEmail','vignesh@gmail.com','2026-03-04 09:45:05'),(45,11,'userEmail','vijay@gmail.com','2026-03-04 10:01:21'),(46,10,'userEmail','vignesh@gmail.com','2026-03-04 10:03:02'),(47,10,'userEmail','vignesh@gmail.com','2026-03-04 10:12:45'),(48,11,'userEmail','vijay@gmail.com','2026-03-05 14:38:29'),(49,10,'userEmail','vignesh@gmail.com','2026-03-05 15:18:35'),(50,10,'userEmail','vignesh@gmail.com','2026-03-05 15:32:27'),(51,10,'userEmail','vignesh@gmail.com','2026-03-05 15:38:25'),(52,10,'userEmail','vignesh@gmail.com','2026-03-05 15:46:58'),(53,10,'userEmail','vignesh@gmail.com','2026-03-06 12:43:12'),(54,10,'userEmail','vignesh@gmail.com','2026-03-06 13:11:37'),(55,10,'userEmail','vignesh@gmail.com','2026-03-06 13:15:04'),(56,10,'userEmail','vignesh@gmail.com','2026-03-06 13:20:11'),(57,10,'userEmail','vignesh@gmail.com','2026-03-06 13:24:04'),(58,10,'userEmail','vignesh@gmail.com','2026-03-06 13:52:37'),(59,11,'userEmail','vijay@gmail.com','2026-03-06 13:57:09'),(60,10,'userEmail','vignesh@gmail.com','2026-03-06 14:01:54'),(61,10,'userEmail','vignesh@gmail.com','2026-03-06 14:06:52'),(62,10,'userEmail','vignesh@gmail.com','2026-03-06 14:21:40'),(63,10,'userEmail','vignesh@gmail.com','2026-03-06 14:31:24'),(64,11,'userEmail','vijay@gmail.com','2026-03-06 15:03:58'),(65,11,'userEmail','vijay@gmail.com','2026-03-06 15:28:23'),(66,11,'userEmail','vijay@gmail.com','2026-03-06 16:04:05'),(67,11,'userEmail','vijay@gmail.com','2026-03-08 13:57:50'),(68,10,'userEmail','vignesh@gmail.com','2026-03-08 14:01:54'),(69,11,'userEmail','vijay@gmail.com','2026-03-10 17:17:38'),(70,11,'userEmail','vijay@gmail.com','2026-03-12 16:50:20'),(71,11,'userEmail','vijay@gmail.com','2026-03-16 12:01:59'),(72,11,'userEmail','vijay@gmail.com','2026-03-16 12:08:53'),(73,10,'userEmail','vignesh@gmail.com','2026-03-16 12:16:02'),(74,11,'userEmail','vijay@gmail.com','2026-03-16 12:16:52'),(75,11,'userEmail','vijay@gmail.com','2026-03-16 12:28:40'),(76,10,'userEmail','vignesh@gmail.com','2026-03-16 13:23:08'),(77,11,'userEmail','vijay@gmail.com','2026-03-16 13:23:40'),(78,11,'userEmail','vijay@gmail.com','2026-03-16 13:29:49'),(79,10,'userEmail','vignesh@gmail.com','2026-03-16 13:30:08'),(80,11,'userEmail','vijay@gmail.com','2026-03-16 13:32:14'),(81,10,'userEmail','vignesh@gmail.com','2026-03-16 13:36:04'),(82,11,'userEmail','vijay@gmail.com','2026-03-16 13:37:13'),(83,11,'userEmail','vijay@gmail.com','2026-03-16 13:46:18'),(84,10,'userEmail','vignesh@gmail.com','2026-03-16 14:10:21'),(85,11,'userEmail','vijay@gmail.com','2026-03-16 14:33:46'),(86,12,'userEmail','varshini@gmail.com','2026-03-16 14:34:55'),(87,11,'userEmail','vijay@gmail.com','2026-03-17 11:28:55'),(88,12,'userEmail','varshini@gmail.com','2026-03-17 11:30:58'),(89,12,'userEmail','varshini@gmail.com','2026-03-17 17:14:08'),(90,12,'userEmail','varshini@gmail.com','2026-03-18 02:25:52'),(91,11,'userEmail','vijay@gmail.com','2026-03-18 02:29:40'),(92,11,'userEmail','vijay@gmail.com','2026-03-18 09:11:23'),(93,10,'userEmail','vignesh@gmail.com','2026-03-18 09:12:16'),(94,12,'userEmail','varshini@gmail.com','2026-03-18 09:30:19'),(95,10,'userEmail','vignesh@gmail.com','2026-03-18 09:42:08'),(96,11,'userEmail','vijay@gmail.com','2026-03-18 09:44:13'),(97,12,'userEmail','varshini@gmail.com','2026-03-18 09:54:33'),(98,11,'userEmail','vijay@gmail.com','2026-03-18 10:10:21'),(99,10,'userEmail','vignesh@gmail.com','2026-03-18 10:30:38'),(100,12,'userEmail','varshini@gmail.com','2026-03-19 11:03:50'),(101,11,'userEmail','vijay@gmail.com','2026-03-19 11:18:59'),(102,10,'userEmail','vignesh@gmail.com','2026-03-22 12:57:10'),(103,10,'userEmail','vignesh@gmail.com','2026-03-23 12:10:08'),(104,11,'userEmail','vijay@gmail.com','2026-03-23 12:12:21'),(105,11,'userEmail','vijay@gmail.com','2026-03-24 02:10:09'),(106,12,'userEmail','varshini@gmail.com','2026-03-24 05:59:33'),(107,11,'userEmail','vijay@gmail.com','2026-03-26 15:19:21'),(108,12,'userEmail','varshini@gmail.com','2026-03-26 15:34:25'),(109,11,'userEmail','vijay@gmail.com','2026-03-26 16:09:38'),(110,11,'userEmail','vijay@gmail.com','2026-03-26 16:53:34'),(111,11,'userEmail','vijay@gmail.com','2026-03-26 17:27:07'),(112,12,'userEmail','varshini@gmail.com','2026-03-26 17:37:09'),(113,12,'userEmail','varshini@gmail.com','2026-03-29 17:46:48'),(114,11,'userEmail','vijay@gmail.com','2026-03-31 15:14:47'),(115,10,'userEmail','vignesh@gmail.com','2026-03-31 15:15:51'),(116,10,'userEmail','vignesh@gmail.com','2026-04-01 09:36:42'),(117,11,'userEmail','vijay@gmail.com','2026-04-01 09:38:30'),(118,11,'userEmail','vijay@gmail.com','2026-04-01 09:45:33'),(119,10,'userEmail','vignesh@gmail.com','2026-04-01 10:29:11'),(120,11,'userEmail','vijay@gmail.com','2026-04-01 10:31:59'),(121,12,'userEmail','varshini@gmail.com','2026-04-03 04:31:06'),(122,11,'userEmail','vijay@gmail.com','2026-04-03 04:32:52'),(123,11,'userEmail','vijay@gmail.com','2026-04-03 04:38:46');
/*!40000 ALTER TABLE `user_cookies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `login_time` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
INSERT INTO `user_sessions` VALUES (1,11,'3CCACC0A68A4A065B244D60ED09A1874','2026-02-18 15:41:29',NULL,'ACTIVE'),(2,11,'BD8C768353A850C4DEE226838B59D48E','2026-02-18 15:49:43',NULL,'ACTIVE'),(3,11,'A2373B5B40E5D3B9BBE6A8ABA66B846C','2026-02-18 15:59:32','2026-02-18 16:03:31','INACTIVE'),(4,10,'A2373B5B40E5D3B9BBE6A8ABA66B846C','2026-02-18 16:02:24','2026-02-18 16:03:31','INACTIVE'),(5,11,'A2373B5B40E5D3B9BBE6A8ABA66B846C','2026-02-18 16:03:04','2026-02-18 16:03:31','INACTIVE'),(6,11,'A2373B5B40E5D3B9BBE6A8ABA66B846C','2026-02-18 16:03:41',NULL,'ACTIVE'),(7,11,'F2779B861BF01B6BFDBD55001DB61BE3','2026-02-25 15:43:06',NULL,'ACTIVE'),(8,11,'FB95B59AD691015B4EE2D1B88CDC8D03','2026-03-02 14:20:07','2026-03-02 14:26:14','INACTIVE'),(9,11,'E1E5BE74BAA1EB6D6BABD556E1F1F58F','2026-03-02 14:43:24',NULL,'ACTIVE'),(10,11,'2CBD63CEC099D48727C382B85E2D3F3E','2026-03-02 15:01:41','2026-03-02 15:35:06','INACTIVE'),(11,10,'2CBD63CEC099D48727C382B85E2D3F3E','2026-03-02 15:14:24','2026-03-02 15:35:06','INACTIVE'),(12,11,'2CBD63CEC099D48727C382B85E2D3F3E','2026-03-02 15:23:07','2026-03-02 15:35:06','INACTIVE'),(13,11,'2CBD63CEC099D48727C382B85E2D3F3E','2026-03-02 15:30:05','2026-03-02 15:35:06','INACTIVE'),(14,10,'2CBD63CEC099D48727C382B85E2D3F3E','2026-03-02 15:35:20',NULL,'ACTIVE'),(15,11,'1AB80EC7F37DCAC13692AEDF6D9C1C8A','2026-03-02 17:27:40',NULL,'ACTIVE'),(16,11,'DE003C4CB1262AFF3475C39E997BFB0B','2026-03-02 17:37:37',NULL,'ACTIVE'),(17,10,'C22DA417CB79DE92FB93F87FD6FACB0F','2026-03-02 17:43:49',NULL,'ACTIVE'),(18,11,'073EC3228BC3135B4A6723E0D70D1623','2026-03-02 21:01:49',NULL,'ACTIVE'),(19,11,'6D9C265CF19F52754D47D1EADF654CEE','2026-03-03 17:06:03','2026-03-03 17:07:40','INACTIVE'),(20,10,'DE256F2943FCA318A404C68762457E93','2026-03-03 17:11:53','2026-03-03 17:12:27','INACTIVE'),(21,11,'DE256F2943FCA318A404C68762457E93','2026-03-03 17:12:40',NULL,'ACTIVE'),(22,11,'C13ABAA406AAA836DE0E07F69579D029','2026-03-03 17:20:01','2026-03-03 17:21:23','INACTIVE'),(23,10,'C13ABAA406AAA836DE0E07F69579D029','2026-03-03 17:21:00','2026-03-03 17:21:23','INACTIVE'),(24,11,'2AB220FDA7177F461FAD06AF1AFE678E','2026-03-03 17:23:45',NULL,'ACTIVE'),(25,11,'2AB220FDA7177F461FAD06AF1AFE678E','2026-03-03 17:28:43',NULL,'ACTIVE'),(26,10,'AD60E2F23E0DE16C87EBF4F3D212C561','2026-03-03 17:40:55',NULL,'ACTIVE'),(27,10,'B7567B2C10035C947E0886E6D86530BD','2026-03-03 17:44:00',NULL,'ACTIVE'),(28,10,'0A219B45FB0BF554438607498D73A914','2026-03-03 17:53:17',NULL,'ACTIVE'),(29,10,'7548009D33EAB4A42C45D675D50928FB','2026-03-03 18:26:15',NULL,'ACTIVE'),(30,10,'19BA737500A32FA1BCC3C461FC372EC9','2026-03-03 19:13:04',NULL,'ACTIVE'),(31,10,'A3366B0D84089BABE018F6B83211B57A','2026-03-03 19:24:17',NULL,'ACTIVE'),(32,11,'FA7F95F173EE117D74976C022F8BFE01','2026-03-03 19:26:20','2026-03-03 19:27:03','INACTIVE'),(33,10,'FA7F95F173EE117D74976C022F8BFE01','2026-03-03 19:27:15',NULL,'ACTIVE'),(34,10,'AB1DC175BCB19E5B8A9C409AFCD20300','2026-03-03 21:09:42',NULL,'ACTIVE'),(35,10,'919E1EFA0C1480965B4B62A206459988','2026-03-03 21:54:01',NULL,'ACTIVE'),(36,10,'4337F637334DA1CE289855555A774143','2026-03-03 22:05:38',NULL,'ACTIVE'),(37,11,'64444B99597F04C9F38680E74DB1FC4D','2026-03-04 09:42:55','2026-03-04 09:43:57','INACTIVE'),(38,11,'64444B99597F04C9F38680E74DB1FC4D','2026-03-04 09:44:16',NULL,'ACTIVE'),(39,10,'64444B99597F04C9F38680E74DB1FC4D','2026-03-04 09:44:28',NULL,'ACTIVE'),(40,10,'B297AE7747CA040DC5CE9F7F1898DC3F','2026-03-04 09:47:55','2026-03-04 09:48:24','INACTIVE'),(41,10,'69CDD651F3256EB99FDEAB30DE1D2AE1','2026-03-04 09:58:09',NULL,'ACTIVE'),(42,10,'13E9F506BF5888F9E9D5A580784EAD7D','2026-03-04 14:56:51',NULL,'ACTIVE'),(43,10,'D85B5DFC066FF0B23CDAD4ACC4B25F3E','2026-03-04 15:12:18',NULL,'ACTIVE'),(44,10,'B2975312EEEE79E5151CA47EE7AF63E5','2026-03-04 15:15:05',NULL,'ACTIVE'),(45,11,'B64830984AD2E4423BB6747488B3F351','2026-03-04 15:31:21','2026-03-04 15:32:18','INACTIVE'),(46,10,'B64830984AD2E4423BB6747488B3F351','2026-03-04 15:33:02',NULL,'ACTIVE'),(47,10,'33F4FF62CC6AB570F7CD0C2ADEFB4B92','2026-03-04 15:42:46',NULL,'ACTIVE'),(48,11,'9F81553E31765CC20101BE262B45B095','2026-03-05 20:08:29',NULL,'ACTIVE'),(49,10,'F46D333560262BE0DD4ED4624C25A78C','2026-03-05 20:48:35','2026-03-05 21:08:58','INACTIVE'),(50,10,'F46D333560262BE0DD4ED4624C25A78C','2026-03-05 21:02:27','2026-03-05 21:08:58','INACTIVE'),(51,10,'F46D333560262BE0DD4ED4624C25A78C','2026-03-05 21:08:25','2026-03-05 21:08:58','INACTIVE'),(52,10,'F46D333560262BE0DD4ED4624C25A78C','2026-03-05 21:16:58',NULL,'ACTIVE'),(53,10,'5CE0659327EE8EB9FC9E4C6A9B64C129','2026-03-06 18:13:12',NULL,'ACTIVE'),(54,10,'64C3230347247D23047AC134DD90B59E','2026-03-06 18:41:37',NULL,'ACTIVE'),(55,10,'A9441EDF46CBBEC351FEA74DFFA9F0E8','2026-03-06 18:45:04',NULL,'ACTIVE'),(56,10,'F5983040ADA95F7EFCAAFD48AEB4946A','2026-03-06 18:50:11',NULL,'ACTIVE'),(57,10,'3D9D8B877038D5EBAE028ACDBB9FCD9B','2026-03-06 18:54:04',NULL,'ACTIVE'),(58,10,'342370E44E3C0091BBF47C623C579F70','2026-03-06 19:22:37',NULL,'ACTIVE'),(59,11,'601927918E77DE4177D6289138C6C661','2026-03-06 19:27:09',NULL,'ACTIVE'),(60,10,'601927918E77DE4177D6289138C6C661','2026-03-06 19:31:54',NULL,'ACTIVE'),(61,10,'61717E677F8ED36EBC725B2C44A9F45A','2026-03-06 19:36:52',NULL,'ACTIVE'),(62,10,'EDC3BFB6FDB958B4240E987C95D4874C','2026-03-06 19:51:41',NULL,'ACTIVE'),(63,10,'F556BAC0F5ED4ED6AAC4A5C83137F906','2026-03-06 20:01:24',NULL,'ACTIVE'),(64,11,'809F04BD02CBFFF268DDC4EC064656AB','2026-03-06 20:33:58',NULL,'ACTIVE'),(65,11,'CB1E0E40BA2B7BA4D5E892880063E116','2026-03-06 20:58:23','2026-03-06 21:00:35','INACTIVE'),(66,11,'1AA3F95285330DC18C1262FABF16E070','2026-03-06 21:34:05','2026-03-06 21:34:48','INACTIVE'),(67,11,'87627315560631BF6AD74E48625E3A05','2026-03-08 19:27:50','2026-03-08 19:34:42','INACTIVE'),(68,10,'87627315560631BF6AD74E48625E3A05','2026-03-08 19:31:54','2026-03-08 19:34:42','INACTIVE'),(69,11,'629376218D0846AD946D8F6532518C79','2026-03-10 22:47:38','2026-03-10 22:47:50','INACTIVE'),(70,11,'222B3881CB646621AD605C98FA378C25','2026-03-12 22:20:20','2026-03-12 22:20:47','INACTIVE'),(71,11,'94EDB6979211B78FC4C251602AFC05D3','2026-03-16 17:32:00','2026-03-16 17:41:03','INACTIVE'),(72,11,'94EDB6979211B78FC4C251602AFC05D3','2026-03-16 17:38:53','2026-03-16 17:41:03','INACTIVE'),(73,10,'0753FD9CB73466B3047B773A9CD6FA84','2026-03-16 17:46:02','2026-03-16 17:46:37','INACTIVE'),(74,11,'0753FD9CB73466B3047B773A9CD6FA84','2026-03-16 17:46:52',NULL,'ACTIVE'),(75,11,'0D2BA39B0955447649319079813F36CB','2026-03-16 17:58:40',NULL,'ACTIVE'),(76,10,'989211D827CC0308A55080BDDD8B0F36','2026-03-16 18:53:08','2026-03-16 18:53:31','INACTIVE'),(77,11,'989211D827CC0308A55080BDDD8B0F36','2026-03-16 18:53:40',NULL,'ACTIVE'),(78,11,'6009C862AE993C11DD2AB84791CBD909','2026-03-16 18:59:49','2026-03-16 19:07:46','INACTIVE'),(79,10,'6009C862AE993C11DD2AB84791CBD909','2026-03-16 19:00:08','2026-03-16 19:07:46','INACTIVE'),(80,11,'6009C862AE993C11DD2AB84791CBD909','2026-03-16 19:02:14','2026-03-16 19:07:46','INACTIVE'),(81,10,'6009C862AE993C11DD2AB84791CBD909','2026-03-16 19:06:04','2026-03-16 19:07:46','INACTIVE'),(82,11,'6009C862AE993C11DD2AB84791CBD909','2026-03-16 19:07:13','2026-03-16 19:07:46','INACTIVE'),(83,11,'E1667BF72EE4445FDDF38C6D193F8582','2026-03-16 19:16:18','2026-03-16 19:16:33','INACTIVE'),(84,10,'67DF32CC7213B81FE0C8856884188B90','2026-03-16 19:40:21','2026-03-16 19:55:01','INACTIVE'),(85,11,'AB937CF81A7207AB3EC782CD42C4BDD7','2026-03-16 20:03:46','2026-03-16 20:05:19','INACTIVE'),(86,12,'AB937CF81A7207AB3EC782CD42C4BDD7','2026-03-16 20:04:55','2026-03-16 20:05:19','INACTIVE'),(87,11,'C8770281AB4E9052C10E068B99BD7592','2026-03-17 16:58:55','2026-03-17 16:59:24','INACTIVE'),(88,12,'4B798CDFB6E63D86469F1C85855159BC','2026-03-17 17:00:58','2026-03-17 17:01:13','INACTIVE'),(89,12,'B35A9C579F085F867766C046A5D03564','2026-03-17 22:44:08','2026-03-17 22:45:11','INACTIVE'),(90,12,'AFA94E47D1A5A7A645D0BE7D0404C7AD','2026-03-18 07:55:52','2026-03-18 07:56:02','INACTIVE'),(91,11,'87248E88C5C0C9C21EAA85F6AF2BB476','2026-03-18 07:59:40','2026-03-18 07:59:49','INACTIVE'),(92,11,'762AEA212870A3CDD2A70EC86689E6B0','2026-03-18 14:41:23','2026-03-18 14:42:36','INACTIVE'),(93,10,'762AEA212870A3CDD2A70EC86689E6B0','2026-03-18 14:42:16','2026-03-18 14:42:36','INACTIVE'),(94,12,'7BD9436E9F8F27CC88BD6AB3630F24DC','2026-03-18 15:00:19',NULL,'ACTIVE'),(95,10,'91ED9D764D160FEC0CF391D86E37C473','2026-03-18 15:12:08','2026-03-18 15:14:47','INACTIVE'),(96,11,'91ED9D764D160FEC0CF391D86E37C473','2026-03-18 15:14:13','2026-03-18 15:14:47','INACTIVE'),(97,12,'62B2458B21C132079E00DCDC0E9BB9C8','2026-03-18 15:24:33',NULL,'ACTIVE'),(98,11,'685142F1C50592FD545A1E5415D2995D','2026-03-18 15:40:21','2026-03-18 15:40:45','INACTIVE'),(99,10,'5A9EC24389B1AB8790BB5C07D2EEA259','2026-03-18 16:00:38','2026-03-18 16:02:10','INACTIVE'),(100,12,'7B8CB518E7F6B75872C4D80C9FF7F03C','2026-03-19 16:33:50','2026-03-19 16:47:24','INACTIVE'),(101,11,'7B8CB518E7F6B75872C4D80C9FF7F03C','2026-03-19 16:48:59',NULL,'ACTIVE'),(102,10,'D0FD055E2F30ECA8EBEF8ECD9CABC0FA','2026-03-22 18:27:10','2026-03-22 18:27:30','INACTIVE'),(103,10,'E39E63D81C8FE040AB5A59B7F666380B','2026-03-23 17:40:08','2026-03-23 17:45:10','INACTIVE'),(104,11,'E39E63D81C8FE040AB5A59B7F666380B','2026-03-23 17:42:21','2026-03-23 17:45:10','INACTIVE'),(105,11,'AA8529B7BCABAB6B3B2B98EF497ECE97','2026-03-24 07:40:09','2026-03-24 07:41:42','INACTIVE'),(106,12,'A4A518BCF786E368BE70367E0637D7EB','2026-03-24 11:29:33',NULL,'ACTIVE'),(107,11,'0BBC67DB24F7B614D583425F41D6F785','2026-03-26 20:49:21',NULL,'ACTIVE'),(108,12,'0BBC67DB24F7B614D583425F41D6F785','2026-03-26 21:04:25',NULL,'ACTIVE'),(109,11,'E9341CCB06E580852D68D79A7ACA86C9','2026-03-26 21:39:38',NULL,'ACTIVE'),(110,11,'9080DF18381A72D60F4CD94495E25D98','2026-03-26 22:23:34',NULL,'ACTIVE'),(111,11,'35C6AE3BAD1A12798B93B1957CAB0ECC','2026-03-26 22:57:07','2026-03-26 23:06:53','INACTIVE'),(112,12,'35C6AE3BAD1A12798B93B1957CAB0ECC','2026-03-26 23:07:09',NULL,'ACTIVE'),(113,12,'35F57C957B4F3900529092C9BC408BBC','2026-03-29 23:16:48',NULL,'ACTIVE'),(114,11,'4858A5AA1E612189003CF8CD7E718128','2026-03-31 20:44:47','2026-03-31 20:45:37','INACTIVE'),(115,10,'4858A5AA1E612189003CF8CD7E718128','2026-03-31 20:45:51',NULL,'ACTIVE'),(116,10,'553F5C1948C6099EED7CE7F200A82DFC','2026-04-01 15:06:42','2026-04-01 15:09:36','INACTIVE'),(117,11,'553F5C1948C6099EED7CE7F200A82DFC','2026-04-01 15:08:30','2026-04-01 15:09:36','INACTIVE'),(118,11,'4D277DC0CECDCF2D3F506CF163322051','2026-04-01 15:15:33','2026-04-01 15:16:24','INACTIVE'),(119,10,'79CBAC184D99EC2D369EDA689EA7EE46','2026-04-01 15:59:11','2026-04-01 16:01:49','INACTIVE'),(120,11,'79CBAC184D99EC2D369EDA689EA7EE46','2026-04-01 16:01:59',NULL,'ACTIVE'),(121,12,'FE9092C17A8425AA6D9F0B7D9D43AFD3','2026-04-03 10:01:06','2026-04-03 10:09:24','INACTIVE'),(122,11,'FE9092C17A8425AA6D9F0B7D9D43AFD3','2026-04-03 10:02:52','2026-04-03 10:09:24','INACTIVE'),(123,11,'FE9092C17A8425AA6D9F0B7D9D43AFD3','2026-04-03 10:08:46','2026-04-03 10:09:24','INACTIVE');
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (10,'vignesh','vignesh@gmail.com','Hello@123','1234567890','customer'),(11,'Vijay','vijay@gmail.com','Hello@123','1234567890','admin'),(12,'Varshini','varshini@gmail.com','Hello@123','9003530942','customer');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-03 12:02:06

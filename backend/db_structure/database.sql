CREATE DATABASE IF NOT EXISTS `AptikesDiepafes` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `AptikesDiepafes`;

CREATE TABLE IF NOT EXISTS `Scheduler` (
  `Frequency` varchar(18) NOT NULL DEFAULT '[1,2,3,4,5]',
  `Type` varchar(50) NOT NULL DEFAULT 'Normal',
  `Time` time NOT NULL,
  `Status` char(1) NOT NULL DEFAULT '1',
  `uid` int(5) unsigned zerofill NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


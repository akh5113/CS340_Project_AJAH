/* CS340 Project Group 15
Anne Harris
Aaron Johnson
Project Step 2*/

--
-- Table structure for table `olympic_games`
--

DROP TABLE IF EXISTS `olympic_games`;
CREATE TABLE `olympic_games`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`games_year` int(4) NOT NULL,
`season` tinyint(1) NOT NULL,
`country` varchar(100) NOT NULL,
`city` varchar(100)
PRIMARY KEY(`id`) 
)ENGINE=InnoDB;

--
-- Data for table `olympic_games`
--

LOCK TABLES `olympic_games` WRITE;
INSERT INTO `olympic_games` VALUES (1, 2018, 0, 'South Korea', 'PyeongChang'),
								   (2, 2016, 1, 'Brazil', 'Reo de Janeiro'),
								   (3, 2014, 0, 'Russia', 'Sochi'),
								   (4, 2012, 1, 'United Kingdom', 'London');
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE `events`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`goldWinner` int(11),
`goldTime` TIME,
`gender` tinyint(1) NOT NULL,
`olympicID` int(11) NOT NULL,
PRIMARY KEY(`id`)
FOREIGN KEY (`olympicID`) REFERENCES `olympic_games` (`id`),
FOREIGN KEY (`goldWinner`) REFERENCES `athletes` (`id`)
)ENGINE=InnoDB;

--
-- Data for table `events`
--

LOCK TABLES `events`;
INSERT INTO `events` VALUES (1, '100 Meter Sprint', 1, '00:00:20', 2),


CREATE TABLE `athletes`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`firstName` varchar(50) NOT NULL,
`lastName` varchar(50) NOT NULL,
`team` int(11) NOT NULL,
`gender` tinyint(1) NOT NULL,
PRIMARY KEY(`id`)
)ENGINE=InnoDB;

CREATE TABLE `teams`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`numAthletes` int(11) DEFAULT '1',
`goldMedals` int(11) DEFAULT '0',
PRIMARY KEY(`id`)
)ENGINE=InnoDB;




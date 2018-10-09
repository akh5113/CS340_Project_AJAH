-- CS340 Project Group 15
-- Anne Harris
-- Aaron Johnson
-- Project Step 2

DROP TABLE IF EXISTS `has`;
DROP TABLE IF EXISTS `events`;
DROP TABLE IF EXISTS `athletes`;
DROP TABLE IF EXISTS `teams`;
DROP TABLE IF EXISTS `olympic_games`;

--
-- Table structure for table `olympic_games`
--

CREATE TABLE `olympic_games`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`games_year` int(4) NOT NULL,
`season` tinyint(1) NOT NULL,
`country` varchar(100) NOT NULL,
`city` varchar(100),
UNIQUE KEY `games_year` (`games_year`),
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
-- Table structure for table `teams`
--

CREATE TABLE `teams`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`numAthletes` int(11) DEFAULT '1',
`goldMedals` int(11) DEFAULT '0',
`olympicID` int(11) NOT NULL,
PRIMARY KEY(`id`),
FOREIGN KEY (`olympicID`) 
		REFERENCES `olympic_games`(`id`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `teams`
--

LOCK TABLES `teams` WRITE;
INSERT INTO `teams` VALUES (1, 'USA', 2, 1, 4),
						   (2, 'France', 1, 1, 3),
						   (3, 'Brazil', 2, 2, 2),
						   (4, 'USA', 2, 1, 1);
UNLOCK TABLES;

-- 
-- Table structure for table `athletes`
--

CREATE TABLE `athletes`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`firstName` varchar(50) NOT NULL,
`lastName` varchar(50) NOT NULL,
`teamID` int(11) NOT NULL,
`gender` tinyint(1) NOT NULL,
PRIMARY KEY(`id`),
FOREIGN KEY (`teamID`)
		REFERENCES `teams`(`id`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `athletes`
--

LOCK TABLES `athletes` WRITE;
INSERT INTO `athletes` VALUES (1, 'Athlete1', 'Summer4', 1, 1),
							  (2, 'Athlete2', 'Summer4', 1, 0),
							  (3, 'Athlete1', 'Winter3', 2, 1),
							  (4, 'Athlete1', 'Summer2', 3, 0),
							  (5, 'Athlete2', 'Summer2', 3, 0),
							  (6, 'Athlete1', 'Winter1', 4, 1),
							  (7, 'Athlete2', 'Winter1', 4, 0);
UNLOCK TABLES;

--
-- Table structure for table `events`
--

CREATE TABLE `events`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`goldWinner` int(11) NOT NULL,
`goldTime` TIME,
`gender` tinyint(1) NOT NULL,
`olympicID` int(11) NOT NULL,
PRIMARY KEY(`id`),
FOREIGN KEY (`olympicID`)
		REFERENCES `olympic_games` (`id`) ON DELETE CASCADE,
FOREIGN KEY (`goldWinner`)
		REFERENCES `athletes` (`id`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `events`
--

LOCK TABLES `events` WRITE;
INSERT INTO `events` VALUES (1, 'Summer Event 0', 4, '00:00:20', 0, 2),
							(2, 'Winter Event 1', 6, '00:20:01', 1, 1),
							(3, 'Summer Event 2', 5, '00:00:12', 0, 2),
							(4, 'Winter Event 2', 3, '01:15:01', 1, 3),
							(5, 'Summer Event 0', 1, '00:00:19', 1, 4);
UNLOCK TABLES;
 
--
-- Table structure for many-to-many relationship
-- Utilizes the id from the athletes table and the id from the events table
-- 

CREATE TABLE `has`(
`athleteID` int(11) NOT NULL,
`eventID` int(11) NOT NULL,
PRIMARY KEY(`athleteID`, `eventID`),
FOREIGN KEY (`athleteID`)
	REFERENCES `athletes`(`id`) ON DELETE CASCADE,
FOREIGN KEY (`eventID`)
	REFERENCES `events`(`id`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `has`;
--

LOCK TABLES `has` WRITE;
INSERT INTO `has` VALUES (1, 5), (2, 5), (3, 4), (4, 1), (5, 3), (6, 2), (7, 2);
UNLOCK TABLES;






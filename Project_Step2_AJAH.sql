-- CS340 Project Group 15
-- Anne Harris
-- Aaron Johnson
-- Project Step 2

DROP TABLE IF EXISTS `athletes_events`;
DROP TABLE IF EXISTS `events`;
DROP TABLE IF EXISTS `athletes`;
DROP TABLE IF EXISTS `teams`;
DROP TABLE IF EXISTS `alien_games`;

--
-- Table structure for table `alien_games`
--

CREATE TABLE `alien_games`(
`ID` int(11) NOT NULL AUTO_INCREMENT,
`games_year` int(4) NOT NULL,
`season` tinyint(1) NOT NULL,
`country` varchar(100) NOT NULL,
`city` varchar(100),
CONSTRAINT UC_games UNIQUE (`games_year`, `season`),
PRIMARY KEY(`ID`)
)ENGINE=InnoDB;

--
-- Data for table `alien_games`
--

LOCK TABLES `alien_games` WRITE;
INSERT INTO `alien_games` VALUES (1, 2018, 0, 'Country1', 'City1'),
								   (2, 2016, 1, 'Country2', 'City2'),
								   (3, 2014, 0, 'Country3', 'City3'),
								   (4, 2012, 1, 'Country4', 'City4');
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

CREATE TABLE `teams`(
`ID` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`gamesID` int(11),
UNIQUE(`name`),
PRIMARY KEY(`ID`),
FOREIGN KEY (`gamesID`) 
		REFERENCES `alien_games`(`ID`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `teams`
--

LOCK TABLES `teams` WRITE;
INSERT INTO `teams` VALUES (1, 'Team1', 4),
						   (2, 'Team2', 3),
						   (3, 'Team3', 2),
						   (4, 'Team4', 1);
UNLOCK TABLES;

-- 
-- Table structure for table `athletes`
--

CREATE TABLE `athletes`(
`ID` int(11) NOT NULL AUTO_INCREMENT,
`firstName` varchar(50) NOT NULL,
`lastName` varchar(50) NOT NULL,
`teamID` int(11) NOT NULL,
CONSTRAINT UC_athletes UNIQUE (`firstName`, `lastName`),
PRIMARY KEY(`ID`),
FOREIGN KEY (`teamID`)
		REFERENCES `teams`(`ID`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `athletes`
--

LOCK TABLES `athletes` WRITE;
INSERT INTO `athletes` VALUES (1, 'Athlete1', 'Summer4', 1),
							  (2, 'Athlete2', 'Summer4', 1),
							  (3, 'Athlete1', 'Winter3', 2),
							  (4, 'Athlete1', 'Summer2', 3),
							  (5, 'Athlete2', 'Summer2', 3),
							  (6, 'Athlete1', 'Winter1', 4),
							  (7, 'Athlete2', 'Winter1', 4);
UNLOCK TABLES;

--
-- Table structure for table `events`
--

CREATE TABLE `events`(
`ID` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`goldWinner` int(11) NOT NULL,
`goldTime` TIME,
`gamesID` int(11) NOT NULL,
UNIQUE(`name`),
PRIMARY KEY(`ID`),
FOREIGN KEY (`gamesID`)
		REFERENCES `alien_games` (`ID`) ON DELETE CASCADE,
FOREIGN KEY (`goldWinner`)
		REFERENCES `athletes` (`ID`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `events`
--

LOCK TABLES `events` WRITE;
INSERT INTO `events` VALUES (1, 'Summer Event 0', 4, '00:00:20', 2),
							(2, 'Winter Event 1', 6, '00:20:01', 1),
							(3, 'Summer Event 2', 5, '00:00:12', 2),
							(4, 'Winter Event 2', 3, '01:15:01', 3),
							(5, 'Summer Event 3', 1, '00:00:19', 4);
UNLOCK TABLES;
 
--
-- Table structure for many-to-many relationship
-- Utilizes the id from the athletes table and the id from the events table
-- 

CREATE TABLE `athletes_events`(
`athleteID` int(11) NOT NULL,
`eventID` int(11) NOT NULL,
CONSTRAINT UC_athletes_events UNIQUE (`athleteID`, `eventID`),
PRIMARY KEY(`athleteID`, `eventID`),
FOREIGN KEY (`athleteID`)
	REFERENCES `athletes`(`ID`) ON DELETE CASCADE,
FOREIGN KEY (`eventID`)
	REFERENCES `events`(`ID`) ON DELETE CASCADE
)ENGINE=InnoDB;

--
-- Data for table `athletes_events`;
--

LOCK TABLES `athletes_events` WRITE;
INSERT INTO `athletes_events` VALUES (1, 5), (2, 5), (3, 4), (4, 1), (5, 3), (6, 2), (7, 2);
UNLOCK TABLES;



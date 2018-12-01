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
								   (4, 2012, 1, 'Country4', 'City4'),
								   (5, 2014, 1, 'Country5', 'City5'),
								   (6, 2010, 0, 'Country6', 'City6'),
								   (7, 2010, 1, 'Country7', 'City7'),
								   (8, 2008, 0, 'Country8', 'City8'),
								   (9, 2008, 1, 'Country9', 'City9'),
								   (10, 2006, 0, 'Country10', 'City10'),
								   (11, 2006, 1, 'Country11', 'City11');
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
INSERT INTO `teams` VALUES (1, 'Team1', 1),
						   (2, 'Team2', 1),
						   (3, 'Team3', 1),
						   (4, 'Team4', 2),
						   (5, 'Team5', 2),
						   (6, 'Team6', 2),
						   (7, 'Team7', 3),
						   (8, 'Team8', 3),
						   (9, 'Team9', 3),
						   (10, 'Team10', 4),
						   (11, 'Team11', 4),
						   (12, 'Team12', 4),
						   (13, 'Team13', 5),
						   (14, 'Team14', 5),
						   (15, 'Team15', 6),
						   (16, 'Team16', 6),
						   (17, 'Team17', 7),
						   (18, 'Team18', 7),
						   (19, 'Team19', 8),
						   (20, 'Team20', 8),
						   (21, 'Team21', 9),
						   (22, 'Team22', 9),
						   (23, 'Team23', 10),
						   (24, 'Team24', 11);
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
INSERT INTO `athletes` VALUES (1, 'Athlete1', 'Lastname', 1),
							  (2, 'Athlete2', 'Lastname', 1),
							  (3, 'Athlete3', 'Lastname', 2),
							  (4, 'Athlete4', 'Lastname', 2),
							  (5, 'Athlete5', 'Lastname', 3),
							  (6, 'Athlete6', 'Lastname', 3),
							  (7, 'Athlete7', 'Lastname', 4),
							  (8, 'Athlete8', 'Lastname', 4),
							  (9, 'Athlete9', 'Lastname', 5),
							  (10, 'Athlete10', 'Lastname', 5),
							  (11, 'Athlete11', 'Lastname', 6),
							  (12, 'Athlete12', 'Lastname', 6),
							  (13, 'Athlete13', 'Lastname', 7),
							  (14, 'Athlete14', 'Lastname', 7),
							  (15, 'Athlete15', 'Lastname', 8),
							  (16, 'Athlete16', 'Lastname', 8),
							  (17, 'Athlete17', 'Lastname', 9),
							  (18, 'Athlete18', 'Lastname', 9),
							  (19, 'Athlete19', 'Lastname', 10),
							  (20, 'Athlete20', 'Lastname', 10),
							  (21, 'Athlete21', 'Lastname', 11),
							  (22, 'Athlete22', 'Lastname', 11),
							  (23, 'Athlete23', 'Lastname', 12),
							  (24, 'Athlete24', 'Lastname', 12);
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
INSERT INTO `events` VALUES (1, 'Event 0', 1, '00:00:20', 1),
							(2, 'Event 1', 1, '00:20:01', 1),
							(3, 'Event 2', 2, '00:00:12', 1),
							(4, 'Event 3', 3, '01:15:01', 2),
							(5, 'Event 4', 4, '00:00:19', 2),
							(6, 'Event 5', 4, '00:00:20', 2),
							(7, 'Event 6', 5, '00:20:01', 3),
							(8, 'Event 7', 5, '00:00:12', 3),
							(9, 'Event 8', 5, '01:15:01', 3),
							(10, 'Event 9', 7, '00:00:19', 4),
							(11, 'Event 10', 8, '00:00:20', 4),
							(12, 'Event 11', 8, '00:20:01', 4),
							(13, 'Event 12', 10, '00:00:12', 5),
							(14, 'Event 13', 10, '01:15:01', 5),
							(15, 'Event 14', 10, '00:00:19', 5),
							(16, 'Event 15', 11, '00:00:20', 6),
							(17, 'Event 16', 12, '00:20:01', 6),
							(18, 'Event 17', 11, '00:00:12', 6),
							(19, 'Event 18', 13, '01:15:01', 7),
							(20, 'Event 19', 13, '00:00:19', 7),
							(21, 'Event 20', 13, '00:00:19', 7),
							(22, 'Event 21', 16, '00:55:20', 8),
							(23, 'Event 22', 16, '02:20:05', 8),
							(24, 'Event 23', 15, '00:03:12', 8),
							(25, 'Event 24', 17, '01:15:01', 9),
							(26, 'Event 25', 18, '00:11:16', 9),
							(27, 'Event 26', 18, '00:19:29', 9),
							(28, 'Event 27', 19, '00:19:19', 10),
							(29, 'Event 28', 19, '03:15:12', 10),
							(30, 'Event 29', 21, '01:15:15', 11),
							(31, 'Event 30', 21, '00:00:26', 11);
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
INSERT INTO `athletes_events` VALUES 	(1, 1), (1, 2), (2, 1), (2, 2), (2, 3), (3, 1), (3, 3), (3, 4), (4, 2), (5, 7), (5, 8), (5, 9), (6, 10), (6, 11), (7, 10), (7, 11), (8, 11), (8, 12),
										(9, 11), (9, 12), (10, 13), (10, 14), (10, 15), (11, 16), (11, 18), (12, 17), (12, 18), (13, 19), (13, 20), (13, 21), (14, 21), (14, 22), (15, 24), (15,23), 
										(16, 22), (16, 23), (17, 25), (17, 26), (18, 26), (18, 27), (19, 29), (19, 28), (21, 31), (21, 30);
UNLOCK TABLES;



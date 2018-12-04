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
INSERT INTO `alien_games` VALUES (1, 2018, 0, 'Westros', 'Kings Landing'),
								   (2, 2016, 1, 'USA', 'Happy Valley'),
								   (3, 2014, 0, 'Dogworld', 'Bark City'),
								   (4, 2012, 1, 'Parks n Rec', 'Pawnee'),
								   (5, 2014, 1, 'North Pole', 'Holidayville');
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
INSERT INTO `teams` VALUES (1, 'Starks', 1),
						   (2, 'Laninsers', 1),
						   (3, 'Targaryens', 1),
						   (4, 'Penn State', 2),
						   (5, 'Ohio State', 2),
						   (6, 'Washington State', 2),
						   (7, 'Underdogs', 3),
						   (8, 'Upperdogs', 3),
						   (9, 'Doggos', 3),
						   (10, 'Pawneeians', 4),
						   (11, 'Eagletonians', 4),
						   (12, 'City Council', 4),
						   (13, 'Nice List', 5),
						   (14, 'Naughtly List', 5),
						   (15, 'Elves', 5);

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
INSERT INTO `athletes` VALUES (1, 'Ned', 'Stark', 1),
							  (2, 'Arya', 'Stark', 1),
							  (3, 'Sansa', 'Stark', 1),
							  (4, 'Jon', 'Snow', 1),
							  (5, 'Cercsi', 'Lanister', 2),
							  (6, 'Jamie', 'Lanister', 2),
							  (7, 'Tyrion', 'Lanister', 2),
							  (8, 'Daenerys', 'Targaryen', 3),
							  (9, 'Rhaegar', 'Targaryen', 3),
							  (10, 'James', 'Franklin', 4),
							  (11, 'Saquon', 'Barkley', 4),
							  (12, 'Trace', 'McSorley', 4),
							  (13, 'Urban', 'Meyer', 5),
							  (14, 'Dwayne', 'Haskins', 5),
							  (15, 'Mike', 'Weber', 5),
							  (16, 'Mike', 'Leach', 6),
							  (17, 'Gardner', 'Minshew II', 6),
							  (18, 'Archie', 'Harris', 7),
							  (19, 'Harry', 'Harris', 7),
							  (20, 'Mick', 'Harris', 7),
							  (21, 'Eleanor', 'Ruffby', 8),
							  (22, 'Benny', 'Smith', 8),
							  (23, 'Ned', 'Forbes', 8),
							  (24, 'Sparkie', 'Ann', 9),
							  (25, 'Marley', 'Heckman', 9),
							  (26, 'Pinto', 'Lederer', 9),
							  (27, 'Murphy', 'Kirkpatrick', 9),
							  (28, 'Leslie', 'Knope', 10),
							  (29, 'Ron', 'Swanson', 10),
							  (30, 'Tom', 'Haverford', 10),
							  (31, 'Lindsay', 'Shay', 11),
							  (32, 'George', 'Gernway', 11),
							  (33, 'Jeremy', 'Jamm', 12),
							  (34, 'Bill', 'Dexhart', 12), 
							  (35, 'Fielding', 'Milton', 12),
							  (36, 'Nice', 'Kid', 13),
							  (37, 'Nicer', 'Kid', 13),
							  (38, 'Nicest', 'Kid', 13),
							  (39, 'Mean', 'Kidd', 14),
							  (40, 'Meaner', 'Kidd', 14),
							  (41, 'Meanest', 'Kidd', 14),
							  (42, 'Short', 'Elf', 15),
							  (43, 'Tall', 'Elf', 15),
							  (44, 'Buddy', 'Elf', 15),
							  (45, 'Sneaky', 'Elf', 15);
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
INSERT INTO `events` VALUES (1, 'Blackwater', 7, '00:00:20', 1),
							(2, 'Hardhome', 4, '03:00:45', 1),
							(3, 'Goldroad', 8, '00:15:32', 1),
							(4, 'Big Ten Championship', 10, '01:40:34', 2),
							(5, 'Rose Bowl', 11, '00:59:59', 2),
							(6, 'Turkey Bowl', 16, '00:34:11', 2),
							(7, 'Zoomies', 18, '00:00:26', 3),
							(8, 'Fetch', 19, '00:01:33', 3),
							(9, 'Agility Course', 21, '00:32:46', 3),
							(10, 'The Pit', 28, '04:32:15', 4),
							(11, 'Burger Cook Off', 29, '00:15:03', 4),
							(12, 'Karate', 33, '00:45:45', 4),
							(13, 'Present Wrapping', 38, '00:00:05', 5),
							(14, 'List Making', 45, '00:01:34', 5),
							(15, 'Gift Giving', 37, '00:09:58', 5);
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
INSERT INTO `athletes_events` VALUES 	(7,1), (2,1), (3,1), (5,1),
										(4,2), (2,2), (9,2), (8,2),
										(8,3), (1,3), (6,3), (7,3),
										(10,4), (13,4), (14,4), (15,4),
										(11,5), (16,5), (17,5), (10,5),
										(16,6), (11,6), (13,6), (12,6),
										(18,7), (20,7), (22,7), (19,7),
										(19,8), (18,8), (27,8), (23,8),
										(21,9), (26,9), (25,9), (20,9), (24,9),
										(28,10), (31,10), (32,10),
										(29, 11), (35, 11), (28,11),
										(33, 12), (30, 12), (34,12),
										(38, 13), (36, 13), (39,13), (43,13),
										(45, 14), (42, 14), (40, 14), (37,14),
										(37, 15), (45, 15), (44,15), (41,15);
UNLOCK TABLES;



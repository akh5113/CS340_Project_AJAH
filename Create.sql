/* CS340 Project Group 15
Anne Harris
Aaron Johnson
Project Step 2*/

CREATE TABLE `olympic_games`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`games_year` int(4) NOT NULL,
`season` tinyint(1) NOT NULL,
`country` int(11) NOT NULL,
`city` varchar(100)
PRIMARY KEY(`id`) 
)ENGINE=InnoDB;

CREATE TABLE `events`(
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(100) NOT NULL,
`goldWinner` int(11),
`goldTime` TIME,
PRIMARy KEY(`id`)
)ENGINE=InnoDB;

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




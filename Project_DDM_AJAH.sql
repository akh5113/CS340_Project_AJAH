-- CS340 Project Group 15
-- Anne Harris
-- Aaron Johnson
-- Project Step 3 - Data Manipulation Queries

-- BELOW HERE ARE SQL QUERIES TO VIEW INFORMATION REGARDING THE ALIEN GAMES

-- get Alien Games information to populate a dropdown
-- For selecting the alien games the user is interested in viewing
SELECT games_year AS Year, country, city, IF(season = 1, "Summer", "Winter") AS Season
 FROM alien_games

-- Gets the team name, number of athletes, and gold medals won
-- for an alien games previously selected by user
SELECT name, numAthletes AS 'Number of Athletes', goldMedals AS 'Gold Medals Won'
	FROM teams
	WHERE gamesID = :gamesID_Selected_From_Dropdown
	
-- Gets the event names and their winners for a specific alien games
-- that was previously selected by the user
SELECT name AS 'Event Name', CONCAT(firstName, ' ', lastName) AS 'Winner'
	FROM events
		JOIN athletes ON events.ID=athletes.ID
	WHERE gamesID = :gamesID_Selected_From_Dropdown


-- Gets all the athletes and the events they participated in. Also shows
-- An X if they won gold in that event, and nothing if they did not
SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'Competing Event',
IF(athleteID=events.goldWinner, "X", " ") AS "Won Gold"
	FROM athletes_events
		JOIN athletes ON athletes_events.athleteID = athletes.ID
		JOIN events ON athletes_events.eventID = events.ID
	WHERE events.gamesID = :gamesID_Selected_From_Dropdown



-- add new Alien Games year, season, and country
INSERT INTO alien_games (games_year, season, country) VALUES (:year_input, :season_bit_from_dropdown, :country_input)

-- add new events for the latest Alien Games
INSERT INTO events (events.name, gamesID) VALUES (:name_input, :gamesID_from_dropdown)

-- Add one new team for latest Alien Games
INSERT INTO teams (teams.name, gamesID) VALUES (:name_input, :gamesID_from_dropdown)

-- Add two new Athletes for the Team
INSERT INTO athletes (firstName, lastName, teamID) VALUES (:firstName_input, :lastName_input, :teamID_from_dropdown)

-- update an event with a gold winner
UPDATE events SET goldWinner = :athlete_ID_dropdown_input WHERE id = :event_ID_from_input

-- delete an athlete
DELETE FROM athletes WHERE id = :athlete_ID_selected_from_page

-- disassociate a an athlete from an event
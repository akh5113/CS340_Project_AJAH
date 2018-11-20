
-- CS340 Project Group 15
-- Anne Harris
-- Aaron Johnson
-- Project Step 3 - Data Manipulation Queries

-- --------------------------------------------------------------------------
-- BELOW HERE ARE SQL QUERIES TO VIEW INFORMATION REGARDING THE ALIEN GAMES
-- --------------------------------------------------------------------------

-- get Alien Games information to populate a dropdown
-- For selecting the alien games the user is interested in viewing
SELECT games_year AS Year, country, city, IF(season = 1, "Summer", "Winter") AS Season
 FROM alien_games

-- Gets the team name, number of athletes, gold medals won and year
-- for an alien games previously selected by user, Total gold medals and total athletes are derived from joins!
SELECT teams.name, SUM(IF(athleteID=events.goldWinner, 1, 0)) AS "Gold Medals", alien_games.games_year AS 'Year', IF(alien_games.season = 1, "Summer", "Winter") AS Season,
	SUM(IF(athletes.teamID=teams.ID, 1, 0)) AS "Num. Athletes", alien_games.games_year AS "Year"
	FROM athletes_events
        JOIN athletes ON athletes_events.athleteID = athletes.ID
        JOIN events ON athletes_events.eventID = events.ID
        JOIN teams ON athletes.teamID = teams.ID
        JOIN alien_games ON teams.gamesID = alien_games.ID
    WHERE gamesID = :gamesID_Selected_From_Dropdown
    GROUP BY teams.name

-- Gets the event names and their winners for a specific alien games
-- that was previously selected by the user
SELECT name AS 'Event Name', CONCAT(firstName, ' ', lastName) AS 'Winner'
	FROM events
		JOIN athletes ON events.ID=athletes.ID
	WHERE gamesID = :gamesID_Selected_From_Dropdown

-- Shows all the events for every game and the year the event was in
SELECT events.name AS 'Event', alien_games.games_year AS 'Year', IF(alien_games.season = 1, "Summer", "Winter") AS Season,
					   CONCAT(athletes.firstName, ' ', athletes.lastName) AS 'Gold Winner', goldTime AS 'Time'
			FROM events
				JOIN alien_games ON events.gamesID = alien_games.ID
				JOIN athletes ON events.goldWinner = athletes.ID

-- Gets all the athletes and the events they participated in. Also shows
-- An X if they won gold in that event, and nothing if they did not
SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'Competing Event',
IF(athleteID=events.goldWinner, "X", " ") AS "Won Gold", teams.name AS 'Team'
	FROM athletes_events
		JOIN athletes ON athletes_events.athleteID = athletes.ID
		JOIN teams ON athletes.teamID = teams.ID
		JOIN events ON athletes_events.eventID = events.ID
	WHERE events.gamesID = :gamesID_Selected_From_Dropdown

-- --------------------------------------------------------------------------
-- BELOW HERE ARE QUERIES TO ADD NEW DATA TO THE DATABASE
-- --------------------------------------------------------------------------

-- add new Alien Games year, season, and country
INSERT INTO alien_games (games_year, season, country, city) VALUES (:year_input, :season_bit_from_dropdown, :country_input, :city_input)

-- Add a new team for latest Alien Games
-- Number athletes and Gold winner values are derived and thus not needed to be input
INSERT INTO teams (teams.name, gamesID) VALUES (:name_input, :gamesID_from_dropdown)

-- Add new Athletes for the Team
INSERT INTO athletes (firstName, lastName, teamID) VALUES (:firstName_input, :lastName_input, :teamID_from_dropdown)

-- add a new event for the latest Alien Games
-- First populate dropdown of all alien games FOR PICKING GAMESID
SELECT games_year AS Year, country, city, IF(season = 1, "Summer", "Winter") AS Season
 FROM alien_games
-- Then populate dropdown of all teams in those games
SELECT name FROM teams
	WHERE gamesID = :gamesID_userInput
--Finally populate a list of all athletes on that specific team FOR PICKING GOLDWINNER
SELECT CONCAT(firstName, ' ' , lastName) AS Athlete
	FROM athletes
	WHERE teamID = :teamID_userInput
-- User would click through those above dropdowns and lists to make the inputs below
-- which are needed for event additions
SELECT CONCAT(firstName, ' ', lastName) AS Athlete
	FROM athletes
	WHERE teamID = :teamID_input
INSERT INTO events (name, goldTime, goldWinner, gamesID) VALUES (:name_input, :goldTime_input, :goldWinner_input, :gamesID_from_dropdown)

--Now all other competing athletes have to be added to the event
--This is handled by adding to the athletes_events table
--First populate a list of all teams in the specific alien games
SELECT name FROM teams
	WHERE gamesID = :gamesID_userInput
--Then populate list of all athletes on that team
SELECT CONCAT(firstName, ' ', lastName) AS Athlete
	FROM athletes
	WHERE teamID = :teamID_userInput
--User would then choose an athlete from that list and that player is added to the event
--by the below query
INSERT INTO athletes_events (athleteID, eventID) VALUES (:athleteID_selection,  :eventID_selection)
--The above would then be looped on the website to add more athletes to the event

-- --------------------------------------------------------------------------
-- BELOW HERE ARE QUERIES TO EDIT DATA IN THE DATABASE
-- --------------------------------------------------------------------------

-- Update an alien games
UPDATE alien_games SET  games_year = :games_yearInput, 
						season = :season_Input, 
						country = :country_Input,
						city = :city_Input
	WHERE ID = :alien_games_ID_from_update

-- Update Team
UPDATE teams SET name = :name_input,
				 gamesID = gamesID_input
	WHERE ID = :teams_ID_from_update

-- Update athlete
UPDATE athletes SET firstName = :firstName_input,
					lastName = :lastName_input,
					teamID = :teamID_input
	WHERE ID = :athlete_ID_from_update

Update Event
UPDATE events SET name = :name_input,
			  goldWinner = :goldWinner_input,
				  gamesID = :gamesID_input
	WHERE ID = :events_ID_from_update

 Update what event an athlete competes in
 UPDATE athletes_events SET eventID = :eventID_input
	WHERE ID = :athleteID_input

-- --------------------------------------------------------------------------
-- BELOW HERE ARE TO DELETE ITEMS
-- --------------------------------------------------------------------------

-- Delete an entire Alien Game
DELETE FROM alien_games WHERE ID = :alien_game_selected_from_dropdown

-- Delete an entire team
DELETE FROM teams WHERE ID = :team_ID_from_dropdown

-- Delete an athlete
DELETE FROM athletes WHERE ID = :athlete_selected_from_list

-- Delete an Event
DELETE FROM events WHERE ID = :event_selected_from_list
UPDATE teams SET goldMedals = goldMedals - 1
	WHERE :event_selected_from_list.goldWinner.teamID = ID

-- Cascading deletes in the SQL table will take care of disassociating events when an athlete or event are deleted
-- So no deletes needed for athletes_events table. (If an event is deleted its automatically deleted in that table)















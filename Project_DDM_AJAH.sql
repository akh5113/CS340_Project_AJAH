
-- CS340 Project Group 15
-- Anne Harris
-- Aaron Johnson
-- Project Step 3 - Data Manipulation Queries

-- --------------------------------------------------------------------------
-- BELOW HERE ARE SQL QUERIES TO VIEW INFORMATION REGARDING THE ALIEN GAMES
-- --------------------------------------------------------------------------

-----------------------------------------------
-- POPULATING DROPDOWNS AND FILTERS
-----------------------------------------------

-- get Alien Games information to populate a dropdown
-- For selecting the alien games the user is interested in viewing
-- Only need to see games year and season
SELECT games_year AS 'Year', IF(season = 1, 'Summer', 'Winter') AS 'Season', alien_games.ID 
	FROM alien_games

-- Populate a dropdown to select a team when adding a new athlete
SELECT name, ID FROM teams

-- When adding a new event, populate dropdown of all teams in previously selected games
SELECT name FROM teams WHERE gamesID = :gamesID_userInput

-- Gets a single, previulsy selected Alien Game
SELECT games_year AS 'Year', IF(season = 1, 'Summer', 'Winter') AS 'Season', alien_games.ID 
	FROM alien_games 
	WHERE alien_games.ID = :selected_alien_game_ID
-- Populates Athlete dropdown based off of previously selected game
SELECT athletes.ID AS 'Winner', CONCAT(firstName,' ', lastName) AS 'Athlete', teams.name AS 'Team' 
	FROM athletes 
	JOIN teams ON athletes.teamID = teams.ID 
	JOIN alien_games ON teams.gamesID = alien_games.ID 
	WHERE alien_games.ID = :prevously_selected_from_dropdown_games_ID

-- Populate events dropdown for associating athletes to events
SELECT events.name AS 'Event', alien_games.games_year AS 'Year', events.ID 
	FROM events 
	JOIN alien_games ON events.gamesID = alien_games.ID
-- Selected a single previulsy seletected event, 
-- used to populate athletes only participating in the Games the same year as when the event takes place
SELECT events.name AS 'Event', alien_games.games_year AS 'Year', events.ID 
	FROM events 
	JOIN alien_games ON events.gamesID = alien_games.ID 
	WHERE events.ID = :event_ID_from_dropdown
-- populate athletes elegible to participate in event
SELECT athletes.ID AS 'ID', CONCAT(firstName,' ', lastName) AS 'Name', teams.name AS 'Team' 
	FROM athletes 
	LEFT JOIN teams ON athletes.teamID = teams.ID 
	LEFT JOIN alien_games ON teams.gamesID = alien_games.ID 
	LEFT JOIN events ON alien_games.ID = events.gamesID 
	WHERE events.ID = ?

-----------------------------------------------
-- VIEW ALL DATA WITHIN TABLES
-----------------------------------------------

-- ALL ALIEN GAMES
-- Selects all Alien Games entries
SELECT games_year AS Year, country, city, IF(season = 1, 'Summer', 'Winter') AS Season FROM alien_games 

-- ALL EVENTS
-- Shows all the events for every game and the year the event was in
SELECT events.name AS 'Event', alien_games.games_year AS 'Year', IF(alien_games.season = 1, "Summer", "Winter") AS Season,
					   CONCAT(athletes.firstName, ' ', athletes.lastName) AS 'Gold Winner', goldTime AS 'Time'
			FROM events
				JOIN alien_games ON events.gamesID = alien_games.ID
				JOIN athletes ON events.goldWinner = athletes.ID

-- ALL ATHLETES
-- Selects all athletes from all games. Also shows an X if they won gold in that event, and nothing if they did not
SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'CompetingEvent', IF(athleteID=events.goldWinner, 'X', ' ') AS 'WonGold', teams.name AS 'Team' 
	FROM athletes_events 
	RIGHT JOIN athletes ON athletes_events.athleteID = athletes.ID 
	LEFT JOIN teams ON athletes.teamID = teams.ID 
	LEFT JOIN events ON athletes_events.eventID = events.ID

-- ALL TEAMS
-- Selects all team entries in table, in all Alien Games
SELECT athletes.teamID, teams.name AS 'Team', SUM(IF(athleteID=events.goldWinner, 1, 0)) AS 'GoldMedals', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', alien_games.games_year AS 'Year', NumAthletes 
	FROM athletes_events AS t1 
	RIGHT JOIN athletes ON t1.athleteID = athletes.ID 
	LEFT JOIN events ON t1.eventID = events.ID 
	RIGHT JOIN teams ON athletes.teamID = teams.ID 
	LEFT JOIN alien_games ON teams.gamesID = alien_games.ID 
	JOIN (SELECT teams.ID AS teamID, COUNT(athletes.teamID) AS NumAthletes 
		FROM athletes 
		JOIN teams ON athletes.teamID = teams.ID 
		GROUP BY teams.name) 
	AS t2 ON athletes.teamID = t2.teamID 
	GROUP BY teams.name

-----------------------------------------------
-- VIEW DATA IN TABLES FILTERED BY ALIEN GAMES
-----------------------------------------------

-- FILTERED TEAMS
-- Gets the team name, number of athletes, gold medals won and year
-- for an alien games previously selected by user, Total gold medals and total athletes are derived from joins!
SELECT athletes.teamID, teams.name AS 'Team', SUM(IF(athleteID=events.goldWinner, 1, 0)) AS 'GoldMedals', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', alien_games.games_year AS 'Year', NumAthletes 
	FROM athletes_events AS t1 
	RIGHT JOIN athletes ON t1.athleteID = athletes.ID 
	LEFT JOIN events ON t1.eventID = events.ID 
	RIGHT JOIN teams ON athletes.teamID = teams.ID 
	LEFT JOIN alien_games ON teams.gamesID = alien_games.ID 
	JOIN (SELECT teams.ID AS teamID, COUNT(athletes.teamID) AS NumAthletes 
		FROM athletes 
		JOIN teams ON athletes.teamID = teams.ID 
		GROUP BY teams.name) 
	AS t2 ON athletes.teamID = t2.teamID 
	WHERE alien_games.ID = :gamesID_Selected_From_Dropdown 
	GROUP BY teams.name

-- FILTERED EVENTS
-- Gets the event names and their winners for a specific alien games
-- that was previously selected by the user
SELECT events.name AS 'Event', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', CONCAT(athletes.firstName, ' ', athletes.lastName) AS 'GoldWinner', goldTime AS 'Time' 
	FROM events 
	JOIN alien_games ON events.gamesID = alien_games.ID 
	JOIN athletes ON events.goldWinner = athletes.ID 
	WHERE events.gamesID = :gamesID_Selected_From_Dropdown

-- FILTERED ATHLETES
-- Gets all the athletes and the events they participated in by Games. Also shows
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
-- Selects game from Dropdown Query
INSERT INTO teams (teams.name, teams.gamesID) VALUES (:name_input, :gamesID_from_dropdown)

-- Add new Athletes for the Team
-- Selects Team from dropdown query
INSERT INTO athletes (firstName, lastName, teamID) VALUES (:firstName_input, :lastName_input, :teamID_from_dropdown)

-- Add a new Event
-- Select Games via Dropdown query
-- Selects Gold Winner from Athlete Dropdown query, which is queired to only show athletes
-- 		that particpiated in the already selected games
INSERT INTO events (name, goldTime, goldWinner, gamesID) VALUES (:name_input, :goldTime_input, :goldWinner_from_athletes_dropdwon, :gamesID_from_dropdown)

-- Associate Athletes with Events (inserting into M-to-M table)
-- Select Event from dropdown
-- Select Athletes that are a part of a team that participated in that years Alien Games
INSERT INTO athletes_events (athleteID, eventID) VALUES (:selected_athlete_ID, :selected_event_ID)


-- --------------------------------------------------------------------------
-- BELOW HERE ARE QUERIES TO EDIT DATA IN THE DATABASE
-- --------------------------------------------------------------------------

-- Update an alien games
UPDATE alien_games SET  games_year = :games_yearInput, 
						season = :season_Input, 
						country = :country_Input,
						city = :city_Input
	WHERE ID = :alien_games_ID_from_update

-- NOT IMPLMENTING UPDATE TEAM
-- Update Team
-- UPDATE teams SET name = :name_input, gamesID = gamesID_input WHERE ID = :teams_ID_from_update

-- NOT IMPLEMENTING UPDATE ATHLETE
-- Update athlete
-- UPDATE athletes SET firstName = :firstName_input, lastName = :lastName_input, teamID = :teamID_input WHERE ID = :athlete_ID_from_update

-- NOT IMPLEMENTING UPDATE EVENT
-- Update Event
-- UPDATE events SET name = :name_input,
-- 			  goldWinner = :goldWinner_input,
-- 				  gamesID = :gamesID_input
-- 	WHERE ID = :events_ID_from_update

-- NOT IMPLMETING ATHLETE - EVENT ASSOCIATION
--  Update what event an athlete competes in
-- UPDATE athletes_events SET eventID = :eventID_input
--	WHERE ID = :athleteID_input

-- --------------------------------------------------------------------------
-- BELOW HERE ARE TO DELETE ITEMS
-- --------------------------------------------------------------------------

-- NOT IMPLEMETING DELETE ON ALIEN GAMES ENTITY
-- Delete an entire Alien Game
-- DELETE FROM alien_games WHERE ID = :alien_game_selected_from_dropdown

-- Delete an entire team
DELETE FROM teams WHERE ID = :team_ID_from_dropdown

-- Delete an athlete
DELETE FROM athletes WHERE ID = :athlete_selected_from_list

-- NOT IMPLEMENTING DELETE ON EVENTS ENTITY
-- Delete an Event
-- DELETE FROM events WHERE ID = :event_selected_from_list
-- UPDATE teams SET goldMedals = goldMedals - 1
-- 	WHERE :event_selected_from_list.goldWinner.teamID = ID

-- Cascading deletes in the SQL table will take care of disassociating events when an athlete or event are deleted
-- So no deletes needed for athletes_events table. (If an event is deleted its automatically deleted in that table)















-- CS340 Project Group 15
-- Anne Harris
-- Aaron Johnson
-- Project Step 3 - Data Manipulation Queires

-- get all the year, season and host country of all Alien Games
SELECT games_year, season, country FROM alien_games

-- get all althetes first and last name in team X
SELECT firstName, lastName FROM athletes WHERE teamID = :team_id_selected_from_dropdown

-- get all athletes and their currently assoicated events
SELECT athleteID, eventID, CONCAT(fname,' ',lname) AS athlete_name AS participating_event 
FROM athletes 
INNER JOIN athletes_events ON athletes.ID = athletes_events.athleteID 
INNER JOIN events on events.ID = athletes_events.eventsID
ORDER BY athlete_name, participating_event 

-- get Alien Games inforamtion to populate a dropdown

-- get all Events information to populate a dropdown
SELECT events.ID AS eventsID, events.name FROM events -- not sure if this is correct 

-- get all Teams information to populate a dropdown

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
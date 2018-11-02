/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

//THE SAME AS VIEW_GAMES_ALL.JS???

module.exports = function(){
    var express = require('express');
    var router = express.Router();

    function getAllGames(res, mysql, context, complete){
		var sql = "SELECT games_year AS Year, country, city, IF(season = 1, 'Summer', 'Winter') AS Season FROM alien_games";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.alien_games = results;
	        complete();
		});
	}

	function getAllAthletes(res, mysql, context, complete){
		var sql = "SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'CompetingEvent', IF(athleteID=events.goldWinner, 'X', ' ') AS 'WonGold', teams.name AS 'Team' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN teams ON athletes.teamID = teams.ID JOIN events ON athletes_events.eventID = events.ID";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.athletes = results;
	        complete();
		});
	}

	function getAllEvents(res, mysql, context, complete){
		var sql = "SELECT events.name AS 'Event', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', CONCAT(athletes.firstName, ' ', athletes.lastName) AS 'GoldWinner', goldTime AS 'Time' FROM events JOIN alien_games ON events.gamesID = alien_games.ID JOIN athletes ON events.goldWinner = athletes.ID";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.events = results;
	        complete();
		});
	}

	function getAllTeams(res, mysql, context, complete){
		var sql = "SELECT teams.name AS 'Team', SUM(IF(athleteID=events.goldWinner, 1, 0)) AS 'GoldMedals', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', SUM(IF(athletes.teamID=teams.ID, 1, 0)) AS 'NumAthletes', alien_games.games_year AS 'Year' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN events ON athletes_events.eventID = events.ID JOIN teams ON athletes.teamID = teams.ID JOIN alien_games ON teams.gamesID = alien_games.ID GROUP BY teams.name";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.teams = results;
	        complete();
		});
	}

	/*Display all Alien Games, display all Athletes, display all Events, display all Teams */
	 
	router.get('/', function(req, res){
		var callbackCount = 0;
		var context = {};
		//context.jsscripts = 
		var mysql = req.app.get('mysql');
		getAllGames(res, mysql, context, complete);
		getAllAthletes(res, mysql, context, complete);
		getAllEvents(res, mysql, context, complete);
		getAllTeams(res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >=4){
				res.render('view_games_all', context)
			}
		}
	});


	return router;
}();

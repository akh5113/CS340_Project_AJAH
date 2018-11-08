/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

module.exports = function(){
    var express = require('express');
    var router = express.Router();


	/*get all alien games for dropdown */
	//NOTE: edited sql
	function getGamesDropdown(res, mysql, context, complete){
		var sql = "SELECT games_year AS 'Year', IF(season = 1, 'Summer', 'Winter') AS 'Season', alien_games.ID FROM alien_games";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.alien_games = results;
	        complete();
		});
	} 

	// Get athletes from a given games year  
	function getAthletesByGames(req, res, mysql, context, complete){
		var query = "SELECT CONCAT(firstName,' ', lastName) AS 'Athlete', events.name AS 'CompetingEvent', IF(athleteID=events.goldWinner, 'X', ' ') AS 'WonGold', teams.name AS 'Team' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN teams ON athletes.teamID = teams.ID JOIN events ON athletes_events.eventID = events.ID WHERE events.gamesID = ?";
		console.log(req.params)
		var inserts = [req.params.gamesID]
		mysql.pool.query(query, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.athletes = results; 
	        complete();
		});
	}

	//Get events from a given games year 
	function getEventsByGames(req, res, mysql, context, complete){
		var query = "SELECT events.name AS 'Event', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', CONCAT(athletes.firstName, ' ', athletes.lastName) AS 'GoldWinner', goldTime AS 'Time' FROM events JOIN alien_games ON events.gamesID = alien_games.ID JOIN athletes ON events.goldWinner = athletes.ID WHERE events.gamesID = ?";
		console.log(req.params)
		var inserts = [req.params.gamesID]
		mysql.pool.query(query, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.events = results;
	        complete();
		});
	}
	
	// Get teams from a given games year 
	function getTeamsByGames(req, res, mysql, context, complete){
		var query = "SELECT teams.name AS 'Team', SUM(IF(athleteID=events.goldWinner, 1, 0)) AS 'GoldMedals', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', SUM(IF(athletes.teamID=teams.ID, 1, 0)) AS 'NumAthletes', alien_games.games_year AS 'Year' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN events ON athletes_events.eventID = events.ID JOIN teams ON athletes.teamID = teams.ID JOIN alien_games ON teams.gamesID = alien_games.ID WHERE events.gamesID = ? GROUP BY teams.name";
		console.log(req.params)
		var inserts = [req.params.gamesID]
		mysql.pool.query(query, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.teams = results;
	        complete();
		});
	}

	//Display athlete, team and event info for given game


	//Display and populate dropdown
	router.get('/', function (req,res){
		var callbackCount = 0;
		var context = {};
		context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getGamesDropdown(res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >= 1){
				res.render('view_games', context);
			}
		}
	});


	//Display all athletes from a given alien games
	router.get('/filterAthletes/:gamesID', function(req, res){
		var callbackCount = 0;
		var context = {};
		context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getAthletesByGames(req, res, mysql, context, complete);
		getGamesDropdown(res, mysql, context, complete);	
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('view_games', context)
			}
		}

	});
	
	//Display all events from a given alien games
	router.get('/filterEvents/:gamesID', function(req, res){
		var callbackCount = 0;
		var context = {};
		context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getEventsByGames(req, res, mysql, context, complete);
		getGamesDropdown(res, mysql, context, complete);	
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('view_games', context)
			}
		}

	});
	
		//Display all events from a given alien games
	router.get('/filterTeams/:gamesID', function(req, res){
		var callbackCount = 0;
		var context = {};
		context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getTeamsByGames(req, res, mysql, context, complete);
		getGamesDropdown(res, mysql, context, complete);	
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('view_games', context)
			}
		}

	});


	return router;
}();

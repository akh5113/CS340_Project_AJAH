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
		var sql = "SELECT games_year AS Year, IF(season = 1, 'Summer', 'Winter') AS Season FROM alien_games";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.alien_games = results;
	        complete();
		});
	}


	/* Get atheltes from a given games year */ 
	function getAthletesByGames(res, mysql, context, complete){
		var sql = "SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'Competing Event', IF(athleteID=events.goldWinner, 'X', ' ') AS 'Won Gold', teams.name AS 'Team' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN teams ON athletes.teamID = teams.ID JOIN events ON athletes_events.eventID = events.ID WHERE events.gamesID = ?";
		console.log(req.params)
		var inserts = [req.params.alien_games]
		mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.athletes = results; //not sure if this is right w/ dropdwon
	        complete();
		});
	}

	/* Get events from a given games year */
	function getEventsByGames(res, mysql, context, complete){
		var sql = "SELECT name AS 'Event Name', CONCAT(firstName, ' ', lastName) AS 'Winner' FROM events JOIN athletes ON events.ID=athletes.ID WHERE gamesID = ?";
		console.log(req.params)
		var inserts = [req.params.alien_games]
		mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.events = results;
	        complete();
		});
	}

	/* Get teams from a given games year */
	function getTeamsByYear(res, mysql, context, complete){
		var sql = "SELECT teams.name, SUM(IF(athleteID=events.goldWinner, 1, 0)) AS 'Gold Medals', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS Season, SUM(IF(athletes.teamID=teams.ID, 1, 0)) AS 'Num. Athletes', alien_games.games_year AS 'Year' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN events ON athletes_events.eventID = events.ID JOIN teams ON athletes.teamID = teams.ID JOIN alien_games ON teams.gamesID = alien_games.ID WHERE gamesID = ? GROUP BY teams.name";
		console.log(req.params)
		var inserts = [req.params.alien_games]
		mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.teams = results;
	        complete();
		});
	}

	/*Display athlete, team and event info for given game*/
	 
	router.get('/:alien_games', function(req, res){
		var callbackCount = 0;
		var context = {};
		//context.jsscripts = [""]
		var mysql = req.app.get('mysql');
		getGamesDropdown(res, mysql, context, complete);
		getAthletesByGames(res, mysql, context, complete);
		getEventsByGames(res, mysql, context, complete);
		getTeamsByGames(res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('view_games', context)
			}
		}
	});


	return router;
}();

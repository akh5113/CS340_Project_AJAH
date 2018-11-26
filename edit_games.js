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
		var sql = "SELECT ID, games_year AS Year, country, city, IF(season = 1, 'Summer', 'Winter') AS Season FROM alien_games";
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
		var sql = "SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'CompetingEvent', IF(athleteID=events.goldWinner, 'X', ' ') AS 'WonGold', teams.name AS 'Team', athleteID FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN teams ON athletes.teamID = teams.ID JOIN events ON athletes_events.eventID = events.ID";
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
		var sql = "SELECT athletes.teamID, teams.name AS 'Team', SUM(IF(athleteID=events.goldWinner, 1, 0)) AS 'GoldMedals', alien_games.games_year AS 'Year', IF(alien_games.season = 1, 'Summer', 'Winter') AS 'Season', alien_games.games_year AS 'Year', NumAthletes FROM athletes_events AS t1 RIGHT JOIN athletes ON t1.athleteID = athletes.ID LEFT JOIN events ON t1.eventID = events.ID RIGHT JOIN teams ON athletes.teamID = teams.ID LEFT JOIN alien_games ON teams.gamesID = alien_games.ID JOIN (SELECT teams.ID AS teamID, COUNT(athletes.teamID) AS NumAthletes FROM athletes JOIN teams ON athletes.teamID = teams.ID GROUP BY teams.name) AS t2 ON athletes.teamID = t2.teamID GROUP BY teams.name";
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
		context.jsscripts = ["delete_athlete.js"];
		var mysql = req.app.get('mysql');
		getAllGames(res, mysql, context, complete);
		getAllAthletes(res, mysql, context, complete);
		getAllEvents(res, mysql, context, complete);
		getAllTeams(res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >=4){
				res.render('edit_games', context)
			}
		}
	});

	/*delete athlete */
	
	router.delete('/athlete/:ID', function(req, res){
		var mysql = req.app.get('mysql');
		var sql = "DELETE FROM athletes WHERE ID = ?";
		var inserts = [req.params.ID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				res.write(JSON.stringify(error));
				res.status(400);
				res.end();
			}else{
				res.status(202).end();
			}
		})
	})

	/* delete team */
	
	router.delete('/team/:ID', function(req, res){
		var mysql = req.app.get('mysql');
		var sql = "DELETE FROM teams WHERE ID = ?";
		var inserts = [req.params.ID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				res.write(JSON.stringify(error));
				res.status(400);
				res.end();
			}else{
				res.status(202).end();
			}
		})
	})

	/*select one Alien Games*/
	function getGames(res, mysql, context, ID, complete){
		var sql = "SELECT ID, games_year AS 'Year', IF(season = 1, 'Summer', 'Winter') AS 'Season', country, city FROM alien_games WHERE ID = ?";
		var inserts = [ID];
		mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				res.write(JSON.stringify(error));
				res.end();
			}
			context.alien_games = results[0];
			//console.log(context.alien_games);
			complete();
		})
	}

	/*display one Alien Game for the specific purposes of updating people*/
	router.get('/:ID', function(req, res){
		callbackCount = 0;
		console.log(req.body);
		var context = {};
		context.jsscripts = ["update_games.js"];
		var mysql = req.app.get('mysql');
		getGames(res, mysql, context, req.params.ID, complete);
	//	console.log(req.params);
		function complete(){
			callbackCount++;
			if(callbackCount >= 1){
				res.render('update_alien_games', context);
			}
		}
	});

	/* update athlete */
	router.put('/:ID', function(req, res){
		var mysql = req.app.get('mysql');
		console.log(req.body);
		var sql = "UPDATE alien_games SET games_year = ?, season = ?, country = ?, city = ? WHERE ID = ?";
		var inserts = [req.body.games_year, req.body.season, req.body.country, req.body.city, req.params.ID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				console.log(error)
				res.write(JSON.stringify(error));
				res.end();
			}else{
				res.status(200);
				res.end();
			}
		});
	});

	return router;
}();

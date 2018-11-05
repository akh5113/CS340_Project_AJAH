/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

module.exports = function(){
    var express = require('express');
    var router = express.Router();

    /* populate the games drop down */
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

	/*RENDER PAGE */

	router.get('/', function(req, res){
			var callbackCount = 0;
			var context = {};
			//context.jsscripts = 
			var mysql = req.app.get('mysql');
			getGamesDropdown(res,mysql,context, complete);
			getAllTeams(res, mysql, context, complete);
			function complete(){
				callbackCount++;
				if(callbackCount >=2){
					res.render('add_team', context)
				}
			}
		});


	/* Add a team */
	
	router.post('/', function(req, res){
		console.log(req.body.alien_games)
		console.log(req.body)
		var mysql = req.app.get('mysql');
		var sql = "INSERT INTO teams (teams.name, teams.gamesID) VALUES (?,?)";
		var inserts = [req.body.name, req.body.gamesID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				console.log(JSON.stringify(error))
                res.write(JSON.stringify(error));
                res.end();
			}else{
				res.redirect('/add_team')
			}
		});
	});
	

	return router;
}();
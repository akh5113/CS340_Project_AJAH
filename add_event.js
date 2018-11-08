/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

module.exports = function(){
    var express = require('express');
    var router = express.Router();

    /* populate games drop down*/
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
	
	//gets a single, previously selected game
	function getGames(req, res, mysql, context, complete){
		var query = "SELECT games_year AS 'Year', IF(season = 1, 'Summer', 'Winter') AS 'Season', alien_games.ID FROM alien_games WHERE alien_games.ID = ?";
		console.log(req.params)
		var inserts = [req.params.gamesID]
		mysql.pool.query(query, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.alien_games = results; 
	        complete();
		});
	}	

    /* populate athletes dropdown*/
    //NOTE edited sql
	function getAthletesByGames(req, res, mysql, context, complete){
		var query = "SELECT athletes.ID AS 'Winner', CONCAT(firstName,' ', lastName) AS 'Athlete', teams.name AS 'Team' FROM athletes JOIN teams ON athletes.teamID = teams.ID JOIN alien_games ON teams.gamesID = alien_games.ID WHERE alien_games.ID = ?";
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

	/* populate event dropdown - not sure if this is right*/
	/*
	function getEventsDropdown(res, mysql, context, complete){
		var sql = "SELECT eventsID, name FROM athletes_events WHERE gamesID = '?'";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.events = results;
	        complete();
		});
	} 
	/*

	/*change sql to include join so the user wont have to select a team to choose atheltes from a particular game year 
	also update to select FROM athletes_events and be able to select name via join*/
	/* populate atheltes checkbox not sure if this is right*/
	/*
    function getAthletes(res, mysql, context, complete){
		var sql = "SELECT CONCAT(firstName, ' ' , lastName) AS Athlete, athletesID FROM athletes WHERE teamID = '?'";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.athletes = results;
	        complete();
		});
	} */

    /* get events */
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

   /* Render page */

	router.get('/', function(req, res){
			var callbackCount = 0;
			var context = {};
			var mysql = req.app.get('mysql');
			getGamesDropdown(res,mysql,context, complete);
			//getEventsDropdown(res, mysql, context, complete);
			//getAthletes(res, mysql, context, complete);
			//getAllEvents(res, mysql, context, complete);
			function complete(){
				callbackCount++;
				if(callbackCount >=1){
					res.render('add_event', context)
				}
			}
		});
	/* Render Filtered Page */
	router.get('/filterAthletesForEvent/:gamesID', function(req, res){
		var callbackCount = 0;
		var context = {};
		context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getGames(req, res, mysql, context, complete);
		//getGamesDropdown(res,mysql,context, complete);
		getAthletesByGames(req, res, mysql, context, complete);	
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('add_event', context)
			}
		}

	});

		
		
	/* Add an event */
	
router.post('/', function(req, res){
//		console.log(req.body.alien_games);
//		console.log(req.body.athletes);
//		console.log(req.body);
		var mysql = req.app.get('mysql');
		var sql = "INSERT INTO events (name, goldTime, goldWinner, gamesID) VALUES (?, ?, ?, ?)";
		var inserts = [req.body.name, req.body.goldTime, req.body.goldWinner, req.body.gamesID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				console.log(JSON.stringify(error));
                res.write(JSON.stringify(error));
                res.end();
			}else{
				res.redirect('/edit_games')
			}
		});
});
				
	

	return router;
}();
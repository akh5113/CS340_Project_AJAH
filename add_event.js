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

    /* populate atheltes dropdown and check box */
    //NOTE edited sql
    function getAthletes(res, mysql, context, complete){
		var sql = "SELECT CONCAT(firstName, ' ' , lastName) AS Athlete, athletes.ID FROM athletes";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.athletes = results;
	        complete();
		});
	} 

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
			getAthletes(res, mysql, context, complete);
			getAllEvents(res, mysql, context, complete);
			function complete(){
				callbackCount++;
				if(callbackCount >=3){
					res.render('add_event', context)
				}
			}
		});


	/* Add an event */
	
	router.post('/', function(req, res){
		console.log(req.body.alien_games)
		console.log(req.body.athletes)
		console.log(req.body)
		var mysql = req.app.get('mysql');
		var sql = "INSERT INTO events (name, goldTime, goldWinner, gamesID) VALUES (?, ?, ?, ?)";
		var inserts = [req.body.name, req.body.goldTime, req.body.goldWinner, req.body.gamesID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				console.log(JSON.stringify(error))
                res.write(JSON.stringify(error));
                res.end();
			}else{
				res.redirect('/add_event')
			}
		});
	});
	

	return router;
}();
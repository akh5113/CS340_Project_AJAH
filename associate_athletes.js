/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

module.exports = function(){
    var express = require('express');
    var router = express.Router();
	
/* Get events to populate dropdown */
	function getEventsDropdown(res, mysql, context, complete){
		mysql.pool.query("SELECT events.name AS 'Event', alien_games.games_year AS 'Year', events.ID FROM events JOIN alien_games ON events.gamesID = alien_games.ID", function(error, results, fields){
							  if(error){
								res.write(JSON.stringify(error));
								res.end();
							  }
							  context.events = results;
							  complete();
						  });
	}
	
/* get athletes */
    /* populate athletes dropdown*/
    //NOTE This SQL will return the ID, Name, and Team of all athletes who competed in the event selected in the previous dropdown
	//It filters through a separate js function that is called in the html and then redirects here
	function getAthletesByGames(req, res, mysql, context, complete){
		var query = "SELECT athletes.ID AS 'ID', CONCAT(firstName,' ', lastName) AS 'Name', teams.name AS 'Team' FROM athletes LEFT JOIN teams ON athletes.teamID = teams.ID LEFT JOIN alien_games ON teams.gamesID = alien_games.ID LEFT JOIN events ON alien_games.ID = events.gamesID WHERE events.ID = ?";
		console.log(req.params)
		var inserts = [req.params.eventID]
		mysql.pool.query(query, inserts, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.athletes = results; 
	        complete();
		});
	}

/* Get the events and their athletes */
	function getEventsAndAthletes(res, mysql, context, complete){
		sql = "SELECT CONCAT(firstName,' ', lastName) AS Athlete, events.name AS 'CompetingEvent' FROM athletes_events JOIN athletes ON athletes_events.athleteID = athletes.ID JOIN teams ON athletes.teamID = teams.ID JOIN events ON athletes_events.eventID = events.ID ORDER BY events.name";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
				res.write(JSON.stringify(error));
				res.end()
			}
			context.athletes_events = results
			complete();
		});
	}
	
/* Render page */
	router.get('/', function(req, res){
		var callbackCount = 0;
		var context = {};
		//context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getEventsDropdown(res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >=1){
				res.render('associate_athletes', context);
			}
		}
	});
	
	router.get('/filterGames/:eventID', function(req, res){
		var callbackCount = 0;
		var context = {};
		context.jsscripts = ["filterByGames.js"];
		var mysql = req.app.get('mysql');
		getEventsDropdown(res, mysql, context, complete);
		getAthletesByGames(req, res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('associate_athletes', context)
			}
		}

	});
	
	router.post('/', function(req, res){
		console.log("Dropdown cert: ", req.body.EID)
		var mysql = req.app.get('mysql');
		var athletes = req.body.AID;
		var events = req.body.events.EID;
		for (let ID of athletes) {
			console.log("Processing athleteID " + ID)
			var sql = "INSERT INTO athletes_events (athleteID, eventID) VALUES (?, ?)";
			var inserts = [ID, events]
			sql = mysql.pool.query(sql, inserts, function(error, results, fields){
				if(error){
					console.log(error);
				}
			});
		}
		res.redirect('/associate_athletes');
	});
		
		
		
		

	return router;
}();
	
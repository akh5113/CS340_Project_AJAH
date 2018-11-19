/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

module.exports = function(){
    var express = require('express');
    var router = express.Router();

    /* populate teams dropdown */
    function getTeamsDropdown(res, mysql, context, complete){
		var sql = "SELECT name, ID FROM teams";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.teams = results;
	        complete();
		});
	} 

    /* get all athletes */
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



    /* render add_athletes athletes page */

	router.get('/', function(req, res){
			var callbackCount = 0;
			var context = {};
			var mysql = req.app.get('mysql');
			getTeamsDropdown(res,mysql,context, complete);
			getAllAthletes(res, mysql, context, complete);
			function complete(){
				callbackCount++;
				if(callbackCount >=2){
					res.render('add_athlete', context);
				}
			}
		});


	/* Add an athlete */
	
	router.post('/', function(req, res){
		console.log(req.body.teams);
		console.log(req.body);
		var mysql = req.app.get('mysql');
		var sql = "INSERT INTO athletes (firstName, lastName, teamID) VALUES (?, ?, ?)";
		var inserts = [req.body.firstName, req.body.lastName, req.body.teamID];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				console.log(JSON.stringify(error));
                res.write(JSON.stringify(error));
                res.end();
			}else{
				res.redirect('/add_athlete');
			}
		});
	});
	

	return router;
}();
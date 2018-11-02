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

	/*get all 

	/*Display all Alien Games, display all Athletes, display all Events, display all Teams */

	router.get('/', function(req, res){
		var callbackCount = 0;
		var context = {};
		//context.jsscripts = 
		var mysql = req.app.get('mysql');
		getGamesDropdown(res, mysql, context, complete);
		getGames(res, mysql, context, complete);
		getAthletes(res, mysql, context, complete);
		getEvents(res, mysql, context, complete);
		getTeams(res, mysql, context, complete);
		function complete(){
			callbackCount++;
			if(callbackCount >=2){
				res.render('view_games', context)
			}
		}
	});

	return router;
}();

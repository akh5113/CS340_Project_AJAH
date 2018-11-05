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

	/* Add a person */
	
	router.post('/', function(req, res){
		console.log(req.body.alien_games) //needed to populate games dropdown
		console.log(req.body)
		var mysql = req.app.get('mysql');
		var sql = "INSERT INTO teams (teams.name, gamesID) VALUES (?,?)";
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

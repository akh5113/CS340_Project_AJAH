/*********************
CS 340
Anne Harris
Aaron Johnson
*********************/

module.exports = function(){
    var express = require('express');
    var router = express.Router();

   /* games info */
   function getAllGames(res, mysql, context, complete){
		var sql = "SELECT games_year AS Year, country, city, IF(season = 1, 'Summer', 'Winter') AS Season FROM alien_games";
		mysql.pool.query(sql, function(error, results, fields){
			if(error){
	                res.write(JSON.stringify(error));
	                res.end();
	        }
	        context.alien_games = results;
	        complete();
		});
	}

    /* render page */
    
	router.get('/', function(req, res){
			var callbackCount = 0;
			var context = {};
			var mysql = req.app.get('mysql');
			getAllGames(res, mysql, context, complete);
			function complete(){
				callbackCount++;
				if(callbackCount >=1){
					res.render('add_games', context)
				}
			}
		});


	/* Add a Games entry*/
	
	router.post('/', function(req, res){
		console.log(req.body.alien_games)
		console.log(req.body)
		var mysql = req.app.get('mysql');
		var sql = "INSERT INTO alien_games (games_year, season, country, city) VALUES (?, ?, ?, ?)";
		var inserts = [req.body.games_year, req.body.season, req.body.country, req.body.city];
		sql = mysql.pool.query(sql, inserts, function(error, results, fields){
			if(error){
				console.log(JSON.stringify(error))
                res.write(JSON.stringify(error));
                res.end();
			}else{
				res.redirect('/add_games')
			}
		});
	});
	

	return router;
}();
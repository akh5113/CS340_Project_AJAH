function filterAthletesByGames() {
		//get the id of the selected alien games from the dropdown
		var games_id = document.getElementById('alien_games_filter').value
		//construct the URl and redirect to it
		window.location = '/view_games/filterAthletes/' + parseInt(games_id)
}

function filterEventsByGames() {
		//get the id of the selected alien games from the dropdown
		var games_id = document.getElementById('alien_games_filter').value
		//construct the URl and redirect to it
		window.location = '/view_games/filterEvents/' + parseInt(games_id)
}

function filterTeamsByGames() {
		//get the id of the selected alien games from the dropdown
		var games_id = document.getElementById('alien_games_filter').value
		//construct the URl and redirect to it
		window.location = '/view_games/filterTeams/' + parseInt(games_id)
}
		
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

function filterAthletesByGamesForEvent() {
		//get the id of the selected alien games from the dropdown
		var games_id = document.getElementById('add_event_filter').value
		//construct the URl and redirect to it
		window.location = '/add_event/filterAthletesForEvent/' + parseInt(games_id)
}

function filterAthletesEvent() {
	//get the id of the games from the selected event from the dropdown
	var event_id=document.getElementById('get_games_from_event').value
	//construct the URL and redirect to it
	window.location ='/associate_athletes/filterGames/' + parseInt(event_id)
}

		
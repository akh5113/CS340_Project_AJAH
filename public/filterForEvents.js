function filterAthletesByGamesForEvent() {
		//get the id of the selected alien games from the dropdown
		var games_id = document.getElementById('add_event').value
		//construct the URl and redirect to it
		window.location = '/add_event/filterAthletesForEvent/' + parseInt(games_id)
}
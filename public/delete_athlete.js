
function deleteAthlete(ID){
	$.ajax({
		url: '/edit_games/athlete/' + ID,
		type: 'DELETE',
		success:function(result){
			window.location.reload(true);
		}
	})
};


function deleteTeam(ID){
	$.ajax({
		url: '/edit_games/team/' + ID,
		type: 'DELETE',
		success:function(result){
			window.location.reload(true);
		}
	})
};
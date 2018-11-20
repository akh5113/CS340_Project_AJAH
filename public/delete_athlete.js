
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
	var r =	confirm('Are you sure you want to delete this team? Deletion of a team permanently delete ALL athletes on that team');
	if (r==true)
	{
		$.ajax({
		url: '/edit_games/team/' + ID,
		type: 'DELETE',
		success:function(result){
			window.location.reload(true);
		}
	})
	}
	else
	{
		return;
	}
};
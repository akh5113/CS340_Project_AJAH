function deleteAthlete(ID){
	$.ajax({
		url: '/edit_games/' + ID,
		type: 'DELETE',
		success:function(result){
			window.location.reload(true);
		}
	})
}
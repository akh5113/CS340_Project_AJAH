function deleteAthlete(id){
	$.ajax({
		url: '/edit_games/' + id,
		type: 'DELETE',
		success:function(result){
			window.location.reload(true);
		}
	})
}
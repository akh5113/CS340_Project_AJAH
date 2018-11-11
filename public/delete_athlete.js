
function deleteAthlete(ID){
	$.ajax({
		url: '/edit_games/' + ID,
		type: 'DELETE',
		success:function(result){
			window.location.reload(true);
		}
	})
};


/*
function deleteAthlete(ID){
	//send a GET request to the server to delete the actual row
	var req = new XMLHttpRequest();
	req.open("GET", "/delete?" +"id=", ID, true);
	req.send();
	event.preventDefault();
};
*/
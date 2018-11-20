function updateAlienGames(ID){
    $.ajax({
        url: '/alien_games/' + id,
        type: 'PUT',
        data: $('#update-alien_games').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};
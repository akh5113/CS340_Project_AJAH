function updateAlienGames(ID){
    $.ajax({
        url: '/edit_games/' + ID,
        type: 'PUT',
        data: $('#update_alien_games').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};
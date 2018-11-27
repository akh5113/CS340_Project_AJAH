function updateAlienGames(ID){
    $.ajax({
        url: '/edit_games/' + ID,
        type: 'PUT',
        data: $('#update_alien_games1').serialize(),
        success: function(result){
            window.location.replace("./");
        }
    })
};

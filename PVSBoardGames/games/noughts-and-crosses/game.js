
var board = createBoard({
    title       : 'Noughts & Crosses',        
    rows        : 3,
    columns     : 3,
    pattern     : 'grid',
})

var isPlayer1Turn = true

board.squareClickedAt = function(column, row) {

    // Is the square already occupied?
    if (board.)
    board.setSquareAtColumnRowColor(column, row, isPlayer1Turn)
    isPlayer1Turn = !isPlayer1Turn;
    //var playerMsg = isPlayer1Turn ? "First player won!" : "Second player won!";
    //board.showPopup(playerMsg)
};

function isEndGame() {
    for (var column = 0; column < board.columns; column++) {
        for (var row = 0; row < board.rows; row++) {
            
        }
    }
    
    return true;
}


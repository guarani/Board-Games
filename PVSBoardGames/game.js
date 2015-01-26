
var board = createBoardOfSize({size:6})

var lastTouch = {}
var isPlayer1Turn = true

board.squareTouchedAt = function(column, row) {
    debugger;
    if (areOrthogonallyAdjacent({row: row, column: column}, lastTouch) && areEmpty({row: row, column: column}, lastTouch)) {
        board.setSquareAtColumnRowColor(lastTouch.column, lastTouch.row, isPlayer1Turn)
        board.setSquareAtColumnRowColor(column, row, isPlayer1Turn)
        lastTouch = {}
        board.cancelMovement()
        if (board.isFull()) {
            var playerMsg = isPlayer1Turn ? "First player won!" : "Second player won!";
            board.showPopup(playerMsg)
        }
        isPlayer1Turn = !isPlayer1Turn
    } else {
        lastTouch.row = row
        lastTouch.column = column
    }
    

};

function areOrthogonallyAdjacent(point1, point2) {
    if (
        !((point1.column == point2.column) && (point1.row == point2.row)) && // Not the same point.
        (
            ((point1.column == point2.column) && ((point1.row == point2.row + 1) || (point1.row == point2.row - 1))) || // Above or below.
            ((point1.row == point2.row) && ((point1.column == point2.column + 1) || (point1.column == point2.column - 1))) // Left or right.
         )) {
            return true
        } else {
            return false
        }
}

function areEmpty(point1, point2) {
    return !board.boardState[point1.column][point1.row] && !board.boardState[point2.column][point2.row]
}

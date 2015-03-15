var PLAYER_1 = 1;
var PLAYER_2 = 2;
var size = 4;
var board = createBoard({
    title       : 'Noughts & Crosses',        
    rows        : size,
    columns     : size,
    pattern     : 'grid',
})

function twoDArray(size) {
    var array = new Array(size);
    for (var i = 0; i < size; i++) {
        array[i] = new Array(size);
        for (var j = 0; j < array[i].length; j++) {
            array[i][j] = 0;
        }
    }
    return array;
}
debugger;
state = twoDArray(size);
var combos = [];


var isPlayer1Turn = true

board.squareClickedAt = function(column, row) {
    debugger;
    // Is the square already occupied?
    if (state[column][row] !== 0) return;

    // Mark the square occupied.
    state[column][row] = isPlayer1Turn ? PLAYER_1 : PLAYER_2;

    board.setSquareAtColumnRowColor(column, row, isPlayer1Turn)

    if (isEndGameForLastMoveAt(column, row)) {
        board.showPopup("Game won!")
    }
    
    isPlayer1Turn = !isPlayer1Turn;
    //var playerMsg = isPlayer1Turn ? "First player won!" : "Second player won!";
    //board.showPopup(playerMsg)
};

function isEndGameForLastMoveAt(column, row) {
    var magicSquare = [[2, 9, 4], [7, 5, 3],[6, 1, 8]];
    player1 = []

    for (var c = 0; c < board.columns; c++) {
        for (var r = 0; r < board.rows; r++) {
            if (state[c][r] === PLAYER_1) {
                player1.push(magicSquare[c][r]);
            }
        }
    }
    
    console.log(player1.join(' '));
    
    printCombination(player1, player1.length, 3)
    
    for (var i = 0; i < combos.length; i++) {
        var sum = combos[i].reduce(function(a, b) {return a + b});
        if (sum === 15) {
            combos = [];
            return true;
        }
    }
    combos = [];
    return false;
}


function printCombination(arr, n, r)
{
    var data = [];
    data.length = r
    combinationUtil(arr, data, 0, n-1, 0, r);
}

function combinationUtil(arr, data, start, end, index, r)
{
    if (index == r) {
       console.log(data.slice(0, r).join("-"))
        combos.push(data.slice(0, r));
        return;
    }
 
    for (var i=start; i<=end && end-i+1 >= r-index; i++)
    {
        data[index] = arr[i];
        combinationUtil(arr, data, i+1, end, index+1, r);
    }
}
////http://www.geeksforgeeks.org/print-all-possible-combinations-of-r-elements-in-a-given-array-of-size-n/

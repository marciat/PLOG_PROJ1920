
:- use_module(library(lists)).
:- include('view.pl').
:- include('auxiliar.pl').

/*
empty cells - 0
white discs - 1
black discs - 2
*/


/* initBoard(-Board)
 * Board - variable to be initialized with a new board
 * initializes Board with a valid initial board layout */
initBoard(Board):-
	Board=[[0,0,0,0,0],
	       [0,1,1,1,0],
	       [0,0,0,0,0],
	       [0,2,2,2,0],
	       [0,0,0,0,0]].


/* initGame(-Board, +Player)
 * Board - variable in which the game board state will be stored
 * Player - player to make the first move, can be 1 (white discs) or 2 (black discs)
 * starts a new game
 * initializes a board and then displays the game */
initGame(Board, Player):-
	initBoard(Board),
	displayGame(Board,Player,0).

/* countBoardPieces(+Board, +Piece, -Number)
 * Board - board with pieces to be counted
 * Piece - type of pieces to be counted
 * Number - number of pieces of specified type on the board
 * counts the number of pieces of a certain type that are on the board
 */
countBoardPieces([], _, Number):-
	Number = 0.

countBoardPieces([H|T], Piece, Number):-
	count(H, Piece, Number),
	count(T, Piece, Number).

/* play
 * starts game */
play:-
	initGame(_, 1).

 %validMoves(+Board, +Player, -ListOfMoves)

 %move(+Move, +Board, -NewBoard)

 gameOver(Board, Winner):-
	countBoardPieces(Board, 1, White),
	countBoardPieces(Board, 2, Black),
	White > Black, !, Winner = 1.

gameOver(Board, Winner):-
	countBoardPieces(Board, 1, White),
	countBoardPieces(Board, 2, Black),
	Black > White, !, Winner = 2.

gameOver(_, Winner):-
	Winner = 0.





	


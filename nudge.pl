
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


/* play
 * starts game */
play:-
	initBoard(Board),
	playGame(Board, 1).

/* playGame(+Board, +Player)
 * Board - current game board
 * Player - current player
 * handles gameplay
 * displays game, handles moves and checks if game has ended after every move
 */
playGame(Board, Player):-
	displayGame(Board, Player, 0),
	gameOver(Board, Winner),
	Winner == 0, !,
	playerMove(Board, Board, Player, 0, NewBoard),
	displayGame(NewBoard, Player, 1),
	gameOver(NewBoard, Winner),
	Winner == 0, !,
	playerMove(NewBoard, Board, Player, 1, FinalBoard),
	NewPlayer is Player mod 2 + 1,
	playGame(FinalBoard, NewPlayer).
	
% if the game has ended
playGame(Board, _):-
	gameOver(Board, Winner),
	displayWinner(Winner).

/* gameOver(+Board, -Winner)
 * Board - game board
 * Winner - game winner, if there is one
 * checks if game has ended, by checking if one player has more pieces on the board than the other
 * Winner is 0 if the game has not ended
 */
gameOver(Board, Winner):-
	countBoardPieces(Board, 1, White),
	countBoardPieces(Board, 2, Black),
	(White > Black, Winner = 1;
	Black > White, Winner = 2;
	Winner = 0).

/* countBoardPieces(+Board, +Piece, -Number)
 * Board - board with pieces to be counted
 * Piece - type of pieces to be counted
 * Number - number of pieces of specified type on the board
 * counts the number of pieces of a certain type that are on the board
 */
countBoardPieces([], _, 0).

countBoardPieces([H|T], Piece, Number):-
	count(H, Piece, N),
	countBoardPieces(T, Piece, NewNumber),
    Number is NewNumber + N.

/* playerMove(+Board, +OriginalBoard, +Player, +MoveNr, -NewBoard)
 * Board - current board
 * OriginalBoard - board when player's turn started (different from Board if it's the second move)
 * Player - current player
 * MoveNr - current move of the player's turn (first or second)
 * NewBoard - new board after the move 
 * reads user input for a move, validates it and then applies the move to the board
 */
playerMove(Board, OriginalBoard, Player, MoveNr, NewBoard):-
	readMove(Board, Player, MoveNr, OriginalBoard, Move),
	move(Move, Board, NewBoard).


/* readMove(+Board, +Player, +MoveNr, +OriginalBoard, -Move)
 * Board - current board
 * Player - current player
 * MoveNr - current move of the player's turn (first or second)
 * OriginalBoard - board when player's turn started (different from Board if it's the second move)
 * Move - information about the move read
 *        list with coordinates of disc and direction to move it
 * reads move information input by the user, checks if it is valid
 * if it is not valid, asks for new input until a valid move is input
 */
readMove(Board, Player, MoveNr, OriginalBoard, Move):-
	write('Which disc do you want to move?'), nl, nl,
	write('Horizontal coord.: '),
	get_code(H),
	get_char(_),
	OldH is H - 64,
	nl, write('Vertical coord.: '),
	get_code(V),
	get_char(_),
	OldV is V - 48,
	nl, write('Direction (Up - U, Down - D, Left - L, Right - R): '),
	get_char(Direction),
	get_char(_),
	nl,
	isPlayerMoveValid(Board, Player, OriginalBoard, MoveNr, [OldH, OldV, Direction], Valid),
	(Valid == 1 -> Move = [OldH, OldV, Direction] ; 
	(write('That is not a valid move. Please try again.'), nl, nl, readMove(Board, Player, MoveNr, OriginalBoard, Move))).

/* move(+Move, +Board, -NewBoard)
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 * Board - current game board (before move is applied)
 * NewBoard - new game board (after move is applied)
 */
move(Move, Board, NewBoard):-
	[OldH, OldV | D] = Move,
	[Direction | _] = D,
	(Direction = 'U', NewH is OldH, NewV is OldV - 1;
	Direction = 'D', NewH is OldH, NewV is OldV + 1;
	Direction = 'L', NewH is OldH - 1, NewV is OldV;
	Direction = 'R', NewH is OldH + 1, NewV is OldV),
	nth1(OldV, Board, Line),
	nth1(OldH, Line, Player),
	replace(Line, OldH, 0, NewLine),
	replace(Board, OldV, NewLine, TmpBoard),
	nth1(NewV, TmpBoard, NewDiscLine),
	replace(NewDiscLine, NewH, Player, FinalLine),
	replace(TmpBoard, NewV, FinalLine, NewBoard).


/* isPlayerMoveValid(+Board, +Player, +OriginalBoard, +MoveNr, +Move, -Valid)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * MoveNr - current move of the player's turn (first or second)
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 * Valid - 1 if move is valid and 0 if it is not
 */
isPlayerMoveValid(Board, Player, OriginalBoard, MoveNr, Move, Valid):-
	[OldH, OldV | D] = Move,
	[Direction | _] = D,
	(Direction = 'U', NewH is OldH, NewV is OldV - 1;
	Direction = 'D', NewH is OldH, NewV is OldV + 1;
	Direction = 'L', NewH is OldH - 1, NewV is OldV;
	Direction = 'R', NewH is OldH + 1, NewV is OldV),
	nth1(OldV, Board, Line),
	nth1(OldH, Line, P),
	P==Player, !,
	Valid is 1.

isPlayerMoveValid(_,_,_,_,_,Valid):-
	Valid is 0.

%validMoves(+Board, +Player, -ListOfMoves)




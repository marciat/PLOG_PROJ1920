
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
	game(Board, Board, 1, 0, 0).


game(_, _, _, _, 1):-
	displayWinner(1).

game(_, _, _, _, 2):-
	displayWinner(2).

game(Board, OriginalBoard, Player, 0, _):-
	displayGame(Board, Player, 0),
	gameOver(Board, Winner1),
	playGame(Board, OriginalBoard, Player, 0, Winner1, NewBoard, NewPlayer),
	game(NewBoard, OriginalBoard, NewPlayer, 1, Winner1).

game(Board, OriginalBoard, Player, 1, _):-
	displayGame(Board, Player, 1),
	gameOver(Board, Winner1),
	playGame(Board, OriginalBoard, Player, 1, Winner1, NewBoard, NewPlayer),
	game(NewBoard, NewBoard, NewPlayer, 0, Winner1).

playGame(_, _, _, _, 1, _, _).
	
playGame(_, _, _, _, 2, _, _).

playGame(Board, OriginalBoard, 1, 0, _, NewBoard, NewPlayer):-
	playerMove(Board, OriginalBoard, 1, 0, NewBoard),
	NewPlayer is 1.

playGame(Board, OriginalBoard, 1, 1, _, NewBoard, NewPlayer):-
	playerMove(Board, OriginalBoard, 1, 1, NewBoard),
	NewPlayer is 2.

playGame(Board, OriginalBoard, 2, 0, _, NewBoard, NewPlayer):-
	playerMove(Board, OriginalBoard, 2, 0, NewBoard),
	NewPlayer is 2.

playGame(Board, OriginalBoard, 2, 1, _, NewBoard, NewPlayer):-
	playerMove(Board, OriginalBoard, 2, 1, NewBoard),
	NewPlayer is 1.

/* playGame(+Board, +Player)
 * Board - current game board
 * Player - current player
 * handles gameplay 
 * displays game, handles moves and checks if game has ended after every move
 */
playGame(Board, OriginalBoard, Player, Move, NewBoard):-
	gameOver(Board, Winner),
	Winner = 0, !,
	playerMove(Board, OriginalBoard, Player, Move, NewBoard).
	
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
	Black = White, Winner = 0).

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
	(write('Do you want to move a disc (D) or a line of discs (L)? '),
	getCodeInput(TypeCode, ValidType),
	char_code(Type, TypeCode),
	nl, nl,
	(ValidType = 1, Type = 'D', write('Which disc do you want to move?');
	ValidType = 1, Type = 'L', write('Coordinates of the first disc of the line:')),
	nl, nl,
	write('Horizontal coord.: '),
	getCodeInput(H, ValidH),
	ValidH = 1,
	OldH is H - 64,
	nl, write('Vertical coord.: '),
	getCodeInput(V, ValidV),
	ValidV = 1,
	OldV is V - 48,
	nl, write('Direction (Up - U, Down - D, Left - L, Right - R): '),
	getCodeInput(DirCode, ValidDir),
	char_code(Direction, DirCode),
	nl,
	ValidDir = 1,
	isPlayerMoveValid(Board, Player, OriginalBoard, MoveNr, [OldH, OldV, Direction, Type], Valid),
	Valid = 1, Move = [OldH, OldV, Direction, Type] ;
	write('That is not a valid move. Please try again.'), nl, nl,
	readMove(Board, Player, MoveNr, OriginalBoard, Move)).

/* move(+Move, +Board, -NewBoard)
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 * Board - current game board (before move is applied)
 * NewBoard - new game board (after move is applied)
 */
move(Move, Board, NewBoard):-
	nth1(4, Move, Type),
	(Type = 'D', simpleMove(Move, Board, NewBoard);
	Type = 'L', multipleMove(Move, Board, NewBoard)).


incrementPosition('U', [H,V|_], Increment, NewH, NewV):-
	NewH is H,
	NewV is V - Increment.

incrementPosition('D', [H,V|_], Increment, NewH, NewV):-
	NewH is H,
	NewV is V + Increment.

incrementPosition('L', [H,V|_], Increment, NewH, NewV):-
	NewH is H - Increment,
	NewV is V.

incrementPosition('R', [H,V|_], Increment, NewH, NewV):-
	NewH is H + Increment,
	NewV is V.

/* simpleMove(+Move, +Board, -NewBoard)
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 * Board - current game board (before move is applied)
 * NewBoard - new game board (after move is applied)
 * moves a single disc
 */
simpleMove(Move, Board, NewBoard):-
	[OldH, OldV | D] = Move,
	[Direction | _] = D,
	incrementPosition(Direction, [OldH, OldV], 1, NewH, NewV),
	getPosition(Board, OldH, OldV, Player),
	setPosition(Board, OldH, OldV, 0, TmpBoard),
	setPosition(TmpBoard, NewH, NewV, Player, NewBoard).


/* multipleMove(+Move, +Board, -NewBoard)
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 * Board - current game board (before move is applied)
 * NewBoard - new game board (after move is applied)
 * moves a line of discs
 */
multipleMove(Move, Board, NewBoard):-
	[OldH, OldV | D] = Move,
	[Direction | _] = D,
	getPosition(Board, OldH, OldV, Player),
	countLineOfDiscs(Board, [OldH, OldV], Direction, Player, PlayerDiscs),
	incrementPosition(Direction, [OldH, OldV], PlayerDiscs, NewH, NewV),
	setPosition(Board, OldH, OldV, 0, TmpBoard),
	getPosition(Board, NewH, NewV, Opponent),
	(Opponent = 0, setPosition(TmpBoard, NewH, NewV, Player, NewBoard);
		countLineOfDiscs(Board, [NewH, NewV], Direction, Opponent, OpponentDiscs),
		incrementPosition(Direction, [NewH, NewV], OpponentDiscs, OpponentH, OpponentV),
		(validCoords(Board, OpponentH, OpponentV, 1), setPosition(TmpBoard, OpponentH, OpponentV, Opponent, TmpBoard2), setPosition(TmpBoard2, NewH, NewV, Player, NewBoard);
		setPosition(TmpBoard, NewH, NewV, Player, NewBoard))).

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
	[Direction | T] = D,
	[Type | _] = T,
	(incrementPosition(Direction, [OldH, OldV], 1, NewH, NewV),
	validCoords(Board, OldH, OldV, 1),
	validCoords(Board, NewH, NewV, 1),
	getPosition(Board, OldH, OldV, Player),
	checkResetBoard(Board, OriginalBoard, Move, 1),
	(Type = 'D', getPosition(Board, NewH, NewV, 0);
	Type = 'L', validateLineMove(Board, Player, [OldH, OldV, Direction], 1)),
	Valid is 1);
	Valid is 0.

isPlayerMoveValid(_, _, _, _, _, Valid):-
	Valid is 0.

validateLineMove(Board, Player, MoveInfo, Valid):-
	[Horizontal, Vertical | D] = MoveInfo,
	[Direction | _] = D,
	countLineOfDiscs(Board, [Horizontal, Vertical], Direction, Player, PlayerDiscs),
	(PlayerDiscs > 1,
	incrementPosition(Direction, [Horizontal, Vertical], PlayerDiscs, NewH, NewV),
	validCoords(Board, NewH, NewV, 1),
	(getPosition(Board, NewH, NewV, 0);
		Opponent is Player mod 2 + 1,
		countLineOfDiscs(Board, [Horizontal, Vertical], Direction, Opponent, OpponentDiscs), 
		OpponentDiscs < PlayerDiscs),
	Valid is 1;
	Valid is 0).

checkResetBoard(Board, OriginalBoard, Move, Valid):-
	move(Move, Board, NewBoard), !,
	NewBoard \= OriginalBoard,
	Valid = 1.

checkResetBoard(_, _, _, Valid):-
	Valid = 0.
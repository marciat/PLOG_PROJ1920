
:- use_module(library(lists)).
:- use_module(library(random)).
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
	Board=[[2,1,1,0,0],
	       [0,0,0,0,0],
	       [0,0,0,0,0],
	       [0,0,2,0,0],
	       [0,0,0,0,0]].

/* play
 * starts game */
play:-
	initBoard(Board),
	readGameMode(Mode),
	game(Mode, Board, Board, 1, 0, 0).


readGameMode(Mode):-
	write('GAME MODE'), nl,
	write('1 - Player vs Player'), nl,
	write('2 - CPU vs CPU'), nl,
	write('3 - Player vs CPU'),
	repeat,
	nl,nl,
	write('Mode (insert number): '),
	getCodeInput(GameMode), !,
	Mode is GameMode - 48.


game(_, _, _, _, _, 1):-
	displayWinner(1).

game(_, _, _, _, _, 2):-
	displayWinner(2).
/* Mode Board OriginalBoard Player Move Winner
*/
game(Mode, Board, OriginalBoard, Player, 0, _):-
	displayGame(Board, Player, 0),
	gameOver(Board, Winner1),
	playGame(Mode, Board, OriginalBoard, Player, 0, Winner1, NewBoard, NewPlayer),
	game(Mode, NewBoard, OriginalBoard, NewPlayer, 1, Winner1).

game(Mode, Board, OriginalBoard, Player, 1, _):-
	displayGame(Board, Player, 1),
	gameOver(Board, Winner1),
	playGame(Mode, Board, OriginalBoard, Player, 1, Winner1, NewBoard, NewPlayer),
	game(Mode, NewBoard, NewBoard, NewPlayer, 0, Winner1).

playGame(_, _, _, _, _, 1, _, _).
	
playGame(_, _, _, _, _, 2, _, _).

playGame(Mode, Board, OriginalBoard, 1, 0, _, NewBoard, NewPlayer):-
	(Mode = 2, moveAILevel2(Board, 1, OriginalBoard, NewBoard);
	playerMove(Board, OriginalBoard, 1, 0, NewBoard)),
	NewPlayer is 1.

playGame(Mode, Board, OriginalBoard, 1, 1, _, NewBoard, NewPlayer):-
	(Mode = 2, moveAILevel2(Board, 1, OriginalBoard, NewBoard);
	playerMove(Board, OriginalBoard, 1, 1, NewBoard)),
	NewPlayer is 2.

playGame(Mode, Board, OriginalBoard, 2, 0, _, NewBoard, NewPlayer):-
	(Mode = 1, playerMove(Board, OriginalBoard, 2, 0, NewBoard);
	moveAILevel2(Board, 2, OriginalBoard, NewBoard)),
	NewPlayer is 2.

playGame(Mode, Board, OriginalBoard, 2, 1, _, NewBoard, NewPlayer):-
	(Mode = 1, playerMove(Board, OriginalBoard, 2, 1, NewBoard);
	moveAILevel2(Board, 2, OriginalBoard, NewBoard)),
	NewPlayer is 1.
	

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
	repeat,
	write('Do you want to move a disc (D) or a line of discs (L)? '),
	getCodeInput(TypeCode),
	char_code(Type, TypeCode),
	nl, nl,
	(Type = 'D', write('Which disc do you want to move?');
	Type = 'L', write('Coordinates of the first disc of the line:')),
	nl, nl,
	repeat,
	write('Horizontal coord.: '),
	getCodeInput(H),
	OldH is H - 64,
	repeat,
	nl, write('Vertical coord.: '),
	getCodeInput(V),
	OldV is V - 48,
	repeat,	
	nl, write('Direction (Up - U, Down - D, Left - L, Right - R): '),
	getCodeInput(DirCode),
	char_code(Direction, DirCode),
	validDirection(Direction),
	nl,
	isPlayerMoveValid(Board, Player, OriginalBoard, [OldH, OldV, Direction, Type], Valid),
	(Valid = 1, Move = [OldH, OldV, Direction, Type] ;
	write('That is not a valid move. Please try again.'), nl, nl,
	readMove(Board, Player, MoveNr, OriginalBoard, Move)).

validDirection('L').

validDirection('R').

validDirection('U').

validDirection('D').


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

/*incrementPosition('U', [H,Increment|_], 0, H, Increment, [0, H]).

incrementPosition('D', [H,0|_], Increment, H, Increment, [H, ]).

incrementPosition('L', [Increment,V|_], Increment, 0, V).

incrementPosition('R', [0,V|_], Increment, Increment, V).*/
/*///////////////////////////////////////////////*/

%incrementPosition(+Direction, +Coordinates, +Increment, +Candidates, -Final)

incrementPosition('U', [H,Increment|_], Increment, _, [H,0]).

incrementPosition('U', [H,V|_], Increment, [CH,CV|_], [FH,FV|_]):-
	(CH =:= H, CV =:= V - Increment, !, FH = CH, FV = CV;
	NewCV is CV-1,
	NewCH = H,
	incrementPosition('U', [H,V], Increment, [NewCH, NewCV], [FH,FV])).


incrementPosition('D', [H,0|_], Increment, _, [H,Increment]).

incrementPosition('D', [H,V|_], Increment, [CH,CV|_], [FH,FV|_]):-
	(CH =:= H, CV =:= V + Increment, !, FH = CH, FV = CV;
	NewCV is CV+1,
	NewCH = H,
	incrementPosition('D', [H,V], Increment, [NewCH, NewCV], [FH,FV])).


incrementPosition('L', [Increment,V|_], Increment, _, [0,V]).

incrementPosition('L', [H,V|_], Increment, [CH,CV|_], [FH,FV|_]):-
	(CH =:= H - Increment, CV =:= V, !, FH = CH, FV = CV;
	NewCH is CH-1,
	NewCV = V,
	incrementPosition('L', [H,V], Increment, [NewCH, NewCV], [FH,FV])).


incrementPosition('R', [0,V|_], Increment, _, [Increment,V]).

incrementPosition('R', [H,V|_], Increment, [CH,CV|_], [FH,FV|_]):-
	(CH =:= H + Increment, CV =:= V, !, FH = CH, FV = CV;
	NewCH is CH+1,
	NewCV = V,
	incrementPosition('R', [H,V], Increment, [NewCH, NewCV], [FH,FV])).


positionFromDirection(Direction, Coordinates, Increment, NewH, NewV):-
	[H,V|_] = Coordinates,
	incrementPosition(Direction, Coordinates, Increment, [H, V], [FH, FV]),
	NewH = FH,
	NewV = FV.
	


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
	positionFromDirection(Direction, [OldH, OldV], 1, NewH, NewV),
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
	positionFromDirection(Direction, [OldH, OldV], PlayerDiscs, NewH, NewV),
	setPosition(Board, OldH, OldV, 0, TmpBoard),
	getPosition(Board, NewH, NewV, Opponent),
	(Opponent = 0, setPosition(TmpBoard, NewH, NewV, Player, NewBoard);
		countLineOfDiscs(Board, [NewH, NewV], Direction, Opponent, OpponentDiscs),
		positionFromDirection(Direction, [NewH, NewV], OpponentDiscs, OpponentH, OpponentV),
		(validCoords(Board, OpponentH, OpponentV), setPosition(TmpBoard, OpponentH, OpponentV, Opponent, TmpBoard2), setPosition(TmpBoard2, NewH, NewV, Player, NewBoard);
		setPosition(TmpBoard, NewH, NewV, Player, NewBoard))).

/* isPlayerMoveValid(+Board, +Player, +OriginalBoard, +Move, -Valid)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 * Valid - 1 if move is valid and 0 if it is not
 */
isPlayerMoveValid(Board, Player, OriginalBoard, Move, Valid):-
	[OldH, OldV | D] = Move,
	[Direction | T] = D,
	[Type | _] = T,
	validCoords(Board, OldH, OldV),
	getPosition(Board, OldH, OldV, CellContent),
	CellContent = Player,
	(positionFromDirection(Direction, [OldH, OldV], 1, NewH, NewV),
	validCoords(Board, NewH, NewV),
	checkResetBoard(Board, OriginalBoard, Move, 1),
	(Type = 'D', getPosition(Board, NewH, NewV, 0);
	Type = 'L', validateLineMove(Board, Player, [OldH, OldV, Direction], 1)),
	Valid is 1);
	Valid is 0.

isPlayerMoveValid(_, _, _, _, 0).

validateLineMove(Board, Player, MoveInfo, Valid):-
	[Horizontal, Vertical | D] = MoveInfo,
	[Direction | _] = D,
	countLineOfDiscs(Board, [Horizontal, Vertical], Direction, Player, PlayerDiscs),
	(PlayerDiscs > 1,
	positionFromDirection(Direction, [Horizontal, Vertical], PlayerDiscs, NewH, NewV), !,
	validCoords(Board, NewH, NewV),
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

validMoves(Board, Player, OriginalBoard, ListOfMoves):-
	findall([HorizontalD, VerticalD, DirectionD, 'D'], isPlayerMoveValid(Board, Player, OriginalBoard, [HorizontalD, VerticalD, DirectionD, 'D'], 1), ListOfMovesD),
	findall([Horizontal, Vertical, Direction, 'L'], isPlayerMoveValid(Board, Player, OriginalBoard, [Horizontal, Vertical, Direction, 'L'], 1), ListOfMovesL),
	append(ListOfMovesD, ListOfMovesL, ListOfMoves).


value(Board, Player, Value):-	
	gameOver(Board, Winner),
	write(Winner), write(Player), nl,
	(Player = Winner, Value = 1;
	Value = 0).

findWinningMoves(_, _, [], []).

findWinningMoves(Board, Player, [H|T], ListOfWinning):-
	findWinningMoves(Board, Player, T, NewListOfWinning),
	move(H, Board, TmpBoard),
	value(TmpBoard, Player, Value),
	write(Value), nl,
	(Value = 1, append(NewListOfWinning, [H], ListOfWinning);
	Value = 0, append(NewListOfWinning, [], ListOfWinning)).
	

moveAILevel2(Board, Player, OriginalBoard, NewBoard):-
	validMoves(Board, Player, OriginalBoard, ListOfMoves),
	write(ListOfMoves), nl,
	findWinningMoves(Board, Player, ListOfMoves, ListOfWinning),
	write(ListOfWinning), nl,
	random_member(Move, ListOfWinning),
	move(Move, Board, NewBoard).	

moveAILevel1(Board, Player, OriginalBoard, NewBoard):-
	validMoves(Board, Player, OriginalBoard, ListOfMoves),
	random_member(Move, ListOfMoves),
	move(Move, Board, NewBoard).


:- use_module(library(lists)).
:- use_module(library(random)).
:- include('view.pl').
:- include('auxiliar.pl').

/*
empty cells - 0
white discs - 1
black discs - 2
*/

validDirection('L').

validDirection('R').

validDirection('U').

validDirection('D').

/* initBoard(-Board)
 * Board - variable to be initialized with a new board
 * initializes Board with a valid initial board layout */

initBoard(1, Board):-
	Board=[[0,0,0,0,0],
	       [0,1,1,1,0],
	       [0,0,0,0,0],
	       [0,2,2,2,0],
	       [0,0,0,0,0]].

initBoard(2, Board):-
	Board=[[1,0,1,0,1],
	       [0,0,0,0,0],
	       [0,0,0,0,0],
	       [0,0,0,0,0],
	       [2,0,2,0,2]].
		   
initBoard(3, Board):-
	Board=[[0,0,1,0,0],
	       [0,1,0,1,0],
	       [0,0,0,0,0],
	       [0,2,0,2,0],
	       [0,0,2,0,0]].
		   
initBoard(4, Board):-
	Board=[[0,1,0,1,0],
	       [0,0,1,0,0],
	       [0,0,0,0,0],
	       [0,0,2,0,0],
	       [0,2,0,2,0]].

/* play
 * starts game */
play:-
	chooseBoard(BoardNumber),
	initBoard(BoardNumber, Board),
	readGameMode(Mode, Level),
	game(Mode, Level, Board, Board, 1, 0, 0).

/*
* chooseBoard(-BoardNumber).
* BoardNumber - starting board number (1-4)
* shows the user the different board layouts
* saves the board number chosen by user
*/
chooseBoard(BoardNumber):-
	write('SELECT THE STARTING BOARD CONFIGURATION'),
	nl,nl,
	write('Board 1:'), nl,
	initBoard(1, Board1),
	getBoardDimensions(Board1, _, Columns1),
	printBoard(Board1, 49, Columns1),
	nl,
	write('Board 2:'), nl,
	initBoard(2, Board2),
	getBoardDimensions(Board2, _, Columns2),
	printBoard(Board2, 49, Columns2),
	nl,
	write('Board 3:'), nl,
	initBoard(3, Board3),
	getBoardDimensions(Board3, _, Columns3),
	printBoard(Board3, 49, Columns3),
	nl,
	write('Board 4:'), nl,
	initBoard(4, Board4),
	getBoardDimensions(Board4, _, Columns4),
	printBoard(Board4, 49, Columns4),
	repeat,
	nl,
	write('Starting Board (1, 2, 3, 4):'),
	getCodeInput(Number),
	(Number = 49; Number = 50; Number = 51; Number = 52), !,
	BoardNumber is Number - 48.

/*
Level
0 - pvp
1 - player vs cpu1 / cpu1 vs cpu1
2 - player vs cpu2 / cpu2 vs cpu2
3 - cpu1 vs cpu2
4 - cpu2 vs cpu1
*/

/* readGameMode(-Mode, -Level)
 * Mode - game mode
 * Level - game level
 * asks user to choose game mode and, if applicable, CPU level
 */
readGameMode(Mode, Level):-
	write('GAME MODE'), nl,
	write('1 - Player vs Player'), nl,
	write('2 - CPU vs CPU'), nl,
	write('3 - Player vs CPU'),
	repeat,
	nl,nl,
	write('Mode (insert number): '),
	getCodeInput(GameMode),
	(GameMode = 49; GameMode = 50; GameMode = 51), !,
	Mode is GameMode - 48,
	(Mode = 2,
	 repeat,
	 nl, nl,
	 write('CPU 1 Level (1 or 2): '),
	 getCodeInput(AI1Level),
	 (AI1Level = 49; AI1Level = 50), !,
	 nl, nl,
	 repeat,
	 write('CPU 2 Level (1 or 2): '),
	 getCodeInput(AI2Level),
	 (AI2Level = 49; AI2Level = 50), !,
	 (AI1Level = AI2Level, Level is AI1Level - 48;
	  AI1Level = 49, Level is 3;
	  Level is 4
	);
	(Mode = 3,
	 repeat,
	 nl, nl,  
	 write('CPU Level (1 or 2): '),
	 getCodeInput(AILevel),
	 (AILevel = 49; AILevel = 50), !,
	 Level is AILevel - 48;
	Level is 0)).

/* game(+Mode, +Board, +OriginalBoard, +Player, +MoveNr, +Winner).
 * Mode - number representing the game mode
 * Board - current game board
 * OriginalBoard - board at the state before the player's first move
 * Player - current active player
 * MoveNr - current movement for active player (0 or 1)
 * Winner - game's winner (0 until game ends)
 * displays board, checks for game over, and executes moves
 */

game(_, _, _, _, _, _, 1):-
	displayWinner(1).

game(_, _, _, _, _, _, 2):-
	displayWinner(2).

game(Mode, Level, Board, OriginalBoard, Player, 0, _):-
	displayGame(Board, Player, 0),
	gameOver(Board, Winner),
	playGame(Mode, Level, Board, OriginalBoard, Player, 0, Winner, NewBoard, NewPlayer),
	game(Mode, Level, NewBoard, OriginalBoard, NewPlayer, 1, Winner).

game(Mode, Level, Board, OriginalBoard, Player, 1, _):-
	displayGame(Board, Player, 1),
	gameOver(Board, Winner),
	playGame(Mode, Level, Board, OriginalBoard, Player, 1, Winner, NewBoard, NewPlayer),
	game(Mode, Level, NewBoard, NewBoard, NewPlayer, 0, Winner).


/* playGame(+Mode, +Level, +Board, +OriginalBoard, +Player, +MoveNr, +Winner, -NewBoard, -NewPlayer).
 * Mode - number representing the game mode
 * Level - number representing the game level
 * Board - current game board
 * OriginalBoard - board at the state before the player's first move
 * Player - current active player
 * MoveNr - current movement for active player (0 or 1)
 * Winner - game's winner (0 until game ends)
 * NewBoard - game board after executing the move
 * NewPlayer - player who moves next
 * calls function to read move (player) or choose move (AI) and updates board, move number and player
 */

playGame(_, _, _, _, _, _, 1, _, _).
	
playGame(_, _, _, _, _, _, 2, _, _).

playGame(Mode, Level, Board, OriginalBoard, 1, 0, _, NewBoard, NewPlayer):-
	(Mode = 2, chooseMove(Board, 1, OriginalBoard, Level, Move);
	readMove(Board, 1, 0, OriginalBoard, Move)),
	move(Move, Board, NewBoard),
	(Mode = 2, write(' '), getCodeInput(_); true),
	NewPlayer is 1.

playGame(Mode, Level, Board, OriginalBoard, 1, 1, _, NewBoard, NewPlayer):-
	(Mode = 2, chooseMove(Board, 1, OriginalBoard, Level, Move);
	readMove(Board, 1, 1, OriginalBoard, Move)),
	move(Move, Board, NewBoard),
	(Mode = 2, write(' '), getCodeInput(_); true),
	NewPlayer is 2.

playGame(Mode, Level, Board, OriginalBoard, 2, 0, _, NewBoard, NewPlayer):-
	(Mode = 1, readMove(Board, 2, 0, OriginalBoard, Move);
	chooseMove(Board, 2, OriginalBoard, Level, Move)),
	move(Move, Board, NewBoard),
	(Mode = 2, write(' '), getCodeInput(_); true),
	NewPlayer is 2.

playGame(Mode, Level, Board, OriginalBoard, 2, 1, _, NewBoard, NewPlayer):-
	(Mode = 1, readMove(Board, 2, 1, OriginalBoard, Move);
	chooseMove(Board, 2, OriginalBoard, Level, Move)),
	move(Move, Board, NewBoard),
	(Mode = 2, write(' '), getCodeInput(_); true),
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

/* readMove(+Board, +Player, +MoveNr, +OriginalBoard, -Move)
 * Board - current board
 * Player - current player
 * MoveNr - current move of the player's turn (first or second)
 * OriginalBoard - board when player's turn started (different from Board if it's the second move)
 * Move - information about the move read
 *        list with coordinates of disc, direction to move it and type (disc or line)
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
	(isPlayerMoveValid(Board, Player, OriginalBoard, [OldH, OldV, Direction, Type]),
	Move = [OldH, OldV, Direction, Type] ;
	write('That is not a valid move. Please try again.'), nl, nl,
	readMove(Board, Player, MoveNr, OriginalBoard, Move)).


/* move(+Move, +Board, -NewBoard)
 * Move - information about the move
 *        list with coordinates of disc, direction to move it and type (disc or line)
 * Board - current game board (before move is applied)
 * NewBoard - new game board (after move is applied)
 * executes a move and generates a new, updated board
 */
move(Move, Board, NewBoard):-
	nth1(4, Move, Type),
	(Type = 'D', simpleMove(Move, Board, NewBoard);
	Type = 'L', multipleMove(Move, Board, NewBoard)).

/* incrementPosition(+Direction, +Coordinates, +Increment, +Candidates, -Final)
 * Direction - direction in which to increment
 * Coordinates - initial position coordinates
 * Increment - number of units to increment
 * Candidates - current coordinates being checked and incremented
 * Final - final incremented coordinates
 * increments position in a given direction, in a recursive way
 * increments candidates one unit every recursive call and compares them with the expected final value
 * if it is the expected final value, save it in Final
 */
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

/* positionFromDirection(+Direction, +Coordinates, +Increment, -NewH, -NewV)
 * Direction - direction for the increment
 * Coordinates - starting coordinates
 * Increment - position increment
 * NewH - new horizontal coordinate after increment
 * NewV - new vertical coordinate after increment
 */
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

/* isPlayerMoveValid(+Board, +Player, +OriginalBoard, +Move)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * Move - information about the move
 *        list with coordinates of disc and direction to move it
 */
isPlayerMoveValid(Board, Player, OriginalBoard, Move):-
	[OldH, OldV | D] = Move,
	[Direction | T] = D,
	[Type | _] = T,
	validCoords(Board, OldH, OldV),
	getPosition(Board, OldH, OldV, CellContent),
	CellContent = Player,
	positionFromDirection(Direction, [OldH, OldV], 1, NewH, NewV),
	validCoords(Board, NewH, NewV),
	checkResetBoard(Board, OriginalBoard, Move),
	(Type = 'D', getPosition(Board, NewH, NewV, 0);
	Type = 'L', validateLineMove(Board, Player, [OldH, OldV, Direction])).

/* validateLineMove(+Board, +Player, +MoveInfo)
 * Board - current game board
 * Player - current player
 * MoveInfo - information about the move, list with coordinates of disc and direction to move it
 */
validateLineMove(Board, Player, MoveInfo):-
	[Horizontal, Vertical | D] = MoveInfo,
	[Direction | _] = D,
	countLineOfDiscs(Board, [Horizontal, Vertical], Direction, Player, PlayerDiscs),
	(PlayerDiscs > 1,
	positionFromDirection(Direction, [Horizontal, Vertical], PlayerDiscs, NewH, NewV), !,
	validCoords(Board, NewH, NewV),
	(getPosition(Board, NewH, NewV, 0);
		Opponent is Player mod 2 + 1,
		countLineOfDiscs(Board, [NewH, NewV], Direction, Opponent, OpponentDiscs), !,
		OpponentDiscs < PlayerDiscs,
		positionFromDirection(Direction, [NewH,NewV], OpponentDiscs, NewEnemyH, NewEnemyV),
		getPosition(Board, NewEnemyH, NewEnemyV, 0))).

/* checkResetBoard(+Board, +OriginalBoard, +Move)
 * Board - current game board
 * OriginalBoard - game board in the beginning of player's turn
 * Move - information about the move, list with coordinates of disc, direction to move it and type (disc or line)
 */
checkResetBoard(Board, OriginalBoard, Move):-
	move(Move, Board, NewBoard), !,
	NewBoard \= OriginalBoard.

/* chooseMove(+Board, +Player, +OriginalBoard, +MoveNr, -Move)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * Level - game level
 * Move - information of the chosen move
 * chooses a move for the cpu, depending ont the game level
 */
chooseMove(Board, Player, OriginalBoard, 1, Move):-
	moveAILevel1(Board, Player, OriginalBoard, Move).

chooseMove(Board, Player, OriginalBoard, 2, Move):-
	moveAILevel2(Board, Player, OriginalBoard, Move).

chooseMove(Board, Player, OriginalBoard, 3, Move):-
	(Player = 1, moveAILevel1(Board, Player, OriginalBoard, Move);
	 Player = 2, moveAILevel2(Board, Player, OriginalBoard, Move)).

chooseMove(Board, Player, OriginalBoard, 4, Move):-
	(Player = 1, moveAILevel2(Board, Player, OriginalBoard, Move);
	 Player = 2, moveAILevel1(Board, Player, OriginalBoard, Move)).

/* validMoves(+Board, +Player, +OriginalBoard, -ListOfMoves)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * ListOfMoves - list of valid moves
 * returns a list with all valid moves for current player
 */
validMoves(Board, Player, OriginalBoard, ListOfMoves):-
	(setof([HorizontalD, VerticalD, DirectionD, 'D'], isPlayerMoveValid(Board, Player, OriginalBoard, [HorizontalD, VerticalD, DirectionD, 'D']), ListOfMovesD);
	ListOfMovesD = []),
	(setof([Horizontal, Vertical, Direction, 'L'], isPlayerMoveValid(Board, Player, OriginalBoard, [Horizontal, Vertical, Direction, 'L']), ListOfMovesL);
	ListOfMovesL = []),
	append(ListOfMovesD, ListOfMovesL, ListOfMoves).

/* isWinningPosition(+Board, +Player)
 * Board - board to be evaluated
 * Player - player that should be the winner
 * checks if with the given Board, Player can make a subsequent move that allows them to win
 */
isWinningPosition(Board, Player):-
	validMoves(Board, Player, Board, ListOfMoves),
	findWinningMoves(Board, Player, ListOfMoves, ListOfWinning),
	length(ListOfWinning, L), !, L>0.

/* value(+Board, +Player, -Value)
 * Board - game board to be evaluated
 * Player - player from which's perspective the board will be evaluated
 * Value - board value
 * finds board value by evaluating it according to different criteria
 * these criteria are: if this board means Player has won (3), if it means Player could lose (0), if it means Player could win (2) or if it is neutral (1)
 */
value(Board, Player, Value):-	
	(gameOver(Board, Player), Value = 3;
	 Opponent is Player mod 2 + 1,
	 isWinningPosition(Board, Opponent), Value is 0;
	 isWinningPosition(Board, Player), Value is 2;
	 Value = 1).


/* listMovesByValue(+Board, +Player, +ListOfMoves, -ListByValues)
 * Board - current game board
 * Player - current player
 * ListOfMoves - list of possible valid movements
 * ListByValues - list with lists of movements by value
 * sorts possible moves by value
 */
listMovesByValue(_, _, [], [[],[],[],[]]).

listMovesByValue(Board, Player, [Move|ListOfMoves], ListByValues):-
	listMovesByValue(Board, Player, ListOfMoves, NewListByValues),
	move(Move, Board, TmpBoard),
	value(TmpBoard, Player, Value),
    (Value = 3, nth1(1, NewListByValues, CurrList), 
				append(CurrList, [Move], UpdatedList),
				replace(NewListByValues, 1, UpdatedList, ListByValues);

	 Value = 2, nth1(2, NewListByValues, CurrList), 
				append(CurrList, [Move], UpdatedList),
				replace(NewListByValues, 2, UpdatedList, ListByValues);

	 Value = 1, nth1(3, NewListByValues, CurrList), 
				append(CurrList, [Move], UpdatedList),
				replace(NewListByValues, 3, UpdatedList, ListByValues);

	 Value = 0, nth1(4, NewListByValues, CurrList), 
				append(CurrList, [Move], UpdatedList),
				replace(NewListByValues, 4, UpdatedList, ListByValues)).

/* findWinningMoves(+Board, +Player, +ListOfMoves, -ListOfWinning)
 * Board - game board
 * Player - player that should win
 * ListOfMoves - list of possible moves for Player with Board
 * ListOfWinning - list of moves that allow player to win
 * given a list of possible moves, finds the moves with which Player wins
 */
findWinningMoves(_, _, [], []).

findWinningMoves(Board, Player, [Move|ListOfMoves], ListOfWinning):-
	findWinningMoves(Board, Player, ListOfMoves, NewListOfWinning),
	move(Move, Board, TmpBoard),
	(gameOver(TmpBoard, Player), append(NewListOfWinning, [Move], ListOfWinning);
	append(NewListOfWinning, [], ListOfWinning)).

/* moveAILevel1(+Board, +Player, +OriginalBoard, -Move)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * Move - chosen move
 * returns with a randomly selected possible move
 */
moveAILevel1(Board, Player, OriginalBoard, Move):-
	validMoves(Board, Player, OriginalBoard, ListOfMoves),
	random_member(Move, ListOfMoves).

/* moveAILevel2(+Board, +Player, +OriginalBoard, -Move)
 * Board - current game board
 * Player - current player
 * Original Board - game board in the beginning of player's turn
 * Move - chosen move 
 * returns with a randomly selected possible move with highest value
 */
moveAILevel2(Board, Player, OriginalBoard, Move):-
	validMoves(Board, Player, OriginalBoard, ListOfMoves),
	listMovesByValue(Board, Player, ListOfMoves, ListByValues),
	(\+nth1(1,ListByValues,[]), nth1(1, ListByValues, CurrList), random_member(Move, CurrList);
	\+nth1(2,ListByValues,[]), nth1(2, ListByValues, CurrList), random_member(Move, CurrList);
	\+nth1(3,ListByValues,[]), nth1(3, ListByValues, CurrList), random_member(Move, CurrList);
	\+nth1(4,ListByValues,[]), nth1(4, ListByValues, CurrList), random_member(Move, CurrList)).

% empty cells - 0 - ' '
% white discs - 1 - 'W'
% black discs - 2 - 'B'

symbol(0, ' ').
symbol(1, 'W').
symbol(2, 'B').

% white discs player - 1 - 'W'
% black discs player - 2- 'B'

player_symbol(1, 'W').
player_symbol(2, 'B').

% increment(+X, -X1)
% X - original value
% X1 - incremented value
% increments X by 1 and stores the result in X1
increment(X, X1) :-
	X1 is X+1.

% decrement(+X, -X1)
% X - original value
% X1 - decremented value
% decrements X by 1 and stores the result in X1
decrement(X, X1) :-
	X1 is X-1.

% getNumberOfColumns(+[H|_], -Columns)
% [H|T] - Board
% Columns - Number of columns of Board
% given a board, counts the number of items in the first line (H - head),
% which is the number of columns of the board
getNumberOfColumns([H|_], Columns):-
	length(H, Columns).

% displayGame(+Board, +Player, +Move)
% Board - Board to be displayed
% Player - current player number
% Move - current player move number
% displays the current game state
% prints horizontal coordinates, board and player
displayGame(Board, Player, Move):-
	nl, nl,
	[H|_] = Board, 
	write('  '),
	printHorizontalCoordinates(H, 65),
	nl,
	getNumberOfColumns(Board, Columns),
	printBoard(Board, 49, Columns),
	nl, nl,
	printPlayer(Player, Move),
	nl, nl.


printBoard([L|T], 49, Columns):-
	write('   '),
	put_code(201), printTopBorder(Columns),
	put_code(49),
	write('  '),
	printLine(L),
	nl,
	printBoard(T, 50, Columns).

printBoard([], _, Columns):-
	write('   '),
	put_code(200),
	printBottomBorder(Columns),
	put_code(188), nl.

printBoard([L|T], LineNr, Columns):-
	write('   '),
	put_code(204), printDivider(Columns), put_code(185), nl,
	put_code(LineNr),
	write('  '),
	printLine(L),
	nl,
	increment(LineNr, NewLineNr),
	printBoard(T, NewLineNr, Columns).

printLine([]):-
	put_code(186).

printLine([C|T]):-
	put_code(186),
	printCell(C),
	printLine(T).

printCell([]).

printCell(C):-
	symbol(C,S),
	write(' '),
	write(S),
	write(' ').

printHorizontalCoordinates([], _).

printHorizontalCoordinates([_|T], LetterCode):-
	write('   '),
	put_code(LetterCode),
	increment(LetterCode, NewLetterCode),
	printHorizontalCoordinates(T,NewLetterCode).

printDivider(1):-
	put_code(205), put_code(205), put_code(205).	

printDivider(NrColumns):-
	put_code(205), put_code(205), put_code(205),
	put_code(206),
	decrement(NrColumns, NewNr),
	printDivider(NewNr).

printTopBorder(1):-
	put_code(205), put_code(205), put_code(205),
	put_code(187), nl.

printTopBorder(NrColumns):-
	put_code(205), put_code(205), put_code(205),
	put_code(203),
	decrement(NrColumns, NewNr),
	printTopBorder(NewNr).	

printBottomBorder(1):-
	put_code(205), put_code(205), put_code(205).

printBottomBorder(NrColumns):-
	put_code(205), put_code(205), put_code(205),
	put_code(202),
	decrement(NrColumns, NewNr),
	printBottomBorder(NewNr).

printPlayer(Player, Move):-
	write('Player '),
	player_symbol(Player, S),
	write(S),
	write('  -  Move '),
	write(Move).


simbolo(0, ' ').
simbolo(1, 'W').
simbolo(2, 'B').

player_symbol(1, 'W').
player_symbol(2, 'B').

% empty cells - 0
% white discs - 1
% black discs - 2

increment(X, X1) :-
	X1 is X+1.

displayGame(Board, Player):-
	nl, nl,
	write('     A   B   C   D   E'),
	nl,
	printBoard(Board, 49),
	nl, nl,
	write('Player '),
	player_symbol(Player, S),
	write(S),
	nl, nl.

printBoard([L|T], 49):-
	printTopBorder(_),
	put_code(49),
	write('  '),
	printLine(L),
	nl,
	printBoard(T, 50).

printBoard([], _):-
	write('   '),
	put_code(200),
	put_code(205), put_code(205), put_code(205),
	put_code(202),
	put_code(205), put_code(205), put_code(205),
	put_code(202),
	put_code(205), put_code(205), put_code(205),
	put_code(202),
	put_code(205), put_code(205), put_code(205),
	put_code(202),
	put_code(205), put_code(205), put_code(205),
	put_code(188), nl.

printBoard([L|T], LineNr):-
	printDivider(_),
	put_code(LineNr),
	write('  '),
	printLine(L),
	nl,
	increment(LineNr, NewLineNr),
	printBoard(T, NewLineNr).

printLine([]):-
	put_code(186).

printLine([C|T]):-
	put_code(186),
	printCell(C),
	printLine(T).

printCell([]).

printCell(C):-
	simbolo(C,S),
	write(' '),
	write(S),
	write(' ').

printDivider(_):-
	write('   '),
	put_code(204),
	put_code(205), put_code(205), put_code(205),
	put_code(206),
	put_code(205), put_code(205), put_code(205),
	put_code(206),
	put_code(205), put_code(205), put_code(205),
	put_code(206),
	put_code(205), put_code(205), put_code(205),
	put_code(206),
	put_code(205), put_code(205), put_code(205),
	put_code(185), nl.

printTopBorder(_):-
	write('   '),
	put_code(201),
	put_code(205), put_code(205), put_code(205),
	put_code(203),
	put_code(205), put_code(205), put_code(205),
	put_code(203),
	put_code(205), put_code(205), put_code(205),
	put_code(203),
	put_code(205), put_code(205), put_code(205),
	put_code(203),
	put_code(205), put_code(205), put_code(205),
	put_code(187), nl.
	
:-use_module(library(lists)).

simbolo(0, ' ').
simbolo(1, 'B').
simbolo(2, 'P').

player_symbol(1, 'B').
player_symbol(2, 'P').

% celulas vazias - 0
% discos brancos - 1
% discos pretos - 2

increment(X, X1) :-
	X1 is X+1.

initBoard(X):-
	X=[[2,0,2,0,2],
	   [0,0,0,0,0],
	   [0,0,0,0,0],
	   [0,0,0,0,0],
	   [1,0,1,0,1]].

printBoard([], LineNr):-
	write('   ---------------------').

printBoard([L|T], LineNr):-
	write('   ---------------------'),
	nl,
	put_code(LineNr),
	write('  '),
	printLine(L),
	nl,
	increment(LineNr, NewLineNr),
	printBoard(T, NewLineNr).

printLine([]):-
	write('|').

printLine([C|T]):-
	write('| '),
	printCell(C),
	printLine(T).

printCell([]).

printCell(C):-
	simbolo(C,S),
	write(S),
	write(' ').

initGame(Board, Player):-
	initBoard(Board),
	displayGame(Board,Player),
	nl.

displayGame(Board, Player):-
	nl,
	write('Player '),
	player_symbol(Player, S),
	write(S),
	nl,
	nl,
	write('     A   B   C   D   E'),
	nl,
	printBoard(Board, 49).

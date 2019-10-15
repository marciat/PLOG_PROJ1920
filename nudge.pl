:-use_module(library(lists)).

simbolo(0, ' ').
simbolo(1, 'B').
simbolo(2, 'P').

player_symbol(1, 'B').
player_symbol(2, 'P').

% celulas vazias - 0
% discos brancos - 1
% discos pretos - 2

initBoard(X):-
	X=[[2,0,2,0,2],
	   [0,0,0,0,0],
	   [0,0,0,0,0],
	   [0,0,0,0,0],
	   [1,0,1,0,1]].

printBoard([]):-
	write('---------------------').
	
printLine([]):-
	write('|').

printCell([]).

printBoard([L|T]):-
	write('---------------------'),
	nl,
	printLine(L),
	nl,
	printBoard(T).

printLine([C|T]):-
	write('| '),
	printCell(C),
	printLine(T).

printCell(C):-
	simbolo(C,S),
	write(S),
	write(' ').

initGame(Board, Player):-
	initBoard(Board),
	displayGame(Board,Player),
	nl.

displayGame(Board, Player):-
	write('Player '),
	player_symbol(Player, S),
	write(S),
	nl,
	nl,
	printBoard(Board).

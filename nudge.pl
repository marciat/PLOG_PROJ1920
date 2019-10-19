:-use_module(library(lists)).
:-include('view.pl').

% empty cells - 0
% white discs - 1
% black discs - 2

initBoard(Board):-
	Board=[[0,0,0,0,0],
	       [0,1,1,1,0],
	       [0,0,0,0,0],
	       [0,2,2,2,0],
	       [0,0,0,0,0]].

initGame(Board, Player):-
	initBoard(Board),
	displayGame(Board,Player).

:-use_module(library(lists)).
:-include('view.pl').

initBoard(X):-
	X=[[2,0,2,0,2],
	   [0,0,0,0,0],
	   [0,0,0,0,0],
	   [0,0,0,0,0],
	   [1,0,1,0,1]].

initGame(Board, Player):-
	initBoard(Board),
	displayGame(Board,Player).

:-use_module(library(lists)).
:-include('view.pl').

% empty cells - 0
% white discs - 1
% black discs - 2

% initBoard(-Board)
% Board - variable to be initialized with a new board
% initializes Board with a valid initial board layout
initBoard(Board):-
	Board=[[0,0,0,0,0],
	       [0,1,1,1,0],
	       [0,0,0,0,0],
	       [0,2,2,2,0],
	       [0,0,0,0,0]].

% initGame(-Board, +Player)
% Board - variable in which the game board state will be stored
% Player - player to make the first move, can be 1 (white discs) or 2 (black discs)
% starts a new game
% initializes a board and then displays the game
initGame(Board, Player):-
	initBoard(Board),
	displayGame(Board,Player,0).

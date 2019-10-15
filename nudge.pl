:-use_module(library(lists)).

% celulas vazias - 0
% discos brancos - 1
% discos pretos - 2

initBoard(X):-
	L1 = [2,0,2,0,2],
	L2 = [0,0,0,0,0],
	L3 = [0,0,0,0,0],
	L4 = [0,0,0,0,0],
	L5 = [1,0,1,0,1].
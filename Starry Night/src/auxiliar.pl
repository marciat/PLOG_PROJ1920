getBoardSide(Board, Side):-
	length(Board, Total),
	Side * Side #= Total,
	Side #>= 0.

validCoords(Board, Horizontal, Vertical):-
	getBoardSide(Board, Side),
	Horizontal #> 0, Vertical #> 0,
	Horizontal #=< Side, Vertical #=< Side.

getLine(Board, LineNr, Line):-
	getBoardSide(Board, Side),
	LineStart is (LineNr - 1) * Side + 1,
	getSublist(Board, LineStart, Side, Line).

getColumn(Board, ColNr, Column):-
	getBoardSide(Board, Side),
	getColumnRecursive(Board, ColNr, Column, Side).

getColumnRecursive(_, _, [], 0):- !.

getColumnRecursive(Board, ColNr, Column, CurrIndex):-
	CurrIndex > 0,
	NewIndex is CurrIndex - 1,
	getColumnRecursive(Board, ColNr, TmpColumn, NewIndex),
	getLine(Board, CurrIndex, Line),
	nth1(ColNr, Line, Element),
	append(TmpColumn, [Element], Column).

/* get sublist starting at Index with Nr elements
*/
getSublist(List, Index, 1, Sublist):-
	nth1(Index, List, Element),
	Sublist = [Element], !.

getSublist(List, Index, Nr, Sublist):-
	Nr > 1,
	NewNr is Nr - 1,
	getSublist(List, Index, NewNr, TmpSublist),!,
	IndexInList is Index + Nr - 1,!,
	nth1(IndexInList, List, Element),!,
	append(TmpSublist, [Element], Sublist).

boardToLists(Board, Matrix):-
	getBoardSide(Board, Side),
	boardToLists(Board, Side, 1, Matrix).

boardToLists(Board, Side, Side, Matrix):-
	getLine(Board, Side, Line),
	Matrix = [Line].

boardToLists(Board, Side, CurrentLine, Matrix):-
	NewLine is CurrentLine + 1,
	boardToLists(Board, Side, NewLine, TmpMatrix),
	getLine(Board, CurrentLine, Line),
	append([Line], TmpMatrix, Matrix).
	  
getEmptySolutionBoard(Side, Board):-
	BoardLength is Side * Side,
	length(Board, BoardLength),
	fillEmptyBoard(Board, BoardLength).

fillEmptyBoard(_,0):- !.

fillEmptyBoard(Board, Index):-
	NewIndex is Index - 1,
	fillEmptyBoard(Board, NewIndex),
	nth1(Index, Board, 0).
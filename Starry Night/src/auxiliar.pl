getPosition(Board, Horizontal, Vertical, Content):-
	(getBoardSide(Board, Side),
	validCoords(Board, Horizontal, Vertical),
	CellIndex is Horizontal + (Vertical-1)*Side,
	nth1(CellIndex, Board, Content);
	Content is -1).

setPosition(Board, Horizontal, Vertical, Content, NewBoard):-
	(getBoardSide(Board, Side),
	validCoords(Board, Horizontal, Vertical),
	CellIndex is Horizontal + (Vertical-1)*Side,
	nth1(CellIndex, Board, Content),
	replace(Board, CellIndex, Content, NewBoard);
	NewBoard is []).

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

getColumnRecursive(_, _, [], 0).

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
	Sublist = [Element].

getSublist(List, Index, Nr, Sublist):-
	Nr > 1,
	NewNr is Nr - 1,
	getSublist(List, Index, NewNr, TmpSublist),!,
	IndexInList is Index + Nr - 1,!,
	nth1(IndexInList, List, Element),!,
	append(TmpSublist, [Element], Sublist).


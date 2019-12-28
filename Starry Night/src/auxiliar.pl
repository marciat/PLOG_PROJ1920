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



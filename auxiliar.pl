/* count(+List, +Element, -NumberOfOcurrences)
 * List - list with elements
 * Element - element whose number of ocurrences will be counted
 * NumberOfOcurrences - number of ocurrences of Element in List
 * counts the number of ocurrences of a specific element in a list */
count([], _, 0).

count([E|T], E, N):-
	count(T, E, N1),
	N is N1 + 1.

count([X|T], E, N):-
	X\=E,
	count(T,E,N).


/* countBoardPieces(+Board, +Piece, -Number)
 * Board - board with pieces to be counted
 * Piece - type of pieces to be counted
 * Number - number of pieces of specified type on the board
 * counts the number of pieces of a certain type that are on the board
 */
countBoardPieces([], _, 0).

countBoardPieces([H|T], Piece, Number):-
	count(H, Piece, N),
	countBoardPieces(T, Piece, NewNumber),
    Number is NewNumber + N.


/* getPosition(+Board, +Horizontal, +Vertical, -Content)
 * Board - game board
 * Horizontal - horizontal coordinate
 * Vertical - vertical coordinate
 * Content - content of the cell with the given coordinates
 * gets content of cell with specified coordinates
 */
getPosition(Board, Horizontal, Vertical, Content):-
	nth1(Vertical, Board, Line),
	nth1(Horizontal, Line, Content).


/* replace(+List, +Index, +Element, -NewList)
 * replaces element at Index of List by Element
 * and saves the result in NewList
 */

replace([_| Tail], 1, Element, NewList):-
	append([Element], Tail, NewList).

replace([Head|Tail], Index, Element, NewList):-
	NewIndex is Index - 1,
	replace(Tail, NewIndex, Element, TmpList),
	append([Head], TmpList, NewList).


/* setPosition(+Board, +Horizontal, +Vertical, +Content, -NewBoard)
 * Board - game board
 * Horizontal - horizontal coordinate
 * Vertical - vertical coordinate
 * Content - content to put on the cell with the given coordinates
 * NewBoard - new board after changing the cell content
 */
setPosition(Board, Horizontal, Vertical, Content, NewBoard):-
	nth1(Vertical, Board, Line),
	replace(Line, Horizontal, Content, NewLine),
	replace(Board, Vertical, NewLine, NewBoard).
symbol(0, ' ').
symbol(1, 'O').
symbol(2, '@').
symbol(3, '*').


displayPuzzle(Board, SolBoard):-
	nl, nl, 
	getBoardSide(SolBoard, Side),
	boardToLists(SolBoard, MatrixBoard),
	printBoard(MatrixBoard, 1, Side),
	nl, nl. 

/* printBoard(+Board, +LineNr, +Columns)
 * Board - Board to be displayed
 * LineNr - Index of line currently being printed 
 * Columns - Number of board columns */

% if the first line is being printed, print top border and line contents
printBoard([L|T], 1, Columns):-
	put_code(201), printTopBorder(Columns),
	printLine(L),
	nl,
	printBoard(T, 2, Columns).

% if all lines have been printed, print only the bottom border
printBoard([], _, Columns):-
	put_code(200),
	printBottomBorder(Columns),
	put_code(188), nl.

% for the rest of the lines, print divider and line contents
printBoard([L|T], LineNr, Columns):-
	put_code(204), printDivider(Columns), put_code(185), nl,
	printLine(L),
	nl,
	NewLineNr is LineNr + 1,
	printBoard(T, NewLineNr, Columns).

/* printLine(+Line)
 * Line - board line to be printed
 * prints a board line */

% if all cells have been printed, print only the vertical divider
printLine([]):-
	put_code(186).

% print vertical divider and cell content
printLine([C|T]):-
	put_code(186),
	printCell(C),
	printLine(T).


/* printCell(+Cell)
 * Cell - cell to be printed
 * prints cell content */

% if cell is empty there is nothing to display
printCell([]).

% print symbol associated to cell content
printCell(C):-
	symbol(C,S),
	write(' '),
	write(S),
	write(' ').

/* printDivider(+NrColumns)
 * NrColumns - number of columns to be printed
 * prints the horizontal divider between lines */

% if there is only one column left, print the divider
printDivider(1):-
	put_code(205), put_code(205), put_code(205).	

% print the divider and decrement number of columns
printDivider(NrColumns):-
	put_code(205), put_code(205), put_code(205),
	put_code(206),
	NewNr is NrColumns - 1,
	printDivider(NewNr).

/* printTopBorder(+NrColumns)
 * NrColumns - number of columns to be printed
 * prints the top border of board */

% if there is only one column left, print the top border
printTopBorder(1):-
	put_code(205), put_code(205), put_code(205),
	put_code(187), nl.

% print the top border and decrement number of columns
printTopBorder(NrColumns):-
	put_code(205), put_code(205), put_code(205),
	put_code(203),
	NewNr is NrColumns - 1,
	printTopBorder(NewNr).	


/* printTopBorder(+NrColumns)
 * NrColumns - number of columns to be printed
 * prints the bottom border of board */

% if there is only one column left, print the bottom border
printBottomBorder(1):-
	put_code(205), put_code(205), put_code(205).

% print the bottom border and decrement number of columns
printBottomBorder(NrColumns):-
	put_code(205), put_code(205), put_code(205),
	put_code(202),
	NewNr is NrColumns - 1,
	printBottomBorder(NewNr).

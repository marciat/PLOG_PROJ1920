%:- include('auxiliar.pl').

/*
 * empty cells - 0 - ' '
 * white discs - 1 - 'W'
 * black discs - 2 - 'B'
 */

symbol(0, ' ').
symbol(1, 'W').
symbol(2, 'B').

/*
 * white discs player - 1 - 'W'
 * black discs player - 2- 'B'
 */

player_symbol(1, 'W').
player_symbol(2, 'B').


/* displayGame(+Board, +Player, +Move)
 * Board - Board to be displayed
 * Player - current player number
 * Move - current player move number
 * displays the current game state
 * prints horizontal coordinates, board and player info */
displayGame(Board, Player, Move):-
	nl, nl,
	[H|_] = Board, 
	write('  '),
	printHorizontalCoordinates(H, 65),
	nl,
	getBoardDimensions(Board, _, Columns),
	printBoard(Board, 49, Columns),
	nl, nl,
	printPlayer(Player, Move),
	nl, nl. 

/* printBoard(+Board, +LineNr, +Columns)
 * Board - Board to be displayed
 * LineNr - Index of line currently being printed 
 * Columns - Number of board columns */

% if the first line is being printed, print top border and line contents
printBoard([L|T], 49, Columns):-
	write('   '),
	put_code(201), printTopBorder(Columns),
	put_code(49),
	write('  '),
	printLine(L),
	nl,
	printBoard(T, 50, Columns).

% if all lines have been printed, print only the bottom border
printBoard([], _, Columns):-
	write('   '),
	put_code(200),
	printBottomBorder(Columns),
	put_code(188), nl.

% for the rest of the lines, print divider and line contents
printBoard([L|T], LineNr, Columns):-
	write('   '),
	put_code(204), printDivider(Columns), put_code(185), nl,
	put_code(LineNr),
	write('  '),
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


/* printHorizontalCoordinates(+BoardLine, +LetterCode)
 * BoardLine - Line from board, used to recursively go through the number of columns
 * LetterCode - ASCII code of the letter of the horizontal currently currently being printed */

% if there are no more columns there is nothing to print
printHorizontalCoordinates([], _).

% print letter of the horizontal coordinate, increment letter ASCII code
printHorizontalCoordinates([_|T], LetterCode):-
	write('   '),
	put_code(LetterCode),
	NewLetterCode is LetterCode + 1,
	printHorizontalCoordinates(T,NewLetterCode).

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

/* printPlayer(+Player, +Move)
 * Player - current player
 * Move - player's current move
 * prints current player symbol and player's current move */
printPlayer(Player, Move):-
	write('Player '),
	player_symbol(Player, S),
	write(S),
	write('  -  Move '),
	write(Move).

/* displayWinner(+Winner)
 * Winner - game winner
 * prints that game has ended and the winner*/
displayWinner(Winner):-
	write('Game Over! Player '),
	player_symbol(Winner, S),
	write(S),
	write(' won!'), nl.


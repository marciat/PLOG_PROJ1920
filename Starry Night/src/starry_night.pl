:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- include('view.pl').
:- include('auxiliar.pl').

/* Board cells content
* 0 - empty
* 1- white circle
* 2 - black circle
* 3 - moon
*/

/* starry_night(+GivenBoard)
* GivenBoard - Symbols outside board, unsolved puzzle
* solves puzzle given
*/
starry_night(GivenBoard):-
    reset_timer,
    length(GivenBoard, BoardInputLength),
    BoardSide is BoardInputLength // 2,
    SolBoardLength is BoardSide * BoardSide,
    % create board for the solution
    length(SolutionBoard, SolBoardLength),
    % cell content domain
    domain(SolutionBoard, 0, 3),
    % constraints related to puzzle rules
    checkOneSymbolPerLineAndColumn(SolutionBoard, BoardSide, BoardSide),
    checkNoDiagonalsBoard(SolutionBoard, BoardSide, BoardSide),
    checkOffBoardSymbols(GivenBoard, SolutionBoard, 0),
    labeling([leftmost,middle], SolutionBoard),
    print_time, nl,
    reset_timer,
    displayPuzzle(GivenBoard, SolutionBoard).

/* generate_starry_night(+Side, -GivenBoard)
* generates puzzle with given Size and unifies it with GivenBoard
*/
generate_starry_night(Side, GivenBoard):-
    reset_timer,
    % starry night puzzles must be at least 5x5
    Side >= 5,
    SolBoardLength is Side * Side,
    BoardLength is Side * 2,
    % create lists for the solution board and the puzzle
    length(SolutionBoard, SolBoardLength),
    length(GivenBoard, BoardLength),
    % domain for both lists
    domain(SolutionBoard, 0, 3),
    domain(GivenBoard, 0, 3),
    % constraints related to puzzle rules
    checkOneSymbolPerLineAndColumn(SolutionBoard, Side, Side),
    checkNoDiagonalsBoard(SolutionBoard, Side, Side),
    checkOffBoardSymbols(GivenBoard, SolutionBoard, 1),
    append(GivenBoard, SolutionBoard, Solution),
    labeling([value(selRandom)], Solution),
    print_time,
    nl,
    % create empty solution board
    % so that the puzzle displayed will be unsolved
    getEmptySolutionBoard(Side, EmptyBoard),
    displayPuzzle(GivenBoard, EmptyBoard),
    write(GivenBoard),
    reset_timer.

/* checkOneSymbolPerLineAndColumn(+Board, +Side, +CurrentIndex)
* ensures there is exactly one star and one circle of each color in each line and column
* in Board, where Board has Side x Side dimensions
*/
checkOneSymbolPerLineAndColumn(_,_,0).

checkOneSymbolPerLineAndColumn(Board, Side, CurrentIndex):-
    % get current line and column
    getLine(Board, CurrentIndex, Line),
    getColumn(Board, CurrentIndex, Column),
    % number of zeros is the side minus the number of symbols
    ZerosPerLine is Side - 3,
    % use global_cardinality to ensure there is exactly one of each symbol
    % in each line and column, and the rest is empty
    global_cardinality(Line, [0-ZerosPerLine,1-1,2-1,3-1]),
    global_cardinality(Column, [0-ZerosPerLine,1-1,2-1,3-1]),
    NewIndex is CurrentIndex - 1,
    % continue to the rest of board
    checkOneSymbolPerLineAndColumn(Board, Side, NewIndex).

/* checkNoDiagonalsCell(+Board, +Horizontal, +Vertical)
* ensures that a cell with given coordinates does not have cells with same symbol
* touching it diagonally
*/
checkNoDiagonalsCell(Board, 1, Vertical):-
    getBoardSide(Board,Side),
    % current cell index in board
    CellIndex is (Vertical-1) * Side + 1,
    % index of cell on the top right corner
    % because it is the first cell of the line there is no top left corner cell to check
    Cell1H is 2, Cell1V is Vertical - 1,
    Cell1Index is (Cell1V-1) * Side + Cell1H,
    % cell content domain
    domain([CellContent, Content1], 0, 3),
    % if cell is empty then no further checking
    % else the content of the cells needs to be different
    (CellContent #= 0 #\/ 
    Content1 #\= CellContent),
    element(CellIndex, Board, CellContent),
    element(Cell1Index, Board, Content1).

checkNoDiagonalsCell(Board, Horizontal, Vertical):-
    getBoardSide(Board, Side),
    % checking if it's the last cell of line
    Horizontal = Side,
    % current cell index in board
    CellIndex is (Vertical-1) * Side + Horizontal,
    % index of cell on the top left corner
    % because it is the last cell of the line there is no top right corner cell to check
    Cell1H is Horizontal - 1, Cell1V is Vertical - 1,
    Cell1Index is (Cell1V-1) * Side + Cell1H,
    % cell content domain
    domain([CellContent, Content1], 0, 3),
    % if cell is empty then no further checking
    % else the content of the cells needs to be different
    (CellContent #= 0 #\/ 
    Content1 #\= CellContent),
    element(CellIndex, Board, CellContent),
    element(Cell1Index, Board, Content1).

checkNoDiagonalsCell(Board, Horizontal, Vertical):-
    validCoords(Board, Horizontal, Vertical),
    getBoardSide(Board, Side),
    % current cell index in board
    CellIndex is (Vertical-1) * Side + Horizontal,
    % index of cell on the top left corner
    Cell1H is Horizontal - 1, Cell1V is Vertical - 1,
    Cell1Index is (Cell1V-1) * Side + Cell1H,
    % index of cell on the top right corner
    Cell2H is Horizontal + 1, Cell2V is Vertical - 1,
    Cell2Index is (Cell2V-1) * Side + Cell2H,
    % cell content domain
    domain([CellContent, Content1, Content2], 0, 3),
    % if cell is empty then no further checking
    % else the content of the cells needs to be different
    (CellContent #= 0 #\/ 
    (Content1 #\= CellContent #/\ Content2 #\= CellContent)),
    element(CellIndex, Board, CellContent),
    element(Cell1Index, Board, Content1),
    element(Cell2Index, Board, Content2).

checkNoDiagonalsLine(_,0,_).

/* checkNoDiagonalsLine(+Board, +Column, +Line)
* ensures that the various cells in a line do not have cells with same symbol
* touching them diagonally
*/
checkNoDiagonalsLine(Board, Column, Line):-
    % check cell
    checkNoDiagonalsCell(Board, Column, Line),
    NewColumn is Column - 1,
    % continue to rest of the line
    checkNoDiagonalsLine(Board, NewColumn, Line).

/* checkNoDiagonalsBoard(+Board, +Side, +CurrLine)
* ensures that CurrLine in Board with Side x Side dimensions
* does not have cells with same symbol touching diagonally
*/
checkNoDiagonalsBoard(_,_,1).

checkNoDiagonalsBoard(Board, Side, CurrLine):-
    % check line
    checkNoDiagonalsLine(Board, Side, CurrLine),
    NewLine is CurrLine - 1,
    % continue to rest of the board
    checkNoDiagonalsBoard(Board, Side, NewLine).


/* checkOffBoardSymbols(?GivenBoard, -SolutionBoard, +Mode)
* checkOffBoardSymbols(?GivenBoard, -SolutionBoard, +Side, +CurrentBoardIndex, +Mode)
* ensure that puzzle rules regarding symbols outside board (GivenBoard) are being applied in SolutionBoard
* circle (0/1) - in that line/column the circle with that color is closest to the star
* star (3) - in that line/column the circles are at the same distance from the star
* Mode - is 0 if solver (GivenBoard is initialized) or 1 if generator (restrictions will be applied to GivenBoard)
*/
checkOffBoardSymbols(GivenBoard, SolutionBoard, Mode):-
    getBoardSide(SolutionBoard, Side),
    checkOffBoardSymbols(GivenBoard, SolutionBoard, Side, 1, Mode).

checkOffBoardSymbols(_, _, Side, CurrentBoardIndex, _):-
    % if whole board has been checked
    Side*2 =:= CurrentBoardIndex, !.

checkOffBoardSymbols(GivenBoard, SolutionBoard, Side, CurrentBoardIndex, Mode):-
    (CurrentBoardIndex > Side, % index corresponds to a column
    ColIndex is CurrentBoardIndex - Side, % column index
    % check column
    checkOffBoardColumn(GivenBoard, SolutionBoard, Side, ColIndex, Mode); 
    % check line
    checkOffBoardLine(GivenBoard, SolutionBoard, Side, CurrentBoardIndex, Mode)),
    NewBoardIndex is CurrentBoardIndex + 1,
    % continue to rest of board
    checkOffBoardSymbols(GivenBoard, SolutionBoard, Side, NewBoardIndex, Mode).

/* checkOffBoardColumn(?GivenBoard, -SolutionBoard, +Side, +CurrentColumn, +Mode)
* ensure that puzzle rules regarding symbols outside board (GivenBoard) are being applied
* in a specific column of SolutionBoard
*/
checkOffBoardColumn(GivenBoard, SolutionBoard, Side, CurrentColumn, Mode):-
    getColumn(SolutionBoard, CurrentColumn, Column),
    % symbol index in GivenBoard
    OffSymbolIndex is Side + CurrentColumn,
    (Mode = 0, nth1(OffSymbolIndex, GivenBoard, OffSymbol);
    Mode = 1, element(OffSymbolIndex, GivenBoard, OffSymbol)),
    % symbols indexes domain and ensuring they're distinct from each other
    domain([StarIndex, BlackIndex, WhiteIndex], 1, Side),
    all_distinct([StarIndex, BlackIndex, WhiteIndex]),
    % calculating distance between star and each circle
    BDist #= abs(StarIndex - BlackIndex),
    WDist #= abs(StarIndex - WhiteIndex),
    % if white circle, white circle distance is smaller
    % if black circle, white circle distance is larger
    % if star, distances are the same
    (Mode = 0, ((OffSymbol = 1, BDist #> WDist);
    (OffSymbol = 2, BDist #< WDist);
    (OffSymbol = 3, BDist #= WDist);
    OffSymbol = 0);
    Mode = 1, ((OffSymbol #= 1, BDist #> WDist);
    (OffSymbol #= 2, BDist #< WDist);
    (OffSymbol #= 3, BDist #= WDist);
    OffSymbol #= 0)),
    element(StarIndex, Column, 3),
    element(BlackIndex, Column, 2),
    element(WhiteIndex, Column, 1).

/* checkOffBoardLine(?GivenBoard, -SolutionBoard, +Side, +CurrentLine, +Mode)
* ensure that puzzle rules regarding symbols outside board (GivenBoard) are being applied
* in a specific line of SolutionBoard
*/
checkOffBoardLine(GivenBoard, SolutionBoard, Side, CurrentLine, Mode):-
    getLine(SolutionBoard, CurrentLine, Line),
    (Mode = 0, nth1(CurrentLine, GivenBoard, OffSymbol);
    Mode = 1, element(CurrentLine, GivenBoard, OffSymbol)),
    % symbols indexes domain and ensuring they're distinct from each other
    domain([StarIndex, BlackIndex, WhiteIndex], 1, Side),
    all_distinct([StarIndex, BlackIndex, WhiteIndex]),
    % calculating distance between star and each circle
    BDist #= abs(StarIndex - BlackIndex),
    WDist #= abs(StarIndex - WhiteIndex),
    % if white circle, white circle distance is smaller
    % if black circle, white circle distance is larger
    % if star, distances are the same
    (Mode = 0, ((OffSymbol = 1, BDist #> WDist);
    (OffSymbol = 2, BDist #< WDist);
    (OffSymbol = 3, BDist #= WDist);
    OffSymbol = 0);
    ((OffSymbol #= 1, BDist #> WDist);
    (OffSymbol #= 2, BDist #< WDist);
    (OffSymbol #= 3, BDist #= WDist);
    OffSymbol #= 0)),
    element(StarIndex, Line, 3),
    element(BlackIndex, Line, 2),
    element(WhiteIndex, Line, 1).

/* The predicates below were taken from PLOG Moodle Slides*/

% measuring and printing time
reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	nl, write('Time: '), write(T), write('ms'), nl, nl.

% random selection in labeling
selRandom(Var, _, BB0, BB1):-
    fd_set(Var, Set), fdset_to_list(Set, List),
    random_member(Value,List),
    (first_bound(BB0, BB1), Var#= Value;
    later_bound(BB0, BB1), Var#\= Value).

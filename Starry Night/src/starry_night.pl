:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- include('view.pl').
:- include('auxiliar.pl').

% tabuleiros 5x5
starry_night(Board):-
    % board final com a solucao
    length(Board, BoardInputLength),
    BoardSide is BoardInputLength // 2,
    SolBoardLength is BoardSide * BoardSide,
    length(SolBoard, SolBoardLength),
    /* dominio das celulas do tabuleiro
        0-vazio, 1-circulo branco, 2-circulo preto, 3-estrela
    */
    domain(SolBoard, 0, 3),
    checkOneSymbolPerLineAndColumn(SolBoard, BoardSide, BoardSide),
    checkNoDiagonalsBoard(SolBoard, BoardSide, BoardSide),
    checkOffBoardSymbols(Board, SolBoard),
    labeling([], SolBoard),
    displayPuzzle(Board,SolBoard).

checkOneSymbolPerLineAndColumn(_,_,0).

checkOneSymbolPerLineAndColumn(Board, Side, CurrentIndex):-
    getLine(Board, CurrentIndex, Line),
    getColumn(Board, CurrentIndex, Column),
    ZerosPerLine is Side - 3,
    global_cardinality(Line, [0-ZerosPerLine,1-1,2-1,3-1]),
    global_cardinality(Column, [0-ZerosPerLine,1-1,2-1,3-1]),
    NewIndex is CurrentIndex - 1,
    checkOneSymbolPerLineAndColumn(Board, Side, NewIndex).

checkNoDiagonalsCell(Board, 1, Vertical):-
    getBoardSide(Board,Side),
    CellIndex is (Vertical-1) * Side + 1,
    Cell1H is 2, Cell1V is Vertical - 1,
    Cell1Index is (Cell1V-1) * Side + Cell1H,
    domain([CellContent, Content1], 0, 3),
    (CellContent #= 0 #\/ 
    Content1 #\= CellContent),
    element(CellIndex, Board, CellContent),
    element(Cell1Index, Board, Content1).

checkNoDiagonalsCell(Board, Horizontal, Vertical):-
    getBoardSide(Board, Side),
    Horizontal = Side,
    CellIndex is (Vertical-1) * Side + Horizontal,
    Cell1H is Horizontal - 1, Cell1V is Vertical - 1,
    Cell1Index is (Cell1V-1) * Side + Cell1H,
    domain([CellContent, Content1], 0, 3),
    (CellContent #= 0 #\/ 
    Content1 #\= CellContent),
    element(CellIndex, Board, CellContent),
    element(Cell1Index, Board, Content1).

checkNoDiagonalsCell(Board, Horizontal, Vertical):-
    validCoords(Board, Horizontal, Vertical),
    getBoardSide(Board, Side),
    % guardar simbolo da celula em causa
    CellIndex is (Vertical-1) * Side + Horizontal,
    Cell1H is Horizontal - 1, Cell1V is Vertical - 1,
    Cell1Index is (Cell1V-1) * Side + Cell1H,
    Cell2H is Horizontal + 1, Cell2V is Vertical - 1,
    Cell2Index is (Cell2V-1) * Side + Cell2H,
    domain([CellContent, Content1, Content2], 0, 3),
    (CellContent #= 0 #\/ 
    (Content1 #\= CellContent #/\ Content2 #\= CellContent)),
    element(CellIndex, Board, CellContent),
    element(Cell1Index, Board, Content1),
    element(Cell2Index, Board, Content2).

checkNoDiagonalsLine(_,0,_).

% fazer check de diagonais para uma linha do board
checkNoDiagonalsLine(Board, Side, Line):-
    checkNoDiagonalsCell(Board, Side, Line),
    NewSide is Side - 1,
    checkNoDiagonalsLine(Board, NewSide, Line).

checkNoDiagonalsBoard(_,_,1).

% fazer check de diagonais para as varias celulas, linha sim linha nao
checkNoDiagonalsBoard(Board, Side, CurrLine):-
    checkNoDiagonalsLine(Board, Side, CurrLine),
    NewLine is CurrLine - 1,
    checkNoDiagonalsBoard(Board, Side, NewLine).

/*
check se as regras do puzzle relativamente aos simbolos fora do tabuleiro sao cumpridas
circulo - nessa coluna/linha circulo dessa cor esta mais proximo da estrela
estrela - nessa coluna/linha os circulos estao a mesma distancia da estrela
*/
checkOffBoardSymbols(Board, SolBoard):-
    getBoardSide(SolBoard, Side),
    checkOffBoardSymbols(Board, SolBoard, Side, 1).

checkOffBoardSymbols(_, _, Side, CurrentBoardIndex):-
    Side*2 =:= CurrentBoardIndex, !.

checkOffBoardSymbols(Board, SolBoard, Side, CurrentBoardIndex):-
    (CurrentBoardIndex > Side,
    ColIndex is CurrentBoardIndex - Side,
    checkOffBoardColumn(Board, SolBoard, Side, ColIndex); 
    checkOffBoardLine(Board, SolBoard, Side, CurrentBoardIndex)),
    NewBoardIndex is CurrentBoardIndex + 1,
    checkOffBoardSymbols(Board, SolBoard, Side, NewBoardIndex).

checkOffBoardColumn(Board, SolBoard, Side, CurrentColumn):-
    getColumn(SolBoard, CurrentColumn, Column),
    OffSymbolIndex is Side + CurrentColumn,
    nth1(OffSymbolIndex, Board, OffSymbol),
    domain([StarIndex, BlackIndex, WhiteIndex], 1, Side),
    all_distinct([StarIndex, BlackIndex, WhiteIndex]),
    BDist #= abs(StarIndex - BlackIndex),
    WDist #= abs(StarIndex - WhiteIndex),
    ((OffSymbol = 1, BDist #> WDist);
    (OffSymbol = 2, BDist #< WDist);
    (OffSymbol = 3, BDist #= WDist);
    OffSymbol = 0),
    element(StarIndex, Column, 3),
    element(BlackIndex, Column, 2),
    element(WhiteIndex, Column, 1).

checkOffBoardLine(Board, SolBoard, Side, CurrentLine):-
    getLine(SolBoard, CurrentLine, Line),
    nth1(CurrentLine, Board, OffSymbol),
    domain([StarIndex, BlackIndex, WhiteIndex], 1, Side),
    all_distinct([StarIndex, BlackIndex, WhiteIndex]),
    BDist #= abs(StarIndex - BlackIndex),
    WDist #= abs(StarIndex - WhiteIndex),
    ((OffSymbol = 1, BDist #> WDist);
    (OffSymbol = 2, BDist #< WDist);
    (OffSymbol = 3, BDist #= WDist);
    OffSymbol = 0),
    element(StarIndex, Line, 3),
    element(BlackIndex, Line, 2),
    element(WhiteIndex, Line, 1).

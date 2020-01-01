:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- include('view.pl').
:- include('auxiliar.pl').

% tabuleiros 5x5
starry_night(Board, SolBoard):-
    % board final com a solucao
    SolBoard = [A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5,D1,D2,D3,D4,D5,E1,E2,E3,E4,E5],
    /* dominio das celulas do tabuleiro
        0-vazio, 1-circulo branco, 2-circulo preto, 3-estrela
    */
    domain(SolBoard, 0, 3),
    /* exatamente uma estrela e circulo de cada cor em cada linha e coluna
    */
    global_cardinality([A1,A2,A3,A4,A5], [0-2,1-1,2-1,3-1]),
    global_cardinality([B1,B2,B3,B4,B5], [0-2,1-1,2-1,3-1]),
    global_cardinality([C1,C2,C3,C4,C5], [0-2,1-1,2-1,3-1]),
    global_cardinality([D1,D2,D3,D4,D5], [0-2,1-1,2-1,3-1]),
    global_cardinality([E1,E2,E3,E4,E5], [0-2,1-1,2-1,3-1]),
    global_cardinality([A1,B1,C1,D1,E1], [0-2,1-1,2-1,3-1]),
    global_cardinality([A2,B2,C2,D2,E2], [0-2,1-1,2-1,3-1]),
    global_cardinality([A3,B3,C3,D3,E3], [0-2,1-1,2-1,3-1]),
    global_cardinality([A4,B4,C4,D4,E4], [0-2,1-1,2-1,3-1]),
    global_cardinality([A5,B5,C5,D5,E5], [0-2,1-1,2-1,3-1]),
    /* simbolos iguais nao se tocam diagonalmente
    */
    checkNoDiagonalsBoard(SolBoard,5,5),
    checkOffBoardSymbols(Board, SolBoard),
    labeling([], SolBoard),
    LineA = [A1,A2,A3,A4,A5],
    LineB = [B1,B2,B3,B4,B5],
    LineC = [C1,C2,C3,C4,C5],
    LineD = [D1,D2,D3,D4,D5],
    LineE = [E1,E2,E3,E4,E5],
    nl,
    write(LineA), nl,
    write(LineB), nl,
    write(LineC), nl,
    write(LineD), nl,
    write(LineE).

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
    checkOffBoardLine(Board, SolBoard, CurrentBoardIndex)),
    NewBoardIndex is CurrentBoardIndex + 1,
    checkOffBoardSymbols(Board, SolBoard, Side, NewBoardIndex).

checkOffBoardColumn(Board, SolBoard, Side, CurrentColumn):-
    getColumn(SolBoard, CurrentColumn, Column),
    OffSymbolIndex is Side + CurrentColumn,
    nth1(OffSymbolIndex, Board, OffSymbol),
    domain([StarIndex, BlackIndex, WhiteIndex], 1, 5),
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

checkOffBoardLine(Board, SolBoard, CurrentLine):-
    getLine(SolBoard, CurrentLine, Line),
    nth1(CurrentLine, Board, OffSymbol),
    domain([StarIndex, BlackIndex, WhiteIndex], 1, 5),
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

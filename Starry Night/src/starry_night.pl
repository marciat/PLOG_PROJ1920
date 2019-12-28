:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- include('view.pl').
:- include('auxiliar.pl').

% tabuleiros 5x5
starry_night(Board, SolBoard):-
    % board final com a solucao
    SolBoard = [A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5,D1,D2,D3,D4,D5,E1,E2,E3,E4,E5],
    /* simbolos fora do tabuleiro
    */
    nth1(1,Board,Off1), nth1(2,Board,Off2), nth1(3,Board,Off3), nth1(4,Board,Off4), nth1(5,Board,Off5),
    nth1(6,Board,OffA), nth1(7,Board,OffB), nth1(8,Board,OffC), nth1(9,Board,OffD), nth1(10,Board,OffE),
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
    checkNoDiagonalsBoard(SolBoard,5,4),
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

checkNoDiagonalsCell(Board, Horizontal, Vertical):-
    validCoords(Board, Horizontal, Vertical),
    % guardar simbolo da celula em causa
    getPosition(Board, Horizontal, Vertical, CellContent),
    % se a celula estiver vazia nao e necessario verificar diagonais
    (CellContent #= 0;
    % coordenadas das celulas que sao diagonais a celula em causa
    Cell1H is Horizontal - 1, Cell1V is Vertical - 1,
    Cell2H is Horizontal + 1, Cell2V is Vertical - 1,
    Cell3H is Horizontal - 1, Cell3V is Vertical + 1,
    Cell4H is Horizontal + 1, Cell4V is Vertical + 1,
    getPosition(Board, Cell1H, Cell1V, Content1),
    getPosition(Board, Cell2H, Cell2V, Content2),
    getPosition(Board, Cell3H, Cell3V, Content3),
    getPosition(Board, Cell4H, Cell4V, Content4),
    % verificar se as diagonais sao coordenadas validas e, se forem, verificar que nao tem o mesmo simbolo
    Content1 #\= CellContent, Content2 #\= CellContent, Content3 #\= CellContent, Content4 #\= CellContent).

checkNoDiagonalsLine(_,0,_).

% fazer check de diagonais para uma linha do board
checkNoDiagonalsLine(Board, Side, Line):-
    checkNoDiagonalsCell(Board, Side, Line),
    NewSide is Side - 1,
    checkNoDiagonalsLine(Board, NewSide, Line).

checkNoDiagonalsBoard(_,_,0).
checkNoDiagonalsBoard(_,_,-1).

% fazer check de diagonais para as varias celulas, linha sim linha nao
checkNoDiagonalsBoard(Board, Side, CurrLine):-
    checkNoDiagonalsLine(Board, Side, CurrLine),
    NewLine is CurrLine - 2,
    checkNoDiagonalsBoard(Board, Side, NewLine).






# StarryNight_1

Para resolver puzzles é usado o predicado starry_night(+GivenBoard) e a solução é apresentada em modo de texto. GivenBoard é uma lista com os símbolos de fora do tabuleiro, primeiro os referentes às linhas e depois os referentes às colunas. Encontram-se exemplos de valores para GivenBoard de vários tamanhos no ficheiro puzzles.txt.

Para gerar puzzles é usado o predicado generate_starry_night(+Side, -GivenBoard), em que Side é o tamanho do lado do tabuleiro a gerar (no mínimo 5) e GivenBoard é o tabuleiro gerado, num formato semelhante ao explicado acima.


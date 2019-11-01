/* count(+List, +Element, -NumberOfOcurrences)
 * List - list with elements
 * Element - element whose number of ocurrences will be counted
 * NumberOfOcurrences - number of ocurrences of Element in List
 * counts the number of ocurrences of a specific element in a list */
count([], _, N):-
	N = 0.

count([E|T], E, N):-
    N1 is N+1,
	count(T, E, N1).

count([_|T], E, N):-
	count(T, E, N).
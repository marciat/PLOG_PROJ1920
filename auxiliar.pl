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
:- module(read, [read_int/1, read_ints/2]).


read_int(Int) :-
  get0(C),
  read_int_chars(C, Ints),
  name(Int, Ints).

read_int_chars(C, [C|Ints]) :-
  48 =< C, % the ascii code of '0'
  C =< 57, % the ascii code of '9'
  !,
  get0(C1),
  read_int_chars(C1, Ints).

read_int_chars(_, []).


read_ints(N, [Int|Ints]) :-
  N > 0,
  !,
  read_int(Int),
  N1 is N - 1,
  read_ints(N1, Ints).

read_ints(0, []).

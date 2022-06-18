[read].

main :-
  read_int(NumberOfSteelRods),
  read_ints(NumberOfSteelRods, SteelRodLengths),
  solve(NumberOfSteelRods, SteelRodLengths, JumboJavelinLength),
  write(JumboJavelinLength).

solve(NumberOfSteelRods, SteelRodLengths, JumboJavelinLength) :-
  sum_list(SteelRodLengths, N),
  JumboJavelinLength is N - NumberOfSteelRods + 1.

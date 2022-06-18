[read].

main :-
  read_int(Articles),
  read_int(ImpactFactor),
  solve(Articles, ImpactFactor, Scientists),
  write(Scientists).

solve(Articles, ImpactFactor, Scientists) :-
  Articles > 1,
  !,
  Scientists is Articles * (ImpactFactor - 1) + 1.

solve(1, N, N).

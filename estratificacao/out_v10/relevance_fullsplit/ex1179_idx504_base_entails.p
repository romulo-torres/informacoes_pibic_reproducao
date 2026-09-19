% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : (? [Y] : (((((((monitor(X) & producedby(X, aoc)) & in(X, library)) & ~((X = Y))) & monitor(Y)) & producedby(Y, aoc)) & in(Y, library))))).
fof(p2, axiom, ! [X] : (((monitor(X) & in(X, library)) => cheaperthan(X, dollars800)))).
fof(p3, axiom, ! [X] : (((monitor(X) & cheaperthan(X, dollars800)) => resolutionlessthan(X, p1080)))).
fof(p4, axiom, ! [X] : (((monitor(X) & resolutionlessthan(X, p1080)) => ~(supports(X, type_cport))))).
fof(p5, axiom, supports(a_2017, type_cport)).
fof(extra1, axiom, ~((producedby(a_2017, aoc) & in(a_2017, library)))).

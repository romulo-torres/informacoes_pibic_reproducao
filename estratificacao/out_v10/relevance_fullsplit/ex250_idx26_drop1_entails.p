% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((residentof(X, lawtonpark) => usezipcode(X, num98199)))).
fof(p2, axiom, residentof(tom, lawtonpark)).
fof(p3, axiom, usezipcode(daniel, num98199)).
fof(extra1, axiom, ~(~(usezipcode(tom, num98199)))).

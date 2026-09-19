% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((maxlistento(X) & classicalmusic(X)) => (song(X) & from(X, c_12thcentury))))).
fof(p2, axiom, ! [X] : (((maxlistento(X) & rap(X)) => (song(X) & by(X, kanyewest))))).
fof(p3, axiom, ! [X] : (((song(X) & by(X, kanyewest)) => (song(X) & fulloflyrics(X))))).
fof(p4, axiom, ! [X] : (((song(X) & fulloflyrics(X)) => needtobewrittenwith(X, words)))).
fof(p5, axiom, ~(((classicalmusic(asitwasbyharrystyles) & song(asitwasbyharrystyles)) & from(asitwasbyharrystyles, c_12thcentury)))).
fof(p6, axiom, maxlistento(asitwasbyharrystyles)).
fof(extra1, axiom, ~(~(((song(asitwasbyharrystyles) & by(asitwasbyharrystyles, kanyewest)) & needtobewrittenwith(asitwasbyharrystyles, words))))).

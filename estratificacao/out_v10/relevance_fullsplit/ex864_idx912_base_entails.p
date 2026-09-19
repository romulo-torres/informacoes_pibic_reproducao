% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((havein(X, alotofmusicdecoration, room) => ~(moveouteasily(X))))).
fof(p2, axiom, ! [X] : ((ambitious(X) => moveouteasily(X)))).
fof(p3, axiom, ! [X] : ((bigfanofmusic(X) => musicdecorations(X, room)))).
fof(p4, axiom, ! [X] : (((attendfrequently(X, musicfestival) & youngteenagegirl(X)) => (bigfanofpopband(X) & bigfanofpopsinger(X))))).
fof(p5, axiom, (ambitious(sam) => (bbigfanofpopband(sam) & bigfanofpopsinger(sam)))).
fof(extra1, axiom, ~(~((attend(sam, festival) & youngteenagegirl(sam))))).

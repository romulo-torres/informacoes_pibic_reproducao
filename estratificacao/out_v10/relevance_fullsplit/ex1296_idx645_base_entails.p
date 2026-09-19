% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((flyover(X, vastdistance) => glideinair(X)))).
fof(p2, axiom, ! [X] : (((flightless(X) & bird(X)) => ~(flyover(X, vastdistance))))).
fof(p3, axiom, ! [X] : ((penguin(X) => (flightless(X) & bird(X))))).
fof(p4, axiom, ! [X] : ((((nonflying(X) & bird(X)) & in(X, antarctica)) => penguin(X)))).
fof(p5, axiom, (penguin(fido) | flyover(fido, vastdistance))).
fof(extra1, axiom, ~((~(((nonflying(fido) & bird(fido)) & in(fido, antarctica))) & ~(glideinair(fido))))).

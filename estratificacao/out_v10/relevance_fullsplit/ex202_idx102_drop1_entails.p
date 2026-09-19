% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : ((directedby(X, Y) => filmmaker(Y))))).
fof(p2, axiom, documentary(aftertiller)).
fof(p3, axiom, ! [X] : ((documentary(X) => film(X)))).
fof(p4, axiom, from(lanawilson, kirkland)).
fof(p5, axiom, in(kirkland, unitedstates)).
fof(p6, axiom, ! [X] : (! [Y] : (! [Z] : (((from(X, Y) & in(Y, Z)) => from(X, Z)))))).
fof(p7, axiom, nomination(aftertiller, theindependentspiritawardforbestdocumentary)).
fof(extra1, axiom, ~(~(? [X] : (((filmmaker(X) & from(X, kirkland)) & directedby(missamericana, X)))))).

% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((directedby(aftertiller, lanawilson) & directedby(thedeparture, lanawilson)) & directedby(missamericana, lanawilson))).
fof(p2, axiom, ! [X] : (! [Y] : ((directedby(X, Y) => filmmaker(Y))))).
fof(p3, axiom, documentary(aftertiller)).
fof(p4, axiom, ! [X] : ((documentary(X) => film(X)))).
fof(p5, axiom, from(lanawilson, kirkland)).
fof(p6, axiom, in(kirkland, unitedstates)).
fof(p7, axiom, ! [X] : (! [Y] : (! [Z] : (((from(X, Y) & in(Y, Z)) => from(X, Z)))))).
fof(p8, axiom, nomination(aftertiller, theindependentspiritawardforbestdocumentary)).
fof(extra1, axiom, ~(~(? [X] : (((filmmaker(X) & from(X, kirkland)) & directedby(missamericana, X)))))).

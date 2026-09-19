% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (greek(evangeloseleftheriou) & electricalengineer(evangeloseleftheriou))).
fof(p2, axiom, workforin(evangeloseleftheriou, ibm, zurich)).
fof(p3, axiom, ! [X] : (! [X] : (! [Z] : (((company(X) & workforin(y, X, Z)) => haveofficein(X, Z)))))).
fof(p4, axiom, company(ibm)).
fof(extra1, axiom, ~((haveofficein(ibm, london) | haveofficein(ibm, zurich)))).

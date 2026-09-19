% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (museum(whitneymuseumofamericanart) & in(metropolitanmuseumofart, nyc))).
fof(p2, axiom, (museum(museumofmodernart) & in(museumofmodernart, nyc))).
fof(p3, axiom, (include(metropolitanmuseumofart, byzantineart) & include(metropolitanmuseumofart, islamicart))).
fof(p4, axiom, include(whitneymuseumofamericanart, americanart)).
fof(extra1, axiom, (? [X] : ((((museum(X) & in(X, nyc)) & include(X, byzantineart)) & include(X, islamicart))))).

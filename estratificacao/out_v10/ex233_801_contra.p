% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, bornin(asahoffmann, newyorkcity)).
fof(p2, axiom, livein(asahoffmann, manhattan)).
fof(p3, axiom, chessplayer(asahoffmann)).
fof(p4, axiom, ? [X] : (? [Y] : (((((chessplayer(X) & grandmaster(X)) & ~((X = Y))) & chessplayer(Y)) & grandmaster(Y))))).
fof(p5, axiom, ! [X] : (((bornin(X, newyorkcity) & livein(X, newyorkcity)) => newyorker(X)))).
fof(p6, axiom, ! [X] : ((livein(X, manhattan) => livein(X, newyorkcity)))).
fof(extra1, axiom, (~(livein(asahoffmann, newyorkcity)))).

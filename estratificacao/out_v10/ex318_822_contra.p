% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (((song(showyourlove) & recordedby(showyourlove, btob4u)) & southkorean(btob4u)) & boyband(btob4u))).
fof(p2, axiom, (extendedplay(inside) & leadsingleof(showyourlove, inside))).
fof(p3, axiom, contains(showyourlove, hopefulmessage)).
fof(p4, axiom, (member(hyunsik, btob4u) & wrote(hyunsik, showyourlove))).
fof(p5, axiom, have(showyourlove, musicvideo)).
fof(extra1, axiom, (! [X] : (! [Y] : ((wrote(X, showyourlove) => ~((boyband(Y) & memberof(X, Y)))))))).

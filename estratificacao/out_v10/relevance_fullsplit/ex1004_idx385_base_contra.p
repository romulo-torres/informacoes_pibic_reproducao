% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((((inthistechcompany(X) & consistent(X)) & stickto(X, theirregularroutine)) => ~(like(X, surprise))))).
fof(p2, axiom, ! [X] : (((inthistechcompany(X) & ? [Y] : ((flannelshirt(Y) & weareveryday(X, Y)))) => (consistent(X) & stickto(X, theirregularroutine))))).
fof(p3, axiom, ! [X] : (((inthistechcompany(X) & ~(likeshoppingfor(X, clothes))) => ? [Y] : ((flannelshirt(Y) & weareveryday(X, Y)))))).
fof(p4, axiom, ! [X] : ((((inthistechcompany(X) & old(X)) & livein(X, stablehome)) => ~(like(X, surprise))))).
fof(p5, axiom, ! [X] : ((((inthistechcompany(X) & have(X, highenergy)) & impulsive(X)) => ~(like(X, surprise))))).
fof(p6, axiom, inthistechcompany(mike)).
fof(p7, axiom, (~(((? [Y] : ((flannelshirt(Y) & weareveryday(x, Y))) & have(mike, highenergy)) & impulsive(mike))) => ((consistent(mike) & stickto(mike, theirregularroutine)) <~> ~(like(mike, surprise))))).
fof(extra1, axiom, (((~((old(mike) & livein(mike, stablehome))) & ~(likeshoppingfor(mike, clothes))) => ~(likeshoppingfor(mike, clothes))))).

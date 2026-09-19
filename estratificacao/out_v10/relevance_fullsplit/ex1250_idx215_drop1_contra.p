% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((((thisbrand(X) & product(X)) & producedin(X, china)) => labeled(X)))).
fof(p2, axiom, ! [X] : ((((thisbrand(X) & product(X)) & producedin(X, us)) => soldin(X, us)))).
fof(p3, axiom, ! [X] : ((((thisbrand(X) & product(X)) & labeled(X)) => cheaper(X)))).
fof(p4, axiom, ! [X] : ((((thisbrand(X) & product(X)) & soldin(X, us)) => soldin(X, walmart)))).
fof(p5, axiom, ! [X] : ((((thisbrand(X) & product(X)) & displayedin(X, homepage)) => soldin(X, walmart)))).
fof(p6, axiom, ! [X] : ((((thisbrand(X) & product(X)) & returnedby(X, customer)) => ~(soldin(X, walmart))))).
fof(p7, axiom, ((product(g910) & thisbrand(g910)) & ~((displayedin(g910, homepage) <~> cheaper(g910))))).
fof(extra1, axiom, ((thisbrand(g910) & returnedby(g910, customer)))).

% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (talentedpoet(lorca) & support(lorca, populists))).
fof(p2, axiom, ! [X] : ((support(X, populists) => opposed(nationalists, X)))).
fof(p3, axiom, ! [X] : ((talentedpoet(X) => popular(X)))).
fof(p4, axiom, ! [X] : (((opposed(nationalists, X) & popular(X)) => killed(nationalists, X)))).
fof(p5, axiom, (support(daniel, populists) & ~(popular(daniel)))).
fof(extra1, axiom, ~(~(killed(nationalists, daniel)))).

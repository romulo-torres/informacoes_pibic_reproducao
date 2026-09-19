% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((oncounter(X) & drink(X)) => edible(X)))).
fof(p2, axiom, ! [X] : (((oncounter(X) & juice(X)) => drink(X)))).
fof(p3, axiom, ! [X] : ((orangejuice(X) => juice(X)))).
fof(p4, axiom, ! [X] : ((oncounter(X) => (orangejuice(X) <~> applejuice(X))))).
fof(p5, axiom, ! [X] : (((oncounter(X) & applejuice(X)) => sweet(X)))).
fof(p6, axiom, (oncounter(coke) & (applejuice(coke) => drink(coke)))).
fof(p7, axiom, (~(applejuice(coke)) => ~(edible(coke)))).
fof(extra1, axiom, ~((edible(coke) & sweet(coke)))).

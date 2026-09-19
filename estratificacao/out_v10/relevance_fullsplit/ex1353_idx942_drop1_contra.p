% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((oncounter(X) & juice(X)) => drink(X)))).
fof(p2, axiom, ! [X] : ((orangejuice(X) => juice(X)))).
fof(p3, axiom, ! [X] : ((oncounter(X) => (orangejuice(X) <~> applejuice(X))))).
fof(p4, axiom, ! [X] : (((oncounter(X) & applejuice(X)) => sweet(X)))).
fof(p5, axiom, (oncounter(coke) & (applejuice(coke) => drink(coke)))).
fof(p6, axiom, (~(applejuice(coke)) => ~(edible(coke)))).
fof(extra1, axiom, (~((edible(coke) & sweet(coke))))).

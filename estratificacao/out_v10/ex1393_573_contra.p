% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((grass(X) => ~(food(X))))).
fof(p2, axiom, ! [X] : ((meadow(X) => grass(X)))).
fof(p3, axiom, ! [X] : ((edible(X) => food(X)))).
fof(p4, axiom, ! [X] : ((fruit(X) => edible(X)))).
fof(p5, axiom, ! [X] : ((lemon(X) => fruit(X)))).
fof(p6, axiom, ~((edible(grape) & lemon(grape)))).
fof(p7, axiom, (grass(banana) | fruit(banana))).
fof(extra1, axiom, (food(grape))).

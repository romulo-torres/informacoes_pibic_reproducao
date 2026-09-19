% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((meadow(X) => grass(X)))).
fof(p2, axiom, ! [X] : ((edible(X) => food(X)))).
fof(p3, axiom, ! [X] : ((fruit(X) => edible(X)))).
fof(p4, axiom, ! [X] : ((lemon(X) => fruit(X)))).
fof(p5, axiom, ~((edible(grape) & lemon(grape)))).
fof(p6, axiom, (grass(banana) | fruit(banana))).
fof(extra1, axiom, ((lemon(banana) & meadow(banana)))).

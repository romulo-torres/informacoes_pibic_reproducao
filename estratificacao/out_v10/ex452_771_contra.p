% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((((provide(party, strawberry) & provide(party, orange)) & provide(party, blueberry)) & provide(party, grape)) & provide(party, cherry))).
fof(p2, axiom, ! [X] : ((lowestweightremainingat(X, endofparty) => mostpopular(X)))).
fof(p3, axiom, lowestweightremainingat(strawberries, endofparty)).
fof(p4, axiom, lowerweightat(blueberry, cherry, endofparty)).
fof(p5, axiom, ((((eat(benjamin, orange) & eat(benjamin, grape)) & ~(eat(benjamin, blueberry))) & ~(eat(benjamin, cherry))) & ~(eat(benjamin, strawberry)))).
fof(extra1, axiom, (eat(blueberry, benjamin))).

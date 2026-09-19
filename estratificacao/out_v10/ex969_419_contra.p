% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((in(X, thisneighborhood) & visitregularly(X, coffeeshop)) => addictedto(X, coffee)))).
fof(p2, axiom, ! [X] : ((in(X, thisneighborhood) => (visitregularly(X, coffeeshop) | ? [Y] : ((takeout(Y) & order(X, Y, aday))))))).
fof(p3, axiom, ! [X] : (((in(X, thisneighborhood) & makeatusing(X, home, ownfood, recipe)) => ? [Y] : ((takeout(Y) & order(X, Y)))))).
fof(p4, axiom, ! [X] : (((in(X, thisneighborhood) & ? [Y] : ((coffeemakerandblender(Y) & own(X, Y)))) => ~(orderatleastonceaday(X, takeout))))).
fof(p5, axiom, ! [X] : (((in(X, thisneighborhood) & busywith(X, c_12hourworkhour)) => makeatusing(X, home, ownfood, recipe)))).
fof(p6, axiom, (in(sam, thisneighborhood) & ~((addictedto(sam, coffee) <~> busywith(sam, c_12hourworkhour))))).
fof(extra1, axiom, ((? [Y] : ((coffeemakerandblender(Y) & own(sam, Y))) | ? [Y] : ((takeout(Y) & order(sam, Y, aday)))))).

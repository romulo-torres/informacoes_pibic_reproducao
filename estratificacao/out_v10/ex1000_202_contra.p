% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((michaelsneightbor(X) & growin(X, vegetable, garden)) => have(X, amplespace)))).
fof(p2, axiom, ! [X] : ((((michaelsneightbor(X) & youngworkingprofession(X)) & livein(X, largecity)) => ~(have(X, amplespace))))).
fof(p3, axiom, ! [X] : (((michaelsneightbor(X) & orderoften(X, takeout)) => grow(X, vegetable, garden)))).
fof(p4, axiom, ! [X] : (((michaelsneightbor(X) & enjoygoingoutoftentowith(X, restaurant, friend)) => orderoften(X, takeout)))).
fof(p5, axiom, ! [X] : (((michaelsneightbor(X) & toutover(X, homecookedmeals, fastfood)) => enjoygoingoutoftentowith(X, restaurant, friend)))).
fof(p6, axiom, (michaelsneightbor(peter) & (growin(peter, vegetable, garden) | toutover(peter, homecookedmeals, fastfood)))).
fof(extra1, axiom, ((youngworkingprofession(peter) & livein(peter, largecity)))).

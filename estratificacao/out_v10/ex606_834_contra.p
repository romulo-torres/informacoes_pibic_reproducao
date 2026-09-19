% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((roomfor(X, dessert) => roomfor(X, broccoli)))).
fof(p2, axiom, ! [X] : ((atluisparty(X) => roomfor(X, dessert)))).
fof(p3, axiom, ~(roomfor(mauricia, broccoli))).
fof(p4, axiom, (atluisparty(allison) & firstdinnerpartyfor(luisparty, allison))).
fof(p5, axiom, (roomfor(gustave, broccoli) & roomfor(gustave, asparagus))).
fof(p6, axiom, (vegetable(broccoli) & vegetable(asparagus))).
fof(extra1, axiom, (atluisparty(mauricia))).

% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (heavycruiser(usssalem) & builtfor(usssalem, unitedstatesnavy))).
fof(p2, axiom, museumship(usssalem)).
fof(p3, axiom, ! [X] : ((museumship(X) => opentopublic(X)))).
fof(p4, axiom, (servedin(usssalem, atlantic) & servedin(usssalem, mediterranean))).
fof(extra1, axiom, (opentopublic(usssalem))).

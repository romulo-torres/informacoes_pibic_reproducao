% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (heavycruiser(usssalem) & builtfor(usssalem, unitedstatesnavy))).
fof(p2, axiom, lastheavycruisertoenterservice(usssalem)).
fof(p3, axiom, museumship(usssalem)).
fof(p4, axiom, ! [X] : ((museumship(X) => opentopublic(X)))).
fof(p5, axiom, (servedin(usssalem, atlantic) & servedin(usssalem, mediterranean))).
fof(extra1, axiom, ~(opentopublic(usssalem))).

% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (heavycruiser(usssalem) & builtfor(usssalem, unitedstatesnavy))).
fof(p2, axiom, lastheavycruisertoenterservice(usssalem)).
fof(p3, axiom, ! [X] : ((museumship(X) => opentopublic(X)))).
fof(p4, axiom, (servedin(usssalem, atlantic) & servedin(usssalem, mediterranean))).
fof(extra1, axiom, ~(? [X] : (((museumship(X) & opentopublic(X)) & servedin(X, mediterranean))))).

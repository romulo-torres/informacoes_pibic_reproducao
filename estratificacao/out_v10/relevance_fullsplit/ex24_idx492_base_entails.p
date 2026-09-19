% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (vole(taigavole) & livein(taigavole, northamerica))).
fof(p2, axiom, likeplayingwith(cat, taigavole)).
fof(p3, axiom, livein(taigavole, borealtaigazone)).
fof(p4, axiom, ! [X] : (((livein(X, northamerica) & livein(X, borealtaigazone)) => livein(X, coldplace)))).
fof(extra1, axiom, ~(~(livein(taigavole, coldplace)))).

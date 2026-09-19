% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, likeplayingwith(cat, taigavole)).
fof(p2, axiom, livein(taigavole, borealtaigazone)).
fof(p3, axiom, ! [X] : (((livein(X, northamerica) & livein(X, borealtaigazone)) => livein(X, coldplace)))).
fof(extra1, axiom, (~(livein(taigavole, coldplace)))).

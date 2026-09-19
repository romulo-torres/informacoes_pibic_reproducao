% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((kangaroo(X) => animal(X)))).
fof(p2, axiom, ! [X] : ((kangaroo(X) => ~(livein(X, germany))))).
fof(p3, axiom, (savesfor(jane, enoughmoney, thesummer) => flyto(jane, germany))).
fof(p4, axiom, (flyto(jane, germany) => goto(jane, berlinzoo))).
fof(p5, axiom, ! [X] : (? [Y] : ((((goto(X, berlinzoo) & livein(X, germany)) & animal(Y)) => willsee(Y, X, berlinzoo))))).
fof(extra1, axiom, (? [X] : (((savesfor(jane, enoughmoney, thesummer) & kangaroo(X)) => willsee(X, jane, berlinzoo))))).

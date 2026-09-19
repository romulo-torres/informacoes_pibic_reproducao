% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((getajobat(X, google) => (have(X, alotofworkexperience) | have(X, goodeducation))))).
fof(p2, axiom, ! [X] : ((getajobat(X, google) => submitted(X, resume, google)))).
fof(p3, axiom, have(john, alotofworkexperience)).
fof(p4, axiom, (submitted(john, resume, google) & getajobat(john, google))).
fof(extra1, axiom, (yalegraduate(john))).

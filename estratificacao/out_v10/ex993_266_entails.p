% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((hodophiles(X) & enjoyeating(X, gelato)) => enjoy(X, vacationtoitaly)))).
fof(p2, axiom, ! [X] : ((hodophiles(X) & ~(? [Y] : (((((resist(X, Y) & hallmark(Y)) & delectabl(Y)) & dessert(Y)) & famousin(Y, italy))))))).
fof(p3, axiom, ! [X] : ((hodophiles(X) => (enjoyeating(X, gelato) | lovetotraveloften(X))))).
fof(p4, axiom, ! [X] : (((hodophiles(X) & takein(X, studyabroadsemester, europe)) => ~(regret(X, collegeexperience))))).
fof(p5, axiom, ! [X] : (((hodophiles(X) & lovetotraveloften(X)) => takein(X, studyabroadsemester, europe)))).
fof(p6, axiom, (hodophiles(robert) & ~((enjoyeating(robert, gelato) <~> lovetotraveloften(robert))))).
fof(extra1, axiom, ~(? [Y] : (((((resist(robert, Y) & hallmark(Y)) & delectabl(Y)) & dessert(Y)) & famousin(Y, italy))))).

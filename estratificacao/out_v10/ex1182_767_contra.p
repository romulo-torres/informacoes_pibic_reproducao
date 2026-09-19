% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (? [Y] : (((((((employeein(X, jamesstown) & workin(X, businessanalysis)) & goodat(X, math)) & ~((X = Y))) & employeein(Y, jamesstown)) & workin(Y, businessanalysis)) & goodat(Y, math))))).
fof(p2, axiom, ! [X] : (((employeein(X, jamesstown) & workin(X, businessanalysis)) => workfor(X, thiscompany)))).
fof(p3, axiom, ! [X] : (((employeein(X, jamesstown) & workfor(X, thiscompany)) => ~(from(X, china))))).
fof(p4, axiom, ! [X] : (((employeein(X, jamesstown) & workin(X, softwareengineering)) => from(X, china)))).
fof(p5, axiom, (employeein(leif, jamesstown) & workin(leif, softwareengineering))).
fof(extra1, axiom, (~((goodat(leif, math) & workin(leif, businessanalysis))))).

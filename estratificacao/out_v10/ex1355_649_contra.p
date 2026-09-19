% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((memberof(X, universityfaculty) => professor(X)))).
fof(p2, axiom, ! [X] : ((principalinvestigator(X) => memberof(X, universityfaculty)))).
fof(p3, axiom, ! [X] : ((professor(X) => ~(undergraduatestudent(X))))).
fof(p4, axiom, ! [X] : ((pursuing(X, bachelor) => undergraduatestudent(X)))).
fof(p5, axiom, ~((pursuing(leon, bachelor) <~> principalinvestigator(leon)))).
fof(p6, axiom, (~(pursuing(leon, bachelor)) => professor(leon))).
fof(extra1, axiom, ((~(undergraduatestudent(leon)) & ~(principalinvestigator(leon))))).

% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((principalinvestigator(X) => memberof(X, universityfaculty)))).
fof(p2, axiom, ! [X] : ((professor(X) => ~(undergraduatestudent(X))))).
fof(p3, axiom, ! [X] : ((pursuing(X, bachelor) => undergraduatestudent(X)))).
fof(p4, axiom, ~((pursuing(leon, bachelor) <~> principalinvestigator(leon)))).
fof(p5, axiom, (~(pursuing(leon, bachelor)) => professor(leon))).
fof(extra1, axiom, ((~(undergraduatestudent(leon)) & ~(principalinvestigator(leon))))).

% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((student(X) => memberof(X, university)))).
fof(p2, axiom, ! [X] : ((graduatestudent(X) => student(X)))).
fof(p3, axiom, ! [X] : ((phdstudent(X) => graduatestudent(X)))).
fof(p4, axiom, ? [X] : ((phdstudent(X) & teachingfellow(X)))).
fof(p5, axiom, (~(phdstudent(john)) => ~(memberof(john, university)))).
fof(p6, axiom, (teachingfellow(john) => (phdstudent(john) <~> graduatestudent(john)))).
fof(extra1, axiom, (~(tf(john)))).

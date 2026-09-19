% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((have(X, authorization, studyin, unitedstates) => enrolledin(X, academicprogram)))).
fof(p2, axiom, ! [X] : ((enrolledin(X, academicprogram) => ~(work(X, fulltime))))).
fof(p3, axiom, ! [X] : ((studyin(X, unitedstates) => have(X, authorization, studyin, unitedstates)))).
fof(p4, axiom, ! [X] : ((phdgraduate(X) => work(X, fulltime)))).
fof(p5, axiom, (~(studyin(x, unitedstates)) => enrolledin(x, academicprogram))).
fof(extra1, axiom, ~(~(phdgraduate(tom)))).

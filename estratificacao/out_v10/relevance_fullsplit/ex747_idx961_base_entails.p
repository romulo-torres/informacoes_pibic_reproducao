% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((outsideofcontrol(X) => ~(shouldworry(jerry, X))))).
fof(p2, axiom, ! [X] : ((traffic(X) => outsidecontrol(X)))).
fof(extra1, axiom, ~(~(shouldworry(jerry, traffic)))).

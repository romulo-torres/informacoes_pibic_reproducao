% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((olympicgoldmedalwinner(X) => professionalathlete(X)))).
fof(p2, axiom, ! [X] : ((fulltimescientist(X) => ~(spendon(X, mostoftheirtime, sports))))).
fof(p3, axiom, ! [X] : ((nobelphysicslaureate(X) => fulltimescientist(X)))).
fof(p4, axiom, (spendon(amy, mostoftheirtime, sports) | olympicgoldmedalwinner(amy))).
fof(p5, axiom, (~(nobelphysicslaureate(amy)) => ~(olympicgoldmedalwinner(amy)))).
fof(extra1, axiom, ((~(olympicgoldmedalwinner(amy)) => nobelphysicslaureate(amy)))).

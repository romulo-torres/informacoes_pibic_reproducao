% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((professionalathlete(X) => spendon(X, mostoftheirtime, sports)))).
fof(p2, axiom, ! [X] : ((olympicgoldmedalwinner(X) => professionalathlete(X)))).
fof(p3, axiom, ! [X] : ((fulltimescientist(X) => ~(spendon(X, mostoftheirtime, sports))))).
fof(p4, axiom, ! [X] : ((nobelphysicslaureate(X) => fulltimescientist(X)))).
fof(p5, axiom, (spendon(amy, mostoftheirtime, sports) | olympicgoldmedalwinner(amy))).
fof(p6, axiom, (~(nobelphysicslaureate(amy)) => ~(olympicgoldmedalwinner(amy)))).
fof(extra1, axiom, (~((fulltimescientist(amy) | olympicgoldmedalwinner(amy))))).

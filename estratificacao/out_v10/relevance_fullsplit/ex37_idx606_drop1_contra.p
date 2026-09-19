% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (form(stevehillage, system7) & form(miquettegiraudy, system7))).
fof(p2, axiom, (formermemberof(stevehillage, gong) & formermemberof(miquettegiraudy, gong))).
fof(p3, axiom, ! [X] : ((electronicdancemusicband(X) => band(X)))).
fof(p4, axiom, ? [X] : ((clubsingle(X) & release(system7, X)))).
fof(p5, axiom, ! [X] : ((clubsingle(X) => ~(single(X))))).
fof(extra1, axiom, (~(band(system7)))).

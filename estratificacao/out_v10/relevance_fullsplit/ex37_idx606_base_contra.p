% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (basedin(system7, uk) & electronicdancemusicband(system7))).
fof(p2, axiom, (form(stevehillage, system7) & form(miquettegiraudy, system7))).
fof(p3, axiom, (formermemberof(stevehillage, gong) & formermemberof(miquettegiraudy, gong))).
fof(p4, axiom, ! [X] : ((electronicdancemusicband(X) => band(X)))).
fof(p5, axiom, ? [X] : ((clubsingle(X) & release(system7, X)))).
fof(p6, axiom, ! [X] : ((clubsingle(X) => ~(single(X))))).
fof(extra1, axiom, (~(band(system7)))).

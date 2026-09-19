% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((product(X) => ~(perfect(X))))).
fof(p2, axiom, ! [X] : ((dress(X) => clothes(X)))).
fof(p3, axiom, ! [X] : ((skirt(X) => dress(X)))).
fof(p4, axiom, (clothes(fabricbundle) => (perfect(fabricbundle) & dress(fabricbundle)))).
fof(extra1, axiom, (skirt(fabricbundle))).

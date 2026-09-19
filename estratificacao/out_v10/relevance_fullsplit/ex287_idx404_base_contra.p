% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, (televisionseries(diray) & policeprocedural(diray))).
fof(p2, axiom, (creates(maya, diray) & writes(maya, diray))).
fof(p3, axiom, produces(jed, diray)).
fof(p4, axiom, (british(maya) & british(jed))).
fof(extra1, axiom, (? [X] : ((british(X) & creates(X, diray))))).

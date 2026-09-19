% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((devices(X) & with(X, companylogo)) => belongto(X, company)))).
fof(p2, axiom, ! [X] : ((devices(X) => (with(X, companylogo) <~> belongto(X, employee))))).
fof(p3, axiom, ! [X] : (((devices(X) & belongto(X, employee)) => canbeconnectedto(X, wifi)))).
fof(p4, axiom, ! [X] : (((devices(X) & connectto(X, googlehome)) => controlledby(X, manager)))).
fof(p5, axiom, ! [X] : (((devices(X) & canbeconnectedto(X, wifi)) => easytooperate(X)))).
fof(p6, axiom, ! [X] : (((devices(X) & easytooperate(X)) => producedafternewctoappointed(X, company)))).
fof(p7, axiom, (devices(modelxx) & ~(producedafternewctoappointed(modelxx, company)))).
fof(extra1, axiom, ((~(with(modelxx, companylogo)) & ~(controlledby(x, manager))))).

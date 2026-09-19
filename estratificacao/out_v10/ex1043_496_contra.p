% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((disease(X) => (affects(X, female) | affects(X, male))))).
fof(p2, axiom, ! [X] : ((affect(X, female) => ~(prostatecancer(X))))).
fof(p3, axiom, ! [X] : ((prostatecancer(X) | nonprostatecancer(X)))).
fof(p4, axiom, ! [X] : ((cancer(X) => ~(without(X, mutation))))).
fof(p5, axiom, ! [X] : ((nonprostatecancer(X) => cancer(X)))).
fof(p6, axiom, ((cancer(adenocarcinoma) | without(adenocarcinoma, mutation)) => (affect(adenocarcinoma, female) | without(adenocarcinoma, mutation)))).
fof(extra1, axiom, (((affect(adenocarcinoma, men) | without(adenocarcinoma, mutation)) => (nonprostatecancer(adenocarcinoma) & without(adenocarcinoma, mutation))))).

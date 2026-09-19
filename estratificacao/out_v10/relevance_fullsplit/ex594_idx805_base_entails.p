% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((greatlake(X) => ((((superior(X) <~> michigan(X)) <~> huron(X)) <~> erie(X)) <~> ontario(X))))).
fof(p2, axiom, ! [X] : (((erie(X) & majorsettlement(X)) => (((in(X, ny) | in(X, pa)) | in(X, oh)) | in(X, mi))))).
fof(p3, axiom, (((stateof(ny, us) & stateof(pa, us)) & stateof(oh, us)) & stateof(mi, us))).
fof(p4, axiom, stateof(on, canada)).
fof(p5, axiom, ? [X] : (((huron(X) & majorsettlement(X)) & in(X, on)))).
fof(p6, axiom, ! [X] : (! [Y] : ((stateof(X, Y) => in(X, Y))))).
fof(p7, axiom, in(us, northamerica)).
fof(p8, axiom, ! [X] : ((greatlake(X) => formatendof(X, lastglacialperiod)))).
fof(extra1, axiom, ~(? [X] : (? [Y] : ((erie(Y) & majorsettlementof(X, Y)))))).

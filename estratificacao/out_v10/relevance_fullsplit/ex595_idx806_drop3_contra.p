% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((greatlake(X) => ((((superior(X) <~> michigan(X)) <~> huron(X)) <~> erie(X)) <~> ontario(X))))).
fof(p2, axiom, ! [X] : (((erie(X) & majorsettlement(X)) => (((in(X, ny) | in(X, pa)) | in(X, oh)) | in(X, mi))))).
fof(p3, axiom, stateof(on, canada)).
fof(p4, axiom, ? [X] : (((huron(X) & majorsettlement(X)) & in(X, on)))).
fof(p5, axiom, ! [X] : (! [Y] : ((stateof(X, Y) => in(X, Y))))).
fof(p6, axiom, in(us, northamerica)).
fof(p7, axiom, ! [X] : ((greatlake(X) => formatendof(X, lastglacialperiod)))).
fof(extra1, axiom, (? [X] : ((greatlake(X) & ~(formatendof(X, lastglacialperiod)))))).

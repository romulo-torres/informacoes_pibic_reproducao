% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (surname(nameodell) & from(nameodell, odellbedfordshire))).
fof(p2, axiom, (mistakenspellingof(nameo_dell, nameodell) & ? [X] : (? [Y] : (((((family(X) & named(X, nameo_dell)) & ~((X = Y))) & family(Y)) & named(Y, nameo_dell)))))).
fof(p3, axiom, ((british(amyodell) & singer(amyodell)) & songwriter(amyodell))).
fof(p4, axiom, (english(jackodell) & toyinventor(jackodell))).
fof(extra1, axiom, ~(named(amyodell, nameodell))).

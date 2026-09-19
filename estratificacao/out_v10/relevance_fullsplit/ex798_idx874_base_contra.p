% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((inurbanarea(X) => ~(mansionhouse(X))))).
fof(p2, axiom, ! [X] : ((skyscraper(X) => inurbanarea(X)))).
fof(p3, axiom, ! [X] : ((creepyhauntedhouse(X) => mansionhouse(X)))).
fof(p4, axiom, ! [X] : (((terrifyingbuilding(X) & onhalloween(X)) => creepyhauntedhouse(X)))).
fof(p5, axiom, (creepyhauntedhouse(lalauriehouse) | (terrifyingbuilding(lalauriehouse) & onhalloween(lalauriehouse)))).
fof(extra1, axiom, (((skyscraper(lalauriehouse) <~> creepyhauntedhouse(lalauriehouse)) => ~(mansionhouse(lalauriehouse))))).

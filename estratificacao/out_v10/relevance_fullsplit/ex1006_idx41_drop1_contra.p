% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((outside(X, solarsystem) => ~(sunas(X, star))))).
fof(p2, axiom, ! [X] : ((in(X, solarsystem) => boundby(X, sun, gravitationally)))).
fof(p3, axiom, ! [X] : (((planet(X) & boundby(X, sun, gravitationally)) => ~((planet(X) & rogue(X)))))).
fof(p4, axiom, ! [X] : (((planet(X) & orphan(X)) => (planet(X) & rogue(X))))).
fof(p5, axiom, (~(((planet(psoj318_5_22) & rogue(psoj318_5_22)) & boundby(psoj318_5_22, sun, gravitationally))) => (planet(psoj318_5_22) & rogue(psoj318_5_22)))).
fof(extra1, axiom, (((planet(psoj318_5_22) & orphan(psoj318_5_22)) | ~(sunas(psoj318_5_22, star))))).

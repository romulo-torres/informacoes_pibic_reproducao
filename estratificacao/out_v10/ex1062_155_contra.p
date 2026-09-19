% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((inductivereasoning(X) => derivefrom(generalprinciple, observations)))).
fof(p2, axiom, ! [X] : ((majorargumentform(X) => (inductivereasoning(X) <~> deductivereasoning(X))))).
fof(p3, axiom, ! [X] : ((deductivereasoning(X) => (basedon(X, fact) | basedon(X, rule))))).
fof(p4, axiom, ! [X] : (((basedon(X, fact) | basedon(X, rule)) => ~(usedfor(X, statisticalgeneralization))))).
fof(p5, axiom, ~((inductivereasoning(modusponens) & usedfor(modusponens, statisticalgeneralization)))).
fof(p6, axiom, argumentform(modusponens)).
fof(extra1, axiom, ((~((derive(generalprinciple, observations) <~> usedfor(x, statisticalgeneralization))) => (~(inductivereasoning(modusponens)) & ~(usedfor(modusponens, statisticalgeneralization)))))).

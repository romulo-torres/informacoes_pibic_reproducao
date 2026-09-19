% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((workwellinteamsin(X, workplace) => ! [Y] : ((colleague(Y) & getalongwithatwork(X, Y)))))).
fof(p2, axiom, ! [X] : ((cometoworkwitheveryday(X, positiveattitude) => workwellinteamsin(X, workplace)))).
fof(p3, axiom, ! [X] : ((cometoworkwitheveryday(X, positiveattitude) <~> alwaystiredinmorning(X)))).
fof(p4, axiom, ! [X] : ((alwaystiredinmorning(X) => criticizedby(X, boss)))).
fof(p5, axiom, ! [X] : ((criticizedby(X, boss) => ~(receivefromatwork(X, positivefeedback, team))))).
fof(p6, axiom, ~((workwellinteamsin(kat, workplace) <~> tired(kat)))).
fof(extra1, axiom, (cometoworkwitheveryday(kat, positiveattitude))).

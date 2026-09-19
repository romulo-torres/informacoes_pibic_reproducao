% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((presentworkat(X, conference) <~> provideat(X, tutorialsession, conference)))).
fof(p2, axiom, ! [X] : ((presentworkat(X, conference) => attendinperson(X, conference)))).
fof(p3, axiom, ! [X] : ((providesessionat(X, tutorial, conference) => invitedtojoin(X, club)))).
fof(p4, axiom, ! [X] : ((attendinperson(X, conference) => providedwith(X, souvenir)))).
fof(p5, axiom, ! [X] : ((invitedtojoin(X, club) => providedwith(X, deliciousmeal)))).
fof(p6, axiom, ! [X] : (((providedwith(X, deliciousmeal) & providedwith(y, deliciousmeal)) => ? [Y] : (? [Z] : (((((~((Y = X)) & ~((Z = X))) & ~((Y = Z))) & happytocommunicatewithduringthedinner(X, Y)) & happytocommunicatewithduringthedinner(X, Z))))))).
fof(p7, axiom, ! [X] : ((providedwith(X, deliciousmeal) => invitedtotakephotowith(X, audience)))).
fof(p8, axiom, ~((attendinperson(james, conference) & providedwith(x, souvenir)))).
fof(extra1, axiom, (providedwith(james, souvenir))).

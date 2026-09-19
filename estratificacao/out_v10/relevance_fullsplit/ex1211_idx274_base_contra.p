% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((taxpayer(X) => contributeto(X, country)))).
fof(p2, axiom, ! [X] : ((workfor(X, governmentagency) => taxpayer(X)))).
fof(p3, axiom, ! [X] : ((servesin(X, thearmy) => workfor(X, governmentagency)))).
fof(p4, axiom, ! [X] : ((sentencedformurder(X) => imprisoned(X)))).
fof(p5, axiom, ! [X] : ((imprisoned(X) => has(X, criminalrecord)))).
fof(p6, axiom, (sentencedformurder(james) <~> imprisoned(james))).
fof(p7, axiom, (has(james, criminalrecord) <~> taxpayer(james))).
fof(extra1, axiom, (contributetocountry(james))).

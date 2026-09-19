% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (! [Y] : ((((paymentcard(X) & russianbank(Y)) & issuedby(X, Y)) => ~(usedwith(X, applepay)))))).
fof(p2, axiom, ! [X] : (! [Y] : (((paymentcard(X) & mir(X)) => (russianbank(Y) & issuedby(X, Y)))))).
fof(p3, axiom, ? [X] : (((paymentcard(X) & international(X)) => usedwith(X, applepay)))).
fof(p4, axiom, ! [X] : (! [Y] : (((socialpayment(X) & transferredto(X, Y)) => (paymentcard(Y) & mir(Y)))))).
fof(extra1, axiom, (! [X] : (((((paymentcard(bandofamerica) & international(bandofamerica)) & socialpayment(X)) & transferredto(X, bandofamerica)) => international(bandofamerica))))).

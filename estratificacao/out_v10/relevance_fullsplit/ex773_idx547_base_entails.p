% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (! [Y] : ((((paymentcard(X) & russianbank(Y)) & issuedby(X, Y)) => ~(usedwith(X, applepay)))))).
fof(p2, axiom, ! [X] : (! [Y] : (((paymentcard(X) & mir(X)) => (russianbank(Y) & issuedby(X, Y)))))).
fof(p3, axiom, ? [X] : (((paymentcard(X) & international(X)) => usedwith(X, applepay)))).
fof(p4, axiom, ! [X] : (! [Y] : (((socialpayment(X) & transferredto(X, Y)) => (paymentcard(Y) & mir(Y)))))).
fof(p5, axiom, (paymentcard(bankofamerica) & usedwith(bankofamerica, applepay))).
fof(extra1, axiom, ~((paymentcard(bankofamerica) & international(bankofamerica)))).

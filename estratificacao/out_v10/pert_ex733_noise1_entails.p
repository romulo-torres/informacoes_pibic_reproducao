% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((iphone(X) => electronic(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((((phone(X) & phone(Y)) & iphone(X)) & iphone(Y)) & ~((X = Y)))))).
fof(p3, axiom, noise_p_617205113(noise_c_617205113)).
fof(extra1, axiom, ~(! [X] : ((phone(X) => ~(electronic(X)))))).

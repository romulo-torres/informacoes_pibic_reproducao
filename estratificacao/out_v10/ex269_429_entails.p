% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (painter(bernardabrysonshahn) & lithographer(bernardabrysonshahn))).
fof(p2, axiom, bornin(bernardabrysonshahn, athensohio)).
fof(p3, axiom, marriedto(bernardabrysonshahn, benshahn)).
fof(p4, axiom, ! [X] : ((bornin(X, athensohio) => american(X)))).
fof(extra1, axiom, ~(divorced(bernardabrysonshahn))).

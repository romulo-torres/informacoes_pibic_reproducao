% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((sells(quiksilver, X) => (((sportswear(X) | clothing(X)) | footwear(X)) | accessory(X))))).
fof(p2, axiom, clothing(flannel)).
fof(p3, axiom, ? [X] : ((sells(quiksilver, X) & owns(joe, X)))).
fof(extra1, axiom, ~(owns(joe, flannel))).

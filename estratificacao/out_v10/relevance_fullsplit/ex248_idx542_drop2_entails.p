% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((sells(quiksilver, X) => (((sportswear(X) | clothing(X)) | footwear(X)) | accessory(X))))).
fof(p2, axiom, ? [X] : ((sells(quiksilver, X) & owns(joe, X)))).
fof(extra1, axiom, ~(? [X] : (((((owns(joe, X) & sportswear(X)) | clothing(X)) | footwear(X)) | accessory(X))))).

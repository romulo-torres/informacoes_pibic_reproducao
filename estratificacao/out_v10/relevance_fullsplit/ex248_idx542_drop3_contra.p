% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((sells(quiksilver, X) => (((sportswear(X) | clothing(X)) | footwear(X)) | accessory(X))))).
fof(p2, axiom, clothing(flannel)).
fof(extra1, axiom, (? [X] : (((((owns(joe, X) & sportswear(X)) | clothing(X)) | footwear(X)) | accessory(X))))).

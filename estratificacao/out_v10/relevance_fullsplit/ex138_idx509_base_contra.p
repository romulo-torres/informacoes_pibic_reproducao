% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((author(douglasadams) & authored(douglasadams, thesalmonofdoubt)) & book(thesalmonofdoubt))).
fof(p2, axiom, (about(thesalmonofdoubt, lifeexperience) & about(thesalmonofdoubt, technology))).
fof(p3, axiom, ! [X] : ((author(X) => writer(X)))).
fof(p4, axiom, ! [X] : ((writer(X) => create(X, innovativeidea)))).
fof(p5, axiom, ? [X] : (? [Y] : ((((contain(X, innovativeidea) & about(X, technology)) & ~((X = Y))) & (contain(Y, innovativeidea) & about(Y, technology)))))).
fof(extra1, axiom, (writer(douglasadams))).

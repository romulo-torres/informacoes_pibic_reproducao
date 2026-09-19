% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((choralconductor(X) => musician(X)))).
fof(p2, axiom, ? [X] : (? [Y] : (((musician(X) => love(X, music)) & ((~((X = Y)) & musician(Y)) => love(Y, music)))))).
fof(p3, axiom, publishedbook(miroslav, methodofstudyinggregorianchant, yr1946)).
fof(extra1, axiom, (! [X] : ((choralconductor(X) => ~(specializeinperformanceof(X, renaissancemusic)))))).

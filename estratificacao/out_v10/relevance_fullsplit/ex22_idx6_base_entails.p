% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (((czech(miroslav) & choralconductor(miroslav)) & specializeinperformanceof(miroslav, renaissancemusic)) & specializeinperformanceof(miroslav, baroquemusic))).
fof(p2, axiom, ! [X] : ((choralconductor(X) => musician(X)))).
fof(p3, axiom, ? [X] : (? [Y] : (((musician(X) => love(X, music)) & ((~((X = Y)) & musician(Y)) => love(Y, music)))))).
fof(p4, axiom, publishedbook(miroslav, methodofstudyinggregorianchant, yr1946)).
fof(extra1, axiom, ~(! [X] : ((choralconductor(X) => ~(specializeinperformanceof(X, renaissancemusic)))))).

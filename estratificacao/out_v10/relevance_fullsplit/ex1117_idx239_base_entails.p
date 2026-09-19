% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ? [X] : ((inbenjisfamily(X) => (likeeating(X, cheese) | francophile(X))))).
fof(p2, axiom, ! [X] : (((inbenjisfamily(X) & francophile(X)) => ~(favor(X, spain))))).
fof(p3, axiom, ? [X] : ((inbenjisfamily(X) & (favor(X, spain) | likeeating(X, cheese))))).
fof(p4, axiom, (inbenjisfamily(fabien) & ~((likeeating(fabien, cheese) & study(fabien, spanish))))).
fof(p5, axiom, study(fabien, spanish)).
fof(extra1, axiom, ~(likeeating(fabien, cheese))).

% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((product(X) & designedby(X, apple)) => soldin(X, applestore)))).
fof(p2, axiom, ! [X] : (((product(X) & with(X, applelogo)) => designedby(X, apple)))).
fof(p3, axiom, ! [X] : ((macbook(X) => with(X, applelogo)))).
fof(p4, axiom, ! [X] : (((product(X) & with(X, applem2chip)) => macbook(X)))).
fof(p5, axiom, ~((soldin(thinkpadx1, applestore) & macbook(thinkpadx1)))).
fof(extra1, axiom, ((with(thinkpadx1, applem2chip) <~> macbook(thinkpadx1)))).

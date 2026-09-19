% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((kid(X) & in(X, ourfamily)) => ~(love(X, opera))))).
fof(p2, axiom, ! [X] : (((adult(X) & in(X, ourfamily)) => love(X, opera)))).
fof(p3, axiom, ! [X] : (((scientist(X) & in(X, ourfamily)) => adult(X)))).
fof(p4, axiom, ? [X] : (((student(X) & in(X, ourfamily)) & kid(X)))).
fof(p5, axiom, (kid(billy) & in(billy, ourfamily))).
fof(extra1, axiom, ~((student(billy) & scientist(billy)))).

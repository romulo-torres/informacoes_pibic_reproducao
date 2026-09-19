% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((realnum(num6) & realnum(num7)) & realnum(num8))).
fof(p2, axiom, ! [X] : (! [Y] : ((((realnum(X) & realnum(Y)) & issuccessorof(X, Y)) => larger(X, Y))))).
fof(p3, axiom, ! [X] : (! [Y] : ((larger(X, Y) => ~(larger(Y, X)))))).
fof(p4, axiom, ? [Y] : ((issuccessorof(Y, num6) & equals(num7, Y)))).
fof(p5, axiom, ? [Y] : ((issuccessorof(Y, num7) & equals(num8, Y)))).
fof(p6, axiom, positive(num2)).
fof(p7, axiom, ! [X] : (! [Y] : (((positive(X) & isdouble(Y, X)) => positive(Y))))).
fof(p8, axiom, isdouble(num8, num4)).
fof(p9, axiom, isdouble(num4, num2)).
fof(extra1, axiom, ~(larger(eight, seven))).

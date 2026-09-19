% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((in(X, frannysfamily) & (drink(X, kombucha) | ? [Y] : ((drink(X, cocacola) | (pepsiproduct(Y) & drink(X, Y)))))))).
fof(p2, axiom, ! [X] : (((in(X, frannysfamily) & ? [Y] : ((drink(X, cocacola) | (pepsiproduct(Y) & drink(X, Y))))) => ? [Y] : (? [Z] : (((((((~((Y = Z)) & busyparent(Y)) & busyparent(Z)) & ~(pack(Y, lunch))) & ~(pack(Z, lunch))) & growupwith(X, Y)) & growupwith(X, Z))))))).
fof(p3, axiom, ((! [X] : (in(X, frannysfamily)) & ? [Y] : ((drink(x, cocacola) | (pepsiproduct(Y) & drink(x, Y))))) => havetovisitfrequently(x, dentist))).
fof(p4, axiom, ! [X] : (((in(X, frannysfamily) & ? [Y] : (? [Z] : (((((((~((Y = Z)) & busyparent(Y)) & busyparent(Z)) & ~(pack(Y, lunch))) & ~(pack(Z, lunch))) & growupwith(X, Y)) & growupwith(X, Z))))) => ? [Y] : ((((have(X, Y) & erratic(Y)) & diverse(Y)) & eatinghabit(Y)))))).
fof(p5, axiom, (! [X] : ((in(X, frannysfamily) & ? [Y] : ((((have(X, Y) & erratic(Y)) & diverse(Y)) & eatinghabit(Y))))) => ~((consistenteverydayroutine(x) & stickto(damon, solidschedule))))).
fof(p6, axiom, in(damon, frannysfamily)).
fof(p7, axiom, ~((? [Y] : (? [Z] : (((((((~((Y = Z)) & busyparent(Y)) & busyparent(Z)) & ~(pack(Y, lunch))) & ~(pack(Z, lunch))) & growupwith(damon, Y)) & growupwith(damon, Z)))) <~> (consistenteverydayroutine(damon) & stickto(damon, solidschedule))))).
fof(extra1, axiom, ~(havetovisitfrequently(damon, dentist))).

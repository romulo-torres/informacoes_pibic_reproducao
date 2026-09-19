% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (! [Y] : (! [Z] : (((albumbyband(X, Y) & rockband(Y, Z)) => genre(X, rock)))))).
fof(p2, axiom, ! [X] : (! [Y] : (! [Z] : (((albumbyband(X, Y) & albumaward(X, Z)) => rockbandaward(Y, Z)))))).
fof(p3, axiom, albumbyband(trouble_at_the_henhouse, the_tragically_hip)).
fof(p4, axiom, rockband(the_tragically_hip, canada)).
fof(p5, axiom, songinalbum(butts_wigglin, trouble_at_the_henhouse)).
fof(p6, axiom, albumaward(trouble_at_the_henhouse, the_album_of_the_year)).
fof(p7, axiom, ? [X] : ((songinfilm(X) & songinalbum(X, trouble_at_the_henhouse)))).
fof(extra1, axiom, (genre(troubleatthehenhouse, rock))).

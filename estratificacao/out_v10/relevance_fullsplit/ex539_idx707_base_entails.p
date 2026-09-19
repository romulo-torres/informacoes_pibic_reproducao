% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((europeansoccerclub(X) => ((attend(X, ucl) | attend(X, uel)) | attend(X, uecl))))).
fof(p2, axiom, ! [X] : (! [Y] : (((((europeansoccerclub(X) & europeansoccerclub(Y)) & attend(X, ucl)) & attend(Y, uel)) => higherrank(X, Y))))).
fof(p3, axiom, ! [X] : (! [Y] : (((((europeansoccerclub(X) & europeansoccerclub(Y)) & attend(X, uel)) & attend(Y, uecl)) => higherrank(X, Y))))).
fof(p4, axiom, (europeansoccerclub(manchesterunited) & europeansoccerclub(manchestercity))).
fof(p5, axiom, attend(manchesterunited, uel)).
fof(p6, axiom, attend(manchestercity, ucl)).
fof(extra1, axiom, ~(higherrank(manchestercity, manchesterunited))).

% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ((((districtin(xiufeng, guilin) & districtin(xiangshan, guilin)) & districtin(diecai, guilin)) & districtin(qixing, guilin)) & city(guilin))).
fof(p2, axiom, ~(districtin(yangshuo, guilin))).
fof(extra1, axiom, ~(? [X] : (((districtin(xiangshan, X) & districtin(diecai, X)) & city(X))))).

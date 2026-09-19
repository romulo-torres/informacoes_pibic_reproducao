% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((convictedcriminal(X) & ~(commitcrime(X))) => innocent(X)))).
fof(p2, axiom, ! [X] : ((convictedcriminal(X) & (trulyguilty(X) | foundguilty(X))))).
fof(p3, axiom, ! [X] : (((convictedcriminal(X) & foundguilty(X)) => sentencedtopunishment(X)))).
fof(p4, axiom, ! [X] : (((convictedcriminal(X) & foundguilty(X)) => canargueagainst(X, punishment)))).
fof(p5, axiom, (convictedcriminal(garry) & ~((foundguilty(garry) | sentencedtopunishment(garry))))).
fof(extra1, axiom, (~((innocent(garry) & ~(commitcrime(garry)))))).

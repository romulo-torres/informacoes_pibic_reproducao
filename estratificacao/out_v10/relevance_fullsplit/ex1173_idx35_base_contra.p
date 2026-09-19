% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ? [X] : (((((((monitor(X) & producedby(X, lg)) & have(X, typecport)) & ~((X = y))) & monitor(y)) & producedby(y, lg)) & have(y, typecport)))).
fof(p2, axiom, ! [X] : ((have(X, typecport) => ~(producedbefore(X, yr2010))))).
fof(p3, axiom, ! [X] : (((monitor(X) & in(X, library)) => producedbefore(X, yr2010)))).
fof(p4, axiom, (monitor(l_2021) & (in(l_2021, library) <~> have(l_2021, typecport)))).
fof(p5, axiom, ~((producedbefore(l_2021, yr2010) <~> producedby(l_2021, lg)))).
fof(extra1, axiom, (in(l_2021, library))).

% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((have(X, typecport) => ~(producedbefore(X, yr2010))))).
fof(p2, axiom, ! [X] : (((monitor(X) & in(X, library)) => producedbefore(X, yr2010)))).
fof(p3, axiom, (monitor(l_2021) & (in(l_2021, library) <~> have(l_2021, typecport)))).
fof(p4, axiom, ~((producedbefore(l_2021, yr2010) <~> producedby(l_2021, lg)))).
fof(extra1, axiom, ~((have(l_2021, typecport) <~> producedby(l_2021, lg)))).

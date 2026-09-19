% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((primenumber(X) => naturalnumber(X)))).
fof(p2, axiom, ! [X] : ((integer(X) => realnumber(X)))).
fof(p3, axiom, ! [X] : ((realnumber(X) => complexnumber(X)))).
fof(p4, axiom, (primenumber(one) | naturalnumber(one))).
fof(p5, axiom, (~(complexnumber(one)) => (primenumber(one) & integer(one)))).
fof(extra1, axiom, ((primenumber(one) <~> naturalnumber(one)))).

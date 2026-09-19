% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((goto(john, thecinema) & goto(john, today)) <=> (goto(jack, thecinema) & goto(jack, today)))).
fof(p2, axiom, ((goto(john, thecinema) & goto(john, today)) <=> (on(ironman) & ~(bad(weather, today))))).
fof(p3, axiom, ? [X] : (((day(X) & march(X)) => ~(bad(weather, X))))).
fof(p4, axiom, on(ironman)).
fof(p5, axiom, (day(presentmoment) & march(presentmoment))).
fof(extra1, axiom, (~(bad(weather, today)))).

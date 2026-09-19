% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, (~(falling(bottle)) => (upright(bottle) <~> toppledover(bottle)))).
fof(p2, axiom, (~(falling(bottle)) => ~(upright(bottle)))).
fof(extra1, axiom, ~((~(falling(bottle)) => toppleover(bottle)))).

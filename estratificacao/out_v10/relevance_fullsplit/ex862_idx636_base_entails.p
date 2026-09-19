% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((~(cleanoften(X, home)) => ~(have(X, tidyhouse))))).
fof(p2, axiom, ! [X] : ((~(prioritize(X, cleaning)) => ~(cleanoften(X, home))))).
fof(p3, axiom, ! [X] : (((hire(X, maid) | hire(X, cleaningservice)) => have(X, tidyhouse)))).
fof(p4, axiom, ! [X] : ((~(careabout(X, cleanliness)) => ~(prioritize(X, cleaning))))).
fof(p5, axiom, (~((hire(x, maid) | hire(x, cleaningservice))) <~> ~(cleanoften(jack, home)))).
fof(extra1, axiom, ~((~(prioritize(jack, cleaning)) | ~(careabout(jack, cleanliness))))).

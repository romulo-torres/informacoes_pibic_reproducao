% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((at(X, event) & youngadult(X)) => like(X, independence)))).
fof(p2, axiom, ! [X] : (((at(X, event) & collegestudent(X)) => youngadult(X)))).
fof(p3, axiom, ! [X] : (((at(X, event) & yalestudent(X)) => collegestudent(X)))).
fof(p4, axiom, ! [X] : ((at(X, event) => (yalestudent(X) <~> harvardstudent(X))))).
fof(p5, axiom, ! [X] : (((at(X, event) & harvardstudent(X)) => diligent(X)))).
fof(p6, axiom, (at(susan, event) & (harvardstudent(susan) => youngadult(susan)))).
fof(p7, axiom, (yalestudent(susan) => ~(like(susan, independence)))).
fof(extra1, axiom, ~(~((like(susan, independence) & diligent(susan))))).

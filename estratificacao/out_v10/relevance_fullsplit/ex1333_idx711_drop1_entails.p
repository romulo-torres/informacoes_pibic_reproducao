% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((classroomin(X, williamlharknesshall) & ~(privatestudyspot(X))))).
fof(p2, axiom, ! [X] : ((classroomin(X, williamlharknesshall) & (usedfor(X, lecture) | usedfor(X, officehours))))).
fof(p3, axiom, ! [X] : (((classroomin(X, williamlharknesshall) & bookedin(X, evening)) => ~(freelyusableatnight(X))))).
fof(p4, axiom, ! [X] : (((classroomin(X, williamlharknesshall) & usedfor(X, officehours)) => bookedin(X, evening)))).
fof(p5, axiom, (classroomin(num116, williamlharknesshall) & ~((usedfor(num116, lecture) <~> usedfor(num116, officehours))))).
fof(extra1, axiom, ~(privatestudyspot(room116))).

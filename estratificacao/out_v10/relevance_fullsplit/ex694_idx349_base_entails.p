% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : ((repayontime(X) => has(X, highcreditscore)))).
fof(p2, axiom, ? [X] : (((has(X, highcreditscore) & has(X, highsalary)) => approvedfor(X, mortgage)))).
fof(p3, axiom, has(john, highsalary)).
fof(extra1, axiom, ~((repayontime(john) => approvedfor(john, mortgage)))).

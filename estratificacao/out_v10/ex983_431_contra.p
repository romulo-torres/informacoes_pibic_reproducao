% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((inemmasfamily(X) & upgradetoeveryyear(X, newestiphonemodel)) => ~(savingmoneyforon(X, downpayment, newhouse))))).
fof(p2, axiom, ! [X] : ((((inemmasfamily(X) & enjoyreading(X, techspec)) & keepupdatedon(X, latesttechnology)) => upgradetoeveryyear(X, newestiphonemodel)))).
fof(p3, axiom, ! [X] : ((inemmasfamily(X) & (savingmoneyforon(X, downpayment, newhouse) | livein(X, apartment, bigmetropolitancity))))).
fof(p4, axiom, ! [X] : (((inemmasfamily(X) & ? [Y] : ((livewith(X, Y) & roommate(Y)))) => ~(? [Y] : ((own(X, Y) & pet(Y))))))).
fof(p5, axiom, ! [X] : (((inemmasfamily(X) & ? [Y] : ((own(X, Y) & pet(Y)))) => ? [Y] : ((livewith(X, Y) & roommate(Y)))))).
fof(p6, axiom, inemmasfamily(emily)).
fof(p7, axiom, ((? [Y] : ((own(emily, Y) & roommate(Y))) & livein(emily, apartment, bigmetropolitancity)) => ((? [Y] : ((own(emily, Y) & pet(Y))) & livein(emily, apartment, bigmetropolitancity)) <~> ~((? [Y] : ((own(emily, Y) & roommate(Y))) | livein(emily, apartment, bigmetropolitancity)))))).
fof(extra1, axiom, ((enjoyreading(emily, techspec) & keepupdatedon(emily, latesttechnology)))).

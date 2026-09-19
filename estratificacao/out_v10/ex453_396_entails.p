% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, ! [X] : (((wanttogoto(mr_andmrs_smith, X) & city(X)) => ((california(X) | florida(X)) & nevergo(X))))).
fof(p2, axiom, ((((((((city(sanfrancisco) & california(sanfrancisco)) & wanttogoto(mr_andmrs_smith, sanfrancisco)) & city(losangeles)) & california(losangeles)) & wanttogoto(mr_andmrs_smith, losangeles)) & city(sandiego)) & california(sandiego)) & wanttogoto(mr_andmrs_smith, sandiego))).
fof(p3, axiom, (((((city(orlando) & florida(orlando)) & wanttogo(mr_andmrs_smith, orlando)) & city(miami)) & florida(miami)) & wanttogo(mr_andmrs_smith, miami))).
fof(p4, axiom, ? [X] : (? [Y] : (! [Z] : ((((((((((~((X = Z)) & ~((Y = Z))) & ~((X = Y))) & city(X)) & city(Y)) & city(Z)) & california(X)) & california(Y)) & california(Z)) => ((visit(mr_smith, X) & visit(mr_smith, Y)) & ~(visit(mr_smith, Z)))))))).
fof(p5, axiom, ? [X] : (! [Y] : ((((((~((X = Y)) & city(X)) & city(Y)) & florida(X)) & florida(Y)) => (visit(mrs_smith, X) & ~(visit(mrs_smith, Y))))))).
fof(extra1, axiom, ~(? [X] : ((city(X) & visit(mr_smith, sanfrancisco))))).

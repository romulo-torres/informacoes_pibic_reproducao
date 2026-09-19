% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : ((fascinatedby(X, historyofrenaissance) => attendregularly(X, renaissancefair)))).
fof(p2, axiom, ! [X] : ((fascinatedby(X, historyofrenaissance) <~> (contemporaryacademic(X) & enjoy(X, learning))))).
fof(p3, axiom, ! [X] : (((focusedon(X, futuristicsubject) & focusedon(X, vocationalsubject)) => (contemporaryacademic(X) & enjoy(X, learning))))).
fof(p4, axiom, ! [X] : (((professor(X) & take(X, historicalapproach)) => ~((contemporaryacademic(X) & enjoy(X, learning)))))).
fof(p5, axiom, (~((focusedon(clyde, futuristicsubject) & focusedon(clyde, vocationalsubject))) => ~(((focusedon(clyde, futuristicsubject) & focusedon(clyde, vocationalsubject)) | (enjoy(clyde, dressingup, oldfashionedclothing) & enjoy(clyde, dressingup, historicalperiodclothing)))))).
fof(extra1, axiom, ((professor(clyde) & take(clyde, historicalapproach)))).

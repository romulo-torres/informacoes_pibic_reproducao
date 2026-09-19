% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ! [X] : (((disease(X) & require(X, medicaldiagnosis)) => (requiredfor(labtest, X) | requiredfor(imaging, X))))).
fof(p2, axiom, ! [X] : ((raredisease(X) => require(X, medicaldiagnosis)))).
fof(p3, axiom, ! [X] : (((disease(X) & mild(X)) => ~((requiredfor(labtest, X) | requiredfor(imaging, X)))))).
fof(p4, axiom, ! [X] : ((bloodcancer(X) => rarediseases(X)))).
fof(p5, axiom, ! [X] : (((disease(X) & leukemia(X)) => bloodcancer(X)))).
fof(p6, axiom, (disease(bladdercancer) & (bloodcancer(bladdercancer) | leukemia(bladdercancer)))).
fof(extra1, axiom, ((raredisease(bladdercancer) <~> mild(bladdercancer)))).

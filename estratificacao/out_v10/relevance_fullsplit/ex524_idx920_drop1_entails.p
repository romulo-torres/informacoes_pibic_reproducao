% premises + ~conclusion (UNSAT => entails)
fof(p1, axiom, impressedintoserviceby(britta, germany)).
fof(p2, axiom, ! [X] : (! [Y] : (((ship(X) & impressedintoserviceby(X, Y)) => seizedby(X, Y))))).
fof(p3, axiom, soldto(britta, hongkong)).
fof(extra1, axiom, ~(? [X] : (((cargoship(X) & seizedby(X, germany)) & soldto(X, hongkong))))).

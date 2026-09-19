% premises + conclusion (UNSAT => contradiction)
fof(p1, axiom, ((cargoship(britta) & ship(britta)) & builtfor(britta, norwegians))).
fof(p2, axiom, impressedintoserviceby(britta, germany)).
fof(p3, axiom, ! [X] : (! [Y] : (((ship(X) & impressedintoserviceby(X, Y)) => seizedby(X, Y))))).
fof(p4, axiom, soldto(britta, hongkong)).
fof(extra1, axiom, (seizedby(britta, hongkong))).

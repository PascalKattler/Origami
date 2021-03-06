InstallGlobalFunction(AllOrigamisByDegree, function(d)
	local C, part, Sd, canonicals, canonicals_x, canonicals_y, x;
  part := Partitions(d);
  canonicals := [];
  canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
	Sd := SymmetricGroup(d);
	for x in canonicals_x do
    	C := Centralizer(Sd, x);
    	canonicals_y := List(OrbitsDomain(C, Sd, OnPoints), Minimum);
    	Append(canonicals, List(canonicals_y, y -> rec(x := x, y := y)));
	od;
	canonicals := Filtered(canonicals, o -> IsTransitive(Group(o.x, o.y), [1..d]));
	Apply(canonicals, o -> OrigamiNC(o.x, o.y, d));
	return canonicals;
end);

InstallGlobalFunction(AllOrigamisInStratum, function(d, stratum)
	stratum := AsSortedList(stratum);
	return Filtered(AllOrigamisByDegree(d), O -> Stratum(O) = stratum);
end);

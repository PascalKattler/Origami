InstallMethod(
	Origami, [IsPerm, IsPerm], function(horizontal, vertical)
		local d;
		d :=  Maximum(LargestMovedPoint(horizontal), LargestMovedPoint(vertical)) - Minimum(SmallestMovedPoint(horizontal), SmallestMovedPoint(vertical)) + 1;
		if IsTransitive( Group(horizontal, vertical) ) = false 
			then Error("The described surface is not connected. The permutation group, generated by the two permutations, must act transitive on [1..d] ");
		fi;
		return OrigamiNC(horizontal, vertical, d);
	end
	);

InstallOtherMethod( Origami, [IsPerm, IsPerm, IsInt], function(horizontal, vertical, d)
		if IsTransitive( Group(horizontal, vertical) ) = false 
			then Error("The described surface is not connected. The permutation group, generated by the two permutations, must act transitive on [1..d] ");
		fi;
		return OrigamiNC(horizontal, vertical, d);
	end
	);


InstallGlobalFunction(
	OrigamiNC, function(horizontal, vertical, d)
		local Obj, ori;
		ori:= rec(d := d, x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(OrigamiFamily, IsOrigami and IsAttributeStoringRep) , HorizontalPerm, ori.x, VerticalPerm, ori.y, DegreeOrigami, d );
		return Obj;
	end
	);


InstallMethod(String, [IsOrigami], function(Origami)
	return Concatenation("Origami(", String(HorizontalPerm(Origami)), ", ", String(VerticalPerm(Origami)), ", ", String(DegreeOrigami(Origami)), ")");
	end
);

InstallMethod( DisplayString, [IsOrigami], function( origami )
	local s;
	s := Concatenation(String( origami ), "\n", "horizontal permutation = ", String(HorizontalPerm(origami)), "\n", "vertical permutation = ", String(VerticalPerm(origami)), "\n", "Genus = ", 			String( Genus( origami ) ), "\n", "Stratum = ", String( Stratum( origami ) ) );
	return s;
end);

InstallMethod(ViewString, [IsOrigami], function( origami )
	return String( origami );
end);

InstallMethod(PrintString, [IsOrigami], function( origami )
	return String( origami );
end);

InstallMethod(\=, [IsOrigami, IsOrigami], function(O1, O2)
	return (VerticalPerm(O1) = VerticalPerm(O2)) and (HorizontalPerm(O1) = HorizontalPerm(O2));
	end
);


InstallMethod(\<, [IsOrigami, IsOrigami], function(o1, o2) 
	if HorizontalPerm(o1) >  HorizontalPerm (o1) then return true;
		else if HorizontalPerm(o1) <  HorizontalPerm (o1) then return false; else return VerticalPerm(o1) < VerticalPerm(o2);fi; 
		fi;
end);



# This method specifies the hash key for origamis
InstallMethod(SparseIntKey, [IsObject, IsOrigami], function( b , origami )
	local HashForOrigami;
	HashForOrigami := function( origami )
    	return (hashForPermutations( HorizontalPerm(origami) ) + hashForPermutations( VerticalPerm(origami) ));
	end;	
	return HashForOrigami;
end);







#This function calculates the coset Graph of the Veech group of an given Origami O
#INPUT: An origami O
#OUTPUT: The coset Graph as Permutations sigma_S and Sigma_T
InstallGlobalFunction(CalcVeechGroup, function(O)
	local  sigma, HelpCalc, D, foundM, W, NewOrigamiPositions, canonicalOrigamiList, i, j, newOrigamis;
	sigma:=[[],[]];
	canonicalOrigamiList := [OrigamiNormalForm(O)];
	HelpCalc := function(GlList)
		NewOrigamiPositions := [];
		for W in GlList do
			newOrigamis := [OrigamiNormalForm( ActionOfT(W) ), OrigamiNormalForm( ActionOfS(W) )];
			for j in [1, 2] do
				foundM := false;
				for i in [1..Length(canonicalOrigamiList)] do
					if canonicalOrigamiList[i] = newOrigamis[j] then
						foundM := true;
						sigma[j][Position(canonicalOrigamiList, W)] := i;
						break;
					fi;
				od;
				if foundM = false then
					Add(canonicalOrigamiList, newOrigamis[j]);
					Add(NewOrigamiPositions, newOrigamis[j]);
					sigma[j][Position(canonicalOrigamiList, W)] := Length(canonicalOrigamiList);  # = Length(Rep) -1 ?
				fi;
			od;
		od;
		if Length(NewOrigamiPositions) > 0 then HelpCalc(NewOrigamiPositions); fi;
	end;
	HelpCalc([OrigamiNormalForm(O)]);
	return [ModularSubgroup(PermList(sigma[2]), PermList(sigma[1]))];
end);


InstallGlobalFunction(CalcVeechGroupWithHashTables, function(O)
	local NewOrigamiList, newOrigamis, sigma, HelpCalc, foundM, W, canonicalOrigamiList, i, j,
	 				counter, HelpO;
	counter := 1;
	sigma:=[[],[]];
	canonicalOrigamiList := [];
	HelpO := OrigamiNormalForm(O);
	SetindexOrigami (HelpO, 1);
	#AddHash(canonicalOrigamiList, HelpO,  hashForOrigamis);
	HelpCalc := function(GlList)
		NewOrigamiList := [];
		for W in GlList do
			newOrigamis := [OrigamiNormalForm(ActionOfT(W)), OrigamiNormalForm(ActionOfS(W))];
			for j in [1, 2] do
				 #M = newOrigamis[
				i := ContainHash( canonicalOrigamiList, newOrigamis[j], hashForOrigamis );
				if i = 0 then foundM := false; else foundM := true; fi;
				if foundM then
					sigma[j][indexOrigami(W)] := i;
				fi;
				if foundM = false then
					SetindexOrigami(newOrigamis[j], counter);
					AddHash(canonicalOrigamiList, newOrigamis[j], hashForOrigamis);
					Add(NewOrigamiList, newOrigamis[j]);
					sigma[j][indexOrigami(W)] := counter;
					counter := counter + 1;
				fi;
			od;
		od;
		if Length(NewOrigamiList) > 0 then HelpCalc(NewOrigamiList); fi;
	end;
	HelpCalc([HelpO]);
	return ModularSubgroup(PermList(sigma[2]), PermList(sigma[1]));
end);


InstallGlobalFunction(CalcVeechGroupWithHashTablesOld, function(O)
	local NewOrigamiList, newOrigamis, sigma, HelpCalc, foundM, W, canonicalOrigamiList, i, j,
	 				counter, HelpO;
	counter := 2;
	sigma:=[[],[]];
	canonicalOrigamiList := SparseHashTable();
	HelpO := OrigamiNormalForm(O);
	AddDictionary( canonicalOrigamiList, HelpO, 1 );
	HelpCalc := function(GlList)
		NewOrigamiList := [];
		for W in GlList do
			newOrigamis := [OrigamiNormalForm(ActionOfT(W)), OrigamiNormalForm(ActionOfS(W))];
			for j in [1, 2] do
				i := LookupDictionary(canonicalOrigamiList, newOrigamis[j]);
				if i = fail then foundM := false; else foundM := true; fi;
				if foundM then
					sigma[j][LookupDictionary(canonicalOrigamiList, W) ] := i;
				fi;
				if foundM = false then
					AddDictionary( canonicalOrigamiList, newOrigamis[j], counter  );
					Add(NewOrigamiList, newOrigamis[j]);
					sigma[j][ LookupDictionary(canonicalOrigamiList, W) ] := counter;
					counter := counter + 1;
				fi;
			od;
		od;
		if Length(NewOrigamiList) > 0 then HelpCalc(NewOrigamiList); fi;
	end;
	HelpCalc([HelpO]);
	return ModularSubgroup(PermList(sigma[2]), PermList(sigma[1]));
end);




InstallMethod(Genus, "for a origami", [IsOrigami], function(Origami)
	local s, i, e;
	e := 0;
	s := Stratum(Origami);
	for i in s do
		e := e + i;
	od;
	return ( e + 2 ) / 2;
end);

InstallMethod(VeechGroup, "for a origami", [IsOrigami], function(Origami)
	return CalcVeechGroupWithHashTables(Origami);
end);

InstallMethod(Cosets, "for a origami", [IsOrigami], function(Origami)
	return RightCosetRepresentatives(VeechGroup(Origami));
end);


#This function calculates the Stratum of an given Origami
#INPUT: An Origami O
#OUTPUT: The Stratum of the Origami as List of Integers.
InstallMethod(Stratum,"for a origami", [IsOrigami], function(O)
	local com, Stratum, CycleStructure, current,i, j;
	com:=HorizontalPerm(O)* VerticalPerm(O) * HorizontalPerm(O)^(-1) * VerticalPerm(O)^(-1);
	CycleStructure:= CycleStructurePerm(com);
	Stratum:=[];
	for i in [1..Length(CycleStructure)] do
		if IsBound(CycleStructure[i]) then
			for j in [1..CycleStructure[i]] do
				Add(Stratum, i);
			od;
		fi;
	od;
	return AsSortedList( Stratum);
end);






InstallGlobalFunction( EquivalentOrigami, function(O1, O2)
	if RepresentativeAction(SymmetricGroup(DegreeOrigami(O1)), [HorizontalPerm(O1), VerticalPerm(O1)],
																			[HorizontalPerm(O2), VerticalPerm(O2)], OnTuples) = fail
		 then return false;
	else
		return true;
	fi;
end
);

InstallGlobalFunction(IsConnectedOrigami, function(origami)
	return IsTransitive(Group(HorizontalPerm(origami), VerticalPerm(origami)), [1..DegreeOrigami(origami)]);
end);


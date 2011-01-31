
for l in [8..10] do
    s := Filtered([1..2000], x -> Length(Factors(x)) = l);
    s := Filtered(s, x -> not IsPrimePowerInt(x));
    s := Filtered(s, x -> not x in [384,576]);
    for i in s do
        grp := ConstructAllGroups(i);
        grp := Flat(grp);
        ids := List(grp, IdGroup);
        if ForAny(ids, x -> x[1] <> i) then Error("wrong order"); fi;
        ids := List(ids, x -> x[2]);
        if Set(ids) <> [1..NumberSmallGroups(i)] then Error("wrong grps"); fi;
        Print(i," done of ",Length(s)," for ",l,"\n");
    od;
od;
        


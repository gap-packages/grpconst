#############################################################################
##
#W  grpconst.gi                 GrpConst                         Bettina Eick
#W                                                         Hans Ulrich Besche
##

#############################################################################
##
#F AllNonSolublePerfectGroups( size ) . . . . . . . . . . . . . . . . . local
##
InstallGlobalFunction( AllNonSolublePerfectGroups, function( size )
    local n;
    n := NrPerfectGroups(size);
    if n = 0 or size = 1 then 
        return [];
    elif IsBool( n ) then
        return n;
    else
        return List( [1..n], x -> PerfectGroup(IsPermGroup, size, x) );
    fi;
end );

BindGlobal( "ConstructAllNilpotentGroups", function( arg )
    local size, uncoded, pr, grps, p, n, new, tmp, G, H, D;

    size := arg[1];
    uncoded := Length( arg ) = 2 and arg[2];

    pr := Factors( size );

    # nilpotent groups come from the SmallGroups library
    grps := [PcGroupCode( 0,1 )];
    size := 1;
    for p in Set( pr ) do
        n := Length( Filtered( pr, x -> x = p ) );
        if (p^n <> 512 and p^n <= 1000) or n <= 7 then
            new := AllSmallGroups( p^n, IsNilpotent, true );
        else
            Print("sorry - prime powers in order are too large\n");
            return fail;
        fi;
        tmp := [];
        for G in grps do
            if IsInt(G) then
                G := PcGroupCode( G, size );
            fi;
            for H in new do
                D := DirectProduct( G, H );
                if uncoded then
                    Add( tmp, D );
                else
                    Add( tmp, CodePcGroup( D ) );
                fi;
            od;
        od;
        size := size * p^n;
        grps := tmp; 
    od;

    return grps;
end );

BindGlobal( "ConstructAllSolvableNonNilpotentGroups", function( arg )
    local size, uncoded, pr, grps, new, tmp, cl, flags, i;

    size := arg[1];
    uncoded := Length( arg ) = 2 and arg[2];

    pr := Factors( size );
    grps := [];

    # if size is of  type p^n * q
    cl := Collected( pr );
    if Length( cl ) = 2 and cl[1][2] = 1 then
        new := CyclicSplitExtensionMethod(cl[2][1],cl[2][2],cl[1][1],uncoded);
        Append( grps, new.up );
        Append( grps, new.down );
        flags := rec( nonpnorm := Set( pr ) );
    elif Length( cl ) = 2 and cl[2][2] = 1 then
        new := CyclicSplitExtensionMethod(cl[1][1],cl[1][2],cl[2][1],uncoded);
        Append( grps, new.up );
        Append( grps, new.down );
        flags := rec( nonpnorm := Set( pr ) );
    else
        flags := rec( nonnilpot := true );
        # Use Sylow theorem to find primes p such that any group of
        # the given size must have a normal Sylow $p$-subgroup
        tmp := Filtered( cl, pk -> [1] = Filtered(
            DivisorsInt( size / pk[1]^pk[2] ), n -> (n mod pk[1]) = 1) );
        if Length( tmp ) > 0 then
            flags.pnormal := List( tmp, pk -> pk[1] );
            if flags.pnormal = Set( pr ) then
                # all Sylow subgroups are normal -> all groups are
                # nilpotent.
                return [ ];
            fi;
        fi;
    fi;

    # remaining soluble groups
    new := FrattiniExtensionMethod( size, flags, uncoded );
    Append( grps, new );
    if not uncoded then
        for i in [1..Length(grps)] do
            if IsList(grps[i]) then
                Assert(0, ForAll(grps[i], g -> g.order = size));
                grps[i] := List(grps[i], g -> g.code);
            else
                Assert(0, IsRecord(grps[i]));
                Assert(0, grps[i].order = size);
                grps[i] := grps[i].code;
            fi;
        od;
    fi;

    return grps;
end );

BindGlobal( "ConstructAllNonSolvableGroups", function( size )
    local grps, new, tmp, G, d;

    tmp := [];
    for d in DivisorsInt( size ) do
        new := AllNonSolublePerfectGroups( d );
        if IsBool( new ) then 
            Print("sorry - perfect groups are not available \n");
            return fail;
        fi;
        Append( tmp, new );
    od;

    grps := [];
    for G in tmp do
        if Size(Centre(G)) = 1 then 
            new := UpwardsExtensionsNoCentre( G, size/Size(G) );
        else
            new := UpwardsExtensions( G, size / Size(G) );
            new := new[Length(new)];
        fi;
        Append( grps, new );
    od;

    return grps;
end );

#############################################################################
##
#F ConstructAllGroups( size ) . . . . . .  construct all groups of given size
##
InstallGlobalFunction( ConstructAllGroups, function( size )
    local pr, grps; 

    # trivial case
    pr := Factors( size );
    if Length( pr ) <= 3 then return AllSmallGroups( size ); fi;

    grps := [];
    Append( grps, ConstructAllNilpotentGroups( size, true ) );
    Append( grps, ConstructAllSolvableNonNilpotentGroups( size, true ) );
    Append( grps, ConstructAllNonSolvableGroups( size ) );

    # now we got them all
    return grps;
end );
  

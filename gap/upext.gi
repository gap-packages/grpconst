#############################################################################
##
#W  upext.gi                      GrpConst                       Bettina Eick
#W                                                         Hans Ulrich Besche
##

#############################################################################
##
#F GroupOfInnerAutomorphismSpecial( G, A )
##
InstallGlobalFunction( GroupOfInnerAutomorphismSpecial,
function( G, A )
    local gens, autos, g, imgs, inn;
    gens := GeneratorsOfGroup( G );
    autos := [];
    for g in gens do
        imgs := List( gens, x -> x^g );
        inn := GroupHomomorphismByImagesNC( G, G, gens, imgs );
        Add( autos, inn );
    od;
    return SubgroupNC( A, autos );
end );

#############################################################################
##
#F AutomorphismGroupSpecial(G) 
##
## Characteristic direct products are a special case.
##
BindGlobal( "AutomorphismGroupSpecial", function(G)
    local N, C, U, 
          AN, AC, gensN, gensC, idN, idC, gens, autos, aut, imgs, auto,
          cls, tups, subl, tup, ext, tmp, cl, imgtup, n, orb, g, max, k, 
          i, I, A, img, t, len, all, vec, done, o;

    if HasAutomorphismGroup( G ) then
        return AutomorphismGroup( G );
    fi;

    # get char classes of G
    N := PerfectResiduum( G );
    C := Centralizer( G, N );
    U := Intersection( N, C );

    # catch the direct product case
    if Size(C) > 1 and Size(N) > 1 and Size(U) = 1 and 
       Size(N)*Size(C)=Size(G) then

        Info( InfoGrpCon, 3, "   Aut: compute aut group - direct product case");
        AN := AutomorphismGroup(N);
        AC := AutomorphismGroup(C);
        gensN := GeneratorsOfGroup( N );
        gensC := GeneratorsOfGroup( C );
        gens := Concatenation(gensN, gensC);
        autos := [];

        for aut in GeneratorsOfGroup( AN ) do
            imgs := List( gensN, x -> Image(aut, x) );
            Append( imgs, gensC );
            auto := GroupHomomorphismByImagesNC( G,G,gens,imgs ); 
            Add( autos, auto );
        od;

        for aut in GeneratorsOfGroup( AC ) do
            imgs := ShallowCopy( gensN );
            Append( imgs, List( gensC, x -> Image(aut, x) ) );
            auto := GroupHomomorphismByImagesNC( G,G,gens,imgs ); 
            Add( autos, auto );
        od;
        A := Group( autos, IdentityMapping(G) );
        SetIsFinite( A, true );
        SetIsAutomorphismGroup( A, true );
        SetAutomorphismGroup( G, A );
        return A;
    fi;
    Info( InfoGrpCon, 3, "   Aut: compute aut group - general case ");
    return AutomorphismGroup( G );
end );

#############################################################################
##
#F DirectSplitting( G, N )
##
BindGlobal( "DirectSplitting", function( G, N )
   local C, U, cl, norm;
   
   C := Centralizer( G, N );
   U := Intersection( C, N );

   if Size(C)*Size(N)/Size(U) <> Size(G) then
       return [G];
   fi;
   if Size(U) = 1 then return [G, C]; fi;

   if IsSolvableGroup( U ) then
       cl := ComplementClassesRepresentatives( C, U );
       cl := Filtered( cl, x -> IsNormal(G,x) );

       if Length(cl)>0 then
           return [G, cl[1]]; 
       else
           return [G];
       fi;
   fi;

   norm := NormalSubgroups( C );
   norm := Filtered(norm, x -> Size(x) = Size(C)/Size(U) );
   norm := Filtered(norm, x -> Size(Intersection(U,N)) = 1 );
   if Length(norm)>0 then
       return [G, norm[1]];
   else
       return [G];
   fi;
end );

#############################################################################
##
#F RandomIsomorphismTestUEM( G, H )
##
BindGlobal( "RandomIsomorphismTestUEM", function( G, H )
    local cocl, cocr, size, ngens, size_inner, elms, poses, pos, qual, i, j,
          gens1, gens2, f, tpos, tqual, len_classes;

    cocl := List( [ G, H ], CocGroup );
    cocr := DiffCocList( cocl, false );
    if cocr[ Length( cocr ) ] <> fail then
        Info( InfoRandIso, 2, "RandomIsomorphismTestUEM distinguishs groups" );
        return false;
    fi;

    size := Size( G );
    ngens := Length( SmallGeneratingSet( G ) );
    size_inner := size / Size( Center( G ) );

    cocl := List( cocl, x -> List( x, Concatenation ) );
    len_classes := List( cocl[ 1 ], Length );
    elms := Concatenation( cocl[ 1 ] );
    poses := Concatenation( List( [ 1 .. Length( len_classes ) ],
                          x -> List( [ 1 .. len_classes[ x ] ], y -> x ) ) );
    SortParallel( elms, poses );
    pos := fail;
    qual := size ^ ngens;
    for i in [ 1 .. 1000 ] do
        gens1 := List( [ 1 .. ngens ], x -> Random( AsList( G ) ) );
        tpos := List( gens1, x -> poses[ Position( elms, x ) ] );
        tqual := Product( len_classes{ tpos } );
        if ( tqual >= size_inner ) and ( tqual < qual ) and
           ( Size( Group( gens1 ) ) = size ) then
            pos := tpos;
            qual := tqual;
        fi;
    od;
    if pos = fail then
        Info( InfoRandIso, 1, "RandomIsomorphismTestUEM: ",
                         " no generating system found" );
        return fail;
    fi;
    Info( InfoRandIso, 3, "RandomIsomorphismTestUEM: ", qual,
                         " generating system candidates" );

    j := 0;
    f := 0;
    cocl := List( cocl, x -> x{ pos } );
    while true do
        j := j + 1;
        repeat 
            gens1 := List( cocl[ 1 ], Random );
            f := f + 1;
            if j + f > 10000 then
                Info( InfoRandIso, 2,
                      "RandomIsomorphismTestUEM failed to decide" );
                return fail;
            fi;
        until Size( Group( gens1 ) ) = size;
        repeat 
            gens2 := List( cocl[ 2 ], Random );
            f := f + 1;
            if j + f > 10000 then
                Info( InfoRandIso, 2,
                      "RandomIsomorphismTestUEM failed to decide" );
                return fail;
            fi;
        until Size( Group( gens2 ) ) = size;
        if GroupHomomorphismByImages( G, H, gens1, gens2 ) <> fail then
            Info( InfoRandIso, 2, "RandomIsomorphismTestUEM ",
                                "found isomorphism" );
            return true;
        fi;
        if j mod 50 = 0 then
            Info( InfoRandIso, 5, "RandomIsomorphismTestUEM: ", j,
                                 " loops without isomorphism" );
        fi;
    od;
end );

#############################################################################
##
#F IsomorphismTest( G, H )
##
BindGlobal( "IsomorphismTest", function( G, H )
    local homG, homH, dirG, dirH, res, i;

    # the factor
    Info( InfoGrpCon, 4, "    Iso: test isomorphism on groups of size ",Size(G));
    homG := NaturalHomomorphismByNormalSubgroupNC( G, PerfectResiduum(G) );
    homH := NaturalHomomorphismByNormalSubgroupNC( H, PerfectResiduum(H) );
    if IdGroup( Image( homG ) ) <> IdGroup( Image( homH ) ) then
        return false;
    fi;

    # check for direct splittings
    dirG := DirectSplitting( G, PerfectResiduum(G) );
    dirH := DirectSplitting( H, PerfectResiduum(H) );
    if Length( dirG ) <> Length( dirH ) then
        return false;
    elif Length( dirG ) = 2 then
        return true;
    fi;

    # lets make some random tests
    for i in [ 1 .. 3 ] do
        res := RandomIsomorphismTestUEM( G, H );
        if res in [ true, false ] then
            return res;
        fi;
    od;

    # the final test - both groups are not direct splittings
    return not IsBool( IsomorphismGroups( G, H ) );
end );

#############################################################################
##
#F ReducedList( size, list )
##
BindGlobal( "ReducedList", function( size, list )
    local rem, types, G, new, i, H, iso, g, h;

    if Length( list ) <= 1 then return list; fi;

    rem   := [1..Length(list)];
    types := [];

    while Length(rem) > 0 do
        g := list[rem[1]];
        G := Group( g, () );
        SetSize( G, size );
        new := [rem[1]];
        Add( types, g );

        # compute isomorphic copies
        for i in [2..Length(rem)] do
            h := list[rem[i]];
            H := Group( h, () );
            SetSize( H, size );
            iso := IsomorphismTest( G, H );
            if iso then
                Add( new, rem[i] );
            fi;
        od;

        # delete them from rem
        rem := Difference( rem, new );
    od;

    return types;
end );  

#############################################################################
##
#F IsomorphismClasses( size, list )
##
BindGlobal( "IsomorphismClasses", function( size, list )
    local sub, fin, G, f, j, i, g, finger;
    
    if Length( list ) <= 1 then return list ; fi;
    Info( InfoGrpCon, 3,"   Iso: test isom on ", Length(list)," groups ");

    Assert(0, size = Size( Group( list[1], () ) ));
    if ID_AVAILABLE(size) <> fail then
        finger := IdGroup;
    else
        finger := FingerprintFF;
    fi;

    # first compute fingerprints
    sub := [];
    fin := [];
    for i in [1..Length(list)] do
        if InfoLevel(InfoGrpCon) >= 3 then
            Print("\r", "#I      computing fingerprint ", i, "/", Length(list), "\c");
        fi;
        g := list[i];
        G := Group( g, () );
        SetSize( G, size );
        f := finger( G );
        j := Position( fin, f );
        if IsBool( j ) then
            Add( sub, [g] );
            Add( fin, f );
        else
            Add( sub[j], g );
        fi;
    od; 
    if InfoLevel(InfoGrpCon) >= 3 then
        Print("\r");
    fi;
    SortBy( sub, Length );
    Info( InfoGrpCon, 3, "   Iso: split up in sublists of length ",
                        List( sub, Length ) );

    # now reduce
    for i in [1..Length(sub)] do
        Info( InfoGrpCon, 3, "   Iso: start sublist ", i ,"/", Length(sub),
              " of length ", Length(sub[i]) );
        sub[i] := ReducedList( size, sub[i] );
    od;
    sub := Concatenation( sub );
    Info( InfoGrpCon, 3, "   Iso: reduced to ",Length(sub)," groups" );
    return sub;
end );

#############################################################################
##
#F CyclicExtensionByTuple( G, p, aut, n )
##
InstallGlobalFunction( CyclicExtensionByTuple,
function( G, p, aut, n )
    local d, gens, base, g, x, m, i, c, shift, shifts, k, l, H, new, N;

    # all shifting perms
    gens := GeneratorsOfGroup( G );
    d    := LargestMovedPointPerms( gens );
    shifts := List( [1..p], x -> MappingPermListList( [1..d], 
                    [(x-1)*d+1..x*d] ) );

    # the base
    base := [];
    for g in gens do
        x := g;
        m := g;
        for i in [1..p-1] do
            m := Image( aut, m ); 
            x := x * (m^shifts[i+1]);
        od;
        Add( base, x );
    od;
    
    # the cyclic extension
    x := n^shifts[p];
    shift := [];
    for i in [1..p] do
        k := RemInt( i, p );
        for l in [1..d] do
            shift[(i-1)*d+l] := k*d+l;
        od;
    od;
    shift := PermList( shift );
    shift := x^-1 * shift;
    Add( base, shift );
    
    H := Group( base, () );
    if not Size(H) = Size(G)*p then 
        Error("wrong up ext \n");
    fi;

    H := Image( SmallerDegreePermutationRepresentation( H : cheap ) );

    return SmallGeneratingSet( H );
end );

#############################################################################
##
#F ConjugatingElement( G, inn )
##
BindGlobal( "ConjugatingElement", function( G, inn )
    local elm, C, g, h, n, gens, imgs, i;

    elm := Identity( G );
    C   := G;
    gens := GeneratorsOfGroup( G );
    imgs := List( gens, x -> Image( inn, x ) );
    for i in [1..Length(gens)] do
        g := gens[i];
        h := imgs[i];
        n := RepresentativeAction( C, g, h );
        elm := elm * n;
        C := Centralizer( C, g^n );
        gens := List( gens, x -> x ^ n );
    od;
    return elm;
end );

#############################################################################
##
#F CyclicExtensions( G, p )
##
InstallGlobalFunction( CyclicExtensions,
function( G, p )
    local A, I, iso, PA, PI, cl, res, a, h, e, m, C, fix, f, H, F, hom;

    # compute automorphisms group and inner autos
    A := AutomorphismGroupSpecial( G:nogensyssearch );
    I := GroupOfInnerAutomorphismSpecial( G, A );

    # compute perm reps
    iso := IsomorphismPermGroup( A );
    #iso := ActionHomomorphism( A, AsList(G) );
    PA := Image( iso );
    PI := Image( iso, I );
    hom := NaturalHomomorphismByNormalSubgroup( PA, PI );
    F := Image( hom );

    # compute rational classes of elements with a^p in PI
    cl := RationalClasses( F );
    cl := List( cl, x -> Representative( x ) );
    cl := Filtered( cl, x -> x^p = Identity( F ) );
    cl := List( cl, x -> PreImagesRepresentative( hom, x ) );

    # for each rep compute elements of G corresponding to a^p
    res := [];
    for a in cl do
        h := PreImagesRepresentative( iso, a );
        e := h^p;
        m := ConjugatingElement( G, e ); 
 
        C := Centre( G );
        fix := Filtered( RightCoset( C, m ), x -> Image(h,x) = x );

        # compute extensions
        for f in fix do
            H := CyclicExtensionByTuple( G, p, h, f );
            Add( res, H );
        od;
    od;
    Info( InfoGrpCon, 2, "   found ",Length(res)," extensions ");
    return List( res, x -> Group(x, ()) );
end );

#############################################################################
##
#F UpwardsExtensions( P, stepsize )
##
InstallGlobalFunction( UpwardsExtensions,
function( P, stepsize )
    local div, grps, size, i, d, r, pr, G, p, ext, j, gens, A, n, k;

    # the trivial stuff
    if stepsize = 1 then return [[P]]; fi;

    # start loop
    div := DivisorsInt( stepsize );
    grps := List( div, x -> [] );

    if IsList( P ) then
        size := Gcd( List( P, Size ) );
        for i in [ 1 .. Length( P ) ] do
           Add( grps[ Position( div, Size( P[ i ] ) / size ) ], 
                SmallGeneratingSet( P[ i ] ) );
        od;
    elif IsGroup( P ) then
        grps[1] := [SmallGeneratingSet(P)];
        size := Size(P);
    fi;

    for i in [1..Length(div)-1] do
        d := div[i];
        r := stepsize/d;
        pr := Set( FactorsInt( r ) );
        Info( InfoGrpCon, 1, "extend groups of size ", d*size,
                            " by primes ",pr );

        n := Length( grps[i] );

        # extend each group in turn
        for k in [1..n] do

            Info( InfoGrpCon, 1, " start group ",k," of ",n );
            G := Group( grps[i][k], () );
            for p in pr do

                Info( InfoGrpCon, 1,"  start prime ",p);
                ext := CyclicExtensions( G, p );
                ext := List( ext, x -> GeneratorsOfGroup( x ) );
                j := Position( div, d * p );
                Append( grps[j], ext );
            od;
        od;

        # reduce to isomorphism classes
        Info( InfoGrpCon, 2, "Iso: reduce to isomorphism clasess \n");
        grps[i+1] := IsomorphismClasses( div[i+1] * size, grps[i+1] );
    od;

    Info( InfoGrpCon, 1, "extensions for steps ",div );

    # go back to groups
    for i in [1..Length(div)] do
        grps[i] := List( grps[i], x -> Group(x,()) );
    od;

    return grps;
end );

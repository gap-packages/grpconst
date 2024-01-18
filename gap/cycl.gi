#############################################################################
##
#W  cycl.gi                     GrpConst                         Bettina Eick
#W                                                         Hans Ulrich Besche
##

#############################################################################
##
#F QClasses( A, q )
##
BindGlobal( "QClasses", function( A, q )
    local hom, P, S, cl;

    hom := NiceMonomorphism( A );
    P := NiceObject( A );

    # if there is no or only one q-class
    if not IsInt( Size(P)/q ) then 
        return []; 
    elif not IsInt( Size(P)/(q^2)) then
        S := SylowSubgroup( P, q );
        return [ PreImage( hom, GeneratorsOfGroup(S)[1] ) ];
    fi;
    
    # otherwise compute
    cl := MyRatClassesPElmsReps( P, q );
    cl := List( cl, x -> PreImage(hom, x));
    return cl;
end );

#############################################################################
##
#F CyclicSplitExtensionsUp( G, q, uncoded )
##
InstallGlobalFunction( CyclicSplitExtensionsUp,
function( arg )
    local G, q, uncoded, res, C, g, A, iso, P, cl, h, l, U, hom, S, code;

    # catch arguments
    G := arg[1];
    q := arg[2];
    if Length( arg ) = 3 then
        uncoded := arg[3];
    else
        uncoded := false;
    fi;
    Info( InfoGrpCon, 2, "  extend up --  p^n = ", Size(G), " and q = ", q );

    # compute cyclic group and generator
    C := CyclicGroup( q );
    g := GeneratorsOfGroup( C )[1];

    # get automorphism group 
    A := AutomorphismGroup( G );
    Info( InfoGrpCon, 3, "    aut group has size ", Size(A) );

    # get classes
    cl := QClasses( A, q );

    # loop over classes
    Info( InfoGrpCon, 3, "    have ",Length(cl)," classes to process");
    res := [];
    for h in cl do
        U := SubgroupNC( A, [h] );
        hom := GroupHomomorphismByImagesNC( C, U, [g], [h] );
        S := SplitExtension( C, hom, G );
        code := CodePcGroup( S );
        Add( res, rec( code := code, order := Size(G)*q ) );
    od;
    if uncoded then
        return List( res, x -> PcGroupCode( x.code, x.order ) );
    fi;
    return res;
end);

#############################################################################
##
#F CyclicGenerator( C )
##
InstallGlobalFunction( CyclicGenerator,
function( C )
    if IsTrivial( C ) then
        return One( C );
    fi;
    return MinimalGeneratingSet( C )[ 1 ];
end);

#############################################################################
##
#F NormalSubgroupsCyclicFactor( G, d )
##
BindGlobal( "NormalSubgroupsCyclicFactor", function( G, d )
    local nat, F, norms, i, max;

    nat := MaximalAbelianQuotient( G );
    F := Image( nat );

    norms := ShallowCopy( MaximalSubgroups( F ) );
    if not IsElementaryAbelian( F ) and not IsPrime( d ) then
        i := 1;
        while i <= Length( norms ) do
            max := MaximalSubgroups( norms[i] );
            max := Filtered( max, x -> IsInt( d / Index(F,x) ) );
            max := Filtered( max, x-> IsCyclic( F/x ) );
            Append( norms, max );
            i := i + 1;
        od;
    fi;
    return List( norms, x -> PreImage( nat,x ) );
end );

#############################################################################
##
#F CyclicSplitExtensionsDown( G, q, uncoded )
##
InstallGlobalFunction( CyclicSplitExtensionsDown,
function( arg )
    local G, q, uncoded, res, AutG, C, g, AutC, genC, D, norms, f, N, hom, 
          F, gensN, gensF, 
          niceMon, niceAutG, gensAutG, gensNiceAutG,
          imgsF, gens, r, genU, U, genF, i, S, ind, aut, imgs, AutF, 
          Sind, reps, E, l;

    # catch arguments
    G := arg[1];
    q := arg[2];
    if Length( arg ) = 3 then
        uncoded := arg[3];
    else
        uncoded := false;
    fi;
    Info( InfoGrpCon, 2, "  extend down -- p^n = ", Size(G), " and q = ", q );
    if not IsInt( (q-1) / PrimePGroup(G) ) then return []; fi;

    # get q-Sylow subgroup and aut group
    C := CyclicGroup( q );
    g := GeneratorsOfGroup( C )[1]; 
    AutC := AutomorphismGroup( C );
    genC := CyclicGenerator( AutC );

    # get automorphism group of G
    AutG := AutomorphismGroup( G );
    niceMon := NiceMonomorphism( AutG );
    niceAutG := NiceObject( AutG );
    gensNiceAutG := GeneratorsOfGroup( niceAutG );
    gensAutG := List(gensNiceAutG, x -> PreImage(niceMon, x));
    Info( InfoGrpCon, 3, "    aut group has size ", Size(AutG));

    # compute orbits of normal subgroups with cyclic quotients
    norms := NormalSubgroupsCyclicFactor( G, q-1 );
    f := function( pt, a ) return Image( a, pt ); end;
    norms := List( Orbits( AutG, norms, f ), x -> x[1] );

    # loop over normal subgroups
    Info( InfoGrpCon, 3, "    have ",Length(norms)," orbits to process");
    res := [];
    for N in norms do

        hom := NaturalHomomorphismByNormalSubgroupNC(G, N);
        F := Image( hom );
        genF  := CyclicGenerator( F ); 
        gensN := Pcgs(N);
        gensF := Pcgs(G) mod gensN;
        imgsF := List( gensF, x -> Image( hom, x ) );
        gens  := Concatenation( gensF, gensN );

        # compute automorphism of C of order G/N
        Info( InfoGrpCon, 4, "      isom of abelian groups");
        l := (q-1) / Size(F);
        genU := genC^l;
        U    := SubgroupNC( AutC, [genU] );
        i    := GroupHomomorphismByImagesNC( F, U, [genF], [genU] ); 
        
        # compute cosets
        Info( InfoGrpCon, 4, "      compute stabilizer");
        S := Stabilizer( niceAutG, N, gensNiceAutG, gensAutG, f );
        S := PreImage( niceMon, S );

        ind := [];
        Info( InfoGrpCon, 4, "      compute induced subgroup");
        for aut in GeneratorsOfGroup( S ) do
            imgs := List( gensF, x -> Image( hom, Image( aut, x ) ) );
            Add( ind, GroupHomomorphismByImagesNC( F, F, imgsF, imgs ) );
        od;
        AutF := AutomorphismGroup( F );
        Sind := SubgroupNC( AutF, ind );
        reps := List( RightCosets( AutF, Sind ), Representative );
  
        # loop
        Info( InfoGrpCon, 4, "      have ",Length(reps)," reps to process");
        for r in reps do
            imgs := List( imgsF, x -> Image( i, Image(r, x ) ) );
            Append( imgs, List( gensN, x -> Identity( AutC ) ) );

            hom := GroupHomomorphismByImagesNC( G, AutC, gens, imgs );
            E := SplitExtension( G, hom, C );
            Add( res, rec( code := CodePcGroup( E ), order := Size(G)*q ) );
        od;  
    od;
    if uncoded then
        return List( res, x -> PcGroupCode( x.code, x.order ) ) ;
    fi;
    return res;
end );

#############################################################################
##
#F CyclicSplitExtensions( G, q, uncoded )
##
InstallGlobalFunction( CyclicSplitExtensions,
function( arg )
    local G, q, uncoded, up, down, both, D;

    # catch arguments
    G := arg[1];
    q := arg[2];
    if Length( arg ) = 3 then
        uncoded := arg[3];
    else
        uncoded := false;
    fi;

    # the two difficult cases
    up := CyclicSplitExtensionsUp( G, q, uncoded );
    down := CyclicSplitExtensionsDown( G, q, uncoded );

    # the trivial case
    D := DirectProduct( G, CyclicGroup(q) );
    if uncoded then 
        both := [D];
    else
        both := [CodePcGroup( D )];
    fi;
    return rec(up := up, down := down, both := both);
end );

#############################################################################
##
#F CyclicSplitExtensionMethod( p, n, pr, uncoded )
##
InstallGlobalFunction( CyclicSplitExtensionMethod,
function( arg )
    local p, n, uncoded, m, up, down, both, i, G, ext, q, l;

    # catch arguments
    p := arg[1];
    n := arg[2];
    if IsList( arg[3] ) then 
        l := arg[3];
    else 
        l := [arg[3]]; 
    fi;
    if Length( arg ) = 4 then
        uncoded := arg[4];
    else
        uncoded := false;
    fi;

    m := NumberSmallGroups( p^n );
    Info( InfoGrpCon, 1, "compute extensions of ",m," groups of order ",
                         p^n );
    up := [];
    down := [];
    both := [];
    for i in [1..m] do
        Info( InfoGrpCon, 1, "start extending group ",i );
        G := SmallGroup( p^n, i );
        NiceMonomorphism( AutomorphismGroup( G ) );
        for q in l do
            ext := CyclicSplitExtensions( G, q, uncoded );
            Append( up, ext.up );
            Append( down, ext.down );
            Append( both, ext.both );
        od;
    od;
    return rec( up := up, down := down, both := both );
end );

#############################################################################
BindGlobal( "NumberChecks", function( p, n, q )
    local o, k, i, G, u, d;
    o := p^n * q;
    k := NumberSmallGroups( o );
    u := 0;
    d := 0;
    for i in [1..k] do
        G := SmallGroup( o, i );
        if not IsNilpotent( G ) then
            if IsNormal( G, SylowSubgroup( G, p ) ) then
                u := u + 1;
            elif IsNormal( G, SylowSubgroup( G, q ) ) then
                d := d + 1;
            fi;
        fi;
    od;
    return rec( up := u, down := d );
end );


#############################################################################
##
#W  semisim.gi                  GrpConst                         Bettina Eick
#W                                                         Hans Ulrich Besche
##
Revision.("grpconst/gap/semisim_gi") :=
    "@(#)$Id: semisim.gi,v 1.5 2002/01/29 19:26:15 gap Exp $";

#############################################################################
##
#F BlockDiagonalMat( blocks, field )
##
InstallGlobalFunction( BlockDiagonalMat, function( blocks, field )
    local c, n, new, mat, i, j;
    c := 0;
    n := Sum( List( blocks, Length ) );
    new := MutableNullMat( n, n, field );
    for mat in blocks do
        for i in [1..Length(mat)] do
            for j in [1..Length(mat)] do
                new[c+i][c+j] := mat[i][j];
            od;
        od;
        c := c + Length( mat );
    od;
    return new;
end );

#############################################################################
##
#F Choices( part, irr ) . . . jeder gegen jeden
##
InstallGlobalFunction( Choices, function( part, irr )
    local col, sub, new, i, tmp, U;

    # catch the trivial case
    if ForAny( Set(part), x -> Length(irr[x]) = 0 ) then
        return [];
    fi;

    # first for each homogeneous sublist of part
    col := Collected( part );
    sub := List( col, c -> UnorderedTuples( irr[c[1]], c[2] ) );

    # now combine
    new := sub[1];
    for i in [2..Length(col)] do
        tmp := [];
        for U in new do
            Append( tmp, List( sub[i], x -> Concatenation(U,x) ) );
        od;
        new := Set( tmp );
    od;
    return new;
end );

#############################################################################
##
#F EmbeddingIntoGL( M, part, list )
##
InstallGlobalFunction( EmbeddingIntoGL, function( M, part, list )
    local new, r, f, i, e, l, gens, U;
    new := [];
    r := Length(list);
    f := FieldOfMatrixGroup(list[1]);
    for i in [1..r] do
        e := Sum(part{[1..i-1]});
        l := Sum(part{[i+1..r]});
        gens := GeneratorsOfGroup( list[i] );
        gens := List( gens, x -> [IdentityMat(e, f), x, IdentityMat(l, f)] );
        gens := List( gens, x -> BlockDiagonalMat( x, f ) ); 
        U := Subgroup( M, gens ); 
        SetSize( U, Size( list[i] ) );
        Add( new, U );
    od;
    return new;
end );

#############################################################################
##
#F ComputeSocleDimensions( U )
##
ComputeSocleDimensions := function( U )
    local isom, modu, comp, dims;
    isom := Projections(U)[1];
    modu := GModuleByGroup( Image(isom, U) );
    comp := MTX.CompositionFactors( modu );
    dims := List( comp, x -> x.dimension );
    Sort( dims );
    SetSocleDimensions( U, dims );
end;

#############################################################################
##
#F ReduceConjugates( P, all )
##
ReduceConjugates := function( P, all )
    local sub, U, found, j;

    sub := [];
    for U in all do
        found := false;
        j := 1;
        while not found and j <= Length( sub ) do
            if RepresentativeAction( P, U, sub[j] ) <> fail then
                found := true;
            fi;
            j := j + 1;
        od;
        if not found then Add( sub, U ); fi;
    od;
    return sub;
end;

#############################################################################
##
#F SemiSimpleGroups( n, p, sizes, supersol )
##
## - up to conjugacy in GL(n,p)
## - if size is not false, then of order dividing one size in sizes
## - if supersol, then the irreducible constituents are 1-dimensional
##
InstallGlobalFunction( SemiSimpleGroups, function( n, p, sizes, supersol ) 
    local M, field, iso, P, gensP, imgsP, inv, parts, irr, subdir, part, 
          cand, all, list, emb, new, sub, i, dims, d;

    # set up
    M := GL(n, p);
    field := GF(p);

    # size is a list of possible sizes
    if IsBool( sizes ) then 
        sizes := [Size( M )]; 
    elif IsInt( sizes ) then
        sizes := [sizes];
    elif IsList( sizes ) then
        sizes := MinimizeList( sizes );
    else
        Error("wrong input in SemiSimpleGroups");
    fi;

    # compute isomorphisms iso and inv
    iso   := IsomorphismPermGroup( M );
    P     := Image( iso );
    gensP := GeneratorsOfGroup( P );
    imgsP := List( gensP, x -> PreImagesRepresentative( iso, x ) );
    inv   := GroupHomomorphismByImagesNC( P, M, gensP, imgsP );
        
    # check supersol 
    if supersol or ForAll( sizes, x -> Set(FactorsInt(x))=[p] ) then
        parts := [List( [1..n], x -> 1 )];
        dims  := [1];
    else
        parts := Partitions( n );
        dims  := [1..n];
    fi;

    # first we catch a special case
    if not supersol and Length( sizes ) = 1 and IsPrime(sizes[1]) and
       sizes[1] <> p then
        sub := RationalClassesPElements( P, sizes[1] );
        sub := List( sub, Representative );
        sub := Filtered( sub, x -> IsInt( sizes[1]/Order( x ) ) );
        sub := List( sub, x -> Subgroup( P, [x] ) );
        Add( sub, TrivialSubgroup( P ) );
        for i in [1..Length(sub)] do
            SetProjections( sub[i], [inv] );
            ComputeSocleDimensions( sub[i] );
        od;
        return sub;
    fi;

    # compute irreducible groups
    irr := List( dims, x -> [] );
    for d in dims do
        for i in [1..Length(sizes)] do
            new := IrreducibleGroups( d, p, sizes[i] );
            new := Filtered( new, x -> UnknownSize(sizes{[1..i-1]}, Size(x)));
            Append( irr[d], new );
        od;
    od;

    subdir := [];
    for part in parts do
        Sort( part );

        # construct candidates first
        cand := Choices( part, irr );
    
        # compute subdirect products within P
        all := [];
        for list in cand do
            emb := EmbeddingIntoGL( M, part, list );
            emb := List( emb, x -> Image( iso, x ) );
            new := InnerSubdirectProducts( P, emb );
            new := Filtered( new, x -> KnownSize( sizes, Size(x) ) );
            Append( all, new );
        od;

        # filter conjugates in P
        sub := ReduceConjugates( P, all ); 

        # add some information
        for i in [1..Length(sub)] do
            SetSocleDimensions( sub[i], part );
            SetProjections( sub[i], [inv] );
        od;
        Append( subdir, sub );
    od;
    return subdir; 
end );

#############################################################################
##
#F Test to check semisimple
##
TestSemiSimple := function(s)
    local ppi, q, p, n, max, size, emb, cat;
    ppi := Filtered( [s..255], x -> IsPrimePowerInt(x) and not IsPrime(x) );
    for q in ppi do
        p := Factors(q)[1];
        n := Length( Factors(q) );
        max := QuoInt( 2000, q );
        for size in [1..max] do
            Print("start ", p, "^", n," and size ", size,"\n");
            emb := SemiSimpleGroups( n, p, size, false );
        od;
    od;
end; 

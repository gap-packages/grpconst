#############################################################################
##
#W  intdiv.gi                  GrpConst                          Bettina Eick
#W                                                         Hans Ulrich Besche
##

#############################################################################
##
#F UnknownSize( sizes, n ) . . .check
##
BindGlobal( "UnknownSize", function( sizes, n )
    return not ForAny( sizes, x -> IsInt(x/n) );
end );

#############################################################################
##
#F KnownSize( sizes, n ) . . .check
##
BindGlobal( "KnownSize", function( sizes, n )
    return ForAny( sizes, x -> IsInt(x/n) );
end );

#############################################################################
##
#F MinimizeList( list ) . . . . . . . . . . . . . . . . . . . . . reduce list
##
BindGlobal( "MinimizeList", function( list )
    local new, l;
    new := list{[1]};
    for l in list{[2..Length(list)]} do
        if UnknownSize( new, l ) then
            new := Filtered( new, x -> not IsInt(l/x) );
            Add( new, l );
        fi;
    od;
    return new;
end );

#############################################################################
##
#F IsCubeFree( m )
##
BindGlobal( "IsCubeFree", function( m )
    return ForAll( Collected(Factors(m)), x -> x[2] <= 2 );
end );


#############################################################################
##
#F MaximalAutSize( n )
##
BindGlobal( "MaximalAutSize", function( n )
    local s;
    s := Collected( FactorsInt( n ) );
    return Product( s, x -> SizeGL( x[2], x[1] ) );
end );

#############################################################################
##
#W  intdiv.gi                  GrpConst                          Bettina Eick
#W                                                         Hans Ulrich Besche
##

#############################################################################
##
#F UnknownSize( sizes, n ) . . .check
##
UnknownSize := function( sizes, n )
    return not ForAny( sizes, x -> IsInt(x/n) );
end;

#############################################################################
##
#F KnownSize( sizes, n ) . . .check
##
KnownSize := function( sizes, n )
    return ForAny( sizes, x -> IsInt(x/n) );
end;

#############################################################################
##
#F MinimizeList( list ) . . . . . . . . . . . . . . . . . . . . . reduce list
##
MinimizeList := function( list )
    local new, l;
    new := list{[1]};
    for l in list{[2..Length(list)]} do
        if UnknownSize( new, l ) then
            new := Filtered( new, x -> not IsInt(l/x) );
            Add( new, l );
        fi;
    od;
    return new;
end;

#############################################################################
##
#F SizeOfGL( n, p )
##
SizeOfGL := function( n, p )
    return Product( [1..n], x -> p^n - p^(x-1) );
end;

#############################################################################
##
#F IsCubeFree( m )
##
IsCubeFree := function( m )
    return ForAll( Collected(Factors(m)), x -> x[2] <= 2 );
end;


#############################################################################
##
#F MaximalAutSize( n )
##
MaximalAutSize := function( n )
    local s;
    s := Collected( FactorsInt( n ) );
    return Product( s, x -> SizeOfGL( x[2], x[1] ) );
end;

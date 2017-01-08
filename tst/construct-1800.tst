gap> START_TEST("construct-1800.tst");
gap> ConstructAndTestAllGroups := function( size )
> local grps;
>     grps := ConstructAllGroups( size );
>    if Length( grps ) <> NumberSmallGroups( size ) then
>        Print( "wrong number of groups of size ", size, "\n" );
>    fi;
>    if Set( List( grps, IdGroup ) ) <>
>       List( [ 1 .. NumberSmallGroups( size ) ], x -> [ size, x ] ) then
>        Print( "wrong ids for the groups of size ", size, "\n" );
>    fi;
> end;;
gap> ConstructAndTestAllGroups( 1800 );;
gap> STOP_TEST( "construct-1800.tst", 10000 );

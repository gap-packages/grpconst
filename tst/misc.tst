gap> START_TEST("misc.tst");

# CyclicGenerator
gap> CyclicGenerator(TrivialGroup(IsPcGroup));
<identity> of ...
gap> CyclicGenerator(TrivialGroup(IsPermGroup));
()
gap> CyclicGenerator(TrivialGroup(IsFpGroup));
<identity ...>
gap> CyclicGenerator(Group(  (1,2,3,4), (1,3)(2,4), (1,4,3,2) ));
(1,2,3,4)

#
gap> STOP_TEST( "misc.tst", 10000 );

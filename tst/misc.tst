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

# UpwardsExtensionsNoCentre
gap> res := UpwardsExtensionsNoCentre(PSL(3,4), 2);
[ <permutation group with 3 generators>, <permutation group with 3 generators>
    , <permutation group with 3 generators>, 
  <permutation group with 3 generators> ]
gap> List(res, Size);
[ 40320, 40320, 40320, 40320 ]
gap> List(res, StructureDescription);
[ "C2 x PSL(3,4)", "PSL(3,4) : C2", "PSL(3,4) : C2", "PSL(3,4) : C2" ]
gap> List(res, NrConjugacyClasses);
[ 20, 14, 14, 14 ]

#
gap> STOP_TEST( "misc.tst", 10000 );

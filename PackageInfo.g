#############################################################################
##  
##  PackageInfo.g for the package `GrpConst'                     Bettina Eick

SetPackageInfo( rec(

PackageName := "GrpConst",
Subtitle := "Constructing the Groups of a Given Order",
Version := "2.6.5",
Date := "22/01/2024", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [

 rec(
      LastName      := "Besche",
      FirstNames    := "Hans Ulrich",
      IsAuthor      := true,
      IsMaintainer  := false,
      Place         := ""),

 rec(
      LastName      := "Eick",
      FirstNames    := "Bettina",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "beick@tu-bs.de",
      WWWHome       := "http://www.iaa.tu-bs.de/beick",
      PostalAddress := Concatenation(
               "Institut Analysis und Algebra\n",
               "TU Braunschweig\n",
               "Universitätsplatz 2\n",
               "D-38106 Braunschweig\n",
               "Germany" ),
      Place         := "Braunschweig",
      Institution   := "TU Braunschweig"),

  rec(
    LastName      := "Horn",
    FirstNames    := "Max",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "mhorn@rptu.de",
    WWWHome       := "https://www.quendi.de/math",
    PostalAddress := Concatenation(
                       "Fachbereich Mathematik\n",
                       "RPTU Kaiserslautern-Landau\n",
                       "Gottlieb-Daimler-Straße 48\n",
                       "67663 Kaiserslautern\n",
                       "Germany" ),
    Place         := "Kaiserslautern, Germany",
    Institution   := "RPTU Kaiserslautern-Landau"
  ),
],

Status := "accepted",
CommunicatedBy := "Charles Wright (Eugene)",
AcceptDate := "07/1999",

PackageWWWHome  := "https://gap-packages.github.io/grpconst/",
README_URL      := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/grpconst",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/grpconst-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := 
"The <span class=\"pkgname\">GrpConst</span> package contains methods to construct up to isomorphism the groups of a given order. The FrattiniExtensionMethod constructs all soluble groups of a given order. On request it gives only those that are (or are not) nilpotent or supersolvable or that do (or do not) have normal Sylow subgroups for some given set of primes. The CyclicSplitExtensionMethod constructs all groups having a normal Sylow subgroup for orders of the type p^n *q. The method relies on the availability of a list of all groups of order p^n. The UpwardsExtensions algorithm takes as input a permutation group G and a positive integer s and returns a list of permutation groups, one for each extension of G by a soluble group of order a divisor of s. This method can used to construct the non-solvable groups of a given order by taking the perfect groups of certain orders as input for G. The programs in this package have been used to construct a large part of the Small Groups library.",

               
PackageDoc := rec(
  BookName  := "GrpConst",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Constructing the Groups of a Given Order",
  Autoload  := true),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [
    ["autpgrp", ">=1.6"],
    ["irredsol", ">=1.2"],
    ["smallgrp", ">=1.4"],
  ],
  SuggestedOtherPackages := [],
  ExternalConditions := [] ),

AvailabilityTest := ReturnTrue,
TestFile := "tst/testall.g",
Keywords := ["constructing groups of small order", 
             "Frattini extension method",
             "Cyclic split extension method",
             "Upwards extension method"]

));



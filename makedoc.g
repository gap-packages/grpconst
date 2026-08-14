#############################################################################
##
##  makedoc.g
##
##  Builds the package documentation with AutoDoc/GAPDoc.
##
#############################################################################

LoadPackage("AutoDoc");

# Run this from the package's root directory: gap makedoc.g
AutoDoc(rec(
    autodoc := rec(scan_dirs := []),
    gapdoc := rec(main := "main", files := []),
    extract_examples := true,
    scaffold := rec(
        includes := [
            "preface.xml",
            "intro.xml",
            "wrap.xml",
            "frattext.xml",
            "cyclic.xml",
            "upext.xml",
            "examples.xml"
        ],
        entities := rec(
            GrpConst := "<Package>GrpConst</Package>",
        ),
        bib := "grpconst.bib",
    ),
));

QuitGap();

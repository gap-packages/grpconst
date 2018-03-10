#!/usr/bin/env bash
#
# DO NOT EDIT THIS FILE!
#
# If you need to collect additional coverage data, please do so
# from your .travis.yml or a custom script.
#
# If you have any questions about this script, or think it is not general
# enough to cover your use case (i.e., you feel that you need to modify it
# anyway), please contact Max Horn <max.horn@math.uni-giessen.de>.
#
set -ex

# If we don't care about code coverage, do nothing
if [[ -n $NO_COVERAGE ]]; then
    exit 0
fi

# start GAP with custom GAP root, to ensure correct package version is loaded
GAP="$GAPROOT/bin/gap.sh -l $PWD/gaproot; --quitonbreak -q"

# generate library coverage reports
$GAP -a 500M -m 500M -q <<GAPInput
if LoadPackage("profiling") <> true then
    Print("ERROR: could not load profiling package");
    FORCE_QUIT_GAP(1);
fi;
d := Directory("$COVDIR");;
covs := [];;
for f in DirectoryContents(d) do
    if f in [".", ".."] then continue; fi;
    Add(covs, Filename(d, f));
od;
Print("Merging coverage results from ", covs, "\n");
r := MergeLineByLineProfiles(covs);;
Print("Outputting JSON\n");
OutputJsonCoverage(r, "gap-coverage.json");;
QUIT_GAP(0);
GAPInput

# generate source coverage reports by running gcov
gcov -o . src/*.c*

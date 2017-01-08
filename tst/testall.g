LoadPackage( "grpconst" );
dirs := DirectoriesPackageLibrary( "grpconst", "tst" );
TestDirectory(dirs[1], rec(exitGAP := true));

FORCE_QUIT_GAP(1);

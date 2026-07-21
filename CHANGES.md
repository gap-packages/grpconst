This file describes changes in the grpconst package.

## 2.6.6 (2026-07-21)

  - Speed up the randomized isomorphism test used by `UpwardsExtensions`
  - Minor janitorial changes

## 2.6.5 (2024-01-22)

  - Fix `CyclicGenerator` for the trivial group
  - Speed up quotient construction by using known-normal-subgroup operations
  - Add a regression test for `UpwardsExtensionsNoCentre`
  - Update the CI setup and maintainer contact details

## 2.6.4 (2023-02-10)

  - Replace obsolete SmallGrp interfaces with their supported equivalents
  - Use GAP's `SizeGL` in place of a package-local implementation
  - Declare the SmallGrp package dependency explicitly

## 2.6.3 (2022-11-14)

  - Update the code to use supported SmallGrp interfaces
  - Protect internal global functions from accidental redefinition
  - Move the test suite to GitHub Actions and update its coverage setup
  - Fix typos and reorganize an internal consistency check as a test

## 2.6.2 (2020-01-28)

  - Add GPL-2.0-or-later license metadata
  - Update maintainer details and package documentation
  - Update the Travis CI setup

## 2.6.1 (2018-08-09)

  - Restore the `ConjugatingElement` helper after its removal from the GAP
    library
  - Add Max Horn as a maintainer

## 2.6 (2018-03-08)

  - Modernize the package for newer GAP versions and renamed library APIs
  - Fix the construction of nilpotent groups and the handling of unresolved
    isomorphism tests
  - Speed up cyclic split extensions, rational-class computations, and
    isomorphism classification
  - Improve soluble-group construction using Sylow restrictions and support
    nilpotent factors through seventh powers of primes
  - Add a test suite, continuous integration, and code-coverage support
  - Move the package to its current repository and documentation setup

## 2.5 (2015-12-07)

  - Raise the minimum versions to GAP 4.7, AutPGrp 1.6, and IrredSol 1.2

## 2.4 (2015-12-07)

  - Fix the double-coset computation used to construct extensions by
    centre-free perfect groups
  - Update author and package metadata

## 2.3 (2012-05-29)

  - Modernize package loading and metadata for newer GAP versions
  - Update the documentation build script

## 2.2 (2011-01-31)

  - Use the IrredSol catalogue for irreducible soluble matrix groups
  - Rework semisimple-group construction, including specialized handling of
    prime, supersolvable, and cube-free cases
  - Improve rational-class and extension computations
  - Update package metadata and documentation

## 2.0 (2002-11-19)
  
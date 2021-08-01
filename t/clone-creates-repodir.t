git dirs clone creates .git-dirs/repos.d on demand
==================================================
.. vim: ft=rst sw=2 sts=2 et


setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)


test that clone implies `mkdir -p ~/.git-dirs/repo.d/` ::

  $ test -e .git
  [1]

  $ test -e .git-dirs
  [1]

  $ test -e snafu
  [1]

  $ git dirs clone file://$PWD/fubar
  cloned .git-dirs/repo.d/fubar from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar

  $ ls ~/.git-dirs/repo.d/
  fubar

  $ test -e snafu
  [1]

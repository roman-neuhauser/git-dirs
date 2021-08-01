git dirs clone activates the new repo
=====================================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)


test ::

  $ git dirs clone file://$PWD/fubar
  cloned .git-dirs/repo.d/fubar from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar

  $ git rev-parse --git-dir
  */.git-dirs/repo.d/fubar (glob)

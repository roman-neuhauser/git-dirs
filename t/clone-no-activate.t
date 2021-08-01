git dirs clone -A / --no-activate leaves .git alone
===================================================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)

  $ print "gitdir: $PWD/fubar/.git" > .git


test --no-activate::

  $ git dirs clone --no-activate file://$PWD/fubar fubar2
  cloned .git-dirs/repo.d/fubar2 from file://*/fubar (glob)

  $ git rev-parse --git-dir
  /*/fubar/.git (glob)


test -A::

  $ git dirs clone -A file://$PWD/fubar fubar3
  cloned .git-dirs/repo.d/fubar3 from file://*/fubar (glob)

  $ git rev-parse --git-dir
  /*/fubar/.git (glob)

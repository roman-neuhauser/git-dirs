git dirs clone does not clobber repos.d/* nor .git
===================================================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)

  $ git dirs clone file://$PWD/fubar snafu
  cloned .git-dirs/repo.d/snafu from file://*/fubar (glob)
  activated .git-dirs/repo.d/snafu

  $ git dirs clone file://$PWD/fubar fubar
  cloned .git-dirs/repo.d/fubar from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar


refuses to clobber existing repo::

  $ git dirs clone file://$PWD/fubar snafu
  path exists: .git-dirs/repo.d/snafu
  [1]


test that failed clone preserves .git as it was::

  $ git rev-parse --git-dir
  /?*/.git-dirs/repo.d/fubar (glob)

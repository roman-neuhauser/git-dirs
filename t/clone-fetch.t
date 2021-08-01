git dirs clone fetches all refs from $origin
============================================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -qb master fubar
  $ echo omg > fubar/snafu
  $ git -C fubar add snafu
  $ git -C fubar commit -qm snafu
  $ git -C fubar tag youre-it
  $ git -C fubar show-ref --head >>(sed -E 's/\S+ //')
  HEAD
  refs/heads/master
  refs/tags/youre-it


test default origin::

  $ git dirs clone file://$PWD/fubar
  cloned .git-dirs/repo.d/fubar from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar

  $ git show-ref --head >>(sed -E 's/\S+ //')
  HEAD
  refs/heads/master
  refs/remotes/origin/HEAD
  refs/remotes/origin/master
  refs/tags/youre-it


test --origin::

  $ git dirs clone --origin omgwtf file://$PWD/fubar snafu
  cloned .git-dirs/repo.d/snafu from file://*/fubar (glob)
  activated .git-dirs/repo.d/snafu

  $ git show-ref --head >>(sed -E 's/\S+ //')
  HEAD
  refs/heads/master
  refs/remotes/omgwtf/HEAD
  refs/remotes/omgwtf/master
  refs/tags/youre-it

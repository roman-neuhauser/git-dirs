git dirs clone: remote setup
============================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)

  $ git dirs clone file://$PWD/fubar fubar6
  cloned .git-dirs/repo.d/fubar6 from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar6


test that it sets url of the remote::

  $ git config --get remote.origin.url
  file://*/fubar (glob)


test that it sets up fetch for all branches::

  $ git config --get-all remote.origin.fetch
  +refs/heads/*:refs/remotes/origin/*

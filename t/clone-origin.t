git dirs clone -o / --origin assigns name for the remote
========================================================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)


test --origin::

  $ git dirs clone --origin asdf file://$PWD/fubar fubar4
  cloned .git-dirs/repo.d/fubar4 from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar4

  $ git config --get remote.origin.url
  [1]
  $ git config --get remote.asdf.url
  file://*/fubar (glob)

  $ git config --get-all remote.origin.fetch
  [1]
  $ git config --get-all remote.asdf.fetch
  +refs/heads/*:refs/remotes/asdf/*


test -o::

  $ git dirs clone -o qwer file://$PWD/fubar fubar5
  cloned .git-dirs/repo.d/fubar5 from file://*/fubar (glob)
  activated .git-dirs/repo.d/fubar5

  $ git config --get remote.origin.url
  [1]

  $ git config --get remote.qwer.url
  file:///*/fubar (glob)

  $ git config --get-all remote.origin.fetch
  [1]
  $ git config --get-all remote.qwer.fetch
  +refs/heads/*:refs/remotes/qwer/*

git dirs clone help
===================
.. vim: ft=rst sw=2 sts=2 et


setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)


usage::

  $ git dirs clone -h
  usage: git dirs clone -h | --help
  usage: git dirs clone [--no-activate] [--origin NAME] URL [REPO]
  
  Clone repository at URL into .git-dirs/repo.d/REPO.
  REPO defaults to the basename of URL without any .git suffix.
  
  Options:
    -h, --help        Display this message
    -A, --no-activate Do not activate the repository
    -o, --origin NAME Use NAME instead of "origin" for upstream
  
  Operands:
    REPO              Name of a directory in .git-dirs/repo.d


  $ diff -u =(git dirs clone -h) =(git dirs clone --help)

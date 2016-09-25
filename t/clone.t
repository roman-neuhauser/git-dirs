git dirs clone
==============
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)


usage::

  $ git dirs clone -h
  usage: git dirs clone -h | --help
  usage: git dirs clone [--no-activate] URL [REPO]
  
  Clone repository at URL into .git-dirs/repo.d/REPO.
  REPO defaults to the basename of URL without any .git suffix.
  
  Options:
    -h, --help        Display this message
    -A, --no-activate Do not activate the repository
  
  Operands:
    REPO              Name of a directory in .git-dirs/repo.d


  $ diff -u =(git dirs clone -h) =(git dirs clone --help)


rejects unknown option ::

  $ git dirs clone --fubar snafu
  git dirs: unknown option '--fubar'
  run 'git dirs -h' for usage instructions
  [1]


rejects unknown operand::

  $ git dirs clone foo bar baz
  git dirs: unknown argument 'baz'
  run 'git dirs -h' for usage instructions
  [1]


implies `mkdir -p ~/.git-dirs/repo.d/`::

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


activates the created repo::

  $ git rev-parse --git-dir
  */.git-dirs/repo.d/fubar (glob)


does not activate the created repo if asked not to::

  $ git dirs clone --no-activate file://$PWD/.git-dirs/repo.d/fubar fubar2
  cloned .git-dirs/repo.d/fubar2 from file://*/fubar (glob)

  $ git dirs clone -A file://$PWD/.git-dirs/repo.d/fubar fubar3
  cloned .git-dirs/repo.d/fubar3 from file://*/fubar (glob)

  $ git rev-parse --git-dir
  /?*/.git-dirs/repo.d/fubar (glob)


refuses to clobber existing repo::

  $ git clone -q --bare .git-dirs/repo.d/fubar .git-dirs/repo.d/snafu

  $ git dirs clone file://$PWD/fubar snafu
  path exists: .git-dirs/repo.d/snafu
  [1]


failure does not clobber state::

  $ git rev-parse --git-dir
  /?*/.git-dirs/repo.d/fubar (glob)

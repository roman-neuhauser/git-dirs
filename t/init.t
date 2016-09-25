git dirs init
=============
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup


usage::

  $ git dirs init -h
  usage: git dirs init -h | --help
  usage: git dirs init [--no-activate] REPO
  
  Initialize a repository in .git-dirs/repo.d/REPO and activate it.
  
  Options:
    -h, --help        Display this message
    -A, --no-activate Do not activate the repository
  
  Operands:
    REPO              Name of a directory in .git-dirs/repo.d


  $ diff -u =(git dirs init -h) =(git dirs init --help)


  $ diff -u =(git dirs init -h) =(git dirs init --help)


rejects unknown option ::

  $ git dirs init --fubar snafu
  git dirs: unknown option '--fubar'
  run 'git dirs -h' for usage instructions
  [1]


implies `mkdir -p ~/.git-dirs/repo.d/`::

  $ test -e .git
  [1]

  $ test -e .git-dirs
  [1]

  $ git dirs init fubar
  initialized .git-dirs/repo.d/fubar
  activated .git-dirs/repo.d/fubar

  $ sed "s:${PWD%%/##}/::" ~/.git
  gitdir: .git-dirs/repo.d/fubar

  $ git dirs init snafu
  initialized .git-dirs/repo.d/snafu
  activated .git-dirs/repo.d/snafu

  $ sed "s:${PWD%%/##}/::" ~/.git
  gitdir: .git-dirs/repo.d/snafu

  $ ls ~/.git-dirs/repo.d/
  fubar
  snafu


activates the created repo::

  $ git rev-parse --git-dir
  */.git-dirs/repo.d/snafu (glob)


does not activate the created repo if asked not to::

  $ git dirs init --no-activate rofl
  initialized .git-dirs/repo.d/rofl

  $ git dirs init -A lmao
  initialized .git-dirs/repo.d/lmao

  $ git rev-parse --git-dir
  /?*/.git-dirs/repo.d/snafu (glob)


refuses to clobber existing repo::

  $ git dirs init fubar
  path exists: .git-dirs/repo.d/fubar
  [1]


failure does not clobber state::

  $ git rev-parse --git-dir
  */.git-dirs/repo.d/snafu (glob)

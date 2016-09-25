git dirs activate
=================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup


usage::

  $ git dirs activate -h
  usage: git dirs activate -h | --help
  usage: git dirs activate REPO
  
  Associate $PWD with REPO.  Points .git at .git-dirs/repo.d/REPO.
  
  Operands:
    REPO              Name of a directory in .git-dirs/repo.d


  $ diff -u =(git dirs activate -h) =(git dirs activate --help)


rejects unknown option::

  $ git dirs activate --fubar snafu
  git dirs: unknown option '--fubar'
  run 'git dirs -h' for usage instructions
  [1]


rejects unknown operand::

  $ git dirs activate fubar snafu
  git dirs: unknown argument 'snafu'
  run 'git dirs -h' for usage instructions
  [1]


fails if the target repo does not exist (no repos at all here)::

  $ git dirs activate fubar
  nonexistent: .git-dirs/repo.d/fubar
  [1]

  $ test ! -e ~/.git


succeeds when no repo is active::

  $ git init -q --bare ~/.git-dirs/repo.d/fubar

  $ git dirs activate fubar
  activated .git-dirs/repo.d/fubar

  $ sed "s:${PWD%%/##}/::" .git
  gitdir: .git-dirs/repo.d/fubar


fails if the target repo does not exist (other repos do exist)::

  $ git dirs activate snafu
  nonexistent: .git-dirs/repo.d/snafu
  [1]

  $ sed "s:${PWD%%/##}/::" .git
  gitdir: .git-dirs/repo.d/fubar


succeeds when another repo is active::

  $ git init -q --bare ~/.git-dirs/repo.d/snafu

  $ git dirs activate snafu
  activated .git-dirs/repo.d/snafu

  $ sed "s:${PWD%%/##}/::" .git
  gitdir: .git-dirs/repo.d/snafu


succeeds if the target is already active::

  $ git dirs activate snafu
  activated .git-dirs/repo.d/snafu

  $ sed "s:${PWD%%/##}/::" .git
  gitdir: .git-dirs/repo.d/snafu

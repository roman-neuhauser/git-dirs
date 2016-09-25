git dirs list
=============
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup


usage::

  $ git dirs list -h
  usage: git dirs list -h | --help
  usage: git dirs list [--full | --relative | --short]
  
  List repositories in .git-dirs/repo.d.
  
  Options:
    -h, --help        Display this message
    -f, --full        Display full path
    -r, --relative    Display relative path from the top of the work tree
    -s, --short       Display basename


  $ diff -u =(git dirs list -h) =(git dirs list --help)


rejects unknown option ::

  $ git dirs list --fubar
  git dirs: unknown option '--fubar'
  run 'git dirs -h' for usage instructions
  [1]


rejects unknown operand ::

  $ git dirs list fubar
  git dirs: unknown argument 'fubar'
  run 'git dirs -h' for usage instructions
  [1]


no `.git`, missing `.git-dirs/repo.d`::

  $ ! test -e .git
  $ ! test -e .git-dirs

  $ git dirs list

  $ mkdir -p .git-dirs
  $ git dirs list


no `.git`, empty `.git-dirs/repo.d/`::

  $ mkdir -p .git-dirs/repo.d
  $ git dirs list


no `.git`, some dirs under `.git-dirs/repo.d/`::

  $ mkdir .git-dirs/repo.d/{snafu,fubar}

  $ git dirs list
  fubar
  snafu

  $ git dirs list --relative
  .git-dirs/repo.d/fubar
  .git-dirs/repo.d/snafu

  $ git dirs list --full
  /?*/.git-dirs/repo.d/fubar (glob)
  /?*/.git-dirs/repo.d/snafu (glob)

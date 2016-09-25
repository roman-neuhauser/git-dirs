git dirs active
===============
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup


usage::

  $ git dirs active -h
  usage: git dirs active -h | --help
  usage: git dirs active [--full | --relative | --short]
  
  Show the currently active repository.
  
  Options:
    -h, --help        Display this message
    -f, --full        Display full path
    -r, --relative    Display relative path from the top of the work tree
    -s, --short       Display basename


  $ diff -u =(git dirs active -h) =(git dirs active --help)


rejects unknown option ::

  $ git dirs active --fubar
  git dirs: unknown option '--fubar'
  run 'git dirs -h' for usage instructions
  [1]


rejects unknown operand::

  $ git dirs active fubar
  git dirs: unknown argument 'fubar'
  run 'git dirs -h' for usage instructions
  [1]


fails cleanly w/ missing .git-dirs ::

  $ git dirs active
  [1]

  $ mkdir -p .git-dirs/repo.d


fails cleanly w/ no repo ::

  $ git dirs active
  [1]


outputs repo pointed at by .git::

  $ r=.git-dirs/repo.d/rofl
  $ git init -q --bare $r
  $ git config --file $r/config core.bare false
  $ git config --file $r/config core.worktree ~
  $ print > .git "gitdir: $PWD/$r"

  $ git dirs active
  rofl

  $ git dirs active --relative
  .git-dirs/repo.d/rofl

  $ git dirs active --full
  /*/.git-dirs/repo.d/rofl (glob)

git dirs clone misuse
=====================
.. vim: ft=rst sw=2 sts=2 et


setup ::

  $ . $TESTDIR/setup

  $ git init -q fubar
  $ (cd fubar; echo omg > snafu; git add snafu; git commit -q -m snafu)


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

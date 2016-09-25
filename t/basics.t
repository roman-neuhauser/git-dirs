git dirs basics
===============
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ fake man <<\EOF
  > print -u 2 -- $0:t "$@"
  > EOF


help ::

  $ git dirs -h
  usage: git dirs -h|--help
  usage: git dirs activate REPO
  usage: git dirs active [--full|--relative|--short]
  usage: git dirs clone [--no-activate] URL [REPO]
  usage: git dirs init [--no-activate] REPO
  usage: git dirs list [--full|--relative|--short]
  
  Dotfile management for Git
  
  Options:
    -h                Display this message
    --help            Display manual page
  Commands:
    activate          Associate $PWD with REPO
    active            Show the currently active repository
    clone             Clone URL into .git-dirs/repo.d/REPO
    init              Initialize a repository in .git-dirs/repo.d/REPO
    list              List repositories in .git-dirs/repo.d
  
  Use git dirs <cmd> -h to display more detailed usage for <cmd>.


manpage handled by git ::

  $ git dirs --help
  man git-dirs


manpage handled by git-dirs ::

  $ git-dirs --help
  man 1 git-dirs


unknown option (short) ::

  $ git dirs -y
  git dirs: unknown option '-y'
  run 'git dirs -h' for usage instructions
  [1]


unknown option (long) ::

  $ git dirs --yeehaa
  git dirs: unknown option '--yeehaa'
  run 'git dirs -h' for usage instructions
  [1]


missing argument ::

  $ git dirs
  git dirs: missing argument
  run 'git dirs -h' for usage instructions
  [1]

unknown argument ::

  $ git dirs snafubar
  git dirs: unknown argument 'snafubar'
  run 'git dirs -h' for usage instructions
  [1]

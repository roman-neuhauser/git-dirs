code from README.rst
====================
.. vim: ft=rst sw=2 sts=2 et

setup ::

  $ . $TESTDIR/setup

  $ mkdir -p .vim/{ftdetect,syntax}
  $ touch .vimrc .vim/{ftdetect,syntax}/rfc.vim
  $ mkdir -p .zsh/functions
  $ touch .zsh{env,rc} .zsh/functions/in-dir
  $ mkdir .mail bin
  $ touch .mail/muttrc .mail/maildroprc bin/mu

::

  $ printf "%s\n" mail vim zsh | xargs -n 1 git dirs init --no-activate
  initialized .git-dirs/repo.d/mail
  initialized .git-dirs/repo.d/vim
  initialized .git-dirs/repo.d/zsh

  $ git dirs activate mail
  activated .git-dirs/repo.d/mail

  $ git add .mail bin/mu

  $ git status -suno
  A  .mail/maildroprc
  A  .mail/muttrc
  A  bin/mu

  $ git commit -q -m ...

  $ git dirs activate vim
  activated .git-dirs/repo.d/vim

  $ git add .vim .vimrc

  $ git status -suno
  A  .vim/ftdetect/rfc.vim
  A  .vim/syntax/rfc.vim
  A  .vimrc

  $ git commit -q -m ...

  $ git dirs activate zsh
  activated .git-dirs/repo.d/zsh

  $ git dirs list
  mail
  vim
  zsh

  $ git dirs active
  zsh

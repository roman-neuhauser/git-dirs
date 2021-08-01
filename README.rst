.. vim: ft=rst sts=2 sw=2 tw=77

.. :Author: Roman Neuhauser
.. :Contact: neuhauser+git-dirs@sigpipe.cz
.. :Copyright: This document is in the public domain.

.. this file is marked up using reStructuredText
.. lines beginning with ".." are reST directives
.. "foo_" or "`foo bar`_" is a link, defined at ".. _foo" or ".. _foo bar"
.. "::" introduces a literal block (usually some form of code)
.. "`foo`" is some kind of identifier
.. suspicious backslashes in the text ("`std::string`\s") are required for
.. reST to recognize the preceding character as syntax


Introduction
============

`git-dirs` facilitates using a single directory as a Git_ `work tree`
with multiple `git dirs` backing (different parts of) the work tree.
`git-dirs` manages ``.git`` at the top of the work tree as a `gitfile`
(see `git-rev-parse(1)`, `gitrepository-layout(5)`, `gitglossary(7)`),
and repositories under ``.git-dirs/repo.d``.

`git-dirs` is fairly minimalistic, its goal is to setup the `.git`
link and the corresponding repository so unadorned `git(1)` will DTRT_.
Downside: since `.git` is no longer a plain directory at the root of
the work tree, the ability to casually chdir into it or edit `.git/config`
is lost.

`git-dirs` was conceived as a tool to ease use of Git_ for dotfiles
in a home directory, a transparent and get-out-of-your-way alternative
to vcsh_ but it is not tied to this use case.  It simply works in its
*current working directory*.

.. _DTRT: https://acronymfinder.com/Do-The-Right-Thing-(DTRT).html
.. _Git: https://git-scm.org/
.. _vcsh: https://github.com/RichiH/vcsh


Usage
=====

::

  $ git dirs -h
  usage: git dirs -h|--help
  usage: git dirs activate REPO
  usage: git dirs active [--full|--relative|--short]
  usage: git dirs clone [--no-activate] [--origin NAME] URL [REPO]
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


Quickstart
==========

One way to start versioning one's dotfiles is to init a repository
for each independent fileset::

  $ printf "%s\n" mail vim zsh | xargs -n 1 git dirs init --no-activate
  initialized .git-dirs/repo.d/mail
  initialized .git-dirs/repo.d/vim
  initialized .git-dirs/repo.d/zsh

Then `activate` a repository and commit files into it::

  $ git dirs activate mail
  activated .git-dirs/repo.d/mail

  $ git add .mail bin/mu

  $ git status -suno
  A  .mail/maildroprc
  A  .mail/muttrc
  A  bin/mu

  $ git commit -q -m ...

And so on with remaining repositories::

  $ git dirs activate vim
  activated .git-dirs/repo.d/vim

  $ git add .vim .vimrc

  $ git status -suno
  A  .vim/ftdetect/rfc.vim
  A  .vim/syntax/rfc.vim
  A  .vimrc

  $ git commit -q -m ...

  $ git dirs activate zsh
  ...

We can list the repositories::

  $ git dirs list
  mail
  vim
  zsh

And see which one is currently active::

  $ git dirs active
  zsh


Finally, `git dirs clone` clones a given URL or path, configures it for
the non-default work tree path, and activates it (unless told not to)::

  $ git dirs clone git@example.org:somewhere/emacs.git
  cloned .git-dirs/repo.d/emacs from git@example.org:somewhere/emacs.git
  activated .git-dirs/repo.d/emacs

  $ git checkout master
  ...


License
=======

Published under the `MIT license`_, see `LICENSE file`_.

.. _MIT license: https://opensource.org/licenses/MIT
.. _LICENSE file: LICENSE

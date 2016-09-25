.. vim: ft=rst sts=2 sw=2 tw=77

.. :Author: Roman Neuhauser
.. :Contact: neuhauser+git-dirs@sigpipe.cz
.. :Copyright: This document is in the public domain.

.. this file is marked up using reStructuredText
   lines beginning with ".." are reST directives
   "foo_" or "`foo bar`_" is a link, defined at ".. _foo" or ".. _foo bar"
   "::" introduces a literal block (usually some form of code)
   "`foo`" is some kind of identifier
   suspicious backslashes in the text ("`std::string`\s") are required for
   reST to recognize the preceding character as syntax

.. default-role:: strong
.. parsed-literal::

  `NAME`
      `git dirs` — Manage multiple gitdirs

  `SYNOPSIS`
      `git dirs` -h | --help
      `git dirs` activate REPO
      `git dirs` active [--full | --relative | --short]
      `git dirs` clone [--no-activate] URL [REPO]
      `git dirs` init [--no-activate] REPO
      `git dirs` list [--full | --relative | --short]

  `DESCRIPTION`
      `git-dirs` facilitates using a single directory as a git(1) `work tree`
      with multiple `git dirs` backing (different parts of) the work tree.
      `git-dirs` manages ``.git`` at the top of the work tree as a `gitfile`
      (see git-rev-parse(1), gitrepository-layout(5), gitglossary(7)),
      repositories under `.git-dirs/repo.d`.

  `OPTIONS`
      `-h`
        Display usage information.

      `--help`
        Display this manual page.

  `COMMANDS`
      `git dirs command -h` displays usage information for `command`.

      `activate REPO`
        Associate `$PWD` with `REPO`.
        Points `.git` at `.git-dirs/repo.d/REPO`.

      `active [--full | --relative | --short]`
        Show the currently active repository.

        `-f`, `--full`      Display full path.
        `-r`, `--relative`  Display relative path from the top of the work tree.
        `-s`, `--short`     Display basename.

      `clone [--no-activate] URL [REPO]`
        Clone repository at `URL` into `.git-dirs/repo.d/REPO`.
        `REPO` defaults to the basename of `URL` without any `.git` suffix.

        `-N`, `--no-activate`
          Do not activate the repository.

      `init [--no-activate] REPO`
        Initialize a repository in `.git-dirs/repo.d/REPO`
        and activate it.

        `-N`, `--no-activate`
          Do not activate the repository.

      `list [--full | --relative | --short]`
        List repositories in `.git-dirs/repo.d`.

        `-f`, `--full`      Display full path.
        `-r`, `--relative`  Display relative path from the top of the work tree.
        `-s`, `--short`     Display basename.

  `ENVIRONMENT`
      `git-dirs` may be influenced by environment variables used by
      the programs listed in `SEE ALSO`, possibly others.

  `FILES`
      `.git`, `.git-dirs/`
      `$XDG_CONFIG_HOME/git/`, `$XDG_CONFIG_HOME/git-dirs/`

  `EXIT STATUS`
      The `git-dirs` utility exits 0 on success, and >0 if an error occurs.

  `EXAMPLES`
      `git-dirs` was conceived as a tool for versioning dotfiles in a home
      directory:

      $ cd

      $ git dirs list

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

  `SEE ALSO`
      *git(1)*, *zsh(1)*.

  `AUTHORS`
      Roman Neuhauser <neuhauser+git-dirs@sigpipe.cz>
          https://github.com/roman-neuhauser/git-dirs/

  `BUGS`
      No doubt plentiful.  Please report them at
          https://github.com/roman-neuhauser/git-dirs/issues

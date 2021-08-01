#!@ZSH@ -f
# vim: ts=2 sts=2 sw=2 et fdm=marker cms=\ #\ %s

setopt extended_glob
setopt hist_subst_pattern
setopt pipe_fail
setopt err_return
setopt no_unset
setopt warn_create_global

declare -gr cmdname=${0:t}

function $cmdname-main # {{{
{
  local -r usage='
  usage: #c -h|--help
  usage: #c activate REPO
  usage: #c active [--full|--relative|--short]
  usage: #c clone [--no-activate] URL [REPO]
  usage: #c init [--no-activate] REPO
  usage: #c list [--full|--relative|--short]

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

  Use #c <cmd> -h to display more detailed usage for <cmd>.
  '

  local opt arg
  local -i i=0
  while haveopt i opt arg h help -- "$@"; do
    case $opt in
    h|help) display-help $opt ;;
    *)      reject-misuse -$arg ;;
    esac
  done; shift $i

  local -ra commands=(
    activate
    active
    clone
    init
    list
  )
  local cmd=${1-}
  local impl=
  case $cmd in
  ${(~j:|:)commands})
    impl=do-$cmd
    shift
  ;;
  *) reject-misuse $cmd ;;
  esac

  local -r dotdir=.git-dirs
  local -r repodir=$dotdir/repo.d

  $impl "$@"
} # }}}

function display-help # {{{
{
  if [[ $1 == h ]]; then
    local -r self=${cmdname/-/ }
    local msg="${usage//\#c/$self}"
    msg="${${msg/#[[:space:]]#/}/%[[:space:]]#/}"
    msg="${(@F)${(@f)msg}/#  /}"
    print -- $msg
    exit
  fi
  exec man 1 $cmdname
} # }}}

function fdr # {{{
{
  local -i o0=0 o1=1 o2=2
  local optname OPTARG OPTIND
  while getopts 0:1:2: optname; do
    case $optname in
    0) exec {o0}<$OPTARG ;;
    1) exec {o1}>$OPTARG ;;
    2) exec {o2}>$OPTARG ;;
    esac
  done; shift $((OPTIND - 1))
  "$@" <&${o0} 1>&${o1} 2>&${o2}
} # }}}

function reject-misuse # {{{
{
  local -r val=${1-} self=${cmdname/-/ }
  case $val in
  -?)  print -f "%s: unknown option '%s'\n" -- $self $val ;;
  -?*) print -f "%s: unknown option '%s'\n" -- $self -$val ;;
  ?*)  print -f "%s: unknown argument '%s'\n" -- $self $val ;;
  '')  print -f "%s: missing argument\n" -- $self ;;
  esac
  print -f "run '%s -h' for usage instructions\n" -- $self
  exit 1
} # }}}

function reject # {{{
{
  local -r ex=$1; shift
  print -u 2 -f "%s\n" "$@"
  exit $ex
} # }}}

function do-activate # {{{
{
  local -r usage='
  usage: #c activate -h | --help
  usage: #c activate REPO

  Associate $PWD with REPO.  Points .git at .git-dirs/repo.d/REPO.

  Operands:
    REPO              Name of a directory in .git-dirs/repo.d
  '

  local -a options=(
    h   help
  )
  local opt arg
  local -i i=0
  while haveopt i opt arg $=options -- "$@"; do
    case $opt in
    h|help) display-help $opt[1] ;;
    *)      reject-misuse -$arg ;;
    esac
  done; shift $i


  (( $# == 1 )) || reject-misuse "$2"

  local -r link=.git repo="$repodir/$1"
  [[ -e $repo ]] || reject 1 "nonexistent: ${(D)repo}"
  [[ -f $link ]] && rm $link
  git config --file "$repo/config" core.worktree ../../..
  fdr -1 $link print "gitdir: $repo:a"
  print -f "activated %s\n" -- ${(D):-$repo}
} # }}}

function do-active # {{{
{
  local -r usage='
  usage: #c active -h | --help
  usage: #c active [--full | --relative | --short]

  Show the currently active repository.

  Options:
    -h, --help        Display this message
    -f, --full        Display full path
    -r, --relative    Display relative path from the top of the work tree
    -s, --short       Display basename
'

  local -a options=(
    h   help
    f   full
    r   rel relative
    s   short
  )
  local opt arg mode=s
  local -i i=0
  while haveopt i opt arg $=options -- "$@"; do
    case $opt in
    f|full)         mode=$opt[1] ;;
    r|rel|relative) mode=$opt[1] ;;
    s|short)        mode=$opt[1] ;;

    h|help) display-help $opt[1] ;;
    *)      reject-misuse -$arg ;;
    esac
  done; shift $i

  (( $# == 0 )) || reject-misuse "$1"

  local -r link=.git
  local fp=
  [[ -f $link ]]
  fp=$(git rev-parse --resolve-git-dir $link)
  case $mode in
  f) print $fp        ;;
  r) print ${fp#$(git rev-parse --show-toplevel)/} ;;
  s) print $fp:t      ;;
  esac
} # }}}

function do-clone # {{{
{
  local -r usage='
  usage: #c clone -h | --help
  usage: #c clone [--no-activate] URL [REPO]

  Clone repository at URL into .git-dirs/repo.d/REPO.
  REPO defaults to the basename of URL without any .git suffix.

  Options:
    -h, --help        Display this message
    -A, --no-activate Do not activate the repository

  Operands:
    REPO              Name of a directory in .git-dirs/repo.d
'

  local -a options=(
    h   help
    A   no-activate
  )
  local opt arg
  local -i i=0 o_activate=1
  while haveopt i opt arg $=options -- "$@"; do
    case $opt in
    A|no-activate)  o_activate=0 ;;
    h|help)         display-help $opt[1] ;;
    *)              reject-misuse -$arg ;;
    esac
  done; shift $i

  (( $# <= 2 )) || reject-misuse "$3"

  local -r url=$1
  local -r name=${2-${1:s/%.git//:t}}
  local -r repo=$repodir/$name

  [[ -e $repo ]] && reject 1 "path exists: ${(D)repo}"
  mkdir -p $repo
  git clone -q --bare $url $repo
  git config --file $repo/config core.bare false
  git config --file "$repo/config" core.worktree ../../..
  print -l -- /.git-dirs >> $repo/info/exclude
  print -f "cloned %s from %s\n" "${(D)repo}" "$url"
  (( o_activate )) || return 0
  do-activate $name
} # }}}

function do-init # {{{
{
  local -r usage='
  usage: #c init -h | --help
  usage: #c init [--no-activate] REPO

  Initialize a repository in .git-dirs/repo.d/REPO and activate it.

  Options:
    -h, --help        Display this message
    -A, --no-activate Do not activate the repository

  Operands:
    REPO              Name of a directory in .git-dirs/repo.d
'

  local -a options=(
    h   help
    A   no-activate
  )
  local opt arg
  local -i i=0 o_activate=1
  while haveopt i opt arg $=options -- "$@"; do
    case $opt in
    A|no-activate)  o_activate=0 ;;
    h|help)         display-help $opt[1] ;;
    *)              reject-misuse -$arg ;;
    esac
  done; shift $i

  (( $# == 1 )) || reject-misuse "$2"

  local -r name=$1
  local -r repo=$repodir/$name

  [[ -e $repo ]] && reject 1 "path exists: ${(D)repo}"
  mkdir -p $repo
  git init -q --bare $repo
  git config --file $repo/config core.bare false
  git config --file "$repo/config" core.worktree ../../..
  print -l -- /.git-dirs >> $repo/info/exclude
  print -f "initialized %s\n" "${(D)repo}"
  (( o_activate )) || return 0
  do-activate $name
} # }}}

function do-list # {{{
{
  local -r usage='
  usage: #c list -h | --help
  usage: #c list [--full | --relative | --short]

  List repositories in .git-dirs/repo.d.

  Options:
    -h, --help        Display this message
    -f, --full        Display full path
    -r, --relative    Display relative path from the top of the work tree
    -s, --short       Display basename
'

  local -a options=(
    h   help
    f   full
    r   rel relative
    s   short
  )
  local opt arg mode=t
  local -i i=0
  while haveopt i opt arg $=options -- "$@"; do
    case $opt in
    f|full)         mode=a ;;
    r|rel|relative) mode=  ;;
    s|short)        mode=t ;;

    h|help) display-help $opt[1] ;;
    *)      reject-misuse -$arg ;;
    esac
  done; shift $i

  (( $# == 0 )) || reject-misuse "$1"

  local -ra repos=($repodir/*(N${mode+:$mode}))
  (( $#repos )) || return 0
  print -f "%s\n" -- "${(@)repos}"
} # }}}

. haveopt.sh

$cmdname-main "$@"

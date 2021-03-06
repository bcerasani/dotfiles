set PATH /opt/bin $PATH
set PATH /usr/local/bin $PATH
set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
set -x DOCKER_HOST "tcp://192.168.59.103:2375"

set fish_greeting
  echo Happy (date '+%A').\n

function dl
  docker ps -l -q
end

function ..
  cd ..
end

function ...
  cd ../..
end

function ....
  cd ../../..
end

function .....
  cd ../../../..
end

function config
  subl ~/.config/fish/config.fish
end

function reload! -d "reload functions and env"  
  . $HOME/.config/fish/config.fish
end

function myip
  dig +short myip.opendns.com @resolver1.opendns.com
end

# Git Shortcuts
function g
  git
end

function gs
  git status
end

function gb
  git checkout -b
end

function gc
  git commit -m $argv
end

function gd
  git difftool $argv
end

function ga
  git add -A
end

function gl
  git log
end

function g-unstage
  git rm --cached
end

function g-undo
  git reset --soft HEAD^
end

function g-amend
  git commit --amend -C HEAD
end

# Git Status in Prompt
function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
  set -l git_diff (git diff)

  if test -n "$git_diff"
    echo (set_color red) $branch (set_color normal)
  else
    echo (set_color green) $branch (set_color normal)
  end
end

function hide
  switch $argv
    case desktop
      defaults write com.apple.finder CreateDesktop -bool false; and killall Finder
    case hidden
      defaults write com.apple.finder AppleShowAllFiles -bool false; and killall Finder
    case iTerm
      /usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' /Applications/iTerm.app/Contents/Info.plist
    case '*'
      echo Error
  end
end

function show
  switch $argv
    case desktop
      defaults write com.apple.finder CreateDesktop -bool true; and killall Finder
    case hidden
      defaults write com.apple.finder AppleShowAllFiles -bool true; and killall Finder
    case iTerm
      /usr/libexec/PlistBuddy -c 'Delete :LSUIElement' /Applications/iTerm.app/Contents/Info.plist
    case '*'
      echo Error
  end
end

#  Asset Grabbers (thanks https://github.com/juliogarciag/dotfiles)
function url_final_part -d "get the final part of a string separated by /"
  set str_parts (echo $argv[1] | sed 's/\//\ /g')
  eval "set parts $str_parts"
  echo $parts[-1..-1]
end

function download -d "download a file in the current dir from the url $1"
  curl -o (url_final_part $argv[1]) $argv[1]
end

function get
  switch $argv
    case jquery
      download http://code.jquery.com/jquery.min.js
    case normalize
      download https://raw.github.com/necolas/normalize.css/master/normalize.css
    case '*'
      echo $error
  end
end

# Blog Kickstart
function blog # $title $tags
  set date (date '+%Y-%m-%d')
  set filename (echo $argv[1] | tr -s ' ' | tr ' ' '-')
  set gitdir ~/documents/Journal/
  set var_count (count $argv)
  cd $gitdir
    if test $var_count = 2
      echo title: $argv[1]\nexcerpt: \ndate: $date\ntags: $argv[2]\n---\n\n >entries/$filename.md
    else
      echo title: $argv[1]\nexcerpt: \ndate: $date\ntags: general\n---\n\n >entries/$filename.md
    end
  open entries/$filename.md
end

# Prompt
function fish_prompt
  if test -d .git
    printf '%s  %s%s git:%s ' 🍉 (set_color -o black) (prompt_pwd) (parse_git_branch)
  else
    printf '%s  %s%s ' 🍉 (set_color -o black) (prompt_pwd)
  end
end

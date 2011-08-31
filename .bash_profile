alias tmuxs="tmux attach-session -t"
export TERM=xterm-256color

# http://github.com/zkim/nsfw
export NSFW_ENV=dev
export LEIN_SNAPSHOTS_IN_RELEASE=true

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

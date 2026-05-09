# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

# Shell behavior
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB

typeset -U path   # auto-dedupe PATH entries

# Completion — rebuild zcompdump once per day, else skip audit for fast startup
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Aliases
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
alias comp='clang++ -DEVAL -std=c++11 -stdlib=libc++ -O2 -pipe -o'
alias cat="bat"
alias ls="eza --icons=always"
alias la="eza -la --icons=always"
alias v="nvim"
# alias vi="vim"
alias cl='clear'

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gad='git add .'

# Dev commands
alias dev='bun run dev'
alias build='bun run build'
alias start='bun run start'

export EDITOR="nvim"

# Keybindings
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
# bindkey '^u' autosuggest-toggle   # removed: broke line-clear in sessionizer/obsidian/startup bindkeys
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
# bindkey -s '^f' '^u~/.scripts/tmux-sessionizer^M'
bindkey -s '^f' '^u. ~/.scripts/ghostty-sessionizer^M'
bindkey -s '^o' '^u~/.scripts/obsidian^M'
bindkey -s '^x' '^u~/.scripts/startup-tmux^M'

# Starship prompt
eval "$(starship init zsh)"

# Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf shell integration: ctrl+r fuzzy history, ctrl+t file picker, alt+c fuzzy cd
source <(fzf --zsh)

eval "$(fnm env --use-on-cd --shell zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -s "/Users/simon/.bun/_bun" ] && source "/Users/simon/.bun/_bun"

# PATH
export PATH="$HOME/go/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$HOME/.scripts:$PATH"

# Syntax highlighting — must be last (per plugin docs)
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

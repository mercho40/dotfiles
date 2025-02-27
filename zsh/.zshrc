# ---- ruby ----#
# if [[ -f .ruby-version ]]; then
#   source "$HOME/.rvm/scripts/rvm"
# fi
#
# plugins=(git)


# User configuration
# flutter
# export CHROME_EXECUTABLE="/Applications/Chromium.app/Contents/MacOS/Chromium"
# ------ FZF ----
# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# source ~/.config/fzf-git/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# ---- Bat(better cat) theme
export BAT_THEME="Catppuccin Mocha"
# Aliases
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
#C++ alias
alias comp='g++ -DEVAL -std=gnu++11 -O2 -pipe -o'

# thefuck alias
# eval $(thefuck --alias)
# eval $(thefuck --alias fk)
# zoxide(better cd) alias
alias cd="z"
# bat(better cat) alias
alias cat="bat"
# ---- Eza (better ls) -----
alias ls="eza --icons=always"
alias la="eza -la --icons=always"
## vim alias
alias vim="nvim"
alias v="nvim"
alias vi="vim"
# ---- ruby ----#
# alias load_rvm='source "$HOME/.rvm/scripts/rvm"'

# Python 3
alias python=/opt/homebrew/bin/python3
alias python2=/usr/bin/python
alias pip=/opt/homebrew/bin/pip3

alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'
alias gad='git add .'

alias cl='clear'

alias dev='pnpm run dev'
alias build='pnpm run build'
alias start='pnpm run start'

alias pn=pnpm

bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

bindkey jj vi-cmd-mode



bindkey -s ^f '^u~/.scripts/tmux-sessionizer^M'
bindkey -s ^a '^u~/.scripts/aerospace-selector^M'
bindkey -s ^x '^u~/.scripts/startup-tmux^M'
bindkey -s ^g '^u~/.scripts/config^M'


# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# ---- Starship ----
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# ---- fzf ----
eval "$(fzf --zsh)"

# ---- zsh-autosuggestions ----
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---- syntax-highlighting ----
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Python path
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"

# Custom scripts path
export PATH="$HOME/.scripts:$PATH"


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"


# Created by `pipx` on 2024-10-05 19:34:40
# export PATH="$PATH:/Users/simon/.local/bin"


# fnm
FNM_PATH="/Users/simon/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/simon/Library/Application Support/fnm:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"

fi

# pnpm
export PNPM_HOME="/Users/simon/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

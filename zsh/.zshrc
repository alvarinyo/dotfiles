# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt adam2

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
setopt HIST_IGNORE_SPACE
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
#bindkey '^[[A' history-beginning-search-backward-end
#bindkey '^[[B' history-beginning-search-forward-end
bindkey '^[[5~' up-history
bindkey '^[[6~' down-history

eval $(thefuck --alias)

source ~/s/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

hist_plugin_ () { LBUFFER=$(history 0 | fzf +s --tac --height 10 -q "'$LBUFFER" | sed 's/^ *[0-9]* *//'); zle redisplay }
zle -N hist_plugin_ hist_plugin_
bindkey '^r' hist_plugin_

cargo_bin_path="$HOME/.cargo/bin"
scripts_path="$HOME/.local/bin/scripts"
rcimports_path="$HOME/.local/lib/rcimports"

export PATH="$PATH:$cargo_bin_path:$scripts_path"
export EDITOR=nvim

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:-1,bg:-1,hl:#5f87af
 --color=fg+:#d0d0d0,bg+:#7eada4,hl+:#5fd7ff
 --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
 --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
 --border=rounded'

if command -v batcat &> /dev/null
then
	alias cat="batcat -p"
fi
pf_plugin_ () { LBUFFER+=$(script.ls_aux | pf); echo; zle redisplay }
pff_plugin_ () { LBUFFER+=$(pff); echo; zle redisplay }
pfscripts_plugin_ () { LBUFFER+=$(pfscripts); echo; zle redisplay }
gitlog_fzf_plugin_ () { gitlog_fzf; echo; zle redisplay }
zle -N pf_plugin_ pf_plugin_
zle -N pff_plugin_ pff_plugin_
zle -N pfscripts_plugin_ pfscripts_plugin_
zle -N gitlog_fzf_plugin_ gitlog_fzf_plugin_
bindkey 'ñl' pf_plugin_
bindkey 'ñf' pff_plugin_
bindkey 'ñs' pfscripts_plugin_
bindkey 'ñgl' gitlog_fzf_plugin_

[ -d $rcimports_path ] && for f in $rcimports_path/*; do source $f; done
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


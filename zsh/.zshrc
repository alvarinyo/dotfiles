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


# Add fzf to PATH if not already present
fzf_bin_path="$HOME/s/fzf/bin"
[[ ":$PATH:" != *":$fzf_bin_path:"* ]] && PATH="$PATH:$fzf_bin_path"

source ~/s/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

hist_plugin_ () { LBUFFER=$(history 0 | fzf +s --tac --height 16 -q "'$LBUFFER" --preview-window=down:wrap --preview='echo {}  | sed "1s/^ *[0-9]* *//" | batcat -p --color=always -l bash ' | sed 's/^ *[0-9]* *//' | sed 's/\\n/\n/g'); zle redisplay }
zle -N hist_plugin_ hist_plugin_
bindkey '^r' hist_plugin_

cargo_bin_path="$HOME/.cargo/bin"
scripts_path="$HOME/.local/bin/scripts"
rcimports_path="$HOME/.local/lib/rcimports"
nvim_path="/opt/nvim-linux64/bin"

# Add paths only if they're not already in PATH
[[ ":$PATH:" != *":$cargo_bin_path:"* ]] && PATH="$PATH:$cargo_bin_path"
[[ ":$PATH:" != *":$scripts_path:"* ]] && PATH="$PATH:$scripts_path"
[[ ":$PATH:" != *":$nvim_path:"* ]] && PATH="$PATH:$nvim_path"

export PATH
export EDITOR=nvim


if command -v batcat &> /dev/null
then
	alias cat="batcat -p"
fi

pfl_plugin_ () { LBUFFER+=$(script.ls_aux | pfl); echo; zle redisplay }
pff_plugin_ () { LBUFFER+=$(pff); echo; zle redisplay }
pfscripts_plugin_ () { LBUFFER+=$(pfs); echo; zle redisplay }
pfgl_plugin_ () { LBUFFER+=$(pfgl); echo; zle redisplay }
pfgs_plugin_ () { LBUFFER+=$(pfgs); echo; zle redisplay }
quickyank_plugin_ () { LBUFFER+=" | tee >(xsel -bi)"; zle redisplay }
pfd_plugin_ () { LBUFFER+=$(pfd); echo; zle redisplay }
tp_plugin_ () { tp }
tmrw_plugin_ () { tmrw }
joinlines_plugin_ () {
  if [[ "$BUFFER" == *$'\n'* ]]; then
    # If buffer contains newlines, join them with spaces
    BUFFER=$(echo "$BUFFER" | tr '\n' ' ')
  else
    # If buffer is single line, split on spaces
    BUFFER=$(echo "$BUFFER" | tr ' ' '\n')
  fi
  zle redisplay
}
zle -N pfl_plugin_ pfl_plugin_
zle -N pff_plugin_ pff_plugin_
zle -N pfscripts_plugin_ pfscripts_plugin_
zle -N pfgl_plugin_ pfgl_plugin_
zle -N pfgs_plugin_ pfgs_plugin_
zle -N quickyank_plugin_ quickyank_plugin_
zle -N pfd_plugin_ pfd_plugin_
zle -N tp_plugin_ tp_plugin_
zle -N tmrw_plugin_ tmrw_plugin_
zle -N joinlines_plugin_ joinlines_plugin_
zle -N aiask_widget aiask_widget
bindkey 'ñl' pfl_plugin_
bindkey 'ñf' pff_plugin_
bindkey 'ñs' pfscripts_plugin_
bindkey 'ñgl' pfgl_plugin_
bindkey 'ñgs' pfgs_plugin_
bindkey 'ñy' quickyank_plugin_
bindkey 'ñd' pfd_plugin_
bindkey 'ñtp' tp_plugin_
bindkey 'ñtr' tmrw_plugin_
bindkey 'ñj' joinlines_plugin_
bindkey 'ñai' aiask_widget

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

[ -d $rcimports_path ] && for f in $rcimports_path/*; do source $f; done
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:-1,bg:-1,hl:#5f87af
 --color=fg+:#d0d0d0,bg+:#7eada4,hl+:#5fd7ff
 --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
 --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
 --border=rounded
 '$FZF_OPTION_NAVIGATION

export NVM_DIR="$HOME/.nvm"
# Only load nvm if not already loaded (prevents PATH duplication)
if [[ -z "$NVM_BIN" ]]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Work activity logging
WORK_LOG_DIR="${HOME}/.work_logs"
WORK_LOG_ZSH="${WORK_LOG_DIR}/zsh_activity.log"

# Create log directory once at startup if logging is enabled
[[ -n "$WORK_LOG_ENABLE" && "$WORK_LOG_ENABLE" != "0" && ! -d "$WORK_LOG_DIR" ]] && mkdir -p "$WORK_LOG_DIR"

# Log command after execution - checks WORK_LOG_ENABLE each time
preexec() {
  if [[ -n "$WORK_LOG_ENABLE" && "$WORK_LOG_ENABLE" != "0" ]]; then
    printf '%s | %s | %s\n' "$(strftime '%Y-%m-%d %H:%M:%S' $EPOCHSECONDS)" "$PWD" "$1" >> "$WORK_LOG_ZSH"
  fi
}

#!/usr/bin/env bash

swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

grephl()
{
    grep "^\|$1" --color='always'
}

repogeturl()
{
    if [ "$#" -gt 0 ]; then
        FILE_PATH="$(realpath -s --relative-to=$(git rev-parse --show-toplevel) $1)"
        if [ -f $1 ]; then
            # Both github and gitlab use the */blob/main/* url pattern to provide file blobs:
            git config --get remote.origin.url | sed -r "s,^git\@([^:]*):(.*)\.git$,https://\1/\2/blob/main/$FILE_PATH,g"
        elif [[ -d $1 ]]; then
            # Both github and gitlab use the */tree/main/* url pattern to provide directory trees:
            git config --get remote.origin.url | sed -r "s,^git\@([^:]*):(.*)\.git$,https://\1/\2/tree/main/$FILE_PATH,g"
        fi 
    else
        git config --get remote.origin.url | sed -r "s,^git\@([^:]*):(.*)\.git$,https://\1/\2,g"
    fi
}

declare -a FZF_OPTION_MULTI=(--multi
                             --bind 'alt-a:toggle-all')

declare -a FZF_OPTION_PREVIEW=(--preview 'script.preview_file {}' 
                               --bind 'shift-up:preview-page-up,shift-down:preview-page-down')

declare -a FZF_OPTION_RELOAD_LS_AUX=(--bind 'ctrl-l:reload(pushd {} || pushd $(dirname {}) ; script.ls_aux)'
                                     --bind 'ctrl-h:reload(popd || cd $(dirname {})/.. || : ; script.ls_aux)'
                                     -d '//'
                                     --header-lines=1
                                     --with-nth=-1)

declare -a FZF_OPTION_NAVIGATION=(--bind 'tab:toggle'
                                  --bind 'home:last,end:first'
                                  --bind 'ctrl-j:down,ctrl-k:up')

pfbase () {
    args=("$@")
    fzf "${args[@]}" \
        $FZF_OPTION_NAVIGATION \
            | sed 's://:/:g'
}

pfag () {
    ag --hidden -g '' . | pfbase
}

pfl () {
    find $1 -maxdepth 1 -readable -printf '%P\n' | pfbase "${FZF_OPTION_PREVIEW[@]}" "${FZF_OPTION_RELOAD_LS_AUX[@]}" "${FZF_OPTION_MULTI[@]}"
}

pff () {
    find $1 ! -readable -prune -o -print | pfbase "${FZF_OPTION_PREVIEW[@]}" "${FZF_OPTION_RELOAD_LS_AUX[@]}" "${FZF_OPTION_MULTI[@]}"
}

pfd () {
    find $1 ! -readable -prune -o -type d -printf '%P\n'| pfbase "${FZF_OPTION_RELOAD_LS_AUX[@]}" "${FZF_OPTION_MULTI[@]}"
}

pfs () {
    find $scripts_path -maxdepth 1 ! -executable -prune -o -print | awk -F'/' 'NR>1{print $NF}' | fzf --preview="script.preview_file $scripts_path/{}" --bind 'shift-up:preview-page-up,shift-down:preview-page-down,home:last,end:first' 
}

pfgl ()
{
    git log --oneline --color=always | nl | fzf $FZF_OPTION_NAVIGATION $FZF_OPTION_MULTI --ansi --track --no-sort --layout=reverse-list --preview='COMMIT_HASH=$(echo {} | awk '"'"'{print $2}'"'"'); git show $COMMIT_HASH --color=always' | awk '{print $2}'
}

pfgs ()
{
    # TODO preview both diffs in case there are staged and unstaged modifications
    git -c color.status=always status --short | fzf $FZF_OPTION_NAVIGATION $FZF_OPTION_MULTI --ansi --track --no-sort --layout=reverse-list --preview='echo {} | IFS= read -r LINE && INDEX_STATUS=${LINE:0:1} && WORK_STATUS=${LINE:1:1} && echo "$LINE" | read -r STATUS FILE && if [[ $WORK_STATUS = "M" ]]; then git diff --color=always $FILE | batcat -p; elif [[ $INDEX_STATUS = "M" ]]; then
        git diff --staged --color=always $FILE; else script.preview_file $FILE; fi' | awk '{print $2}'
}

fag ()
{
    ag --line-number --color "$@" |
        fzf \
            $FZF_OPTION_NAVIGATION $FZF_OPTION_MULTI \
            --ansi \
            --delimiter=: \
            --preview='batcat -pn --color=always {1} --highlight-line={2}' \
            --preview-window='+{2}+3/4'
}

yfag ()
{
    fag "$@" | awk -F':' '{print $1 " " $2}' | read -r FILENAME FILENO; FILENO=$(($FILENO-1)); echo "e $FILENAME | norm gg$FILENO+" | xsel -bi
}

tp ()
{
    {echo 'Window Command Path WindowID PaneID GlobalPaneId'; tmux list-panes -aF '#W #{pane_current_command} #{pane_current_path} #I #P #D'} | column -t | fzf --header-lines=1 --preview='tmux capture-pane -t $(echo {} | awk '"'"'{print $6}'"'"') -Nep -S 0 ' | read -r TMUX_WINDOW_NAME TMUX_PANE_CMD TMUX_PANE_PATH TMUX_WINDOW_ID TMUX_PANE_ID TMUX_GLOBAL_PANE_ID; tmux select-window -t $TMUX_WINDOW_ID; tmux select-pane -t $TMUX_PANE_ID
}

alias ndiff='git difftool --tool=nvimdiff -y $(pfgs)'
alias findnvim='pwdx $(pgrep -a nvim | grep -v embed | awk '"'"'{print $1}'"'"') | fzf $FZF_OPTION_MULTI $FZF_OPTION_NAVIGATION | awk -F: '"'"'{print $1}'"'"''

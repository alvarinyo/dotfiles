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

declare -a FZF_OPTION_RELOAD=(--bind 'right:reload(pushd {} || pushd $(dirname {}) ; script.ls_aux)'
                              --bind 'left:reload(popd || cd $(dirname {})/.. || : ; script.ls_aux)'
                              --bind 'ctrl-l:reload(pushd {} || pushd $(dirname {}) ; script.ls_aux)'
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
    find $1 -maxdepth 1 -readable -printf '%P\n' | pfbase "${FZF_OPTION_PREVIEW[@]}" "${FZF_OPTION_RELOAD[@]}" "${FZF_OPTION_MULTI[@]}"
}

pff () {
    find $1 ! -readable -prune -o -print | pfbase "${FZF_OPTION_PREVIEW[@]}" "${FZF_OPTION_RELOAD[@]}" "${FZF_OPTION_MULTI[@]}"
}

pfd () {
    find $1 ! -readable -prune -o -type d -printf '%P\n'| pfbase "${FZF_OPTION_RELOAD[@]}" "${FZF_OPTION_MULTI[@]}"
}

pfs () {
    find $scripts_path -maxdepth 1 ! -executable -prune -o -print | awk -F'/' 'NR>1{print $NF}' | fzf --preview="script.preview_file $scripts_path/{}" --bind 'shift-up:preview-page-up,shift-down:preview-page-down,home:last,end:first' 
}

pfgl ()
{
    git log --oneline --color=always | nl | fzf $FZF_OPTION_NAVIGATION --ansi --track --no-sort --layout=reverse-list --preview='COMMIT_HASH=$(echo {} | awk '"'"'{print $2}'"'"'); git diff $COMMIT_HASH~1 $COMMIT_HASH --color=always' | awk '{print $2}'
}






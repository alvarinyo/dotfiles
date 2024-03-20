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

pf () {
    fzf --preview='script.preview_file {}' --bind 'shift-up:preview-page-up,shift-down:preview-page-down,home:last,end:first,alt-enter:reload(cd {} || cd $(dirname {}) ; script.ls_aux),alt-bspace:reload(cd $(dirname {})/.. || : ; script.ls_aux)' -d '//' --header-lines=1 --with-nth=-1 | sed 's://:/:g'
}

pf_with_reload_script () {
    fzf --preview='script.preview_file {}' --bind 'shift-up:preview-page-up,shift-down:preview-page-down,home:last,end:first,alt-enter:reload(cd {} || cd $(dirname {}) ; $1),alt-bspace:reload(cd $(dirname {})/.. || : ; $1)' -d '//' --header-lines=1 --with-nth=-1 | sed 's://:/:g'
}

pfag () {
    ag --hidden -g '' . | pf
}

pfn () {
    find $1 -maxdepth 1 -readable | pf
}

pff () {
    find $1 ! -readable -prune -o -print | pf
}

pfscripts () {
    find $scripts_path -maxdepth 1 ! -executable -prune -o -print | awk -F'/' 'NR>1{print $NF}' | fzf --preview="script.preview_file $scripts_path/{}" --bind 'shift-up:preview-page-up,shift-down:preview-page-down,home:last,end:first' 
}

gitlog_fzf ()
{
    git log --oneline --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list
}


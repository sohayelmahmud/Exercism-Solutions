function pascal(){
    [[ "$@" == '' ]] && echo "1" && return
    [[ "$@" == 1 ]] && echo "1 1" && return
    while (($#>1)); do
        [[ $1 -gt 0 && $2 -gt 0 ]] && ((sum=$1+$2))
        row+=($sum)
        sum=0
        shift
    done
    echo "1 ${row[@]} 1"
}
[[ $1 -eq 1 ]] && echo 1 && exit
new_row=''
temp=''
for ((i=0; i<$1; i++)); do
    ((spaces=$1-i-1))
    for ((j=0; j<$spaces; j++)); do
        temp+=' '
    done
    new_row=$(pascal $new_row)
    echo "$temp$new_row"
    unset temp
done
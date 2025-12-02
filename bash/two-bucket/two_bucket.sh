declare -A bucket=(["one"]=0 ["two"]=0) vol=(["one"]=$1 ["two"]=$2)
goal=$3
start_bucket=$4
count=0
[[ $start_bucket == "one" ]] && other_bucket="two" || other_bucket="one"

show () {
    echo "$count:${bucket["one"]}:${bucket["two"]}"
}

fill() {
    bucket[$1]=${vol[$1]}
    ((count++))
}

empty() {
    bucket[$1]=0
    ((count++))
}

transfer() {
    if [[ $((bucket[$1]+bucket[$2])) -le ${vol[$2]} ]]; then
        ((bucket[$2]+=bucket[$1]))
        bucket[$1]=0
    else
        ((bucket[$1]-=vol[$2]-bucket[$2]))
        ((bucket[$2]=vol[$2]))
    fi
    ((count++))
}

check_win() {
    [[ bucket["one"] -eq $goal ]] && echo "moves: $count, goalBucket: one, otherBucket: ${bucket['two']}" && exit 0
    [[ bucket["two"] -eq $goal ]] && echo "moves: $count, goalBucket: two, otherBucket: ${bucket['one']}" && exit 0
}
check_fail() {
    [[ bucket[$start_bucket] -eq 0 && bucket[$other_bucket] -eq vol[$other_bucket] ]] && echo "invalid goal" && exit 1
    [[ $goal -gt vol[$start_bucket] && $goal -gt vol[$other_bucket] ]] && echo "invalid goal" && exit 1
}

fill $start_bucket
check_win
[[ vol[$other_bucket] -eq $goal ]] && fill $other_bucket || transfer $start_bucket $other_bucket
while true; do
    check_win
    [[ bucket[$start_bucket] -eq 0 ]] && fill $start_bucket
    [[ bucket[$other_bucket] -eq vol[$other_bucket] ]] && empty $other_bucket
    transfer $start_bucket $other_bucket
    check_fail
done
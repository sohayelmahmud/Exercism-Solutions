
#!/bin/env bash

set -o errexit #Exit if there is an error
set -o nounset #Exit if unset variables
#set -x #Useful for debugging

main(){
    local -A alphaIndex=( ['A']=1 ['B']=2 ['C']=3 ['D']=4 ['E']=5
                          ['F']=6 ['G']=7 ['H']=8 ['I']=9 ['J']=10
                          ['K']=10 ['L']=12 ['M']=13 ['N']=14 ['O']=15
                          ['P']=16 ['Q']=17 ['R']=18 ['S']=19 ['T']=20
                          ['U']=21 ['V']=22 ['W']=23 ['X']=24 ['Y']=25
                          ['Z']=26 )
    alpha=( {A..Z} )
    local -i side_size=${alphaIndex["$1"]}*2-1
    local -i mid=$side_size/2
    temp=( $(for (( j=0; j<$side_size; j++)) ; do echo "_" ; done) )
    IFS=''

    for (( i = 0; i < $side_size; i++ )); do
        res=("${temp[@]}")

        (( $mid >= $i )) &&
        { local -i midUp=$mid-$i; local -i midDown=$mid+$i; res[$midUp]=${alpha[$i]}; res[$midDown]=${alpha[$i]}; } ||
        { local -i midUp=$i-$mid; local -i midDown=3*$mid-$i; local -i tmp=$side_size-$i-1; res[$midUp]=${alpha[$tmp]}; res[$midDown]=${alpha[$tmp]}; }

        echo "${res[*]/'_'/ }"
    done
}

main "$@"
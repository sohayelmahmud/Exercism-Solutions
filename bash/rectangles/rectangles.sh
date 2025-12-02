#!/usr/bin/env bash

 main () {
    checkVEdges() {
    start=$1; end=$2; column=$3;
    for (( ii=start; ii<=end; ii++)); do
        r=${rows[$ii]:column:1}
        if [[ $r == '-' || $r == ' ' ]]; then { echo 0; exit; } fi
        done
        echo 1;
    }
    checkHEdges() {
        start=$1; end=$2; row=$3;
        for (( ii=start; ii<=end; ii++)); do
            r=${rows[$row]:ii:1}
            if [[ $r == '|' || $r == ' ' ]]; then { echo 0; exit; } fi
        done
        echo 1;
    }
    xvortices=();  yvortices=()
    countRectangle=0
    rows=()
    while IFS= read -t 1  -r line; do           # read with timeout
        [[ $line = INPUT ]] && break
        rows+=("$line")
    done
    (( ${#rows}<1 )) && { echo 0; exit; }
    for (( ii=0; ii< ${#rows[@]}; ii++)); do
        row=${rows[$ii]}
        ncol=${#row}
        (( ncol<1 )) && { echo 0; exit; }
        for (( jj=0; jj< ncol; jj++)); do
            if [[ ${row:jj:1} == '+' ]]; then
                xvortices+=($ii); yvortices+=($jj)
            fi
        done
    done
    nvortices=${#xvortices[@]}
    # now the array of vortices are created.
    xi=0; yi=0; xj=0; yj=0; xk=0; yk=0
    for (( ii=0; ii<$nvortices; ii++)); do
        for (( jj=ii+1; jj<$nvortices; jj++)); do
            vix=${xvortices[$ii]}; viy=${yvortices[$ii]}
            vjx=${xvortices[$jj]}; vjy=${yvortices[$jj]}
            if (( vix >= vjx || viy >= vjy)); then continue; fi
            vertex1=false;  vertex2=false
            for ((kk=0; kk<$nvortices; kk++)); do
                vkx=${xvortices[$kk]}; vky=${yvortices[$kk]}
                if (( kk != ii &&  kk != jj )); then
                    xi=$vix; yi=$viy
                    xj=$vjx; yj=$vjy
                    xk=$vkx; yk=$vky
                    if (( xi == xk && yj == yk )); then
                        (( $(checkVEdges $xk $xj $yk)==1 && $(checkHEdges $yi $yk $xk)==1 )) && vertex1=true
                    fi
                    if (( yi == yk && xj == xk )); then
                        (( $(checkHEdges $yk $yj $xk)==1 && $(checkVEdges $xi $xk $yk)==1 )) && vertex2=true
                    fi
                fi
                if [[ $vertex1 == true && $vertex2 == true ]]; then
                   (( countRectangle += 1 ))
                    break
                fi
            done
        done
    done
    echo $countRectangle
  }
  main "$@"

#!/usr/bin/env bash

wordy (){
  question="$1"
  operands="${question//plus/+}"
  operands="${operands//minus/-}"
  operands="${operands//multiplied by/m}"
  operands="${operands//divided by//}"
  operands="${operands%?}"
  operands=( $operands )
  format="^What is .+\\?"
  if [[  "${#operands[@]}" == 2 ]]; then
    echo "syntax error"
    return 1
  elif [[ ! $question =~ $format \
    || ! ${question: -1:1} == '?'\
    ||  ${operands[-1]} =~ ^[^-+*/0-9]+$ ]]; then
    echo "unknown operation"
    return 1
  elif [[ ! ${operands[-1]} =~ -?[0-9]+ ]];then
    echo "syntax error"
    return 1
  fi
  for (( i = 2; i < ${#operands[@]}; i++ )); do
      o="${operands[$i]}"
      [[ $o == 'm' ]] && o='*'
      if (( i%2 == 0 ))  && [[ $o =~ ^[+*-/]$ ]] \
      || (( i%2 ))  && [[ $o =~ ^-?[0-9]+$ ]]; then
        echo "syntax error"
        return 1
      fi
      if [[ $(( i%2 == 0 ))  &&  ! $result ]]; then
        result="$o"
      elif [[ "$o" =~ ^[-*+/]$ ]];then
        result+="$o"
      else
        result=$(( "$result $o" ))
      fi
  done
  echo $result
}

(( $# > 1 )) && echo "invalid number of arguments" && exit 1
wordy "$1"
#!/usr/bin/env bash

# Loop through pairs of arguments
# i starts at 1, j starts at 2
# Loop runs as long as i is less than the total number of arguments ($#)
for (( i=1, j=2 ; i < $# ; i++, j++ )); do
  # ${!i} and ${!j} use indirect variable expansion to get the value of the variable whose name is stored in i and j
  # This prints the intermediate proverb lines
  echo "For want of a ${!i} the ${!j} was lost."
done

# Check if the first argument exists to print the final line
# This ensures it only prints if there are arguments provided
[[ -n $1 ]] && echo "And all for the want of a $1." || :

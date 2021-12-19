#!/bin/bash

declare -a arr

while IFS= read -r line; do
  right=${line#* -> }
  left=${line% -> *}
  x1=${left#*,}
  y1=${left%,*}
  x2=${right#*,}
  y2=${right%,*}

  arr+=($x1 $y1 $x2 $y2)
done < 'input.txt'

abs() {
  echo $1 | awk '{print $1 < 0 ? -$1 : $1}'
}

count_overlapping() {
  declare -A map
  local diag=$1
  for ((i=0; i<${#arr[@]}; i+=4)); do
    x1=${arr[$i]}
    y1=${arr[$i+1]}
    x2=${arr[$i+2]}
    y2=${arr[$i+3]}
    stepX=0
    if [[ $x1 -gt $x2 ]]; then
      stepX=-1
    elif [[ $x1 -lt $x2 ]]; then
      stepX=1
    fi

    stepY=0
    if [[ $y1 -gt $y2 ]]; then
      stepY=-1
    elif [[ $y1 -lt $y2 ]]; then
      stepY=1
    fi

    if [[ $stepX -ne 0 && $stepY -ne 0 ]]; then
      if [[ $diag -eq 1 ]]; then
        if [[ $(abs $((x1 - x2))) -ne $(abs $((y1-y2))) ]]; then
          continue;
        fi
      else
        continue;
      fi
    fi

    while ([ $stepX -ne 0 ] && [ $x1 -ne $((x2 + stepX)) ]) || ([ $stepY -ne 0 ] && [ $y1 -ne $((y2 + stepY)) ]); do
      key=$(($y1 * 1000 + $x1))
      # echo $key
      if [[ ${map[$key]} ]]; then
        map[$key]=$((map[$key] + 1))
      else
        map[$key]=1
      fi
      x1=$((x1 + stepX))
      y1=$((y1 + stepY))
    done
  done

  count=0
  for key in "${!map[@]}"; do
    if [ ${map[$key]} -gt 1 ]; then
      count=$((count + 1))
    fi
  done
  echo $count;
}

echo "Part 1: $(count_overlapping 0)"
echo "Part 2: $(count_overlapping 1)"
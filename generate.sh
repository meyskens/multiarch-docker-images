#!/bin/bash

mkdir -p .github/workflows/
rm -f .github/workflows/*

while IFS=, read -r repo path target; do
  if [[ "$repo" != "repo" ]]; then 
    NAME=$(echo "$target" | tr '/' '\n' | tail -n1)
    cp template.yaml .github/workflows/$NAME.yaml
    sed -i 's#$repo#'$repo'#g' .github/workflows/$NAME.yaml
    sed -i 's#$target#'$target'#g' .github/workflows/$NAME.yaml
    sed -i 's#$path#'$path'#g' .github/workflows/$NAME.yaml
  fi
done < image-list
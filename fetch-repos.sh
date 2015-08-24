#!/bin/sh
for repo in midgard baldr sif skadi mjolnir loki odin thor tyr; do
  echo "Fetching $repo..."
  if [ ! -d $repo ]
  then
    git clone --recurse-submodules https://github.com/valhalla/$repo.git
  else
    cd $repo
    git pull && git submodule init && git submodule update
    cd ..
  fi
done

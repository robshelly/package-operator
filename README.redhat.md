# Branches

We want to separate our upstream (the public code) and downstream (things that are redhat
specific. This is done by:
- Mirroring this repo from github into the internal gitlab instance. Only the branch "main"
  and tags are mirrored.
- This repo contains a orphaned branch named "redhat". This one contains redhat specific 
  files. only those, no package operator.
- A gitlab CI job merges "main" and "redhat" in the branch "redhat-main".
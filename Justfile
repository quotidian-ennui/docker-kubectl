set positional-arguments := true
set dotenv-load := true
set unstable := true
set script-interpreter := ['/usr/bin/env', 'bash']

USER := `whoami`
BASE_TAG := USER / "kubectl"

# show recipes
[private]
@help:
    just --list --list-prefix "  "

# Build images
[group("build")]
@build tag="latest":
    docker build . --tag "{{ BASE_TAG }}:$1"

# Run a specific image
[group("build")]
@run tag: (build tag)
    docker run -it --rm "{{ BASE_TAG }}:{{ tag }}"

# Delete built images
[group("build")]
@clean:
    docker images --format json | jq -r 'select(.Repository | contains("{{ BASE_TAG }}")) | .ID' | xargs -r docker rmi -f || true

# Delete builder cache etc.
[group("build")]
@purge: clean
    docker image prune -f || true
    docker builder prune -f -a || true

# run updatecli with args e.g. just updatecli diff
[group("release")]
@updatecli *action="diff":
    updatecli "$@"

# Show the change log
[group("release")]
@changelog *args="--unreleased":
    git cliff "$@"

# pin workflows using pinact
[group("housekeeping")]
[script]
pin-gha *args="":
  pinact run {{ args }}

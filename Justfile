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

# Show the next version based on kubectl bumps
[group("release")]
[script]
next:
    set -eo pipefail

    lastTag=$(git tag | sort -rV | head -n1)
    version_v=$(git log --format=format:'%s' "$lastTag"..HEAD | grep "Bump kubectl" | sed -E "s/^.*(v[0-9]+\.[0-9]+\.[0-9]+).*$/\1/g" | sort -rV | head -n1) || true
    version="${version_v##v}"
    if [[ -z "$version" ]]; then
      echo "No Version bump of kubectl found?"
      exit 1;
    else
      echo "$version"
    fi

# Tag and optionally push
[group("release")]
[script]
autotag push="localonly":
    set -eo pipefail

    next=$(just next)
    echo "ℹ️ Tag & release $next"
    just -g release "$next" {{ push }}

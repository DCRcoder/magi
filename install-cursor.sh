#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash install-cursor.sh [user|project] [all|skills|agent]

Defaults:
  scope = user
  kind  = all
EOF
}

scope="user"
kind="all"

if (($# > 0)); then
  for arg in "$@"; do
    case "$arg" in
      user|project)
        scope="$arg"
        ;;
      all|skills|skill|agent|agents)
        kind="$arg"
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unsupported argument: $arg" >&2
        usage
        exit 1
        ;;
    esac
  done
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="$HOME/.cursor"
if [[ "$scope" == "project" ]]; then
  target_dir="$repo_root/.cursor"
fi

copy_dir() {
  local src="$1"
  local dest="$2"

  if [[ -d "$src" ]]; then
    mkdir -p "$dest"
    cp -R "$src/." "$dest/"
  fi
}

mkdir -p "$target_dir"
case "$kind" in
  all)
    copy_dir "$repo_root/skills" "$target_dir/skills"
    copy_dir "$repo_root/agents" "$target_dir/agents"
    ;;
  skills|skill)
    copy_dir "$repo_root/skills" "$target_dir/skills"
    ;;
  agent|agents)
    copy_dir "$repo_root/agents" "$target_dir/agents"
    ;;
esac

echo "Installed cursor to $scope scope with kind=$kind: $target_dir"
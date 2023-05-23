#!/usr/bin/env bash
set -e

export GOPLS_UNUSED_ROOT

function_to_run=$1

GOPLS_UNUSED_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

function _includes_path {
	echo "$GOPLS_UNUSED_ROOT"/lib
}

function _load_includes {
	for file in "$(_includes_path)"/*.bash; do
		# shellcheck source=/dev/null
		source "$file"
	done
}

_load_includes

if [[ $(type -t "$function_to_run") != function ]]; then
	echo "Subcommand: '$function_to_run' not found."
	exit 1
fi

shift

_pushd "$GOPLS_UNUSED_ROOT"
_debug "Running '$function_to_run $*'..."
"$function_to_run" "$@"
_popd

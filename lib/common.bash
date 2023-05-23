function _pushd {
	# shellcheck disable=2119
	command pushd "$@" >/dev/null || _panic
}

# shellcheck disable=2120
function _popd {
	# shellcheck disable=2119
	command popd "$@" >/dev/null || _panic
}

function _debug {
	local message=$1
	if [ "$DEBUG" = "1" ]; then
		echo >&2 "$message"
	fi
}

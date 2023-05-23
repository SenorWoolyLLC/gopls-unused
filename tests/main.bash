TESTS_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

function _load_test_files {
	source "$TESTS_ROOT/../lib/common.bash"
	for file in "$TESTS_ROOT"/*.bash; do
		if [ "$file" != "$TESTS_ROOT/main.bash" ]; then
			# shellcheck source=/dev/null
			source "$file"
		fi
	done
}

function _run_tests {
	_all_passed="true"

	tests=$(compgen -A function test_)
	while read -r function_name; do
		result=$("$function_name")
		if [ "$result" = "pass" ]; then
			echo "$function_name ✅"
		else
			_all_passed="false"
			echo "$function_name 🔴"
		fi
	done <<<"$tests"

	if [ "$_all_passed" = "false" ]; then
		exit 1
	fi
}

function run {
	_pushd "$TESTS_ROOT"/..
	DEBUG=1 ./gopls-unused.bash "$@" 2>&1
	_popd
}

_load_test_files
_run_tests

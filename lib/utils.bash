function _get_symbols_in_file {
	local file=$1
	gopls symbols "$file"
}

function _find_all_go_files {
	local path=$1
	find "$GOPLS_UNUSED_ROOT/$path" -type f -name "*.go"
}

function _get_references {
	local file_and_location=$1
	references=$(gopls references "$file_and_location")
	references=$(_remove_test_files_from_references "$references")
	echo "$references"
}

function _first_word {
	local input=$1
	echo "$input" | awk '{print $1;}'
}

function _last_word {
	local input=$1
	echo "$input" | awk '{print $(NF)}'
}

function _extract_symbol {
	local symbol_details=$1
	_first_word "$symbol_details"
}

function _extract_location {
	local symbol_details=$1
	_last_word "$symbol_details"
}

function _is_symbol_publically_exported {
	local symbol=$1

	first_letter=${symbol:0:1}
	if [[ "$first_letter" =~ [A-Z] ]]; then
		echo "true"
	else
		echo "false"
	fi
}

function _is_go_test_file {
	local path=$1
	if [[ "$path" =~ .*"_test.go" ]]; then
		echo "true"
	else
		echo "false"
	fi
}

function _remove_test_files_from_references {
	local paths_with_location=$1
	local _is_test_file="false"

	echo "$paths_with_location" | while read -r path_and_location; do
		if [ "$paths_with_location" != "" ]; then
			path=$(echo "$path_and_location" | cut -d ':' -f1)
			if [ "$(_is_go_test_file "$path")" = "true" ]; then
				_debug "Ignoring reference in test file: $path"
				continue
			fi
			if grep -q "github.com/onsi/ginkgo/v2" "$path"; then
				_debug "Ignoring reference in Ginkgo test file: $path"
				continue
			fi
			echo "$path_and_location"
		fi
	done
}

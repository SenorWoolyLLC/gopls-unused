function find_all {
	local go_project_path=$1
	local i=0
	_pushd "$CWD/$go_project_path"

	files=$(_find_all_go_files "$go_project_path")
	total=$(echo "$files" | wc -l)
	echo "$files" | while read -r file; do
		i=$((i + 1))
		_debug "Searching in file $i/$total for publically exported symbols"

		if [ "$(_is_go_test_file "$file")" = "false" ]; then
			find_all_in_file "$file"
		else
			_debug "Skipping Go test file: $file"
		fi
	done

	_popd
}

function find_all_in_file {
	local file=$1
	local i=0

	symbols=$(_get_symbols_in_file "$file")
	echo "$symbols" | while read -r symbol_details; do
		find_symbol_references_in_project "$symbol_details"
	done
}

function find_symbol_references_in_project {
	# `symbol_details` is a line from `gopls symbols ...`
	local symbol_details=$1

	symbol=$(_extract_symbol "$symbol_details")
	if [[ $(_is_symbol_publically_exported "$symbol") == "true" ]]; then
		location=$(_extract_location "$symbol_details")
		references="$(_get_references "$file:$location")"
		relative_file_path=$(echo "$file" | sed "s|$CWD/||g")
		output="$relative_file_path $symbol $location"
		if [ "$references" = "" ]; then
			echo "🔴 $output"
		else
			uses=$(echo "$references" | wc -l)
			_debug "✅ ($uses uses) $output"
		fi
	fi
}

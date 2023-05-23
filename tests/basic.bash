function test_finding_unused_function {
	local status="fail"
	output=$(run find_all tests/go)

	if [[ "$output" =~ "🔴".*"ThisIsUnused" ]]; then
		status="pass"
	fi

	echo "$status"
}

function test_ignores_references_in_go_test_files {
	local status="pass"
	output=$(run find_all tests/go)
	symbol_name="ThisIsOnlyUsedInGoTests"

	if [[ ! "$output" =~ "🔴".*"$symbol_name" ]]; then
		status="fail"
	fi

	if [[ "$output" =~ "✅".*"$symbol_name" ]]; then
		status="fail"
	fi

	echo "$status"
}

function test_ignores_references_in_ginkgo_test_files {
	local status="pass"
	output=$(run find_all tests/go)
	symbol_name="ThisIsOnlyUsedInGinkgoTests"

	if [[ ! "$output" =~ "🔴".*"$symbol_name" ]]; then
		status="fail"
	fi

	if [[ "$output" =~ "✅".*"$symbol_name" ]]; then
		status="fail"
	fi

	echo "$status"
}

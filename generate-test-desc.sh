#!/bin/bash
#
# Generate test-db entries from source code files
#
# Expected input is:
#
#     test: f0e2f23c-7cc6-4610-80c0-8f1e3a6555c7
#     desc: this is a test description
#
# There must be at least one space before "test:" and "desc:",
# and those could be also prefixed with line or block comment.
#
exe_dir=$(dirname $(realpath $0))

test_file="$1"
test_class="$2"

print_test() {
  local test_id="$1"
  local desc="$2"

cat << EOF
          - test:
              id: $test_id
              name: $test_class
              descriptions:
                - desc: "$desc"
EOF
}

rgx_test=' +test: +[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+-[[:xdigit:]]+ *$'

grep --no-group-separator -A1 -E "$rgx_test" "$test_file" | \
while read tst 
do 
	read raw_desc
	desc=$(echo "$raw_desc" | sed -E 's/.* desc: //')
	test_id="$(echo $tst | sed 's/.* test: //')"
	grep $test_id $exe_dir/*.yml >/dev/null 2>&1 || print_test "$test_id" "$desc"
done

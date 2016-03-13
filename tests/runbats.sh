#! /usr/bin/bash
#
# Author:   Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Run BATS test files in the current directory, and the ones in the subdirectory
# matching the host name.
#
# The script installs BATS if needed. It's best to put ${bats_install_dir} in
# your .gitignore.

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable

#{{{ Constants

readonly DEFAULT_INSTALL_DIR="/opt"
readonly TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly TEST_FILE_PATTERN="*.bats"

readonly BATS_ARCHIVE="v0.4.0.tar.gz"
readonly BATS_URL="https://github.com/sstephenson/bats/archive/${BATS_ARCHIVE}"

# color definitions
readonly BLUE='\e[0;34m'
readonly YELLOW='\e[0;33m'
readonly RESET='\e[0m'

#}}}
#{{{ Functions

# Usage: bats_install_dir
# Determines where BATS should be installed. When run as root, install under
# $DEFAULT_INSTALL_DIR, otherwise under the directory where the script is run
# from.
bats_install_dir() {
  if [ "${UID}" -eq "0" ]; then
    echo "${DEFAULT_INSTALL_DIR}"
  else
    echo "${TEST_DIR}"
  fi
}

# Usage: install_bats DIR
# Installs BATS in the specified directory
install_bats() {
  local install_dir="${1}"
  if [ ! -d "${install_dir}/bats" ]; then
    pushd "${install_dir}" > /dev/null
    wget "${BATS_URL}"
    tar xf "${BATS_ARCHIVE}"
    mv bats-* bats
    rm "${BATS_ARCHIVE}"
    popd > /dev/null
  fi
}

# Usage: bats_executable
# Returns the path to the BATS executable. If BATS is not available on the
# system, it is installed.
bats_executable() {
  local bats=""
  if ! which bats > /dev/null 2>&1; then
    local dir
    dir="$(bats_install_dir)"
    install_bats "${dir}"
    bats="${dir}/bats/libexec/bats"
  else
    bats="$(which bats)"
  fi
  echo "${bats}"
}

# Usage: find_tests DIR [MAX_DEPTH]
# Finds BATS test files in the specified directory, up to the specified depth
# (if specified)
find_tests() {
  local max_depth=""
  if [ "$#" -eq "2" ]; then
    max_depth="-maxdepth $2"
  fi

  local tests
  tests=$(find "$1" ${max_depth} -type f -name "${TEST_FILE_PATTERN}" -printf '%p\n' 2> /dev/null)

  echo "${tests}"
}
#}}}
# Script proper

# Get the path to the BATS executable
bats="$(bats_executable)"

# List all test cases (i.e. files in the test dir matching the test file
# pattern)

# Tests to be run on all hosts
global_tests=$(find_tests "${TEST_DIR}" 1)

# Tests for individual hosts
host_tests=$(find_tests "${TEST_DIR}/${HOSTNAME}")

# Loop over test files
for test_case in ${global_tests} ${host_tests}; do
  echo -e "${BLUE}Running test ${YELLOW}${test_case}${RESET}"
  ${bats} "${test_case}"
done

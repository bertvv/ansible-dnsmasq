#! /usr/bin/bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# PURPOSE
# See usage() for details.

#{{{ Bash settings
# abort on nonzero exitstatus
#set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail
#}}}
#{{{ Variables
readonly SCRIPT_NAME=$(basename "${0}")
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)

# color definitions
readonly BLUE='\e[0;34m'
readonly YELLOW='\e[0;33m'
readonly RESET='\e[0m'

# Test settings
readonly BATS_URL='https://github.com/sstephenson/bats/archive/'
readonly BATS_ARCHIVE='v0.4.0.tar.gz'
readonly BATS_LOCAL=bats/libexec/bats
readonly HOSTS=(192.168.6.66 192.168.6.67)
readonly TEST_SUITE=dns.bats
#}}}

main() {

  bats=$(install_bats_if_needed)

  for host in "${HOSTS[@]}"; do
    test_host "${host}"
  done

}

#{{{ Helper functions

test_host() {
  local host="${1}"

  echo -e "${YELLOW}--- Running tests for host ${BLUE}${host}${YELLOW} ---${RESET}"

  # The test script will use the value of ${sut_ip} (= IP address of the System Under Test)
  sut_ip="${host}" "${bats}" "${TEST_SUITE}"
}

install_bats_if_needed() {
  # If BATS is installed system wide, use that
  if test which bats > /dev/null 2>&1; then
    which bats
    return
  fi

  # If BATS is not installed in the current directory, do so
  if [ ! -x "${BATS_LOCAL}" ]; then
    install_bats
  fi
  echo "${BATS_LOCAL}"
}

install_bats() {
  wget "${BATS_URL}/${BATS_ARCHIVE}"
  tar xf "${BATS_ARCHIVE}"
  mv bats-* bats        # Drop the version number from install directory
  rm "${BATS_ARCHIVE}"  # Remove the downloaded tarball
}

#}}}

main "${@}"


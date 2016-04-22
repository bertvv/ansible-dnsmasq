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

  sut_ip="${host}" "${bats}" "${TEST_SUITE}"
}

install_bats_if_needed() {
  if test which bats > /dev/null 2>&1; then
    which bats
    return
  fi

  if [ ! -x "${BATS_LOCAL}" ]; then
    install_bats
  fi
  echo "${BATS_LOCAL}"
}

install_bats() {
  wget "${BATS_URL}"
  tar xf "${BATS_ARCHIVE}"
  mv bats-* bats
  rm "${BATS_ARCHIVE}"
}

#}}}

main "${@}"


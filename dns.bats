#! /usr/bin/env bats
#
# Acceptance test for the DNS server for linuxlab.lan

if [ "${sut_ip}" = "" ]; then
  sut_ip=192.168.6.66
fi
domain=example.lan

#{{{ Helper functions

# Usage: assert_forward_lookup NAME IP
# Exits with status 0 if NAME.DOMAIN resolves to IP, a nonzero
# status otherwise
assert_forward_lookup() {
  local name="$1"
  local ip="$2"

  [ "$ip" = "$(dig @${sut_ip} ${name}.${domain} +short)" ]
}

# Usage: assert_reverse_lookup NAME IP
# Exits with status 0 if a reverse lookup on IP resolves to NAME,
# a nonzero status otherwise
assert_reverse_lookup() {
  local name="$1"
  local ip="$2"

  [ "${name}.${domain}." = "$(dig @${sut_ip} -x ${ip} +short)" ]
}

# Usage: assert_alias_lookup ALIAS NAME IP
# Exits with status 0 if a forward lookup on NAME resolves to the
# host name NAME.DOMAIN and to IP, a nonzero status otherwise
assert_alias_lookup() {
  local alias="$1"
  local name="$2"
  local ip="$3"
  local result="$(dig @${sut_ip} ${alias}.${domain} +short)"

  echo ${result} | grep "${name}\.${domain}\."
  echo ${result} | grep "${ip}"
}

# Usage: assert_ns_lookup NS_NAME...
# Exits with status 0 if all specified host names occur in the list of
# name servers for the domain.
assert_ns_lookup() {
  local result="$(dig @${sut_ip} ${domain} NS +short)"

  [ -n "${result}" ] # the list of name servers should not be empty
  while (( "$#" )); do
    echo "${result}" | grep "$1\.${domain}\."
    shift
  done
}

# Usage: assert_mx_lookup PREF1 NAME1 PREF2 NAME2...
#   e.g. assert_mx_lookup 10 mailsrv1 20 mailsrv2
# Exits with status 0 if all specified host names occur in the list of
# mail servers for the domain.
assert_mx_lookup() {
  local result="$(dig @${sut_ip} ${domain} MX +short)"

  [ -n "${result}" ] # the list of name servers should not be empty
  while (( "$#" )); do
    echo "${result}" | grep "$1 $2\.${domain}\."
    shift
    shift
  done
}

# Usage: assert_srv_lookup SERVICE TARGET PORT [PRIORITY [WEIGHT]]
#   e.g. assert_srv_lookup 0 0 389 charlie
# Exits with status 0 if the query result matches the expected result
assert_srv_lookup() {
  local service="$1"
  local target="$2"
  local port="$3"
  if [ "$#" -ge "4" ]; then
    local priority="$4"
  else
    local priority="0"
  fi
  if [ "$#" -ge "5" ]; then
    local weight="$5"
  else
    local weight="0"
  fi
  local result="$(dig @${sut_ip} SRV ${service}.${domain}  +short)"

  [ -n "${result}" ] # the list of name servers should not be empty
  echo "${result}" | grep "${priority} ${weight} ${port} ${target}\.${domain}\."
}

#}}}

@test 'The `dig` command should be installed' {
  which dig
}

@test 'Forward lookups' {
  #                     host name  IP
  assert_forward_lookup ns     192.168.6.66
  assert_forward_lookup dhcp   192.168.6.66
  assert_forward_lookup alpha  192.168.6.10
  assert_forward_lookup bravo  192.168.6.11
  assert_forward_lookup charlie 192.168.6.12
}

@test 'Reverse lookups' {
  #                     host name  IP
  assert_reverse_lookup ns     192.168.6.66
  assert_reverse_lookup alpha  192.168.6.10
  assert_reverse_lookup bravo  192.168.6.11
  assert_reverse_lookup charlie 192.168.6.12
}

@test 'SRV record lookup' {
  assert_srv_lookup _ldap._tcp charlie 389
}


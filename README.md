# Dnsmasq

An Ansible role for setting up Dnsmasq under CentOS/RHEL 7 and Fedora 16 or newer as a simple DNS forwarder, and/or DHCP server. Specifically, the responsibilities of this role are to install the necessary packages and manage the configuration.

Configuring the firewall is outside the scope of this role. Use another role suitable for your distribution, e.g. [bertvv.el7](https://galaxy.ansible.com/bertvv/el7/).

If you like/use this role, please consider starring it. Thanks!


## Requirements

No specific requirements.

## Role Variables

None of the variables below are required.

| Variable                   | Default | Comments                                                                                                                                                  |
| :---                       | :---    | :---                                                                                                                                                      |
| `dnsmasq_addn_hosts`       | -       | Set this to specify a custom host file that should be read in addition to `/etc/hosts`.                                                                   |
| `dnsmasq_authoritative`    | `false` | When `true`, dnsmasq will function as an authoritative name server.                                                                                       |
| `dnsmasq_bogus_priv`       | `true`  | When `true`, Dnsmasq will not forward addresses in the non-routed address spaces.                                                                         |
| `dnsmasq_dhcp_hosts`       | -       | Array of hashes specifying IP address reservations for hosts, with keys `name` (optional), `mac` and `ip` for each reservation. See below.             |
| `dnsmasq_dhcp_ranges`      | -       | Array of hashes specifying DHCP ranges (with keys `start_addr`, `end_addr`, and `lease_time`) for each address pool. This also enables DHCP. See below. |
| `dnsmasq_domain_needed`    | `true`  | When `true`, local requests (i.e. without domain name) are not forwarded.                                                                                 |
| `dnsmasq_domain`           | -       | The domain for Dnsmasq.                                                                                                                                   |
| `dnsmasq_expand_hosts`     | `false` | Set this (and `dnsmasq_domain`) if you want to have a domain automatically added to simple names in a hosts-file.                                         |
| `dnsmasq_listen_address`   | -       | The IP address of the interface that should listen to DNS/DHCP requests.                                                                                  |
| `dnsmasq_interface`        | -       | The network interface that should listen to DNS/DHCP requests.                                                                                            |
| `dnsmasq_option_router`    | -       | The default gateway to be sent to clients.                                                                                                                |
| `dnsmasq_port`             | -       | Set this to listen on a custom port.                                                                                                                      |
| `dnsmasq_resolv_file`      | -       | Set this to specify a custom `resolv.conf` file.                                                                                                          |
| `dnsmasq_upstream_servers` | -       | Set this to specify the IP address of upstream DNS servers directly. You can specify one ore more servers as a list.                                    |
| `dnsmasq_srv_hosts`        | -       | Array of hashes specifying SRV records, with keys `name` (mandatory), `target`, `port`, `priority` and `weight` for each record. See below.              |

### DNS settings

One or more upstream DNS servers can can be specified with the variable `dnsmasq_server`, e.g.:

```Yaml
    dnsmasq_upstream_servers: ns1.example.com
  OR
    dnsmasq_upstream_server:
      - 8.8.4.4
      - 8.8.8.8
```

SRV records (see [dnsmasq(8)](http://linux.die.net/man/8/dnsmasq) or [RFC 2782](https://www.ietf.org/rfc/rfc2782.txt)) can be specified with `dnsmasq_srv_hosts`, e.g.:

```Yaml
    dnsmasq_srv_hosts:
      - name: _ldap._tcp.example.com
        target: ldap01.example.com
        port: 389
      - name: _ldap._tcp.example.com
        target: ldap02.example.com
        port: 389
```

### DHCP settings

A DHCP range can be specified with the variable `dnsmasq_dhcp_ranges`, e.g.:

```Yaml
    dnsmasq_dhcp_ranges:
      - start_addr: '192.168.6.150'
        end_addr: '192.168.6.253'
        lease_time: '8h'
```

IP address reservations based on MAC addres can be specified with `dnsmasq_dhcp_hosts`, e.g.:

```Yaml
    dnsmasq_dhcp_hosts:
      - name: 'alpha'
        mac: '11:22:33:44:55:66'
        ip: '192.168.6.10'
      - name: 'bravo'
        mac: 'aa:bb:cc:dd:ee:ff'
        ip: '192.168.6.11'
```

## Dependencies

None, but role [bertvv.hosts](https://galaxy.ansible.com/bertvv/hosts/) may come in handy if you want an easy way to manage the contents of `/etc/hosts`.

## Example Playbook

Most Dnsmasq settings have sane defaults and don't have to be specified. The simplest configuration would be a DNS forwarder with default settings:

```Yaml
- hosts: server
  roles:
    - bertvv.dnsmasq
```

A more elaborate example, with DHCP can be found in the [test playbook]().

## Testing

### Setting up the test environment

Tests for this role are provided in the form of a Vagrant environment that is kept in a separate branch, `tests`. I use [git-worktree(1)](https://git-scm.com/docs/git-worktree) to include the test code into the working directory. Instructions for running the tests:

1. Fetch the tests branch: `git fetch origin tests`
2. Create a Git worktree for the test code: `git worktree add tests tests` (remark: this requires at least Git v2.5.0). This will create a directory `tests/`.
3. `cd tests/`
4. `vagrant up` will then create test VMs for all supported distros and apply a test playbook (`test.yml`) to each one.

### Running the tests

The directory also contains a set of functional tests that validate whether the Dnsmasq service actually works on the supported distributions. You can run the tests from the host system by executing the script `runtests.sh`. When needed, the script will install [BATS](https://github.com/sstephenson/bats), a testing framework for Bash.

| **Hostname**      | **IP**       |
| :---              | :---         |
| `centos72-dnsmasq | 192.168.6.66 |
| `fedora23-dnsmasq | 192.168.6.67 |

Run the test script from within its containing directory. If successful, you should see the following output:

```
$ ./runtests.sh
--- Running tests for host 192.168.6.66 ---
 ✓ The `dig` command should be installed
 ✓ Forward lookups
 ✓ Reverse lookups

3 tests, 0 failures
--- Running tests for host 192.168.6.67 ---
 ✓ The `dig` command should be installed
 ✓ Forward lookups
 ✓ Reverse lookups

3 tests, 0 failures
```

In the console transcript above, the output of installing BATS is not shown.

## See also

Debian/Ubuntu users can take a look at [Debops](https://galaxy.ansible.com/debops/)'s [Dnsmasq role](https://galaxy.ansible.com/debops/dnsmasq/).

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section. Pull requests are also very welcome. Preferably, create a topic branch and when submitting, squash your commits into one (with a descriptive message).

## License

Licensed under the 2-clause "Simplified BSD License". See [LICENSE.md](/LICENSE.md) for details.

## Contributors

- [Bert Van Vreckem](https://github.com/bertvv) (maintainer)
- [Chris James](https://github.com/etcet)
- [David Wittman](https://github.com/DavidWittman)
- [Niklas Juslin](https://github.com/JZfi)

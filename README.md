# Dnsmasq

An Ansible role for setting up Dnsmasq under CentOS/RHEL 7 as a simple DNS forwarder, and/or DHCP server. Specifically, the responsibilities of this role are to install the necessary packages and manage the configuration.

Configuring the firewall is outside the scope of this role. Use another role suitable for your distribution, e.g. [bertvv.el7](https://galaxy.ansible.com/bertvv/el7/).

If you like/use this role, please consider starring it. Thanks!


## Requirements

No specific requirements.

## Role Variables

None of the variables below are required.

| Variable                 | Default | Comments                                                                                                                                                                    |
| :---                     | :---    | :---                                                                                                                                                                        |
| `dnsmasq_addn_hosts`     | -       | Set this to specify a custom host file that should be read in addition to `/etc/hosts`.                                                                                     |
| `dnsmasq_authoritative`  | `false` | When `true`, dnsmasq will function as an authoritative name server.                                                                                                         |
| `dnsmasq_bogus_priv`     | `true`  | When `true`, Dnsmasq will not forward addresses in the non-routed address spaces.                                                                                           |
| `dnsmasq_dhcp_hosts`     | -       | Array of hashes specifying IP address reservations for hosts, with keys `name` (optional), `mac` and `ip` for each reservation.                                             |
| `dnsmasq_dhcp_ranges`    | -       | Array of hashes specifying DHCP ranges (with keys `start_addr`, `end_addr`, and `lease_time`) for each address pool. This also enables DHCP. See the Example section below. |
| `dnsmasq_domain_needed`  | `true`  | When `true`, local requests (i.e. without domain name) are not forwarded.                                                                                                   |
| `dnsmasq_domain`         | -       | The domain for Dnsmasq.                                                                                                                                                     |
| `dnsmasq_expand_hosts`   | `false` | Set this (and `dnsmasq_domain`) if you want to have a domain automatically added to simple names in a hosts-file.                                                           |
| `dnsmasq_listen_address` | -       | The IP address of the interface that should listen to DNS/DHCP requests.                                                                                                    |
| `dnsmasq_interface`      | -       | The network interface that should listen to DNS/DHCP requests.                                                                                                              |
| `dnsmasq_option_router`  | -       | The default gateway to be sent to clients.                                                                                                                                  |
| `dnsmasq_port`           | -       | Set this to listen on a custom port.                                                                                                                                        |
| `dnsmasq_resolv_file`    | -       | Set this to specify a custom `resolv.conf` file.                                                                                                                            |
| `dnsmasq_server`         | -       | Set this to specify the IP address of upstream DNS servers directly.                                                                                                        |

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

A more elaborate example, with DHCP can be found in the [test playbook](tests/test.yml).

## Testing

The `tests` directory contains tests for this role in the form of a Vagrant environment. The playbook [`test.yml`](tests/test.yml) applies the role to a VM, setting up a DNS forwarder and DHCP server.

The directory also contains a set of functional tests that validate whether the Dnsmasq service actually works on the supported distributions. You can run the tests both from the host system and the VM by executing the script `runtests.sh`. When needed, the script will install [BATS](https://github.com/sstephenson/bats), a testing framework for Bash.

```
## From the host system:
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

## Author Information

Written by Bert Van Vreckem <bert.vanvreckem@gmail.com>

Contributions by:

- [Chris James](https://github.com/etcet)
- [David Wittman](https://github.com/DavidWittman)

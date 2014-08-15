# Dnsmasq

This role can be used to set up Dnsmasq.

## Requirements

This role can be used on Linux systems with:

* the `yum` package manager,
* `firewalld`, which is used to configure the firewall.

That means a fairly recent Fedora, or RedHat/CentOS 7.

## Role Variables

* `dnsmasq_addn_hosts` (*Optional*) -- set this to specify a custom host file that should be read in addition to `/etc/hosts`.
* `dnsmasq_bogus_priv` (*Optional*) -- set this if Dnsmasq should not forward addresses in the non-routed address spaces.
* `dnsmasq_dhcp_hosts` (*Optional*) -- set this to reserve IP addresses for specific hosts. You should provide an array of hashes with keys `name` (optional), `mac` and `ip` for each reservation.
* `dnsmasq_dhcp_ranges` (*Optional*) -- set this to enable the DHCP server. You should specify an array of hashes (with keys `start_addr`, `end_addr`, and `lease_time`) for each address pool. See the example section below.
* `dnsmasq_domain_needed` (*Optional*) -- set this if Dnsmasq should not forward local requests (i.e. without domain name).
* `dnsmasq_domain` (*Optional*) -- set the domain for Dnsmasq.
* `dnsmasq_expand_hosts` (*Optional*) -- set this (and `dnsmasq_domain`) if you want to have a domain automatically added to simple names in a hosts-file.
* `dnsmasq_listen_address` (*Default value:* 127.0.0.1, set in `defaults/main.yml`) -- set this to specify the IP address of the interface that should listen to DNS/DHCP requests.
* `dnsmasq_option_router` (*Optional*) -- set this to specify the default gateway to be sent to clients.
* `dnsmasq_port` (*Optional*) -- set this to listen on a custom port.
* `dnsmasq_resolv_file` (*Optional*) -- set this to specify a custom `resolv.conf` file.

## Dependencies

None

## Example Playbook

Most Dnsmasq settings have sane defaults and don't have to be specified. The simplest configuration would be:

    - hosts: server
      roles:
         - { role: bertvv.dnsmasq, listen-address: 192.168.0.2 }

This enables a simple DNS forwarder with default settings.

A more elaborate example, with DHCP. In this example variables set in `host_vars/server`, the playbook should only mention the role.

    ---
    dnsmasq_listen_address: '192.168.0.2'
    dnsmasq_domain_needed: true
    dnsmasq_expand_hosts: true
    dnsmasq_bogus_priv: true
    dnsmasq_domain: 'example.com'

    dnsmasq_dhcp_ranges:
      - start_addr: '192.168.0.150'
        end_addr: '192.168.0.250'
        lease_time: '8h'

    dnsmasq_dhcp_hosts:
      - name: 'alpha'
        mac: '11:22:33:44:55:66'
        ip: '192.168.0.10'
      - name: 'bravo'
        mac: 'aa:bb:cc:dd:ee:ff'
        ip: '192.168.0.11'

    dnsmasq_option_router: '192.168.0.254'


## License

Licensed under the 2-clause "Simplified BSD License". See [LICENSE.md](/LICENSE.md) for details.

## Author Information

Written by Bert Van Vreckem <bert.vanvreckem@gmail.com>

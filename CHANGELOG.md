# Change log

This file contains al notable changes to the `bertvv.dnsmasq` Ansible role.

This file adheres to the guidelines of [http://keepachangelog.com/](http://keepachangelog.com/). Versioning follows [Semantic Versioning](http://semver.org/).

## 2.1.0 - 2016-05-20

### Added

- (GH-8) Specify upstream DNS servers with `dnsmasq_upstream_servers` (credits to [Niklas Juslin](https://github.com/JZfi))
- (GH-8) Specify SRV records with `dnsmasq_srv_hosts` (credits to [Niklas Juslin](https://github.com/JZfi))

## 2.0.0 - 2016-04-22

### Added

- Support for Fedora, including tests (on Fedora 23).

### Changed

Some of the changes below result in different default behaviour of the role compared to previous version. These are considered breaking backwards compatibility, hence the major version increment.

- Make `dnsmasq_listen_address` optional. This changes the default behaviour into listening to all interfaces.
- Enable `dnsmasq_bogus_priv` by default for better security.
- Enable `dnsmasq_domain_needed` by default for better security.
- Use generic ‘package’ module for installation. This is a feature new in Ansible 2.0, so this version of the role can no longer be used on older versions of Ansible. This is also considered as a breaking change.
- Separated test code into a different branch, `tests`.

## 1.2.1 - 2016-03-18

### Added

- Functional tests (with [BATS](https://github.com/sstephenson/bats))

### Removed

- The `version:` field in `meta/main.yml` was removed because it is no longer accepted in Ansible 2.0. Unfortunately, this change breaks compatibility with `librarian-ansible`. For more info on this issue, see [ansible/ansible#](https://github.com/ansible/ansible/issues/13496).

## 1.2.0 - 2016-03-12

### Added

- Role variable `dnsmasq_interface` (credits to [David Wittman](https://github.com/DavidWittman))
- Role variable `dnsmasq_server` (credits to [David Wittman](https://github.com/DavidWittman))

### Removed

- Setting firewall rules. This should not be a concern of this role. Use another role that manages the firewall specific to your distribution (e.g. [bertvv.el7](https://galaxy.ansible.com/bertvv/el7/)).

## 1.1.0 - 2015-08-31

### Added

- Role variable `dnsmasq_authoritative`: when true, dnsmasq will function as an authoritative name server. (credits to [Chris James](https://github.com/etcet))
- Config files in `/etc/dnsmasq.d/` will now also be read

### Changed

- Fixed typo (credits to [Chris James](https://github.com/etcet))

## 1.0.1 - 2015-03-14

### Added

- Role test with Vagrant

### Changed

- Remodeled firewall rules
- Updated documentation
- Coding style: use valid YAML instead of Ansible specific `var=val` syntax.

## 1.0.0 - 2014-08-15

### Added

- DNS forwarding
- DHCP server


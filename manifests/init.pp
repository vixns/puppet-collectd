# collectd/manifests/init.pp
# (C) Copyright: 2008, David Schmitt <david@dasz.at>

# Module: collectd
#
# To start managing the collectd, include the collectd class in your node. Use
# the collectd::conf define to set basic parameters of your installation.
# collectd::plugin is the foundation of many plugin-specific defines which help
# you configuring their respective plugin.
#
# Class: collectd
# Manages the installation and running of a collectd as well as the
# /etc/collectd/collectd.conf file.
class collectd {

  file {'/var/lib/puppet/modules':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    mode    => '0755',
    owner   => root,
    group   => 0;
  }

  collectd::libdir { ['collectd', 'collectd/plugins', 'collectd/thresholds' ]: }

  package {'collectd':
    ensure => installed;
  }

  service {'collectd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    pattern    => collectd,
    require    => Package['collectd'];
  }

  file {'/etc/collectd/':
    ensure  => 'directory',
    mode    => '0755',
    owner   => root,
    group   => 0,
    require => Package['collectd'],
  }

  file {'/etc/collectd/collectd.conf':
    ensure  => present,
    mode    => '0644',
    owner   => root,
    group   => 0,
    require => [Package['collectd'], File['/etc/collectd/']],
    notify  => Service['collectd'];
  }

  collectd::conf {'Include':
    value => '/var/lib/puppet/modules/collectd/plugins/*.conf';
  }

  # add customisations for distributions here
  case $::operatingsystem {
    'debian': {
      case $::debianversion {
        'etch': {
        }
      }
    }
    'redhat': {
      file {
        '/etc/collectd.conf':
          ensure  => 'link',
          target  => '/etc/collectd/collectd.conf',
          require => File['/etc/collectd/collectd.conf'],
          notify  => Service['collectd'];
      }
      case $::lsbmajdistrelease {
        '4','5': { }
        default: {
          file{ ['/usr/bin/collectd-nagios']:
            mode    => '0755',
            owner   => 'root',
            group   => 'root',
            seltype => 'nagios_services_plugin_exec_t',
            require => Package['collectd'];
          }
        }
      }
    }
    default: {
      # no changes needed
    }
  }
}

# collectd/manifests/plugin.pp
# (C) Copyright: 2008, David Schmitt <david@dasz.at>

# Define: collectd::plugin
# A generic wrapper for a plugin configuration. This automatically loads the
# plugin before it's configuration and notifies the collectd service to reload
# its configs.
#
# Parameters:
#   namevar	- The plugin to configure.
#   lines	- an optional array of lines to configure the plugin.
#   content	- optional plugin configuration, for cases where an array of lines would be insuffiscent.
#   source	- same as content, but specify a puppet file source instead.
define collectd::plugin($lines = "", $content = "", $source = "") {

	file { "collectd ${name} config":
			path => "/var/lib/puppet/modules/collectd/plugins/${name}.conf",
			mode => 0644, owner => root, group => 0,
			notify => Service['collectd'];
	}

	if ($lines != "") {
		$pluginlines = join("\n\t", $lines)
		File["collectd ${name} config"] {
			content => "LoadPlugin ${name}\n<Plugin ${name}>\n\t${pluginlines}\n</Plugin>\n",
		}
	}

	if ($content != "") {
		File["collectd ${name} config"] {
			content => $content,
		}
	}

	if ($source != "") {
		File["collectd ${name} config"] {
			source => $source,
		}
	}

}

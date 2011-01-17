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
define collectd::plugin($lines = "", $content = "") {

	if ($content == "") {
		$pluginlines = join("\t\n", $lines)
		$pluginconf = "LoadPlugin ${name}\n<Plugin ${name}>\n\t${pluginlines}\n</Plugin>\n"
	} else {
		$pluginconf = undef
	}

	file {
		"/var/lib/puppet/modules/collectd/plugins/${name}.conf":
			content => $content ? {
				""      => $pluginconf,
				default => $content,
			},
			mode => 0644, owner => root, group => 0,
			notify => Service['collectd'];
	}
}

# collectd/manifests/rrdtool.pp
# (C) Copyright: 2009, François Deppierraz <francois.deppierraz@camptocamp.com>

# Define: collectd::rrdtool.
# manage the rrdtool plugin's parameters

define collectd::rrdtool(
  $datadir = '',
  $step_size = '',
  $heartbeat = '',
  $rra_rows = '',
  $rra_timespan = '',
  $xff = '',
  $cache_flush = '',
  $cache_timeout = '',
  $writes_per_second = ''
) {

	collectd::plugin {
		'rrdtool':
			lines => [
        $datadir ? { '' => '', default => "DataDir ${datadir}" },
        $heartbeat ? { '' => '', default => "HeartBeat ${heartbeat}" },
        $rra_rows ? { '' => '', default => "RRARows ${rra_rows}" },
        $rra_timespan ? { '' => '', default => "RRATimespan ${rra_timespan}" },
        $xff ? { '' => '', default => "XFF ${xff}" },
				$cache_flush ? { '' => '', default => "CacheFlush ${cache_flush}" },
				$cache_timeout ? { '' => '', default => "CacheTimeout ${cache_timeout}" },
				$writes_per_second ? { '' => '', default => "WritesPerSecond ${writes_per_second}" },
			]
	}
}


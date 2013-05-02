# = Class: corosync::config
# This class manages the corosync config file
#
# == Parameters:
# $authfile:: Name of the corosync authfile [String]
# $authkey:: Content of $authfile [String]
# $config:: Path to the corosync configuration file [String]
#
# The following parameters are simply values found within the corosync config. Each parameter has a statically declared type, which is munged in the template. Please see the config for more details on each param:
#
# $amf:: [String]
# $bindnetaddr:: [String]
# $broadcast:: [String]
# $compatibility:: [String]
# $config_version:: [Integer]
# $crm_service_version [Integer]
# $consensus:: [Integer]
# $downcheck:: [Integer]
# $fail_recv_const:: [Integer]
# $fileline:: [String]
# $function_name:: [String]
# $heartbeat_failures_allowed:: [Integer]
# $hold:: [Integer]
# $join:: [Integer]
# $logfile:: [String]
# $logfile_priority:: [String]
# $logger_debug:: [String]
# $logger_subsys:: [String]
# $logger_subsys_debug:: [String]
# $max_message:: [Integer]
# $max_network_delay:: [Integer]
# $mcastaddr:: [String]
# $mcastport:: [Integer]
# $members:: [Array]
# $merge:: [Integer]
# $miss_count_const:: [Integer]
# $netmtu:: [Integer]
# $nodeid:: [Integer]
# $ringnumber:: [Integer]
# $rrp_autorecovery_check_timeout:: [Integer]
# $rrp_mode:: [String]
# $rrp_problem_count_timeout:: [Integer]
# $rrp_problem_count_threshold:: [Integer]
# $rrp_problem_count_mcast_threshold:: [Integer]
# $rrp_token_expired_timeout:: [Integer]
# $secauth:: [String]
# $seqno_unchanged_const:: [Integer]
# $service_version:: [Integer]
# $service_use_mgmtd:: [String]
# $service_use_logd:: [String]
# $syslog_facility:: [String]
# $syslog_priority:: [String]
# $threads:: [Integer]
# $timestamp:: [String]
# $to_stderr:: [String]
# $to_logfile:: [String]
# $to_syslog:: [String]
# $token:: [Integer]
# $token_retransmit:: [Integer]
# $ttl:: [Integer]
# $transport:: [String]
# $window_size:: [Integer]
#
# == Sample Usage:
# All parameters can be set from the main class. For example, to change the logfile:
#   class { 'corosync':
#     bindnetaddr => '33.33.33.0',
#     mcastaddr   => '226.94.1.1',
#     authkey     => $authkey,
#     crm         => 'crm',
#     logfile     => '/var/log/yourmom'
#   }

class corosync::config (
  $config,
  $authfile,
  $authkey,
  $amf,
  $bindnetaddr,
  $broadcast,
  $compatibility,
  $config_version,
  $consensus,
  $crm_service_version,
  $downcheck,
  $fail_recv_const,
  $function_name,
  $fileline,
  $heartbeat_failures_allowed,
  $hold,
  $join,
  $logfile,
  $logfile_priority,
  $logger_debug,
  $logger_subsys,
  $logger_subsys_debug,
  $max_messages,
  $max_network_delay,
  $mcastaddr,
  $mcastport,
  $members,
  $merge,
  $miss_count_const,
  $netmtu,
  $nodeid,
  $ringnumber,
  $rrp_autorecovery_check_timeout,
  $rrp_mode,
  $rrp_problem_count_mcast_threshold,
  $rrp_problem_count_threshold,
  $rrp_problem_count_timeout,
  $rrp_token_expired_timeout,
  $secauth,
  $seqno_unchanged_const,
  $service,
  $service_version,
  $service_use_mgmtd,
  $service_use_logd,
  $syslog_facility,
  $syslog_priority,
  $threads,
  $timestamp,
  $to_logfile,
  $to_stderr,
  $to_syslog,
  $token,
  $token_retransmit,
  $transport,
  $ttl,
  $window_size
) {
  
  file { $config:
    ensure  => present,
    content => template("${module_name}/corosync.conf.erb"),
    mode    => '0600',
    notify  => Service["${module_name}"]
  }

  file { $authfile:
    ensure  => present,
    content => $authkey,
    mode    => '0400',
    owner   => 'root',
    group   => 'root'
  }

  if $::osfamily == 'Debian' {
    exec { 'enable corosync':
      command => 'sed -i -e \'s/^\(START=\).*$/\1yes/g\' /etc/default/corosync',
      path    => [ '/bin', '/usr/bin' ],
      unless  => 'grep \'^START=yes$\' /etc/default/corosync',
      require => Package['corosync'],
      before  => Service['corosync'],
    }
  }
}

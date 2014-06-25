# = Class: java
#
# Install Oracle java
#
# Dependencies:
# my puppet module 'puppet-apt'
#
# == Parameters:
#
# [* java_version *]
#   Specify the java version
#   Default: java7
#
class java ( $java_version = hiera('java_version', 'java7' ) ){

  case $operatingsystem {
    debian, ubuntu: {
      $package = "oracle-${java_version}-installer"
    }
    default: {
      fail('operation system is not supported')
    }
  }

  class { 'apt': }

  apt::source { 'webupd8team':
    location   => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
    release    => "precise",
    repos      => 'main',
    key        => 'EEA14886',
    key_server => 'hkp://keyserver.ubuntu.com:80' ,
  }

  apt::preseed_package { "$package":
    ensure          => present,
    module          => 'java',
    install_options => ['--no-install-recommends'],
    require         => Apt::Source['webupd8team'],
  } ->
  package { "oracle-${java_version}-set-default": ensure => present }
}

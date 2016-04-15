# Define: ini_config
# ===========================
#
# Fully manage ini configuration files
#
# Authors
# -------
#
# Andrew Grimberg <agrimberg@linuxfoundation.org>
#
# Copyright
# ---------
#
# Copyright 2016 Andrew Grimberg
#
# @License Apache-2.0 <http://spdx.org/licenses/Apache-2.0>
#
define ini_config (
  Enum['present', 'absent'] $ensure = 'present',
  String $config_file      = '',
  Hash $config             = {},
  Pattern['^[0-7]{4}$'] $mode = '0440',
  String $owner            = 'root',
  String $group            = 'root',
  Boolean $quotesubsection = true,
  Boolean $indentoptions   = true,
) {
  # Our config file should be either $config_file or $title but it must be an
  # absolute_path
  if ($config_file == '') {
    validate_absolute_path($title)
    $file_path = $title
  } else {
    validate_absolute_path($config_file)
    $file_path = $config_file
  }

  if ($ensure == 'present') {
    $_ensure = 'file'
  } else {
    $_ensure = $ensure
  }

  file { $file_path:
    ensure  => $_ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template("${module_name}/config.erb"),
  }
}

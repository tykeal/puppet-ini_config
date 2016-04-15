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
# License
# -------
#
# Apache-2.0 <http://spdx.org/licenses/Apache-2.0>
#
# @example
#   ini_config { '/etc/my_config.ini':
#   }
#
# @example
#   ini_config { 'My config':
#     config_file => '/etc/my_config.ini',
#   }
#
# @example
#   ini_config { '/etc/my_config.ini':
#     config              => {
#       'testsection'     => {
#         'testvar1'      => 'testvar1',
#         'testvar2'      => [ 'testvar2.1', 'testvar2.2' ],
#       },
#       'testsection.sub' => {
#         'testvar3'      => 'testvar3',
#       },
#     },
#   }
#
# @param ensure Ensure if the configuration file is present or not
#
# @param config_file Absolute path to file. Default is to use title
#
# @param config The configuration hash
#
# @param mode Fully qualified octal file mode
#
# @param owner Owner of the configuraiton file
#
# @param group Group owner of the configuration file
#
# @param quotesubsection If ini subections (noted by .subsection in the
#   configuration key) should be quoted or not. Some applications using ini
#   style files require it and some can't handle it.
#
# @param indentoptions If the ini section options should be indented (by a tab)
#   or not. Some applications using ini sytle configuration files can not handle
#   leading white space
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

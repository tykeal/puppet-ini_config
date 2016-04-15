# ini_config

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with ini_config](#setup)
    * [What ini_config affects](#what-ini_config-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ini_config](#beginning-with-ini_config)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Ever wanted a way to manage an entire INI configuration file and didn't want to
subclass `puppetlabs/inifile` to let you force purge? Well, now you're in luck!
This rather simple utility module is just what you need.

## Setup

`puppet module tykeal-ini_config`

## Usage

`ini_config` consists of a single define. At the most basic you're going to pass
in a hash of the ini file that you want built up. For instance, the following
will get you an almost empty configuration file. The only thing in it will be a
header comment of `; MANAGED BY PUPPET` and a few empty lines

```puppet
ini_config { '/etc/my_config.ini':
}
```
That's not all that interesting though, here's a much more interesting example:

```puppet
ini_config { /etc/my_config.in':
  config              => {
		'testsection'     => {
			'testvar1'      => 'testvar1',
      'testvar2'      => [ 'testvar2.1', 'testvar2.2' ],
		},
		'testsection.sub' => {
      'testvar3'      => 'testvar3',
		},
	},
}
```

Which will produce the following ini file

```ini
; MANAGED BY PUPPET

[testsection]
	testvar1 = testvar1
	testvar2 = testvar2.1
	testvar2 = testvar2.2

[testsection "sub"]
	testvar3 = testvar3
```

## Reference

  * `ensure`
		Ensure if the file is present or absent

		**Type**: Enum - `present`, `absent`

		**Default**: `present`

	* `config_file`
		Absolute path to the file to manage.

		NOTE: If not set then the resource title will be used for the file to
		manage. If this is set it takes precedence over the resource title.

		**Type**: String

		**Default**: Empty

	* `config`
		A hash detailing the ini configuration that needs to be managed.

		The hash schema is as follows:

		```puppet
		$config         => {
			<OPTIONTITLE> => {
				<OPTIONKEY> => <OPTIONVALUE>
			}
		}
		```

		```
		OPTIONTITLE ::= <STRING> | <STRING>"."<STRING>
		OPTIONKEY   ::= <STRING>
		OPTIONVALUE ::= <STRING> | [ <STRING>, <STRING>, ... ]
		```

		The `OPTIONTITLE` may containg a single "subsection" which is separated by a
		`.`

		**Type**: Hash

		**Default**: `{}`

	* `mode`
		The file mode octal to set

		**Type**: String matching pattern `^[0-7]{4}$`

		**Default**: `0440`

	* `owner`
		The owner of the file

		**Type**: String

		**Default**: `root`

	* `group`
		The group of the file

		**Type**: String

		**Default**: `root`

	* `quotesubsection`
		Boolean to determine if the the subsection title should be place inside `"`
		or not. Some ini-like systems cannot handle this and others require it.

		**Type**: Boolean

		**Default**: `true`

	* `indentoptions`
		Boolean to determine if the options of a section should be tab indented or
		not. Some ini-like systems cannot handle starting white space on their
		configuration lines

		**Type**: Boolean

		**Default**: `true`

## Limitations

While this module is flagged as only operating on RedHat and CentOS systems it
should work on any system as it is extremely basic

## Development

Do you want to contribute? Please fork on github and send a PR!

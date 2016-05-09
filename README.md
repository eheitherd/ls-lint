# ls-lint
ls-lint is a linter for [LiveScript](http://livescript.net/).

[![npm version][npm-img]][npm-url]
[![Dependency Status][dependency-img]][dependency-url]
[![Build Status][build-img]][build-url]
[![GitHub license][license-img]][license-url]

## Usage

### CLI

```bash
ls-lint file [...]
```

### API

#### ls-lint.lint source, [options]

Returns a list of errors, warnings.

##### options

* `config-file`

  Path for your configuration file.

* `config`

  This overwrites configuration of your configuration file or default.

* `rule-file` [DEPRECATED]

  Path for your rule file.

* `rules` [DEPRECATED]

  This overwrites rules of your rule file or defaults.

```livescript
options =
  config-file: \./my-config.lson
  config:
    eol-last: \ignore
```

[npm-img]: https://badge.fury.io/js/ls-lint.svg
[npm-url]: https://badge.fury.io/js/ls-lint
[dependency-img]: https://gemnasium.com/badges/github.com/eheitherd/ls-lint.svg
[dependency-url]: https://gemnasium.com/github.com/eheitherd/ls-lint
[build-img]: https://travis-ci.org/eheitherd/ls-lint.svg?branch=master
[build-url]: https://travis-ci.org/eheitherd/ls-lint
[license-img]: https://img.shields.io/badge/license-MIT-blue.svg
[license-url]: https://raw.githubusercontent.com/eheitherd/ls-lint/master/LICENSE

# ls-lint
ls-lint is a linter for [LiveScript](http://livescript.net/).

 [![Build Status](https://travis-ci.org/eheitherd/ls-lint.svg?branch=master)](https://travis-ci.org/eheitherd/ls-lint) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/eheitherd/ls-lint/master/LICENSE)

## Usage

### CLI

```bash
ls-lint file [...]
```

### API

#### ls-lint.lint source, [options]

Returns a list of errors, warnings.

##### options

* `rule-file`

  Path for your rule file.

* `rules`

  This overwrites rules of your rule file or defaults.

```livescript
options =
  rule-file: \./my-rule.lson
  rules:
    eol-last: \ignore
```

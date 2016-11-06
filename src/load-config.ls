#------------------------------------------------------------------------------
# Loads lint configuration.

require! {
  fs
  path
  './load-lson'
  './util/util-obj': {deep-merge}
}

# Loads lint configuration from lson files,
#   which is required, is in current directory, or is in this module.
#   {a: b} -> {c: d}
module.exports = (config-file) ->
  request-config = if config-file then load-lson config-file else {}

  deep-merge current-config, request-config

# Loads optional lson file,
# which returns empty object when required file can't be read.
#   String -> {a: b}
load-optional-lson = (lson-file) ->
  try
    fs.access-sync lson-file, fs.R_OK
  catch
    return {}
  load-lson lson-file

current-config = load-optional-lson "./ls-lint.lson"

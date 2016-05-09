#------------------------------------------------------------------------------
# Loads lint configuration.

require! {
  fs
  path
  './load-lson'
}

# Loads lint configuration from lson files,
#   which is required, is in current directory, or is in this module.
#   {a: b} -> {c: d}
module.exports = (opts) ->
  config-file = opts.config-file ? opts.rule-file
  request-config = if config-file then load-lson config-file else {}
  opts-config = opts.config ? {}

  {} <<< default-config <<< current-config <<< request-config <<< opts-config

# Loads optional lson file,
# which returns empty object when required file can't be read.
#   String -> {a: b}
load-optional-lson = (lson-file) ->
  try
    fs.access-sync lson-file, fs.R_OK
  catch
    return {}
  load-lson lson-file

config-file = \ls-lint.lson

default-config =
  module.filename
  |> path.dirname
  |> path.resolve _, "../#{config-file}"
  |> load-lson

current-config = load-optional-lson "./#{config-file}"

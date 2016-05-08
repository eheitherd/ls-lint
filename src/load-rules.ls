#------------------------------------------------------------------------------
# Loads lint rules.

require! {
  fs
  path
  './load-lson'
}

# Loads lint rules from default lson file, root lson file or required file.
#   {a: b} -> {c: d}
module.exports = (opts) ->
  request-rules = if opts.rule-file then load-lson opts.rule-file else {}
  opts-rules = opts.rules ? {}

  {} <<< default-rules <<< root-rules <<< request-rules <<< opts-rules

# Loads optional lson file,
# which returns empty object when required file can't be read.
#   String -> {a: b}
load-optional-lson = (lson-file) ->
  try
    fs.access-sync lson-file, fs.R_OK
  catch
    return {}
  load-lson lson-file

rule-file = \ls-lint.lson

default-rules =
  module.filename
  |> path.dirname
  |> path.resolve _, "../#{rule-file}"
  |> load-lson

root-rules = load-optional-lson "./#{rule-file}"

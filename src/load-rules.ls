#------------------------------------------------------------------------------
# Loads lint rules.

require! {
  fs
  path
  './load-lson'
}

# Store loaded rules with SIDE EFFECTS.
rules = void

# Loads lint rules from default lson file, root lson file or required file.
# with SIDE EFFECTS for cache.
#   {a: b} -> {c: d}
module.exports = (opts) ->
  unless rules?
    default-rule-file =
      module.filename |> path.dirname |> path.resolve _, "../#{rule-file}"
    rules := do
      default: load-lson default-rule-file
      root: load-optional-lson "./#{rule-file}"

  if rules.request-file isnt opts.rule-file
    rules.request = load-optional-lson opts.rule-file
    rules.request-file = opts.rule-file

  rules.opts = opts.rules ? {}

  {} <<< rules.default <<< rules.root <<< rules.request <<< rules.opts

rule-file = \ls-lint.lson

# Loads optional lson file,
# which returns empty object when required file can't be read.
#   String -> {a: b}
load-optional-lson = (lson-file) ->
  try
    fs.access-sync lson-file, fs.R_OK
  catch
    return {}
  load-lson lson-file

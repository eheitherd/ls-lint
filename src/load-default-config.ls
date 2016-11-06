#------------------------------------------------------------------------------
# Loads default configuration.

require! {
  path
  './load-lson'
}

# Loads lint configuration from lson file in this module.
#   -> {c: d}
module.exports = ->
  module.filename
  |> path.dirname
  |> path.resolve _, \../ls-lint.lson
  |> load-lson

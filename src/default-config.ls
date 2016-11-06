#------------------------------------------------------------------------------
# Loads default configuration.

require! {
  fs
  path
  './load-lson'
}

# Loads lint configuration from lson file in this module.
#   -> {c: d}
export load-default-config = ->
  load-lson default-config-file

# Reads default configuration file.
#   -> String
export read-default-config = ->
  fs.read-file-sync default-config-file, encoding: \utf8

default-config-file =
  module.filename
  |> path.dirname
  |> path.resolve _, \../ls-lint.lson

#------------------------------------------------------------------------------
# Loads require rule modules.

require! {
  'prelude-ls': {map}
  path
  'fast-glob'
}

# Returns required rule modules.
#   [String] -> [(a -> b)]
module.exports = (rule-module-paths) ->
  rule-module-paths
  |> map resolve-path
  |> fast-glob.sync
  |> map relative-path
  |> map (-> "./#{it}")
  |> map -> require it

moduledir = module.filename |> path.dirname
edit-path = (act, file) --> file |> path[act] moduledir, _
resolve-path = edit-path \resolve
relative-path = edit-path \relative

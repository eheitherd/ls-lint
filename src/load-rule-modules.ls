#------------------------------------------------------------------------------
# Loads require rule modules.

require! {
  'prelude-ls': {map}
  path
  glob
}

# Returns required rule modules.
#   String -> [(a -> b)]
module.exports = (rule-modules-glob)->
  rule-modules-glob
  |> resolve-path
  |> glob.sync
  |> map relative-path
  |> map (-> "./#{it}")
  |> map -> require it

moduledir = module.filename |> path.dirname
edit-path = (act, file) --> file |> path[act] moduledir, _
resolve-path = edit-path \resolve
relative-path = edit-path \relative

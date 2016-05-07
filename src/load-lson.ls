#------------------------------------------------------------------------------
# Loads required lson file.

require! {
  fs
  livescript: lsc
}

# Loads required lson file.
#   String -> {a: b}
module.exports = (lson-file) ->
  lson-file
  |> fs.read-file-sync _, encoding: \utf8
  |> lsc.compile _, json:true
  |> JSON.parse

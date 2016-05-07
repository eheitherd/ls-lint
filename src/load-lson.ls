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
  |> fs.readFileSync _, encoding: \utf8
  |> lsc.compile _, json:true
  |> JSON.parse

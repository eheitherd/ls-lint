#------------------------------------------------------------------------------
# Reports an error to the console.

require! {
  './report-utils': {level-mark, printerrln}
}

# Reports an error to stderr.
#   {a: b} -> undefined
module.exports = (error) ->
  error
  |> (.toString!)
  |> -> "\n  #{level-mark \fatal} #{it}\n"
  |> printerrln

#------------------------------------------------------------------------------
# Lints single required file.

require! {
  fs
  './ls-lint'
  './reporter': {report-lint-results}
}

# Lints single requied file.
#   String -> a -> Promise
module.exports = (file, opts)->
  new Promise (resolve, reject) ->
    err, data <- fs.read-file file, encoding: \utf8
    if err
      reject err
    else
      data
      |> ls-lint.lint _, opts
      |> report-lint-results file
      |> resolve

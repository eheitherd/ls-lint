#------------------------------------------------------------------------------
# Lints required files.

require! {
  'glob-all'
  fs
  'prelude-ls': {map, flatten, empty}
  './ls-lint'
  './reporters/report-utils': {println}
  './reporters/report-lint-file'
}

# Lints required files.
#   [String] -> Promise
module.exports = (paths, opts) ->
  println ''

  glob-all.sync paths
  |> map lint-file _, opts
  |> Promise.all
  |> (.then flatten)

# Lints single requied file.
#   String -> a -> Promise
lint-file = (file, opts) ->
  new Promise (resolve, reject) ->
    err, data <- fs.read-file file, encoding: \utf8
    if err
      reject err
    else
      try
        data
        |> ls-lint.lint _, opts
        |> report-lint-file file
        |> resolve
      catch e
        reject e

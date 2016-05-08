#------------------------------------------------------------------------------
# Lints required files.

require! {
  glob
  fs
  'prelude-ls': {map, flatten, empty}
  './ls-lint'
  './reporters/report-lint-file'
}

# Lints required files.
#   [String] -> Promise
module.exports = (paths) ->
  paths
  |> map -> glob-promise it .then lint-files-promise
  |> Promise.all
  |> (.then flatten)

glob-promise = (arg) ->
  resolve, reject <- new Promise _
  err, files <- glob arg
  switch
  | err         => reject err
  | empty files => reject new Error "Can't find file '#{arg}'."
  | otherwise   => resolve files

lint-files-promise = (files) ->
  files
  |> map lint-file
  |> Promise.all

# Lints single requied file.
#   String -> a -> Promise
lint-file = (file, opts) ->
  new Promise (resolve, reject) ->
    err, data <- fs.read-file file, encoding: \utf8
    if err
      reject err
    else
      data
      |> ls-lint.lint _, opts
      |> report-lint-file file
      |> resolve

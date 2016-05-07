#------------------------------------------------------------------------------
# Implements command line interface.

require! {
  glob
  commander: program
  'prelude-ls': {map, flatten, empty}
  '../package.json': my-package
  './lint-file'
  './reporter': {report-total-result, report-error}
}

# Implements command line interface.
#   [String] -> undefined
module.exports = (argv) ->

  # Sets CLI up.
  program
    .version my-package.version
    .parse process.argv

  # Prints help and exits when no arguments is given.
  if program.args.length is 0
    program.help!
    process.exit 1

  # Lints required files.
  program.args
  |> map -> glob-promise it .then lint-files-promise
  |> Promise.all
  |> (.then flatten)
  |> (.then report-total-result)
  |> -> it.catch ->
    report-error it

glob-promise = (arg) ->
  resolve, reject <- new Promise _
  err, files <- glob arg
  switch
  | err         => reject err
  | empty files => reject new Error "Can't find file #{arg}."
  | otherwise   => resolve files

lint-files-promise = (files) ->
  files
  |> map lint-file
  |> Promise.all

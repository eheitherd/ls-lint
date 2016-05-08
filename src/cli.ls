#------------------------------------------------------------------------------
# Implements command line interface.

require! {
  glob
  commander: program
  'prelude-ls': {map, flatten, empty}
  '../package.json': my-package
  './lint-files'
  './reporters/report-total'
  './reporters/report-error'
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
  |> lint-files
  |> (.then report-total)
  |> (.then -> process.exit 0)
  |> (.catch report-error)
  |> (.then -> process.exit 1)

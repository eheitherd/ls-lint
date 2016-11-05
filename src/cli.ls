#------------------------------------------------------------------------------
# Implements command line interface.

require! {
  'prelude-ls': {each, empty}
  '../package.json': my-package
  './lint-files'
  './reporters/report-total'
  './reporters/report-error'
  './lib/monad-p': {return-p, bind-p, catch-p, promisize}
}

# Implements command line interface.
#   [String] -> ()
module.exports = (argv) ->
  return-p argv
  |> _ `bind-p` parse
  |> _ `catch-p` print-error
  |> _ `bind-p` action
  |> _ `bind-p` -> process.exit 0
  |> _ `catch-p` -> process.exit 1

parse = promisize (done, _, argv) -> done optionator.parse-argv argv

action = (options) ->
  switch
  | options.version   => print-version!
  | options.help      => print-help!
  | empty options._   => print-help 1
  | otherwise         => lint options._

lint = (files) ->
  lint-files files
  |> _ `bind-p` report-total
  |> _ `catch-p` -> fail-p report-error!

print-version = ->
  print "#{my-package.version}"
  return-p!

print-help = ->
  print optionator.generate-help!
  return-p!

print-error = (e) ->
  print e.message
  print optionator.generate-help!
  fail-p!

optionator = (require \optionator) do
  prepend:  '''
            lint livescript source files

            Usage: ls-lint [options]... [files]...
            '''
  append: "Version #{my-package.version}"
  options:
    * heading: \Options
    * option: \config
      alias: \c
      type: \file::String
      description: 'use specified configuration file'
    * option: \print-config
      type: \Boolean
      description: 'print the configuration'
    * option: \help
      alias: \h
      type: \Boolean
      description: 'output usage information'
    * option: \version
      alias: \v
      type: \Boolean
      description: 'output the version number'

print = console~log

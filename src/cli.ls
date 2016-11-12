#------------------------------------------------------------------------------
# Implements command line interface.

require! {
  'prelude-ls': {each, empty, map, lines, unlines}
  '../package.json': my-package
  './load-config'
  './default-config': {read-default-config}
  './lint-files'
  './reporters/report-lint-file'
  './reporters/report-total'
  './reporters/report-error'
  './reporters/report-utils': {print, println}
  './utils/monad-p': {return-p, bind-p, catch-p, promisize}
}

# Implements command line interface.
#   [String] -> ()
module.exports = (argv) ->
  return-p argv
  |> _ `bind-p` parse
  |> _ `bind-p` action
  |> _ `bind-p` -> process.exit 0
  |> _ `catch-p` ->
    report-error it
    process.exit 1

parse = promisize (done, _, argv) -> done optionator.parse-argv argv

action = (options) ->
  switch
  | options.version       => print-version!
  | options.help          => print-help!
  | options.print-config  => print-config options.config
  | empty options._       => print-help 1
  | otherwise             => lint options._, options.config

lint = (files, config-file) ->
  get-config config-file
  |> _ `bind-p` (config) -> lint-files files, {config}
  |> _ `bind-p` ->
    println ''
    return-p it
  |> _ `bind-p` ->
    map (-> report-lint-file it.file, it.results), it
    return-p it
  |> _ `bind-p` report-total

get-config = promisize (done, _, file) -> done load-config file

print-version = ->
  println "#{my-package.version}"
  return-p!

print-help = ->
  optionator.generate-help!
  |> lines |> map (-> "  #{it}") |> unlines |> println
  return-p!

print-config = (config-file) ->
  if config-file
    get-config config-file
    |> _ `bind-p` -> ...
  else
    print read-default-config!
    return-p!

optionator = (require \optionator) do
  prepend:  '''

            lint livescript source files

            Usage: ls-lint [options]... [files]...
            '''
  append: "Version #{my-package.version}\n"
  options:
    * heading: \Options
    * option: \help
      alias: \h
      type: \Boolean
      description: 'output usage information'
    * option: \version
      alias: \v
      type: \Boolean
      description: 'output the version number'
    * option: \config
      alias: \c
      type: \file::String
      description: 'use specified configuration file'
    * option: \print-config
      type: \Boolean
      description: 'print the configuration'

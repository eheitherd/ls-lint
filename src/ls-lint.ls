#------------------------------------------------------------------------------
# Provides lint function.

require! {
  livescript: lsc
  'prelude-ls': {
    Obj, Str, empty, map, compact, flatten, reject, split,
    last, initial, sort-with}
  './default-config': {load-default-config}
  './load-rule-modules'
  './utils/util-obj': {deep-merge}
}

# Lints LiveScript source.
#    String -> ({a: b}) -> [c]
export lint = (src, opts = {}) ->
  try
    tokens = lsc.lex src
    ast = lsc.ast src
  catch e
    result = /(.*) on line (\d+)|(.*)/.exec e.message
    [message, line] =
      if result.1 then [result.1, +result.2] else [result.3, void]
    return [{rule: \compile, level: \fatal, line, message}]

  config = deep-merge default-config, opts.config
  lint-target = {tokens, ast, src, config, lines: restruct-src src}

  rule-modules
  |> map (<| lint-target)
  |> flatten
  |> compact
  |> reject Obj.empty
  |> sort-with (x, y) ->
    | x.line > y.line   => 1
    | x.line < y.line   => -1
    | _                 => compare-column x, y

rule-modules =
  <[ ./rules/*.js ]>
  |> load-rule-modules

default-config = load-default-config!

# Returns list of {line(Number), src, eol}
#   String -> [{a: b}]
restruct-src = ->
  it
  |> split /(\r?\n)/
  |> trim-last
  |> restruct-src-line 1

# Returns list of {line(Number), src, eol} from [src, eol, src, ...].
# Does recursively.
#    Int -> [a] -> [{b: c}]
restruct-src-line = (line, [src, eol, ...cs]) -->
  [{line, src, eol}] ++ if empty cs then [] else restruct-src-line line + 1, cs

trim-last = -> if Str.empty last it then initial it else it

compare-column = (x, y) ->
  | x.column? and not y.column?   => -1
  | not x.column? and y.column?   => 1
  | not (x.column? and y.column?) => 0
  | _                             => x.column - y.column
